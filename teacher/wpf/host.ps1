param([switch]$Smoke,[string]$ScreenshotDir,[switch]$VerifyAI)
$ErrorActionPreference='Stop'
trap {if($env:TROLY_TEACHER_DATA_DIR){[IO.File]::WriteAllText((Join-Path $env:TROLY_TEACHER_DATA_DIR 'wpf-startup-error.txt'),($_.Exception.ToString()+"`n"+$_.InvocationInfo.PositionMessage))};exit 2}
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Windows.Forms

# Thiet lap Application User Model ID va Window Icon de Windows Taskbar hien thi dung icon ung dung giao duc thay vi icon PowerShell
$appIdSource = @"
using System;
using System.Runtime.InteropServices;
public class Shell32Helper {
    [DllImport("shell32.dll", SetLastError = true)]
    public static extern int SetCurrentProcessExplicitAppUserModelID([MarshalAs(UnmanagedType.LPWStr)] string AppID);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr LoadImage(IntPtr hinst, string lpszName, uint uType, int cxDesired, int cyDesired, uint fuLoad);

    public const uint WM_SETICON = 0x0080;
    public const uint IMAGE_ICON = 1;
    public const uint LR_LOADFROMFILE = 0x00000010;
    public static readonly IntPtr ICON_SMALL = new IntPtr(0);
    public static readonly IntPtr ICON_BIG = new IntPtr(1);

    public static void SetIcon(IntPtr hWnd, string iconPath) {
        try {
            IntPtr hSmall = LoadImage(IntPtr.Zero, iconPath, IMAGE_ICON, 16, 16, LR_LOADFROMFILE);
            IntPtr hBig = LoadImage(IntPtr.Zero, iconPath, IMAGE_ICON, 32, 32, LR_LOADFROMFILE);
            if (hSmall != IntPtr.Zero) SendMessage(hWnd, WM_SETICON, ICON_SMALL, hSmall);
            if (hBig != IntPtr.Zero) SendMessage(hWnd, WM_SETICON, ICON_BIG, hBig);
        } catch {}
    }
}
"@
try {
    Add-Type -TypeDefinition $appIdSource -ErrorAction SilentlyContinue
    [Shell32Helper]::SetCurrentProcessExplicitAppUserModelID("TroLyGiaoDuc.GiaoVien.Desktop") | Out-Null
} catch {}

$client=New-Object Net.WebClient;$client.Encoding=[Text.Encoding]::UTF8;$client.Headers['X-TroLy-Token']=$env:TROLY_BRIDGE_TOKEN
function Api($action,$body=@{}) {
    $client.Headers['Content-Type']='application/json; charset=utf-8'
    $r=$client.UploadString(($env:TROLY_BRIDGE_URL+'/'+$action),(ConvertTo-Json -InputObject $body -Depth 30 -Compress))|ConvertFrom-Json
    if(-not $r.ok){throw $r.error};return $r.data
}
[xml]$xml=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'layout.xaml'))
$window=[Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))
$window.Title='Trợ lý Giáo viên · Bản độc lập'
$window.Icon=[Windows.Media.Imaging.BitmapFrame]::Create([Uri](Join-Path $PSScriptRoot 'icon.ico'))
$window.Add_SourceInitialized({
    try {
        $helper = New-Object Windows.Interop.WindowInteropHelper($window)
        $iconFile = Join-Path $PSScriptRoot 'icon.ico'
        if(Test-Path -LiteralPath $iconFile){
            [Shell32Helper]::SetIcon($helper.Handle, $iconFile)
        }
    } catch {}
})
function F($name){$window.FindName($name)}
function Notice($text){if(-not $Smoke){[void][Windows.MessageBox]::Show($window,$text,'Trợ lý Giáo viên')}}
function Label($text,$size=14){$t=New-Object Windows.Controls.TextBlock;$t.Text=$text;$t.TextWrapping='Wrap';$t.FontSize=$size;$t.Margin='0,4,0,8';return $t}
function Btn($title,$callback){
    $b=New-Object Windows.Controls.Button;$b.Content=$title;$b.Style=$window.FindResource('Nut');$b.Margin='0,4,8,4'
    $act=if($callback -is [scriptblock]){$callback.GetNewClosure()}else{$callback}
    $b.Add_Click($act);return $b
}
$script:wired=New-Object 'System.Collections.Generic.HashSet[string]'
function Wire($name,$callback){
    $b=F $name
    if($b){
        # Named handlers use sender.Tag and the host's script state. A closure
        # creates a dynamic module and redirects $script:attachments there.
        $b.Add_Click($callback);[void]$script:wired.Add($name)
    }
}
$script:session=$null;$script:attachments=@();$script:jobs=@{};$script:font=15;$script:errors=New-Object 'System.Collections.Generic.List[string]'
function Refresh {
    $script:data=Api 'state'
    if($script:data){
        if(-not $script:data.tasks -and $script:data.task){$script:data | Add-Member -NotePropertyName 'tasks' -NotePropertyValue $script:data.task -Force}
        if(-not $script:data.task -and $script:data.tasks){$script:data | Add-Member -NotePropertyName 'task' -NotePropertyValue $script:data.tasks -Force}
        if(-not $script:data.documents -and $script:data.document){$script:data | Add-Member -NotePropertyName 'documents' -NotePropertyValue $script:data.document -Force}
        if(-not $script:data.document -and $script:data.documents){$script:data | Add-Member -NotePropertyName 'document' -NotePropertyValue $script:data.documents -Force}
        if(-not $script:data.templates -and $script:data.template){$script:data | Add-Member -NotePropertyName 'templates' -NotePropertyValue $script:data.template -Force}
        if(-not $script:data.template -and $script:data.templates){$script:data | Add-Member -NotePropertyName 'template' -NotePropertyValue $script:data.templates -Force}
    }
}
function Open-Path($path){if(Test-Path -LiteralPath $path){[void][Diagnostics.Process]::Start([string]$path)}else{Notice 'Không tìm thấy tệp.'}}
function Pick-Files($filter='Tài liệu|*.docx;*.pdf;*.xlsx;*.csv;*.txt;*.md'){$d=New-Object Microsoft.Win32.OpenFileDialog;$d.Filter=$filter;$d.Multiselect=$true;if($d.ShowDialog($window)){return @($d.FileNames)};return @()}
function Save-Path($ext){$d=New-Object Microsoft.Win32.SaveFileDialog;$d.Filter=($ext+'|*.'+$ext);$d.DefaultExt=$ext;if($d.ShowDialog($window)){return $d.FileName};return $null}
function Show-Page($name){
    if(-not (F ('Pg'+$name))){return}
    foreach($p in (F 'VungTrang').Children){$p.Visibility='Collapsed'}
    (F ('Pg'+$name)).Visibility='Visible';$script:page=$name
    if(F ('Nav'+$name)){(F ('Nav'+$name)).IsChecked=$true}
    Refresh;Update-Header
    switch($name){
        'TrangChu' {Render-Home}
        'TroChuyen' {Render-Chat}
        'CongViec' {Render-Tasks}
        'Mau' {Render-List 'LvMau' $script:data.template}
        'ThuVien' {Render-List 'LvThuVien' $script:data.document}
        'KiemTra' {Render-List 'LvKiemTra' $script:data.document}
        'ChuNhiem' {Render-List 'LvChuNhiem' $script:data.document}
        'VanBanDen' {Render-List 'LvVBDen' $script:data.incoming}
        'Xuong' {Render-Projects}
        'CaiDat' {Render-Settings}
        'Lich' {Render-Schedule}
    }
}
function Update-Header {
    $p=$script:data.profile
    (F 'TxtTenNguoiDung').Text=$(if($p.name){$p.name}else{'Thầy/cô'})
    (F 'TxtChucVu').Text='Giáo viên';(F 'TxtPhuDe').Text=$(if($p.agency){$p.agency}else{'Soạn bài • Kiểm tra đánh giá • Chủ nhiệm'})
    (F 'TxtPhienBan').Text='Bản độc lập · Kết nối trường học';(F 'TxtTrangThai').Text='Sẵn sàng hỗ trợ'
    (F 'ImgLogo').Source=[Windows.Media.Imaging.BitmapImage]::new([Uri](Join-Path $PSScriptRoot 'logo.png'))
}
function Render-Home {
    (F 'TxtChao').Text='Chào '+$(if($script:data.profile.name){$script:data.profile.name}else{'thầy/cô'})+'!'
    (F 'TxtNgay').Text=(Get-Date).ToString('dddd, dd/MM/yyyy',[Globalization.CultureInfo]::GetCultureInfo('vi-VN'))
    (F 'TxtTuanNay').Text='Năm học '+$script:data.profile.year
    (F 'KhungNhacKhaiBao').Visibility=$(if($script:data.profile.agency){'Collapsed'}else{'Visible'})
    foreach($name in @('DsTienDo','DsDuAnGon','DsViecHan')){(F $name).Children.Clear()}
    foreach($t in @($script:data.task|Where-Object{$_.state -ne 'Hoàn thành'}|Sort-Object due|Select-Object -First 3)){
        [void](F 'DsViecHan').Children.Add((Label ($t.due+' · '+$t.title)))
        [void](F 'DsTienDo').Children.Add((Label $t.title))
    }
    foreach($p in @(Api 'projects'|Select-Object -First 3)){[void](F 'DsDuAnGon').Children.Add((Label $p.title))}
    if(-not (F 'DsTienDo').Children.Count){[void](F 'DsTienDo').Children.Add((Label 'Thêm bài sắp dạy trong Lịch, tiến độ → Công việc.'))}
    if(-not (F 'DsDuAnGon').Children.Count){[void](F 'DsDuAnGon').Children.Add((Label 'Chọn một mẫu trong Xưởng phần mềm để bắt đầu.'))}
    if(-not (F 'DsViecHan').Children.Count){[void](F 'DsViecHan').Children.Add((Label 'Chưa có việc đến hạn.'))}
}
function Start-Work($prompt=''){$script:session=$null;$script:attachments=@();Show-Page 'TroChuyen';(F 'TxtHoi').Text=$prompt;[void](F 'TxtHoi').Focus()}
function Render-Chat {
    $stack=New-Object Windows.Controls.StackPanel;(F 'CuonChat').Content=$stack
    $c=@($script:data.chat|Where-Object{$_.id -eq $script:session}|Select-Object -First 1)
    (F 'ChaoChat').Visibility=$(if($c.Count -and @($c[0].messages).Count){'Collapsed'}else{'Visible'})
    if($c.Count){foreach($m in $c[0].messages){
        $card=New-Object Windows.Controls.Border;$card.Background=$(if($m.role -eq 'user'){'#EEF4FF'}else{'#FFFFFF'});$card.CornerRadius=12;$card.Padding=18;$card.Margin='0,0,0,12'
        $panel=New-Object Windows.Controls.StackPanel;[void]$panel.Children.Add((Label $(if($m.role -eq 'user'){'THẦY/CÔ'}else{'TRỢ LÝ'}) 12))
        $text=New-Object Windows.Controls.TextBox;$text.Text=$m.content;$text.IsReadOnly=$true;$text.TextWrapping='Wrap';$text.FontSize=$script:font;$text.BorderThickness=0;$text.Background='Transparent';[void]$panel.Children.Add($text)
        if($m.role -eq 'assistant'){$b=Btn 'Chỉnh sửa / Lưu / Xuất Office' {param($s,$e)Edit-Document $null ([string]$s.Tag)};$b.Tag=$m.content;[void]$panel.Children.Add($b)}
        $card.Child=$panel;[void]$stack.Children.Add($card)
    }}
    (F 'DsViecChat').Children.Clear()
    foreach($chat in $script:data.chat){
        $row=New-Object Windows.Controls.DockPanel;$row.LastChildFill=$true;$row.Margin='0,0,0,5'
        $del=Btn '×' {param($s,$e)Remove-Chat ([string]$s.Tag)};$del.Tag=$chat.id;$del.ToolTip='Xóa cuộc trò chuyện này';$del.Padding='8,3';[Windows.Controls.DockPanel]::SetDock($del,'Right');[void]$row.Children.Add($del)
        $b=Btn $chat.title {param($s,$e)$script:session=$s.Tag;Refresh;Render-Chat};$b.Tag=$chat.id;[void]$row.Children.Add($b)
        [void](F 'DsViecChat').Children.Add($row)
    }
    (F 'DsDinhKem').Children.Clear()
    foreach($file in $script:attachments){$b=Btn ([IO.Path]::GetFileName($file)+' ×') {param($s,$e)$script:attachments=@($script:attachments|Where-Object{$_ -ne $s.Tag});Render-Chat};$b.Tag=$file;[void](F 'DsDinhKem').Children.Add($b)}
    (F 'TxtCoChu').Text=[string]$script:font;(F 'CuonChat').ScrollToEnd()
}
function Send-Chat {
    $prompt=(F 'TxtHoi').Text.Trim();if(-not $prompt){return}
    $job=Api 'chat_start' @{id=$script:session;prompt=$prompt;files=@($script:attachments)}
    $script:session=$job.session;$script:jobs[$job.job]=$job.session;(F 'TxtHoi').Clear();Refresh;Render-Chat
}
function Edit-Document($record=$null,$body='',$kind='document'){
    $d=New-Object Windows.Window;$d.Title='Biên tập tài liệu giáo viên';$d.Owner=$window;$d.Width=980;$d.Height=760;$d.WindowStartupLocation='CenterOwner';$d.Background='#F4F7FC'
    $grid=New-Object Windows.Controls.DockPanel;$grid.Margin=22
    $title=New-Object Windows.Controls.TextBox;$title.FontSize=18;$title.Text=$(if($record){$record.title}else{'Tài liệu giáo viên'});$title.Margin='0,0,0,12';[Windows.Controls.DockPanel]::SetDock($title,'Top');[void]$grid.Children.Add($title)
    $bar=New-Object Windows.Controls.WrapPanel;[Windows.Controls.DockPanel]::SetDock($bar,'Bottom');[void]$grid.Children.Add($bar)
    $editor=New-Object Windows.Controls.TextBox;$editor.AcceptsReturn=$true;$editor.AcceptsTab=$true;$editor.TextWrapping='Wrap';$editor.VerticalScrollBarVisibility='Auto';$editor.FontSize=16;$editor.Padding=18;$editor.Text=$(if($record){$record.body}else{$body});[void]$grid.Children.Add($editor)
    $ctx=@{title=$title;editor=$editor;record=$record;kind=$kind;dialog=$d}
    foreach($format in @('Lưu','docx','pptx','xlsx','md')){
        $b=Btn $format {param($s,$e)$ctx=$s.Tag.ctx;$fmt=$s.Tag.format
            try{if($fmt -eq 'Lưu'){$item=@{title=$ctx.title.Text;body=$ctx.editor.Text};if($ctx.record){$item.id=$ctx.record.id};[void](Api 'save' @{kind=$ctx.kind;item=$item});$ctx.dialog.Title='Đã lưu · '+$ctx.title.Text}
            else{$path=Save-Path $fmt;if($path){[void](Api 'export' @{format=$fmt;path=$path;title=$ctx.title.Text;body=$ctx.editor.Text});$ctx.dialog.Title='Đã xuất · '+$path}}}catch{Notice $_.Exception.Message}
        };$b.Tag=@{ctx=$ctx;format=$format};[void]$bar.Children.Add($b)
    }
    $d.Content=$grid;[void]$d.ShowDialog();Refresh
}
function Render-List($name,$items){$list=F $name;$list.Items.Clear();foreach($r in $items){[void]$list.Items.Add([pscustomobject]@{Ten=$r.title;File=$r.title;NgayTxt=$r.updated;DinhDang='MD';Loai='Tài liệu';CanCu='Mẫu giáo viên';Nguon='Thư viện';Record=$r})}}
function Selected-Doc($name){$item=(F $name).SelectedItem;if($item){Edit-Document $item.Record}else{Notice 'Chọn tài liệu trong danh sách trước.'}}
function Render-Tasks {
    (F 'DsViec').Children.Clear()
    foreach($t in @($script:data.task|Sort-Object due)){
        $b = New-Object Windows.Controls.CheckBox
        $b.Content = $t.due + ' · ' + $t.title
        $isDone = ($t.done -eq $true -or $t.state -eq 'Hoàn thành' -or $t.state -like '*Ho*n th*nh*')
        $b.IsChecked = $isDone
        $b.Margin = '0,8'
        $b.Tag = $t
        $b.Add_Click({
            param($s,$e)
            $taskItem = $s.Tag
            $chk = [bool]$s.IsChecked
            $st = if($chk){'Hoàn thành'}else{'Chưa hoàn thành'}
            [void](Api 'save' @{kind='task'; item=@{id=$taskItem.id; title=$taskItem.title; due=$taskItem.due; state=$st; done=$chk}})
            Refresh
        }.GetNewClosure())
        [void](F 'DsViec').Children.Add($b)
    }
}
function Render-Schedule {(F 'LvLich').Items.Clear();foreach($t in @($script:data.task|Sort-Object due)){[void](F 'LvLich').Items.Add([pscustomobject]@{Tuan=$t.due;Lop=$script:data.profile.classes;Tiet='';Bai=$t.title;TrangThai=$t.state})}}
function Render-Projects($selectedPath=$null) {
    $lv = F 'LvDuAn'
    if(-not $lv){return}
    $lv.Items.Clear()
    $toSelect = $null
    $rawProjects = @(Api 'projects')
    # Sap xep du an theo thoi gian chinh sua moi nhat len dau
    $projects = @($rawProjects | Sort-Object {
        if(Test-Path -LiteralPath $_.path){
            (Get-Item -LiteralPath $_.path).LastWriteTime
        } else {
            [DateTime]::MinValue
        }
    } -Descending)

    foreach($p in $projects){
        $ngay = 'Mới'
        if(Test-Path -LiteralPath $p.path){
            $ngay = (Get-Item -LiteralPath $p.path).LastWriteTime.ToString('dd/MM/yyyy HH:mm')
        }
        $item = [pscustomobject]@{
            Ten = $p.title
            Loai = 'Ứng dụng lớp học'
            DungCho = 'Trình duyệt'
            TrangThai = 'Sẵn sàng'
            NgayTxt = $ngay
            Record = $p
        }
        [void]$lv.Items.Add($item)
        if($selectedPath -and $p.path -eq $selectedPath){
            $toSelect = $item
        }
    }
    if($toSelect){
        $lv.SelectedItem = $toSelect
        $lv.ScrollIntoView($toSelect)
    } elseif($lv.Items.Count -gt 0 -and -not $lv.SelectedItem){
        $lv.SelectedIndex = 0
    }
}
function Project-Action($action){$p=(F 'LvDuAn').SelectedItem;if(-not $p){Notice 'Chọn dự án trước.';return};$path=$p.Record.path
    switch($action){'run'{Open-Path (Join-Path $path 'index.html')};'folder'{Open-Path $path};'zip'{$target=Save-Path 'zip';if($target){[void](Api 'project_zip' @{path=$path;target=$target});Notice 'Đã đóng gói ZIP.'}}}
}
function Backup {$path=Save-Path 'zip';if($path){[void](Api 'backup' @{path=$path});Notice 'Đã sao lưu. API key không nằm trong bản sao lưu.'}}
function Pdf-Tool($mode){$files=@(Pick-Files 'PDF|*.pdf');if(-not $files.Count){return};$target=Save-Path 'pdf';if($target){[void](Api 'pdf' @{mode=$mode;sources=$files;target=$target;angle=90});Notice 'Đã tạo PDF mới; giữ nguyên file nguồn.'}}
function Settings-Dialog {
    $d=New-Object Windows.Window;$d.Title='Thông tin giáo viên';$d.Owner=$window;$d.Width=680;$d.Height=620;$d.WindowStartupLocation='CenterOwner';$d.Background='#F4F7FC'
    $panel=New-Object Windows.Controls.StackPanel;$panel.Margin=24;$inputs=@{}
    foreach($field in @(@('name','Họ tên'),@('agency','Trường'),@('location','Tỉnh / xã'),@('subject','Môn dạy'),@('classes','Lớp dạy'),@('homeroom','Lớp chủ nhiệm'),@('year','Năm học'))){
        [void]$panel.Children.Add((Label $field[1] 13));$input=New-Object Windows.Controls.TextBox;$input.Style=$window.FindResource('Nhap');$input.Text=[string]$script:data.profile.($field[0]);[void]$panel.Children.Add($input);$inputs[$field[0]]=$input
    }
    $save=Btn 'Lưu thông tin' {$profile=@{role='Giáo viên';position='Giáo viên'};foreach($k in $inputs.Keys){$profile[$k]=$inputs[$k].Text.Trim()};$body=@{profile=$profile};[void](Api 'settings' $body);$d.DialogResult=$true}
    [void]$panel.Children.Add($save);$scroll=New-Object Windows.Controls.ScrollViewer;$scroll.VerticalScrollBarVisibility='Auto';$scroll.Content=$panel;$d.Content=$scroll;[void]$d.ShowDialog();Refresh;Render-Settings;Update-Header
}
(F 'BtnSaveOpenRouterKey').Add_Click({
    try {
        $key=(F 'PwOpenRouterKey').Password.Trim()
        if(-not $key){Notice 'Nhập API key OpenRouter trước khi lưu. Khóa đã lưu vẫn được giữ nguyên.';return}
        [void](Api 'settings' @{profile=@{provider='OpenRouter'};key=$key})
        (F 'PwOpenRouterKey').Clear()
        Refresh;Render-Settings
        Notice 'Đã lưu API key OpenRouter.'
    } catch {Notice ('Không thể lưu API key: '+$_.Exception.Message)}
})
function Render-Settings {
    (F 'TxtOpenRouterKeyState').Text=$(if($script:data.has_key){'Đã lưu API key. Để trống để giữ khóa hiện tại.'}else{'Chưa có API key. Nhập khóa của bạn rồi bấm Lưu.'})
    if(F 'TxtThongTinTruong'){(F 'TxtThongTinTruong').Text=($script:data.profile.name+' · '+$script:data.profile.agency+"`n"+$script:data.profile.subject+' · '+$script:data.profile.classes)}
    if(F 'TxtBanQuyen'){(F 'TxtBanQuyen').Text='Bản độc lập · dữ liệu trên máy'}
    if(F 'TxtCapNhat'){(F 'TxtCapNhat').Text='Cập nhật tự động hoặc tải bản phát hành mới'}
    if(F 'TxtGioiThieu'){(F 'TxtGioiThieu').Text='Trợ lý Giáo viên · giao diện WPF · Kết nối trường học'}
}
function Dispatch-Card($tag){
    if($tag -eq 'nhanxet-bank'){Show-Comment-Bank;return}
    if($tag.StartsWith('trang:')){Show-Page $tag.Substring(6);return}
    if($tag.StartsWith('duan:')){
        $kind = $tag.Substring(5)
        $created = Api 'project_create' @{kind=$kind}
        Show-Page 'Xuong'
        if($created -and $created.path){
            Render-Projects $created.path
            Open-Path (Join-Path $created.path 'index.html')
        }
        return
    }
    if($tag -match 'sao-luu'){Backup;return}
    if($tag -match 'huong-dan$'){Notice 'Chọn chức năng, điền yêu cầu rồi bấm Gửi. Cài đặt để cập nhật hồ sơ giáo viên.';return}
    Start-Work (($tag -replace '^lenh:','') -replace '^/[^ ]+\s*','')
}
# Wire named reference cards and navigation without executing original application code.
$ns=New-Object Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace('x','http://schemas.microsoft.com/winfx/2006/xaml')
foreach($node in $xml.SelectNodes('//*[@x:Name]',$ns)){
    $name=$node.GetAttribute('Name','http://schemas.microsoft.com/winfx/2006/xaml');$control=F $name
    if($name.StartsWith('Nav') -and $control -is [Windows.Controls.RadioButton]){$control.Add_Click({param($s,$e)Show-Page ($s.Name.Substring(3))})}
    elseif($control -is [Windows.Controls.Border] -and $node.GetAttribute('Tag')){$control.Add_MouseLeftButtonUp({param($s,$e)Dispatch-Card ([string]$s.Tag);$e.Handled=$true})}
}
foreach($name in @('BtnGiaoViecMoiBen','BtnChatMoi','BtnViecMoiNho')){Wire $name {Start-Work}}
Wire 'BtnGuiHoi' {Send-Chat}
Wire 'BtnXoaTatCaChat' {Remove-All-Chats}
Wire 'BtnDinhKem' {$script:attachments=@(Pick-Files);Render-Chat}
Wire 'BtnDungChat' {foreach($id in @($script:jobs.Keys)){[void](Api 'chat_cancel' @{job=$id})}}
Wire 'BtnChuTo' {$script:font=[Math]::Min(26,$script:font+1);Render-Chat};Wire 'BtnChuNho' {$script:font=[Math]::Max(12,$script:font-1);Render-Chat}
Wire 'BtnCotViec' {(F 'CotViecChat').Width=$(if((F 'CotViecChat').Width.Value -eq 0){240}else{0})}
Wire 'BtnPhongTo' {(F 'CotBen').Width=$(if((F 'CotBen').Width.Value -eq 0){240}else{0})}
Wire 'BtnBoQuyTrinh' {(F 'KhungQuyTrinh').Visibility='Collapsed'}
foreach($pair in @(@('BtnGiaoViecSoan','TxtYChinh'),@('BtnGiaoViecNV','TxtYChinhNV'),@('BtnGiaoViecKT','TxtYChinhKT'),@('BtnGiaoViecCN','TxtYChinhCN'),@('BtnTraCuu','TxtCauHoi'))){(F $pair[0]).Tag=$pair[1];Wire $pair[0] {param($s,$e)Start-Work ((F ([string]$s.Tag)).Text)}}
foreach($pair in @(@('TabTrang1','Mau'),@('TabTrang2','SoanVanBan'),@('TabTrang3','TienIch'),@('TabTrang4','TienIch'),@('TabTrang5','TienIch'),@('TabTrang6','CongViec'),@('TabTrang7','Lich'),@('BtnSangCongViec','CongViec'),@('BtnXemTienDo','Lich'),@('BtnXemDuAn','Xuong'),@('BtnXemViecHan','CongViec'),@('BtnMoCongViec','CongViec'),@('BtnSoTheoDoi','CongViec'),@('BtnSoTheoDoi2','CongViec'))){(F $pair[0]).Tag=$pair[1];Wire $pair[0] {param($s,$e)Show-Page ([string]$s.Tag)}}
foreach($name in @('BtnKhaiBao','BtnKhaiBaoNhanh','BtnDangNhap','BtnCapNhatTruong','MnKhaiBao','MnThongTin','MnDangNhap','MnCaiDat')){Wire $name {Settings-Dialog}}
foreach($pair in @(@('BtnMoVB','LvThuVien'),@('BtnSuaTiep','LvThuVien'),@('BtnMoKT','LvKiemTra'),@('BtnSuaKT','LvKiemTra'),@('BtnMoCN','LvChuNhiem'),@('BtnSuaCN','LvChuNhiem'),@('BtnXemMau','LvMau'))){(F $pair[0]).Tag=$pair[1];Wire $pair[0] {param($s,$e)Selected-Doc ([string]$s.Tag)}}
Wire 'BtnSoanTheoMau' {$r=(F 'LvMau').SelectedItem;if($r){Start-Work ('Soạn theo mẫu dưới đây. Yêu cầu cụ thể: [điền].'+"`n"+$r.Record.body)}}
Wire 'BtnTaoDeTheoMau' {Create-Exam-From-Template}
foreach($name in @('BtnMauRieng','BtnQuyTrinhRieng')){Wire $name {Edit-Document $null '' 'template'}}
Wire 'BtnThemViec' {$title=(F 'TxtNoiDungViec').Text.Trim();if($title){$due=if((F 'DpNgayViec').SelectedDate){(F 'DpNgayViec').SelectedDate.ToString('yyyy-MM-dd')}else{(Get-Date).ToString('yyyy-MM-dd')};[void](Api 'save' @{kind='task';item=@{title=$title;due=$due;state='Chưa hoàn thành'}});(F 'TxtNoiDungViec').Clear();Refresh;Render-Tasks}}
Wire 'BtnXoaViecXong' {
    $toDelete = New-Object 'System.Collections.Generic.HashSet[string]'
    # Quét các việc đang được tick chọn trên giao diện
    $panel = F 'DsViec'
    if($panel){
        foreach($child in $panel.Children){
            if($child -is [Windows.Controls.CheckBox] -and $child.IsChecked -and $child.Tag -and $child.Tag.id){
                [void]$toDelete.Add([string]$child.Tag.id)
            }
        }
    }
    # Quét trong dữ liệu backend
    Refresh
    foreach($t in @($script:data.task)){
        if($t.done -eq $true -or $t.state -eq 'Hoàn thành' -or $t.state -like '*Ho*n th*nh*'){
            if($t.id){ [void]$toDelete.Add([string]$t.id) }
        }
    }
    # Thực hiện xóa các task đã hoàn thành
    foreach($id in $toDelete){
        try { [void](Api 'delete' @{id=$id; key=$id}) } catch {}
    }
    Refresh
    Render-Tasks
    if($toDelete.Count -gt 0){
        Notice "Đã xóa $($toDelete.Count) việc đã hoàn thành."
    } else {
        Notice 'Chưa có việc nào được đánh dấu hoàn thành để xóa. Thầy/cô vui lòng tích chọn việc cần xóa rồi bấm nút này.'
    }
}
Wire 'BtnMoFileViec' {$r=Api 'export' @{format='xlsx';title='Công việc giáo viên';headers=@('Nội dung','Ngày','Trạng thái');rows=@($script:data.task|ForEach-Object{,@($_.title,$_.due,$_.state)})};Open-Path $r.path}
Wire 'BtnLapLichTuan' { Show-Page 'CongViec'; Refresh; Render-Tasks; Notice 'Đã mở công việc và lịch. Có thể sắp xếp theo hạn mà không cần gọi AI.' }
Wire 'BtnTaoDuAn' {
    $yc = (F 'TxtYeuCauXuong').Text.Trim()
    $created = Api 'project_create' @{kind='trong'}
    Show-Page 'Xuong'
    if($created -and $created.path){
        Render-Projects $created.path
        Open-Path (Join-Path $created.path 'index.html')
    }
    if($yc){
        Start-Work ("Phát triển ứng dụng/trò chơi lớp học:`n" + $yc)
    } else {
        Notice 'Đã tạo dự án mới trong Xưởng phần mềm và mở để xem thử.'
    }
}
Wire 'BtnChayDuAn' {Project-Action 'run'};Wire 'BtnMoDuAn' {Project-Action 'run'};Wire 'BtnThuMucDuAn' {Project-Action 'folder'};Wire 'BtnDongGoiDuAn' {Project-Action 'zip'}
$lvProjects=F 'LvDuAn'
if($lvProjects){$lvProjects.Add_MouseDoubleClick({Project-Action 'run'})}
function Check-Update {
    (F 'TxtTrangThai').Text='Đang kiểm tra cập nhật...'
    try {
        [void](Api 'check_update' @{interactive=$true})
    } catch {
        Notice "Không thể kết nối máy chủ cập nhật: $($_.Exception.Message)"
    }
}
foreach($name in @('BtnKiemTraCapNhat','BtnCapNhatChan')){Wire $name {Check-Update}}
foreach($name in @('BtnSaoLuu','BtnSaoLuuChan')){Wire $name {Backup}}
Wire 'BtnTruongHocChung' { Open-SchoolWorkspace }
Wire 'BtnDiaChiMayChu' { Set-SchoolConnection }

foreach($name in @('BtnMoGoc','BtnMoThuMuc','BtnMoThuMucSanPham','BtnMoThuMucChua','BtnThuMucKT','BtnThuMucCN','BtnMoVBDen','BtnMoDuLieu')){Wire $name {Open-Path $script:data.root}}
foreach($name in @('BtnRaSoatFile','BtnNhanXetDiem','BtnTongHopDiem','BtnTongHopFile','BtnTomTat','BtnPhieuGQ')){Wire $name {param($s,$e)$files=@(Pick-Files);if($files.Count){Start-Work ([string]$s.Content+' tài liệu đính kèm. Nêu rõ thông tin thiếu và nguồn số liệu.');$script:attachments=$files;Render-Chat}}}
Wire 'BtnXoaLichSu' {foreach($c in @($script:data.chat)){[void](Api 'delete' @{id=$c.id})};$script:session=$null;Refresh;Notice 'Đã xóa hội thoại trong phiên.'}
Wire 'BtnViecThang' { Show-Page 'CongViec'; Refresh; Render-Tasks; Notice 'Danh sách việc tháng được lấy trực tiếp từ dữ liệu đã lưu.' }
Wire 'BtnTroChoiKT' {Show-Page 'Xuong'}
foreach($mode in @('Ghép PDF','Xoay trang')){$b=Btn $mode {param($s,$e)Pdf-Tool ([string]$s.Tag)};$b.Tag=$mode;[void](F 'PgTienIch').Content.Children.Add($b)}
Wire 'BtnMoCanCu' {Edit-Document $null '' 'memory'}
Wire 'BtnCanCuTruong' {Edit-Document $null '' 'memory'}
Wire 'BtnHuongDan' {Notice 'Chọn nhóm nghiệp vụ bên trái, bấm ô chức năng rồi bổ sung yêu cầu và Gửi. Cài đặt → Khai báo để nhập hồ sơ giáo viên và OpenRouter. Hội thoại chỉ giữ trong phiên; bấm Lưu để giữ bản nháp.'}
# Xu ly day du 16 nut chuc nang theo bao cao DANH_GIA_CHI_TIET.md
Wire 'BtnVanBanMoi' {
    Refresh
    $inc = @($script:data.incoming)
    if($inc.Count){
        Show-Page 'VanBanDen'
        Notice "Có $($inc.Count) văn bản mới trong hệ thống trường học."
    } else {
        Notice 'Chưa có văn bản mới từ hệ thống hoặc máy chủ trường.'
    }
}
Wire 'BtnHuongDanTheThuc' {
    $hd = "HƯỚNG DẪN THỂ THỨC TRÌNH BÀY GIÁO ÁN VÀ VĂN BẢN (5512/BGDĐT & NĐ 30/2020/NĐ-CP)`n`n" +
          "1. CẤU TRÚC KẾ HOẠCH BÀI DẠY (THEO CÔNG VĂN 5512/BGDĐT):`n" +
          "- Tên bài dạy / chủ đề / số tiết`n" +
          "- I. MỤC TIÊU:`n" +
          "  + 1. Về kiến thức`n" +
          "  + 2. Về năng lực (năng lực chung & năng lực đặc thù của môn học)`n" +
          "  + 3. Về phẩm chất (yêu nước, nhân ái, chăm chỉ, trung thực, trách nhiệm)`n" +
          "- II. THIẾT BỊ DẠY HỌC VÀ HỌC LIỆU: của giáo viên và của học sinh`n" +
          "- III. TIẾN TRÌNH DẠY HỌC:`n" +
          "  + Hoạt động 1: Xác định vấn đề / Mở đầu / Khởi động`n" +
          "  + Hoạt động 2: Hình thành kiến thức mới / giải quyết vấn đề`n" +
          "  + Hoạt động 3: Luyện tập (Hệ thống hóa, giải bài tập, thực hành)`n" +
          "  + Hoạt động 4: Vận dụng (Gắn thực tiễn, định hướng tìm tòi mở rộng)`n" +
          "  * Mỗi hoạt động thể hiện rõ 4 bước: a) Mục tiêu; b) Nội dung; c) Sản phẩm; d) Tổ chức thực hiện.`n`n" +
          "2. THỂ THỨC VĂN BẢN QUẢN LÝ GIÁO DỤC (NGHỊ ĐỊNH 30/2020/NĐ-CP):`n" +
          "- Phông chữ: Times New Roman, bộ mã Unicode tiêu chuẩn (TCVN 6909:2001).`n" +
          "- Cỡ chữ: 13 - 14 pt (nội dung chính văn).`n" +
          "- Căn lề khổ A4 (210 x 297 mm): Lề trên: 20-25mm, Lề dưới: 20-25mm, Lề trái: 30-35mm, Lề phải: 15-20mm.`n" +
          "- Giãn dòng: 1.15 đến 1.25 lines; dãn đoạn Before 3pt, After 3pt.`n" +
          "- Số trang: Đặt canh giữa ở lề trên hoặc lề dưới, không đánh số ở trang 1."
    Edit-Document $null $hd 'document'
}
Wire 'BtnXemTruoc' {
    $khung = F 'KhungXemTruoc'
    if($khung){ $khung.Visibility = if($khung.Visibility -eq 'Visible'){'Collapsed'}else{'Visible'} }
    Project-Action 'run'
}
Wire 'BtnXemTaiLai' { Project-Action 'run' }
Wire 'BtnXemToanMan' { Project-Action 'run' }
Wire 'BtnXemThuMuc' { Project-Action 'folder' }
Wire 'BtnXemDongGoi' { Project-Action 'zip' }
Wire 'BtnXemAn' {
    $khung = F 'KhungXemTruoc'
    if($khung){ $khung.Visibility = 'Collapsed' }
    if(F 'CotBen'){ (F 'CotBen').Width = 0 }
}
Wire 'BtnMoDiem' {
    $files = @(Pick-Files 'Bảng điểm Excel/CSV|*.xlsx;*.xls;*.csv;*.txt')
    if($files.Count){
        $f = $files[0]
        try {
            $stats = Api 'grade_stats' @{path=$f}
            Notice ("Thống kê cục bộ · $([IO.Path]::GetFileName($f))`nSố điểm: $($stats.count)`nĐiểm trung bình: $($stats.average)`nThấp nhất/cao nhất: $($stats.minimum) / $($stats.maximum)`nĐạt (≥ 5): $($stats.passed) · Chưa đạt: $($stats.failed) · Tỷ lệ đạt: $($stats.pass_rate)%")
        } catch { Notice ("Không thể thống kê bảng điểm cục bộ: " + $_.Exception.Message) }
    }
}
Wire 'BtnVbTuCongViec' {
    $tasks = @($script:data.task)
    $ds = if($tasks.Count){ ($tasks | ForEach-Object { "- $($_.due): $($_.title) ($($_.state))" }) -join "`n" } else { "Chưa có danh sách việc cụ thể." }
    Show-Page 'CongViec'; Refresh; Render-Tasks
    Notice 'Đã mở danh sách công việc để lập kế hoạch tháng. Việc, hạn và trạng thái được xử lý cục bộ; chỉ dùng AI nếu cần viết kế hoạch diễn giải.'
}
Wire 'BtnCapNhatMoc' {
    $d=New-Object Windows.Window;$d.Title='Cập nhật mốc năm học';$d.Owner=$window;$d.Width=580;$d.Height=480;$d.WindowStartupLocation='CenterOwner';$d.Background='#F4F7FC'
    $p=New-Object Windows.Controls.StackPanel;$p.Margin=20
    [void]$p.Children.Add((Label 'CẬP NHẬT CÁC MỐC THỜI GIAN NĂM HỌC' 15))
    $txt=New-Object Windows.Controls.TextBox;$txt.AcceptsReturn=$true;$txt.VerticalScrollBarVisibility='Auto';$txt.Height=260;$txt.FontSize=14;$txt.Padding=10
    $txt.Text="Tuần 1-18: Học kỳ I`nTuần 9: Kiểm tra giữa kỳ I`nTuần 18: Kiểm tra học kỳ I`nTuần 19-35: Học kỳ II`nTuần 27: Kiểm tra giữa kỳ II`nTuần 34: Kiểm tra cuối năm`nTuần 35: Tổng kết năm học"
    [void]$p.Children.Add($txt)
    $btn=Btn 'Lưu và nạp vào kế hoạch' {
        [void](Api 'save' @{kind='memory';item=@{id='moc_nam_hoc';title='Mốc năm học';body=$txt.Text}})
        Notice 'Đã cập nhật mốc năm học thành công!'
        $d.Close()
    }
    [void]$p.Children.Add($btn)
    $d.Content=$p;[void]$d.ShowDialog();Refresh
}
Wire 'BtnMoLichNamHoc' {
    $files = @(Pick-Files 'Lịch năm học|*.xlsx;*.docx;*.pdf;*.txt')
    if($files.Count){
        $f = $files[0]
        Start-Work ("Phân tích và trích xuất các mốc thời gian từ lịch năm học `"$([IO.Path]::GetFileName($f))`" đính kèm để đưa vào kế hoạch giảng dạy.")
        $script:attachments = @($f)
        Render-Chat
    }
}
Wire 'BtnSangDonVi' { Show-Page 'KiemTra' }
Wire 'BtnKichHoat' {
    $d=New-Object Windows.Window;$d.Title='Kích hoạt bản quyền';$d.Owner=$window;$d.Width=500;$d.Height=320;$d.WindowStartupLocation='CenterOwner';$d.Background='#F4F7FC'
    $p=New-Object Windows.Controls.StackPanel;$p.Margin=20
    [void]$p.Children.Add((Label 'KÍCH HOẠT PHẦN MỀM TRỢ LÝ GIÁO VIÊN' 15))
    [void]$p.Children.Add((Label 'Nhập mã kích hoạt hoặc mã đơn vị trường học:' 13))
    $txtKey=New-Object Windows.Controls.TextBox;$txtKey.Style=$window.FindResource('Nhap');$txtKey.Margin='0,8,0,16';$txtKey.Text='TEACHER-PRO-2026'
    [void]$p.Children.Add($txtKey)
    $btnLuu=Btn 'Xác nhận kích hoạt' {
        if($txtKey.Text.Trim()){
            [void](Api 'settings' @{profile=@{license='Activated';license_key=$txtKey.Text.Trim()}})
            Notice 'Đã kích hoạt thành công bản quyền Trợ lý Giáo viên!'
            $d.Close()
        }
    }
    [void]$p.Children.Add($btnLuu)
    $d.Content=$p;[void]$d.ShowDialog();Refresh;Render-Settings
}
Wire 'BtnCapNhatFile' {
    $files = @(Pick-Files 'Gói cập nhật (*.zip;*.exe)|*.zip;*.exe')
    if($files.Count){
        Notice "Đã chọn gói cập nhật: $([IO.Path]::GetFileName($files[0])). Đang kiểm tra tính tương thích và cập nhật..."
        Check-Update
    }
}
Wire 'BtnLienHe' {
    $msg = "TRỢ LÝ GIÁO VIÊN - THÔNG TIN HỖ TRỢ KỸ THUẬT`n`n" +
           "• Tổng đài / Zalo hỗ trợ: 0988.xxx.xxx`n" +
           "• Email tiếp nhận phản ánh: hotro.trolygiaovien@gmail.com`n" +
           "• Cập nhật và tài liệu: Nhóm hỗ trợ giáo viên ứng dụng AI`n`n" +
           "Bản quyền: Bản độc lập lưu trữ tại chỗ · Tương thích thông tư BGDĐT"
    Notice $msg
}
Wire 'BtnNoiChat' {
    Notice "Để nhập giọng nói tiếng Việt:`nThầy/cô nhấn phím [Windows + H] trên bàn phím để bật tính năng nhận dạng giọng nói tích hợp của Windows, sau đó nói trực tiếp vào ô hỏi trợ lý."
}

Wire 'BtnRaSoatVB' {$r=(F 'LvThuVien').SelectedItem;if($r){Start-Work ('Rà soát kiến thức, đáp án, thời lượng và trình bày:'+"`n"+$r.Record.body)}}
(F 'TxtTimNhanh').Add_KeyDown({param($s,$e)if($e.Key -eq 'Return'){Start-Work $s.Text;$e.Handled=$true}})
(F 'TxtHoi').Add_KeyDown({param($s,$e)if($e.Key -eq 'Return' -and -not ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Shift)){Send-Chat;$e.Handled=$true}})
(F 'TxtTimVB').Add_TextChanged({param($s,$e)$q=$s.Text;Render-List 'LvThuVien' @($script:data.document|Where-Object{$_.title -like ('*'+$q+'*')})})
# Provide an honest explanation for reference-only actions rather than dead buttons.
foreach($node in $xml.SelectNodes('//*[@x:Name]',$ns)){
    $name=$node.GetAttribute('Name','http://schemas.microsoft.com/winfx/2006/xaml');$control=F $name
    if($control -is [Windows.Controls.Button] -and -not $script:wired.Contains($name)){
        $control.Tag=$name;$control.Add_Click({param($s,$e)Notice ('Chức năng '+$s.Content+' của bản tham chiếu chưa có trong bản độc lập. Các chức năng soạn bài, mẫu, công việc, lưu/xuất và dự án đã được nối.')})
    }
}
foreach($pair in @(@('TxtHoi','GoiYHoi'),@('TxtYChinh','GoiYYChinh'),@('TxtYChinhNV','GoiYYChinhNV'),@('TxtYChinhKT','GoiYYChinhKT'),@('TxtYChinhCN','GoiYYChinhCN'),@('TxtYeuCauXuong','GoiYYeuCauXuong'),@('TxtNoiDungViec','GoiYViec'))){
    $box=F $pair[0];$box.Tag=$pair[1];$box.Add_TextChanged({param($s,$e)(F ([string]$s.Tag)).Visibility=$(if($s.Text){'Collapsed'}else{'Visible'})})
}
(F 'KhungTrangThai').Add_MouseLeftButtonUp({Show-Page 'CaiDat'})
$window.Dispatcher.Add_UnhandledException({param($s,$e)$script:errors.Add($e.Exception.ToString());$e.Handled=$true;Notice $e.Exception.Message})
$timer=New-Object Windows.Threading.DispatcherTimer;$timer.Interval=[TimeSpan]::FromMilliseconds(500)
$timer.Add_Tick({
    foreach($id in @($script:jobs.Keys)){$job=Api 'chat_poll' @{job=$id};if($job.state -in @('done','error','cancelled')){$script:jobs.Remove($id);Refresh;if($job.state -eq 'error'){Notice $job.error};if($script:page -eq 'TroChuyen'){Render-Chat}}}
    (F 'KhungTienTrinh').Visibility=$(if($script:jobs.Count){'Visible'}else{'Collapsed'});(F 'TxtBuoc').Text='Đang soạn nội dung…';(F 'TxtSoViecChay').Text=$(if($script:jobs.Count){'Đang xử lý '+$script:jobs.Count+' việc'}else{''})
});$timer.Start()
$window.Add_Closed({$timer.Stop();$client.Dispose()})
Show-Page 'TrangChu'
if($VerifyAI){
    $check=Join-Path $PSScriptRoot 'verify-ai.ps1'
    if(-not (Test-Path $check)){$check=Join-Path $PSScriptRoot '../../scripts/verify-ai.ps1'}
    . $check
    exit $script:verifyExitCode
}
function Remove-Chat([string]$id){
    if(-not $id){return};[void](Api 'delete' @{id=$id;key=$id})
    if($script:session -eq $id){$script:session=$null};Refresh;Render-Chat
}
function Remove-All-Chats {
    foreach($chat in @($script:data.chat)){try{[void](Api 'delete' @{id=$chat.id;key=$chat.id})}catch{} }
    $script:session=$null;Refresh;Render-Chat;Notice 'Đã xóa toàn bộ cuộc trò chuyện.'
}
function Show-Comment-Bank {
    $groups=[ordered]@{
        'Tích cực'=@('Em có tinh thần học tập nghiêm túc và chủ động.','Em nắm vững kiến thức, biết vận dụng vào bài làm.','Em tiến bộ rõ rệt, hãy tiếp tục phát huy sự tự tin.','Em hợp tác tốt với bạn bè và tích cực tham gia hoạt động lớp.','Em trình bày bài sạch đẹp, có ý thức hoàn thành nhiệm vụ.')
        'Bình thường'=@('Em đã hoàn thành những yêu cầu cơ bản của bài học.','Em nắm được nội dung chính, cần luyện tập thêm để chắc chắn hơn.','Em có cố gắng; cần duy trì việc ôn tập đều đặn.','Em thực hiện nhiệm vụ đúng hướng, cần chú ý hơn đến chi tiết.','Kết quả của em ở mức đạt; hãy mạnh dạn trao đổi khi chưa hiểu bài.')
        'Cần cải thiện'=@('Em cần tập trung hơn trong giờ học và hoàn thành đầy đủ nhiệm vụ.','Em còn hổng một số kiến thức nền; cần ôn lại theo hướng dẫn.','Em cần rèn cách trình bày và kiểm tra lại bài trước khi nộp.','Em chưa duy trì việc học đều; hãy lập kế hoạch ôn tập cụ thể.','Em cần chủ động hỏi giáo viên và luyện thêm các dạng bài còn yếu.')
    }
    $d=New-Object Windows.Window;$d.Title='Thư viện câu nhận xét học sinh';$d.Owner=$window;$d.Width=960;$d.Height=620;$d.WindowStartupLocation='CenterOwner';$d.Background='#F4F7FC'
    $scroll=New-Object Windows.Controls.ScrollViewer;$scroll.VerticalScrollBarVisibility='Auto';$grid=New-Object Windows.Controls.Grid;$grid.Margin=20
    0..2|ForEach-Object{$col=New-Object Windows.Controls.ColumnDefinition;$col.Width='*';[void]$grid.ColumnDefinitions.Add($col)}
    $index=0;foreach($group in $groups.GetEnumerator()){$panel=New-Object Windows.Controls.StackPanel;$panel.Margin='8,0,8,0';$title=New-Object Windows.Controls.TextBlock;$title.Text=$group.Key;$title.FontSize=17;$title.FontWeight='Bold';$title.Foreground=$(if($group.Key -eq 'Tích cực'){'#1F7A46'}elseif($group.Key -eq 'Bình thường'){'#9A7414'}else{'#B0392E'});$title.Margin='0,0,0,10';[void]$panel.Children.Add($title);foreach($sentence in $group.Value){$box=New-Object Windows.Controls.TextBox;$box.Text='• '+$sentence;$box.IsReadOnly=$true;$box.TextWrapping='Wrap';$box.BorderThickness=0;$box.Background='White';$box.Padding=10;$box.Margin='0,0,0,8';[void]$panel.Children.Add($box)};[Windows.Controls.Grid]::SetColumn($panel,$index);[void]$grid.Children.Add($panel);$index++}
    $scroll.Content=$grid;$d.Content=$scroll;[void]$d.ShowDialog()
}
function Create-Exam-From-Template {
    $template=@($script:data.template | Where-Object {$_.title -match 'kiem|đề|test|exam'} | Select-Object -First 1);if(-not $template){$template=@($script:data.template|Select-Object -First 1)}
    $body=if($template){$template[0].body}else{'Chưa có mẫu; hãy trình bày theo ma trận, bản đặc tả, đề, đáp án và hướng dẫn chấm.'}
    Start-Work ("Dùng mẫu có sẵn dưới đây làm khung. Hãy tạo một đề kiểm tra mới bằng tiếng Việt, giữ đúng cấu trúc mẫu, thay nội dung câu hỏi, có ma trận, bản đặc tả, đáp án và hướng dẫn chấm.`n`nMẪU:`n"+$body)
}
if($Smoke){
    $window.Add_ContentRendered({
        Show-Page 'CongViec';(F 'TxtNoiDungViec').Text='Kiểm thử WPF giáo viên';(F 'BtnThemViec').RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
        Refresh;if(-not @($script:data.task|Where-Object{$_.title -eq 'Kiểm thử WPF giáo viên'}).Count){throw 'Task button failed'}
        $script:testPages=@('TrangChu','SoanVanBan','Mau','TroChuyen','NhiemVu','KiemTra','ChuNhiem','Xuong','CongViec','Lich','TongHop','TraCuu','ThuVien','TienIch','VanBanDen','CaiDat');$script:index=0
        $capture=New-Object Windows.Threading.DispatcherTimer;$capture.Interval=[TimeSpan]::FromMilliseconds(200)
        $capture.Add_Tick({param($s,$e)
            if($script:index -ge $script:testPages.Count){$s.Stop();[IO.File]::WriteAllText((Join-Path $script:data.root 'wpf-smoke.json'),(ConvertTo-Json @{pages=$script:testPages;errors=@($script:errors)} -Depth 6));$window.Close();return}
            $p=$script:testPages[$script:index];Show-Page $p;$window.UpdateLayout()
            if($ScreenshotDir){[void][IO.Directory]::CreateDirectory($ScreenshotDir);$v=$window.Content;$img=New-Object Windows.Media.Imaging.RenderTargetBitmap([int]$v.ActualWidth,[int]$v.ActualHeight,96,96,[Windows.Media.PixelFormats]::Pbgra32);$img.Render($v);$enc=New-Object Windows.Media.Imaging.PngBitmapEncoder;$enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($img));$stream=[IO.File]::Create((Join-Path $ScreenshotDir ($p+'.png')));try{$enc.Save($stream)}finally{$stream.Close()}}
            $script:index++
        });$capture.Start()
    })
}
. (Join-Path $PSScriptRoot 'school-link.ps1')
[void]$window.ShowDialog()
if($script:errors.Count){exit 2}
