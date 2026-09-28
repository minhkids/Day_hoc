import json
from contextlib import closing
from pathlib import Path
import sqlite3
import tempfile
import threading
import time
import unittest
from unittest.mock import patch
import zipfile
import desktop as app

class PreschoolTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.root=Path(self.tmp.name)/'preschool';self.bridge=app.Bridge(self.root)
    def tearDown(self): self.tmp.cleanup()
    def test_records_edit_restart_delete_and_metadata_only(self):
        item=dict(date='2026-09-24',child='PRIVATE-CHILD',notes='PRIVATE-OBSERVATION',next='Hỗ trợ thêm',area='Ngôn ngữ',status='Có tiến bộ')
        saved=self.bridge.dispatch('save',dict(kind='observation',item=item))
        saved['notes']='PRIVATE-UPDATED';self.bridge.dispatch('save',dict(kind='observation',item=saved))
        restarted=app.Bridge(self.root)
        self.assertEqual(restarted.dispatch('state',{})['observation'][0]['notes'],'PRIVATE-UPDATED')
        with closing(sqlite3.connect(self.root/'du-lieu.sqlite3')) as con:
            payload=con.execute('SELECT payload FROM records').fetchone()[0]
        self.assertNotIn('PRIVATE',payload)
        restarted.dispatch('delete',dict(id=saved['id']))
        self.assertEqual(restarted.dispatch('state',{})['observation'],[])
        self.assertEqual(len(list((self.root/'thung-rac').glob('*.json'))),1)
    def test_validation_and_profile_isolation(self):
        with self.assertRaises(ValueError): self.bridge.dispatch('save',dict(kind='observation',item=dict(date='2026-02-31',child='X',notes='Y')))
        with self.assertRaises(ValueError): self.bridge.dispatch('save',dict(kind='document',item=dict(id='../x',title='T',body='B')))
        r=self.bridge.dispatch('settings',dict(profile=dict(model='example/model',classes='Lá',age=app.AGES[-1])))
        self.assertEqual(r['model'],'example/model')
        self.assertEqual(app.Bridge(self.root).dispatch('state',{})['profile']['classes'],'Lá')
        with self.assertRaisesRegex(ValueError,'Cài đặt'): self.bridge.dispatch('chat_start',dict(prompt='Hello'))
    def test_export_and_backup_without_secrets(self):
        saved=self.bridge.dispatch('save',dict(kind='document',item=dict(title='Hoạt động',body='# Mục tiêu\nTrẻ khám phá màu sắc.')))
        self.bridge.dispatch('settings',dict(profile={},key='TEST-SECRET-NEVER-SEND'))
        for fmt in ('docx','pptx','xlsx'):
            target=Path(self.tmp.name)/('activity.'+fmt)
            self.bridge.dispatch('export',dict(path=str(target),title=saved['title'],body=saved['body'],format=fmt))
            with zipfile.ZipFile(target) as z: self.assertIsNone(z.testzip())
        target=Path(self.tmp.name)/'backup.zip';self.bridge.dispatch('backup',dict(path=str(target)))
        with zipfile.ZipFile(target) as z:
            self.assertNotIn('api-key.dpapi',z.namelist());self.assertIn('du-lieu.sqlite3',z.namelist())
            self.assertTrue(any(n.startswith('ho-so/document/') for n in z.namelist()))
        with self.assertRaises(ValueError): self.bridge.dispatch('backup',dict(path=str(self.root/'bad.zip')))
    def test_async_ai_context_and_no_chat_persistence(self):
        self.bridge.dispatch('settings',dict(profile=dict(model='test/model'),key='TEST-SECRET'))
        captured={}
        class Response:
            status_code=200
            def json(self): return {'choices':[{'message':{'content':'Kế hoạch hoạt động mầm non'}}]}
        def post(url,**kwargs): captured.update(kwargs);return Response()
        with patch.object(app.core.requests,'post',post):
            job=self.bridge.dispatch('chat_start',dict(prompt='Soạn hoạt động khám phá',files=[]))
            for _ in range(100):
                result=self.bridge.dispatch('chat_poll',dict(job=job['job']))
                if result['state']!='running': break
                time.sleep(.01)
        self.assertEqual(result['state'],'done')
        self.assertIn('Giáo viên Mầm non',captured['json']['messages'][0]['content'])
        self.assertEqual(captured['json']['model'],'test/model')
        with closing(sqlite3.connect(self.root/'du-lieu.sqlite3')) as con: self.assertEqual(con.execute("SELECT count(*) FROM records WHERE kind='chat'").fetchone()[0],0)
        self.bridge.dispatch('chat_clear',{});self.assertEqual(self.bridge.chats,{})
    def test_cancel_late_answer(self):
        self.bridge.dispatch('settings',dict(profile=dict(model='test/model'),key='TEST-SECRET'))
        gate=threading.Event()
        def answer(*args): gate.wait(2);return 'Late'
        with patch.object(app.core,'ask_ai',answer):
            job=self.bridge.dispatch('chat_start',dict(prompt='Test'))
            self.bridge.dispatch('chat_cancel',dict(job=job['job']));gate.set();time.sleep(.05)
        self.assertEqual(self.bridge.dispatch('chat_poll',dict(job=job['job']))['state'],'cancelled')
        self.assertEqual(self.bridge.chats,{})
    def test_journal_export_text_cells(self):
        self.bridge.dispatch('save',dict(kind='care',item=dict(date='2026-09-24',child='=SUM(1,2)',notes='Ghi nhận')))
        target=Path(self.tmp.name)/'journal.xlsx';self.bridge.dispatch('export_records',dict(kind='care',path=str(target)))
        from openpyxl import load_workbook
        wb=load_workbook(target);self.assertEqual(wb.active['B2'].data_type,'s');wb.close()
    def test_legal_circulars_and_sync(self):
        state = self.bridge.dispatch('state', {})
        self.assertIn('legal', state)
        self.assertGreaterEqual(len(state['legal']), 14)
        self.assertTrue(any('19/2018' in d['number'] for d in state['legal']))
        self.assertTrue(any('13/2020' in d['number'] for d in state['legal']))
        self.assertTrue(any('01/VBHN' in d['number'] for d in state['legal']))
        self.assertTrue(any('124-QĐ/TW' in d['number'] for d in state['legal']))
        self.assertTrue(any('08/2023' in d['number'] for d in state['legal']))
        self.assertTrue(any('105/2020' in d['number'] for d in state['legal']))
        sync_result = self.bridge.dispatch('legal_sync', {})
        self.assertTrue(sync_result['ok'])
        self.assertGreaterEqual(sync_result['total'], 14)

    def test_advanced_methods_school_standards_and_party_templates(self):
        state = self.bridge.dispatch('state', {})
        cat_ids = [c['id'] for c in state['catalog']]
        self.assertIn('adv_method_activity', cat_ids)
        self.assertIn('school_standards_eval', cat_ids)
        self.assertIn('party_review', cat_ids)
        self.assertIn('party_commitment', cat_ids)
        self.assertIn('party_branch_minutes', cat_ids)

        school_eval = next(c for c in state['catalog'] if c['id'] == 'school_standards_eval')
        self.assertIn('Thông tư số 19/2018/TT-BGDĐT', school_eval['body'])
        self.assertIn('Mức 1 (Tối thiểu)', school_eval['body'])
        self.assertIn('Mức 2 (Chuẩn QG Mức 1)', school_eval['body'])
        self.assertIn('Mức 3 (Chuẩn QG Mức 2)', school_eval['body'])

        adv_method = next(c for c in state['catalog'] if c['id'] == 'adv_method_activity')
        self.assertIn('STEAM', adv_method['body'])
        self.assertTrue('MONTESSORI' in adv_method['body'].upper())

        party_review = next(c for c in state['catalog'] if c['id'] == 'party_review')
        self.assertIn('Mẫu 02-HD/BTCTW', party_review['body'])
        self.assertIn('Quy định 124-QĐ/TW', party_review['body'])

        doc1 = self.bridge.dispatch('save', dict(kind='document', item=dict(title='Tự đánh giá chuẩn trường', body=school_eval['body'])))
        self.assertTrue(doc1['id'])
        doc2 = self.bridge.dispatch('save', dict(kind='document', item=dict(title='Bản kiểm điểm đảng viên', body=party_review['body'])))
        self.assertTrue(doc2['id'])

    def test_legal_link_verification_mechanism(self):
        # 1. Test valid preschool teacher document URL
        valid_res = self.bridge.dispatch('legal_verify', dict(
            url='https://thuvienphapluat.vn/van-ban/Bo-may-hanh-chinh/Thong-tu-08-2023-TT-BGDDT-sua-doi-Thong-tu-01-2021-TT-BGDDT-02-2021-TT-BGDDT-514067.aspx',
            number='08/2023/TT-BGDĐT',
            title='Thông tư 08/2023/TT-BGDĐT sửa đổi chùm Thông tư bổ nhiệm giáo viên'
        ))
        self.assertTrue(valid_res['valid'])
        self.assertIn('Thư Viện Pháp Luật', valid_res['reason'])

        # 2. Test invalid URL (e.g. medical / unrelated profession)
        invalid_res = self.bridge.dispatch('legal_verify', dict(
            url='https://thuvienphapluat.vn/van-ban/Y-te-Suc-khoe/Nghi-dinh-05-2023-ND-CP-sua-doi-Nghi-dinh-56-2011-ND-CP-phu-cap-uu-dai-nghe-y-te-555555.aspx',
            number='05/2023/NĐ-CP',
            title='Nghị định về chế độ phụ cấp ưu đãi nghề y tế thôn bản'
        ))
        self.assertFalse(invalid_res['valid'])
        self.assertIn('ngành nghề khác', invalid_res['reason'])

        # 3. Test verify_all
        all_res = self.bridge.dispatch('legal_verify_all', {})
        self.assertTrue(all_res['ok'])
        self.assertGreaterEqual(all_res['total'], 10)
        self.assertEqual(all_res['failed_count'], 0)
        self.assertEqual(all_res['verified_count'], all_res['total'])

        # 4. Test repair link: set broken URL, then repair
        docs = self.bridge.dispatch('state', {})['legal']
        target_doc = next(d for d in docs if d['id'] == 'tt-08-2023-bgddt')
        original_url = target_doc['url']

        # Corrupt the link
        import legal
        for d in docs:
            if d['id'] == 'tt-08-2023-bgddt':
                d['url'] = 'https://moet.gov.vn/van-ban/empty?ItemID=999999'
                d['verified'] = False
        legal.save_legal_docs(self.root, docs)

        # Verify repair restores original canonical URL
        rep = self.bridge.dispatch('legal_repair_link', dict(id='tt-08-2023-bgddt'))
        self.assertTrue(rep['ok'])
        self.assertEqual(rep['url'], original_url)

        # Ensure state reflects verified status
        updated_doc = next(d for d in self.bridge.dispatch('state', {})['legal'] if d['id'] == 'tt-08-2023-bgddt')
        self.assertEqual(updated_doc['url'], original_url)
        self.assertTrue(updated_doc['verified'])

    def test_children_management_and_ward_address_conversion(self):
        # 1. Test saving child profile (with explicit auto_convert flag or manual convert)
        child_item = dict(
            name='Nguyễn Minh Khôi',
            gender='Nam',
            dob='2021-05-15',
            class_name='Lớp Mẫu giáo Lớn A1',
            weight=16.5,
            height=105,
            father_name='Nguyễn Văn Nam',
            father_phone='0912345678',
            mother_name='Trần Thị Mai',
            mother_phone='0987654321',
            address_old='Số 25 ngõ 198 Xã Đàn, Phường Phương Liên, Quận Đống Đa, Hà Nội',
            health_notes='Dị ứng hải sản'
        )
        saved = self.bridge.dispatch('save', dict(kind='child', item=child_item, auto_convert=True))
        self.assertTrue(saved['id'])
        self.assertEqual(saved['name'], 'Nguyễn Minh Khôi')
        self.assertTrue(saved['code'].startswith('TRE-'))
        self.assertEqual(saved['nutrition'], 'Bình thường (Kênh A)')
        # Auto-conversion when requested should produce a new address
        self.assertTrue(saved.get('address_new'), 'address_new should be filled when auto_convert is True')
        self.assertNotEqual(saved['address_new'], saved['address_old'])

        # 2. Test saving child without auto_convert — should NOT automatically alter address
        child_manual = dict(
            name='Trần Bảo An',
            address_old='Ngọc Thụy, Long Biên, Hà Nội'
        )
        saved_manual = self.bridge.dispatch('save', dict(kind='child', item=child_manual))
        self.assertEqual(saved_manual.get('address_new', ''), '', 'address_new must not be auto-converted without explicit request')

        # 3. Test ward conversion API directly with partial ward name
        conv_res = self.bridge.dispatch('ward_convert', dict(
            address='Số 10 phố Hàng Bạc, Quận Hoàn Kiếm, Hà Nội',
            direction='old_to_new'
        ))
        self.assertTrue(conv_res['converted'])
        self.assertIn(conv_res['source'], ('geovina_api', 'local_rules'))

        # Test partial ward name conversion (only ward and district)
        conv_partial = self.bridge.dispatch('ward_convert', dict(
            address='Ngọc Thụy, Long Biên, Hà Nội',
            direction='old_to_new'
        ))
        self.assertTrue(conv_partial['converted'])
        self.assertIn('Hồng Hà', conv_partial['result'])

        # 4. Test growth evaluation API
        growth = self.bridge.dispatch('evaluate_growth', dict(weight=12, height=95))
        self.assertEqual(growth['status'], 'Suy dinh dưỡng (Nhẹ cân / Thấp còi)')

        # 5. Test state retrieval includes children and ward rules
        state = self.bridge.dispatch('state', {})
        self.assertEqual(len(state['child']), 2)
        self.assertTrue(any(c.get('father_name') == 'Nguyễn Văn Nam' for c in state['child']))
        self.assertIn('ward_rules', state)
        self.assertGreaterEqual(len(state['ward_rules']), 10)
        self.assertIn('legal_sync', state)

        # 6. Test export children to excel
        target = Path(self.tmp.name) / 'children_list.xlsx'
        export_res = self.bridge.dispatch('export_records', dict(kind='child', path=str(target)))
        self.assertEqual(export_res['count'], 2)
        self.assertTrue(target.is_file())

        # 7. Test export child Excel template (file mẫu tải về)
        template_target = Path(self.tmp.name) / 'Mau_Danh_Sach_Lop.xlsx'
        tpl_res = self.bridge.dispatch('export_child_template', dict(path=str(template_target)))
        self.assertTrue(template_target.is_file())
        self.assertEqual(tpl_res['path'], str(template_target))

        # 8. Test importing children from Excel template file
        import_res = self.bridge.dispatch('import_children', dict(path=str(template_target)))
        self.assertEqual(import_res['count'], 3, 'Template has 3 sample children rows')
        self.assertGreaterEqual(len(self.bridge.dispatch('state', {})['child']), 5)

        # 9. Test batch conversion API
        batch_res = self.bridge.dispatch('ward_batch_convert', dict(
            addresses=[
                'Phường Phương Liên, Quận Đống Đa, Hà Nội',
                '50 Cao Thắng, Phường 5, Quận 3, TP.HCM'
            ]
        ))
        self.assertIn('results', batch_res)
        self.assertEqual(len(batch_res['results']), 2)
        for r in batch_res['results']:
            self.assertIn('source', r)

        # 10. Test local-only fallback via ward module directly
        import ward
        local = ward.convert_address_old_to_new(
            'Phường Trung Phụng, Quận Đống Đa, Hà Nội',
            root_dir=self.root, use_geovina=False
        )
        self.assertTrue(local['converted'])
        self.assertEqual(local['source'], 'local_rules')
        self.assertIn('Khâm Thiên', local['result'])

        # 11. Test delete child
        for c in self.bridge.dispatch('state', {})['child']:
            self.bridge.dispatch('delete', dict(id=c['id']))
        self.assertEqual(self.bridge.dispatch('state', {})['child'], [])

    def test_preschool_ai_assistant_features(self):
        # 1. State includes preschool AI assistant metadata
        state = self.bridge.dispatch('state', {})
        self.assertIn('themes', state)
        self.assertGreaterEqual(len(state['themes']), 8)
        self.assertIn('adv_methods', state)
        self.assertGreaterEqual(len(state['adv_methods']), 4)
        self.assertIn('parent_scenarios', state)
        self.assertGreaterEqual(len(state['parent_scenarios']), 5)
        self.assertIn('creative_genres', state)
        self.assertIn('situations', state)

        # 2. Activity Wizard
        act_res = self.bridge.dispatch('ai_activity_wizard', dict(
            topic='Khám phá quả cam ngọt ngào',
            age='Mẫu giáo bé 3–4 tuổi',
            theme='Thế giới thực vật',
            method='STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)',
            duration='20–25 phút',
            materials='Quả cam thật, khay trải nghiệm, khăn lau tay'
        ))
        self.assertIn('content', act_res)
        self.assertIn('KHÁM PHÁ QUẢ CAM', act_res['content'].upper())
        self.assertIn('Mục tiêu', act_res['content'])
        self.assertIn('Tiến trình', act_res['content'])
        self.assertIn('Gắn kết', act_res['content'])
        self.assertIn('Khám phá', act_res['content'])

        # 3. Parent Messaging (Sensitive scenarios)
        # 3a. Bump / Scrape
        msg_bump = self.bridge.dispatch('ai_parent_message', dict(
            scenario='Bé va chạm / trầy xước nhẹ (Thông báo chân thành & Đã sơ cứu kịp thời)',
            child_name='Minh Khôi',
            details='Lúc 10h bé chạy ở sân cỏ vấp ngón chân xước nhẹ đầu gối, cô đã rửa nước muối và bôi thuốc'
        ))
        self.assertIn('content', msg_bump)
        self.assertIn('Minh Khôi', msg_bump['content'])
        self.assertIn('nước muối', msg_bump['content'])
        self.assertTrue(any(e in msg_bump['content'] for e in ('❤️', '🌸', '🌿')))

        # 3b. Biting
        msg_bite = self.bridge.dispatch('ai_parent_message', dict(
            scenario='Bé bị bạn cắn hoặc cắn bạn (Xử lý thấu cảm, gắn kết gia đình)',
            child_name='Bảo An',
            details='Trong lúc tranh bóng bạn nhỏ có cắn nhẹ vào tay Bảo An'
        ))
        self.assertIn('Bảo An', msg_bite['content'])
        self.assertIn('chườm', msg_bite['content'])

        # 3c. Milestone / Praise
        msg_praise = self.bridge.dispatch('ai_parent_message', dict(
            scenario='Khen ngợi bé có tiến bộ vượt bậc (Động viên, tạo niềm vui)',
            child_name='Tuấn Kiệt',
            details='Nay con tự giác ăn hết cơm và còn biết dọn thìa bát gọn gàng'
        ))
        self.assertIn('Tuấn Kiệt', msg_praise['content'])
        self.assertIn('tiến bộ', msg_praise['content'])

        # 4. Refine Observation (Pedagogical refiner)
        obs_refine = self.bridge.dispatch('ai_refine_observation', dict(
            child='TRE-01 - Minh Khôi',
            notes='Nam giật đồ chơi của bạn rồi đẩy bạn ngã khóc',
            area='Tình cảm và kỹ năng xã hội',
            kind='observation'
        ))
        self.assertIn('notes', obs_refine)
        self.assertIn('next', obs_refine)
        self.assertNotIn('đẩy bạn ngã khóc', obs_refine['notes'])  # Successfully converted from negative to constructive
        self.assertIn('chia sẻ', obs_refine['notes'])

        # 5. Creative Play Studio (Poem & Story)
        poem_res = self.bridge.dispatch('ai_creative_studio', dict(
            genre='Bài thơ 4 chữ / 5 chữ ngắn dễ thuộc theo chủ đề',
            children_names='Minh Khôi, Bảo An',
            topic='Giữ gìn vệ sinh đôi bàn tay xinh'
        ))
        self.assertIn('content', poem_res)
        self.assertIn('Minh Khôi', poem_res['content'])
        self.assertIn('Bảo An', poem_res['content'])
        self.assertIn('rửa tay', poem_res['content'].lower())

        # 6. Situation Help (Crisis Co-pilot)
        sit_res = self.bridge.dispatch('ai_situation_help', dict(
            situation='Trẻ mới đi học khóc nhiều, bám mẹ không chịu vào lớp',
            details='Bé khóc nấc lúc đón trẻ sáng'
        ))
        self.assertIn('content', sit_res)
        self.assertIn('Quy trình xử lý', sit_res['content'])
        self.assertIn('TUYỆT ĐỐI TRÁNH', sit_res['content'])

if __name__=='__main__': unittest.main()
