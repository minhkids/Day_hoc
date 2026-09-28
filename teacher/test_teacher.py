import tempfile
import time
from pathlib import Path
from unittest.mock import patch
import main


with tempfile.TemporaryDirectory() as directory:
    app=main.Teacher(directory)
    app.withdraw()
    try:
        for page in app.pages:
            app.show(page)
            app.update()
        assert len(app.template_paths)>20
        app.task_title.insert(0,'Dạy bài ôn tập')
        app.add_task()
        task=app.store.all('task')[0]
        app.task_list.selection_set(task['id'])
        app.complete_task()
        assert app.store.all('task')[0]['state']=='Hoàn thành'
        app.prepare('Kế hoạch bài dạy')
        app.store.save_profile({'model':'test-only','subject':'Toán','classes':'8A'})
        with patch.object(app.store,'key',return_value='test-only'), patch.object(main.core,'ask_ai',return_value='# Bài ôn tập\nNội dung dự thảo') as fake:
            app.send()
            deadline=time.monotonic()+5
            while app.busy and time.monotonic()<deadline:
                app.update(); time.sleep(.02)
            assert not app.busy
            assert fake.call_args.args[0]['subject']=='Toán'
        app.save_draft()
        document=app.store.all('document')[0]
        assert 'body' not in document
        assert (Path(directory)/document['path']).read_text(encoding='utf-8').startswith('# Bài')
        assert not app.store.all('chat')
        for fmt in ('docx','pptx','xlsx'):
            output=Path(directory)/('lesson.'+fmt)
            with patch.object(main.filedialog,'asksaveasfilename',return_value=str(output)):
                app.export(fmt)
            assert output.stat().st_size>0
        for kind in app.game_kind['values']:
            app.game_kind.set(kind); app.create_game()
        assert len(app.projects)==6
        assert all((p/'index.html').is_file() for p in app.projects)
        app.project_list.selection_set(0)
        output=Path(directory)/'game.zip'
        with patch.object(main.filedialog,'asksaveasfilename',return_value=str(output)), patch.object(main.messagebox,'showinfo'):
            app.zip_game()
        with main.zipfile.ZipFile(output) as archive:
            assert 'index.html' in archive.namelist()
        from PyPDF2 import PdfWriter, PdfReader
        source=Path(directory)/'input.pdf'
        writer=PdfWriter(); writer.add_blank_page(width=200,height=300)
        with source.open('wb') as stream:writer.write(stream)
        for mode in ('merge','split','rotate'):
            with patch.object(main.filedialog,'askopenfilenames',return_value=[str(source)]), patch.object(main.filedialog,'askdirectory',return_value=directory), patch.object(main.messagebox,'showinfo'), patch.object(main.messagebox,'showerror',side_effect=AssertionError):
                app.pdf_tool(mode)
        assert PdfReader(str(Path(directory)/'PDF-rotate.pdf')).pages[0].get('/Rotate')==90
        backup=Path(directory)/'backup.zip'
        with patch.object(main.filedialog,'asksaveasfilename',return_value=str(backup)), patch.object(main.messagebox,'showinfo'):
            app.backup()
        with main.zipfile.ZipFile(backup) as archive:
            assert 'du-lieu.sqlite3' in archive.namelist()
            assert not any('dpapi' in name for name in archive.namelist())
        print(f'PASS: {len(app.pages)} pages, {len(app.template_paths)} templates, tasks, mocked AI, file drafts, 3 Office formats, 6 games and ZIP. No provider request.')
    finally:
        app.busy=False
        app.close()
