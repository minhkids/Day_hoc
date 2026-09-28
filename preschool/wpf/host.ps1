param([switch]$Smoke,[string]$ScreenshotDir,[switch]$SmokeAI)

$ErrorActionPreference='Stop'

trap { [IO.File]::WriteAllText((Join-Path $env:TROLY_PRESCHOOL_DATA_DIR 'wpf-startup-error.txt'),($_.Exception.ToString()+"`n"+$_.InvocationInfo.PositionMessage));exit 2 }

Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# Thiet lap Application User Model ID va Window Icon de Windows Taskbar hien thi dung icon ung dung giao duc thay vi icon PowerShell
$appIdSource = @"
using System;
using System.Runtime.InteropServices;

[StructLayout(LayoutKind.Sequential, Pack = 4)]
public struct PROPERTYKEY
{
    public Guid fmtid;
    public uint pid;
}

[StructLayout(LayoutKind.Explicit)]
public struct PROPVARIANT
{
    [FieldOffset(0)] public ushort vt;
    [FieldOffset(8)] public IntPtr pwszVal;
}

[ComImport, Guid("886d8eeb-8cf2-4446-8d02-cdba1dbdcf99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IPropertyStore
{
    [PreserveSig] int GetCount(out uint cProps);
    [PreserveSig] int GetAt(uint iProp, out PROPERTYKEY pkey);
    [PreserveSig] int GetValue(ref PROPERTYKEY key, out PROPVARIANT pv);
    [PreserveSig] int SetValue(ref PROPERTYKEY key, ref PROPVARIANT pv);
    [PreserveSig] int Commit();
}

public class Shell32Helper {
    [DllImport("shell32.dll", SetLastError = true)]
    public static extern int SetCurrentProcessExplicitAppUserModelID([MarshalAs(UnmanagedType.LPWStr)] string AppID);

    [DllImport("shell32.dll", SetLastError = true)]
    public static extern int SHGetPropertyStoreForWindow(IntPtr hWnd, ref Guid riid, out IPropertyStore ppv);

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

    public static void SetWindowAppId(IntPtr hWnd, string appId) {
        try {
            Guid iid = new Guid("886d8eeb-8cf2-4446-8d02-cdba1dbdcf99");
            IPropertyStore store;
            if (SHGetPropertyStoreForWindow(hWnd, ref iid, out store) == 0 && store != null) {
                PROPERTYKEY pkey = new PROPERTYKEY {
                    fmtid = new Guid("9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3"),
                    pid = 5
                };
                PROPVARIANT pv = new PROPVARIANT {
                    vt = 31,
                    pwszVal = Marshal.StringToCoTaskMemUni(appId)
                };
                store.SetValue(ref pkey, ref pv);
                store.Commit();
                Marshal.FreeCoTaskMem(pv.pwszVal);
                Marshal.ReleaseComObject(store);
            }
        } catch {}
    }
}
"@
try {
    Add-Type -TypeDefinition $appIdSource -ErrorAction SilentlyContinue
    [Shell32Helper]::SetCurrentProcessExplicitAppUserModelID("TroLyGiaoDuc.MamNon.Desktop") | Out-Null
} catch {}

$client=New-Object Net.WebClient;$client.Encoding=[Text.Encoding]::UTF8;$client.Headers['X-TroLy-Token']=$env:TROLY_BRIDGE_TOKEN

function Api($action,$data=@{}) {

 $client.Headers['Content-Type']='application/json; charset=utf-8'

 $r=$client.UploadString(($env:TROLY_BRIDGE_URL+'/'+$action),(ConvertTo-Json -InputObject $data -Depth 25 -Compress))|ConvertFrom-Json

 if(-not $r.ok){throw $r.error};return $r.data

}

[xml]$xml=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'layout.xaml'))

$window=[Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))

$iconFile = Join-Path $PSScriptRoot 'icon.ico'
if(Test-Path -LiteralPath $iconFile){
    $window.Icon=[Windows.Media.Imaging.BitmapFrame]::Create([Uri]$iconFile)
}

$window.Add_SourceInitialized({
    try {
        $helper = New-Object Windows.Interop.WindowInteropHelper($window)
        $iconFile = Join-Path $PSScriptRoot 'icon.ico'
        if(Test-Path -LiteralPath $iconFile){
            [Shell32Helper]::SetIcon($helper.Handle, $iconFile)
        }
        [Shell32Helper]::SetWindowAppId($helper.Handle, "TroLyGiaoDuc.MamNon.Desktop")
    } catch {}
})

function F($name){$window.FindName($name)}

function Status($text){(F 'Status').Text=$text}

function Notice($text){Status $text;if(-not $Smoke){[void][Windows.MessageBox]::Show($window,$text,'Trợ lý Giáo viên Mầm non')}}

function Check-Update {
 Status 'Đang kiểm tra cập nhật từ xa...'
 try {
  [void](Api 'check_update' @{interactive=$true})
 } catch {
  Notice ('Không thể kết nối máy chủ cập nhật: '+$_.Exception.Message)
 }
}

function Copy-Text($text){
 if(-not $text){Notice 'Chưa có nội dung để sao chép.';return}
 try {
  [Windows.Clipboard]::SetText($text)
  Notice ("✅ ĐÃ SAO CHÉP THÀNH CÔNG!`n`nNội dung đã được lưu vào bộ nhớ tạm (Clipboard). Cô giáo có thể dán (Ctrl+V) ngay vào Zalo gửi phụ huynh hoặc tài liệu của lớp.")
 } catch {
  Notice ('Không thể sao chép: '+$_.Exception.Message)
 }
}

function Label($text,$size=14){$t=New-Object Windows.Controls.TextBlock;$t.Text=$text;$t.FontSize=$size;$t.TextWrapping='Wrap';$t.Margin='0,4,0,9';return $t}

function Button($title,$callback,$tag=$null){$b=New-Object Windows.Controls.Button;$b.Content=$title;$b.Tag=$tag;$b.Add_Click($callback);return $b}

function Add($parent,$child){[void]$parent.Children.Add($child)}

function Field($parent,$key,$title,$value='',$choices=$null,$multiline=$false){

 Add $parent (Label $title 12)

 if($choices){$c=New-Object Windows.Controls.ComboBox;foreach($v in $choices){[void]$c.Items.Add([string]$v)};$c.SelectedItem=[string]$value;if($c.SelectedIndex -lt 0){$c.SelectedIndex=0}}

 else {$c=New-Object Windows.Controls.TextBox;$c.Text=[string]$value;if($multiline){$c.AcceptsReturn=$true;$c.TextWrapping='Wrap';$c.Height=78;$c.VerticalScrollBarVisibility='Auto'}}

 $c.Name=$key;$script:ui[$key]=$c;Add $parent $c

}

function Value($key){$c=$script:ui[$key];if($c -is [Windows.Controls.ComboBox]){return [string]$c.SelectedItem};return $c.Text.Trim()}

function SetValue($key,$value){$c=$script:ui[$key];if($c -is [Windows.Controls.ComboBox]){$c.SelectedItem=[string]$value}else{$c.Text=[string]$value}}

function Refresh {$script:data=Api 'state';(F 'ProfileBadge').Text=($script:data.profile.classes+' · '+$script:data.profile.age).Trim(' ','·')}

function Panel(){return (New-Object Windows.Controls.StackPanel)}

function Section($title){$s=Panel;Add $s (Label $title 20);Add (F 'PageBody') $s;return $s}

function Pick($save=$false,$format='docx'){
 if($save){
  $d=New-Object Microsoft.Win32.SaveFileDialog
  $d.Filter=if($format -eq 'xlsx'){'File Excel (*.xlsx)|*.xlsx|Tất cả tệp (*.*)|*.*'}else{($format.ToUpper()+'|*.'+$format)}
  $d.DefaultExt=$format
 } else {
  $d=New-Object Microsoft.Win32.OpenFileDialog
  $d.Filter=if($format -eq 'xlsx'){'File Excel (*.xlsx;*.xls;*.csv)|*.xlsx;*.xls;*.csv|Tất cả tệp (*.*)|*.*'}else{'Tài liệu|*.docx;*.pdf;*.xlsx;*.csv;*.txt;*.md'}
 }
 if($d.ShowDialog($window)){return $d.FileName};return $null
}

function Confirm($text){if($Smoke){return $true};return ([Windows.MessageBox]::Show($window,$text,'Xác nhận','YesNo','Question') -eq 'Yes')}

$script:errors=New-Object 'System.Collections.Generic.List[string]'

$window.Dispatcher.Add_UnhandledException({param($s,$e)$script:errors.Add($e.Exception.ToString());Notice $e.Exception.Message;$e.Handled=$true})

$script:ui=@{};$script:nav=@{};$script:page='home';$script:docId=$null;$script:docCategory='';$script:recordId=$null

$script:session=$null;$script:job=$null;$script:files=@();$script:lastAnswer='';$script:dirty=$false

(F 'DocBody').Add_TextChanged({$script:dirty=$true})

(F 'DocTitle').Add_TextChanged({$script:dirty=$true})

function Save-Document {

 $item=@{title=(F 'DocTitle').Text.Trim();body=(F 'DocBody').Text;category=$script:docCategory}

 if($script:docId){$item.id=$script:docId}

 $r=Api 'save' @{kind='document';item=$item};$script:docId=$r.id;$script:dirty=$false;Status ('Đã lưu: '+$r.title)

}

function Open-Editor($title,$body,$id=$null,$category=''){

 if($script:dirty -and (F 'DocBody').Text.Trim() -and -not (Confirm 'Thay nội dung đang soạn bằng tài liệu này? Bấm No để quay lại lưu trước.')){return}

 $script:docId=$id;$script:docCategory=$category

 (F 'DocTitle').Text=$title;(F 'DocBody').Text=$body;$script:dirty=$false;Show-Page 'editor'

}

function Prepare-Template($id){

 $t=$script:data.catalog|Where-Object{$_.id -eq $id}|Select-Object -First 1

 $body=$t.body.Replace('Nhóm tuổi: [CẦN BỔ SUNG]',('Nhóm tuổi: '+$script:data.profile.age)).Replace('Lớp: [CẦN BỔ SUNG]',('Lớp: '+$script:data.profile.classes))

 Open-Editor $t.title $body $null $t.page

}

function Disclosure($parent,$title,$content){
 $e=New-Object Windows.Controls.Expander;$e.Header=$title;$e.Content=$content
 $e.Margin='0,8,0,16';$e.Padding='12';$e.Background='White';$e.FontSize=15
 Add $parent $e;return $e
}

function Cards($page){

 $wrap=New-Object Windows.Controls.Primitives.UniformGrid;$wrap.Columns=2

 foreach($t in $script:data.catalog|Where-Object{$_.page -eq $page}){

  $b=Button '' {param($s,$e)Prepare-Template ([string]$s.Tag)} $t.id

  $b.MinHeight=88;$b.Margin='0,0,14,14';$b.Padding='20';$b.Background='White';$b.HorizontalContentAlignment='Stretch'

  $stack=Panel;$title=Label $t.title 16;$title.FontWeight='SemiBold';Add $stack $title

  $b.ToolTip=$t.description

  $hint=Label 'Mở mẫu →' 12;$hint.Foreground='#207465';Add $stack $hint;$b.Content=$stack

  Add $wrap $b

 }

 if($page -in @('activities','parents','materials','legal','children','care','observations')){[void](Disclosure (F 'PageBody') 'Chọn mẫu có sẵn' $wrap)}else{Add (F 'PageBody') $wrap}

}

function Show-Home {
 $p=F 'PageBody'
 $hello=Label ('Chào '+$(if($script:data.profile.name){$script:data.profile.name}else{'cô / thầy'})+'!') 24
 $hello.FontWeight='SemiBold';Add $p $hello
 $hint=Label 'Hôm nay cô cần làm gì?' 15;$hint.Foreground='#668077';$hint.Margin='0,0,0,20';Add $p $hint
 $quick=New-Object Windows.Controls.Primitives.UniformGrid;$quick.Columns=2
 foreach($item in @(
  @('activities','Soạn hoạt động','Chuẩn bị bài dạy cho lớp','01'),
  @('children','Hồ sơ trẻ','Xem và cập nhật danh sách lớp','02'),
  @('observations','Theo dõi trẻ','Ghi lại tiến bộ trong ngày','03'),
  @('parents','Tin nhắn phụ huynh','Soạn lời nhắn cho gia đình','04')
 )){
  $b=Button '' {param($sender,$event)Show-Page ([string]$sender.Tag)} $item[0]
  $b.Background='White';$b.Padding='22';$b.Margin='0,0,14,14';$b.HorizontalContentAlignment='Stretch'
  $stack=Panel;$number=Label $item[3] 12;$number.Foreground='#207465';Add $stack $number
  $title=Label $item[1] 20;$title.FontWeight='SemiBold';Add $stack $title
  $desc=Label $item[2] 14;$desc.Foreground='#668077';Add $stack $desc
  $b.Content=$stack;Add $quick $b
 }
 Add $p $quick
 $stats=New-Object Windows.Controls.Primitives.UniformGrid;$stats.Columns=3;$stats.Margin='0,6,0,18'
 foreach($item in @(
  @('children',@($script:data.child).Count,'Trẻ trong lớp'),
  @('library',@($script:data.document).Count,'Tài liệu đã lưu'),
  @('calendar',@($script:data.task|Where-Object{$_.status -ne 'Hoàn thành'}).Count,'Việc đang chờ')
 )){
  $b=Button '' {param($sender,$event)Show-Page ([string]$sender.Tag)} $item[0]
  $b.Padding='16';$b.Margin='0,0,14,0';$b.HorizontalContentAlignment='Left'
  $stack=Panel;$n=Label ([string]$item[1]) 25;$n.FontWeight='SemiBold';Add $stack $n;Add $stack (Label $item[2] 13)
  $b.Content=$stack;Add $stats $b
 }
 Add $p $stats
 $tasksPanel=Section 'Việc sắp tới'
 $tasks=@($script:data.task|Where-Object{$_.status -ne 'Hoàn thành'}|Sort-Object due|Select-Object -First 3)
 if(-not $tasks.Count){Add $tasksPanel (Label 'Chưa có việc đang chờ.' 14)}
 foreach($t in $tasks){Add $tasksPanel (Label ($t.due+'  ·  '+$t.title) 14)}
 Add $tasksPanel (Button 'Mở lịch công việc →' {Show-Page 'calendar'})
 $barHome=New-Object Windows.Controls.WrapPanel;$barHome.Margin='0,14,0,0'
 Add $barHome (Button '🔄 Kiểm tra cập nhật phần mềm' {Check-Update})
 Add $p $barHome
}

function Show-Journal($kind){

 $script:journalKind=$kind;$script:recordId=$null

 $grid=New-Object Windows.Controls.Grid

 $left=New-Object Windows.Controls.ColumnDefinition;$left.Width='*';[void]$grid.ColumnDefinitions.Add($left)

 $right=New-Object Windows.Controls.ColumnDefinition;$right.Width='*';[void]$grid.ColumnDefinitions.Add($right)

 $form=Panel;$form.Margin='0,0,24,20';Add $grid $form

 $list=Panel;[Windows.Controls.Grid]::SetColumn($list,1);Add $grid $list;Add (F 'PageBody') $grid

 Field $form 'RecordDate' 'Ngày (yyyy-MM-dd)' (Get-Date -Format 'yyyy-MM-dd')

 Field $form 'Child' 'Mã hoặc tên trẻ / nhóm'

 if(@($script:data.child).Count -gt 0){
  $cList=@('--- Chọn nhanh trẻ từ danh mục ---')+(@($script:data.child)|ForEach-Object{$_.code+' - '+$_.name})
  Field $form 'ChildSelect' 'Hoặc chọn nhanh từ danh mục trẻ trong lớp' '' $cList
  $script:ui.ChildSelect.Add_SelectionChanged({
   $sel=Value 'ChildSelect'
   if($sel -and $sel -ne '--- Chọn nhanh trẻ từ danh mục ---'){SetValue 'Child' $sel}
  })
 }

 if($kind -eq 'observation'){

  Field $form 'Area' 'Lĩnh vực (chọn phù hợp độ tuổi)' '' $script:data.fields

  Field $form 'Level' 'Mức ghi nhận trong hoạt động' 'Đang thực hiện' @('Có tiến bộ','Đang thực hiện','Cần hỗ trợ thêm')

 }else{

  Field $form 'Attendance' 'Chuyên cần' '' @('Có mặt','Vắng có phép','Vắng chưa rõ lý do')

  Field $form 'Meal' 'Ăn / vệ sinh (ghi nhận thực tế)'

  Field $form 'Sleep' 'Giấc ngủ (ghi nhận thực tế)'

 }

 Field $form 'Notes' 'Quan sát / ghi nhận thực tế' '' $null $true

 $refineBar=New-Object Windows.Controls.WrapPanel;$refineBar.Margin='0,2,0,8'
 Add $refineBar (Button '🪄 AI Chuẩn hóa nhận xét sư phạm tích cực' {
  $rawNotes=(Value 'Notes').Trim()
  if(-not $rawNotes){Notice 'Vui lòng nhập ghi chép quan sát thô về trẻ trước khi chuẩn hóa.';return}
  Status 'AI đang chuẩn hóa nhận xét sư phạm và gợi ý biện pháp...'
  try {
   $area=if($script:journalKind -eq 'observation'){Value 'Area'}else{'Chăm sóc nề nếp'}
   $res=Api 'ai_refine_observation' @{
    child=(Value 'Child');
    notes=$rawNotes;
    area=$area;
    kind=$script:journalKind;
   }
   if($res -and $res.notes){
    SetValue 'Notes' $res.notes
    if($res.next){SetValue 'Next' $res.next}
    Status '✅ Đã chuẩn hóa nhận xét sư phạm thành công!'
    Notice ("✅ ĐÃ CHUẨN HÓA NHẬN XÉT SƯ PHẠM THÀNH CÔNG!`n`n- Nhận xét: "+$res.notes+"`n- Hướng dẫn hỗ trợ: "+$res.next)
   }
  } catch {
   Notice ('Lỗi: '+$_.Exception.Message)
  }
 })
 Add $form $refineBar

 Field $form 'Next' $(if($kind -eq 'care'){'Nội dung trao đổi với gia đình'}else{'Hỗ trợ tiếp theo'}) '' $null $true

 $bar=New-Object Windows.Controls.WrapPanel

 $save=Button 'Lưu ghi nhận' {Save-Record};$save.Name='SaveRecord';$script:ui.SaveRecord=$save;Add $bar $save

 Add $bar (Button 'Ghi nhận mới' {Show-Page $script:page})

 Add $form $bar

 Add $list (Label 'Sổ ghi nhận đã lưu' 18)

 Field $list 'SearchRecords' 'Tìm trẻ, ngày hoặc nội dung'

 $script:ui.SearchRecords.Add_TextChanged({Render-Records})

 $box=New-Object Windows.Controls.ListBox;$box.Height=340;$script:ui.RecordList=$box;Add $list $box

 $bar=New-Object Windows.Controls.WrapPanel

 Add $bar (Button 'Mở / sửa' {Load-Record})

 Add $bar (Button 'Xóa' {Delete-Record})

 Add $bar (Button 'Xuất sổ Excel' {$path=Pick $true 'xlsx';if($path){$r=Api 'export_records' @{kind=$script:journalKind;query=(Value 'SearchRecords');path=$path};Status ('Đã xuất '+$r.count+' ghi nhận: '+$path)}})

 Add $list $bar;Render-Records

 Add (F 'PageBody') (Label 'Mẫu hỗ trợ soạn nội dung' 20);Cards $kind.Replace('observation','observations')

}

function Render-Records {

 $box=$script:ui.RecordList;if(-not $box){return};$box.Items.Clear();$q=Value 'SearchRecords'

 foreach($r in @($script:data.($script:journalKind))|Sort-Object date -Descending){

  if($q -and (($r|ConvertTo-Json -Compress) -notlike ('*'+$q+'*'))){continue}

  $i=New-Object Windows.Controls.ListBoxItem;$i.Tag=$r;$i.Content=($r.date+' · '+$r.child+"`n"+$r.notes);$i.Padding='8';[void]$box.Items.Add($i)

 }

}

function Save-Record {

 $item=@{date=(Value 'RecordDate');child=(Value 'Child');notes=(Value 'Notes');next=(Value 'Next')}

 if($script:recordId){$item.id=$script:recordId}

 if($script:journalKind -eq 'observation'){$item.area=Value 'Area';$item.status=Value 'Level'}

 else{$item.attendance=Value 'Attendance';$item.meal=Value 'Meal';$item.sleep=Value 'Sleep'}

 $r=Api 'save' @{kind=$script:journalKind;item=$item};$script:recordId=$r.id;Refresh;Render-Records;Status 'Đã lưu ghi nhận vào sổ của lớp.'

}

function Load-Record {

 $i=$script:ui.RecordList.SelectedItem;if(-not $i){Notice 'Chọn một ghi nhận trong danh sách.';return};$r=$i.Tag;$script:recordId=$r.id

 SetValue 'RecordDate' $r.date;SetValue 'Child' $r.child;SetValue 'Notes' $r.notes;SetValue 'Next' $r.next

 if($script:journalKind -eq 'observation'){SetValue 'Area' $r.area;SetValue 'Level' $r.status}

 else{SetValue 'Attendance' $r.attendance;SetValue 'Meal' $r.meal;SetValue 'Sleep' $r.sleep}

 Status 'Đang sửa ghi nhận đã chọn.'

}

function Delete-Record {

 $i=$script:ui.RecordList.SelectedItem;if($i -and (Confirm 'Xóa ghi nhận đã chọn khỏi sổ?')){[void](Api 'delete' @{id=$i.Tag.id});$script:recordId=$null;Refresh;Render-Records;Status 'Đã chuyển ghi nhận vào thùng rác dữ liệu.'}

}

function Show-Children {

 $script:childId=$null

 $grid=New-Object Windows.Controls.Grid

 $col1=New-Object Windows.Controls.ColumnDefinition;$col1.Width=New-Object Windows.GridLength(1.1, [Windows.GridUnitType]::Star);[void]$grid.ColumnDefinitions.Add($col1)

 $col2=New-Object Windows.Controls.ColumnDefinition;$col2.Width=New-Object Windows.GridLength(1.2, [Windows.GridUnitType]::Star);[void]$grid.ColumnDefinitions.Add($col2)

 $form=Panel;$form.Margin='0,0,24,20';Add $grid $form

 $list=Panel;[Windows.Controls.Grid]::SetColumn($list,1);Add $grid $list;Add (F 'PageBody') $grid



 # --- NHÓM 1: THÔNG TIN TRẺ ---

 $h1=Label 'Thông tin trẻ' 15;$h1.FontWeight='Bold';$h1.Foreground='#207465';Add $form $h1

 $cGrid=New-Object Windows.Controls.Grid

 $cg1=New-Object Windows.Controls.ColumnDefinition;$cg1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid.ColumnDefinitions.Add($cg1)

 $cg2=New-Object Windows.Controls.ColumnDefinition;$cg2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid.ColumnDefinitions.Add($cg2)

 $pc1=Panel;$pc1.Margin='0,0,6,0';Field $pc1 'ChildCode' 'Mã định danh / Số danh bộ' ('TRE-'+((@($script:data.child).Count+1).ToString('D2')))

 $pc2=Panel;$pc2.Margin='6,0,0,0';[Windows.Controls.Grid]::SetColumn($pc2,1);Field $pc2 'ChildGender' 'Giới tính' 'Nam' @('Nam','Nữ')

 Add $cGrid $pc1;Add $cGrid $pc2;Add $form $cGrid

 Field $form 'ChildName' 'Họ và tên trẻ (*)' ''

 $cGrid2=New-Object Windows.Controls.Grid

 $cg3=New-Object Windows.Controls.ColumnDefinition;$cg3.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid2.ColumnDefinitions.Add($cg3)

 $cg4=New-Object Windows.Controls.ColumnDefinition;$cg4.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid2.ColumnDefinitions.Add($cg4)

 $pc3=Panel;$pc3.Margin='0,0,6,0';Field $pc3 'ChildDob' 'Ngày sinh (yyyy-MM-dd)' (Get-Date -Format 'yyyy-MM-dd')

 $pc4=Panel;$pc4.Margin='6,0,0,0';[Windows.Controls.Grid]::SetColumn($pc4,1);Field $pc4 'ChildClass' 'Nhóm / lớp' $script:data.profile.classes

 Add $cGrid2 $pc3;Add $cGrid2 $pc4;Add $form $cGrid2



 # --- NHÓM 2: THỂ TRẠNG & SỐ ĐO ---

 $baseForm=$form;$form=Panel;$healthForm=$form
 $h2=Label 'Sức khỏe của trẻ' 15;$h2.FontWeight='Bold';$h2.Foreground='#207465';Add $form $h2

 $mGrid=New-Object Windows.Controls.Grid

 $mg1=New-Object Windows.Controls.ColumnDefinition;$mg1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$mGrid.ColumnDefinitions.Add($mg1)

 $mg2=New-Object Windows.Controls.ColumnDefinition;$mg2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$mGrid.ColumnDefinitions.Add($mg2)

 $pm1=Panel;$pm1.Margin='0,0,6,0';Field $pm1 'ChildWeight' 'Cân nặng (kg)' ''

 $pm2=Panel;$pm2.Margin='6,0,0,0';[Windows.Controls.Grid]::SetColumn($pm2,1);Field $pm2 'ChildHeight' 'Chiều cao (cm)' ''

 Add $mGrid $pm1;Add $mGrid $pm2;Add $form $mGrid



 # Tự động tính chỉ số thể trạng khi giáo viên nhập số đo

 $script:ui.ChildWeight.Add_TextChanged({

  $w=Value 'ChildWeight';$h=Value 'ChildHeight'

  if($w -and $h){try{$g=Api 'evaluate_growth' @{weight=$w;height=$h};if($g.status){SetValue 'ChildNutrition' $g.status}}catch{}}

 })

 $script:ui.ChildHeight.Add_TextChanged({

  $w=Value 'ChildWeight';$h=Value 'ChildHeight'

  if($w -and $h){try{$g=Api 'evaluate_growth' @{weight=$w;height=$h};if($g.status){SetValue 'ChildNutrition' $g.status}}catch{}}

 })



 Field $form 'ChildNutrition' 'Đánh giá thể trạng dinh dưỡng' 'Bình thường (Kênh A)' @('Bình thường (Kênh A)','Suy dinh dưỡng nhẹ cân','Suy dinh dưỡng thấp còi','Nguy cơ thừa cân','Thừa cân / Béo phì')

 Field $form 'ChildHealthNotes' 'Lưu ý sức khỏe / tiền sử bệnh / dị ứng' '' $null $true



 # --- NHÓM 3: BỐ MẸ & LIÊN HỆ GIA ĐÌNH ---

 [void](Disclosure $baseForm 'Sức khỏe · số đo, dị ứng' $healthForm)
 $form=Panel;$familyForm=$form
 $h3=Label 'Liên hệ gia đình' 15;$h3.FontWeight='Bold';$h3.Foreground='#207465';Add $form $h3

 $fGrid=New-Object Windows.Controls.Grid

 $fg1=New-Object Windows.Controls.ColumnDefinition;$fg1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$fGrid.ColumnDefinitions.Add($fg1)

 $fg2=New-Object Windows.Controls.ColumnDefinition;$fg2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$fGrid.ColumnDefinitions.Add($fg2)

 $pf1=Panel;$pf1.Margin='0,0,6,0';Field $pf1 'ChildFatherName' 'Họ tên Bố' ''

 $pf2=Panel;$pf2.Margin='6,0,0,0';[Windows.Controls.Grid]::SetColumn($pf2,1);Field $pf2 'ChildFatherPhone' 'Số điện thoại Bố' ''

 Add $fGrid $pf1;Add $fGrid $pf2;Add $form $fGrid



 $mGrid2=New-Object Windows.Controls.Grid

 $mg3=New-Object Windows.Controls.ColumnDefinition;$mg3.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$mGrid2.ColumnDefinitions.Add($mg3)

 $mg4=New-Object Windows.Controls.ColumnDefinition;$mg4.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$mGrid2.ColumnDefinitions.Add($mg4)

 $pm3=Panel;$pm3.Margin='0,0,6,0';Field $pm3 'ChildMotherName' 'Họ tên Mẹ' ''

 $pm4=Panel;$pm4.Margin='6,0,0,0';[Windows.Controls.Grid]::SetColumn($pm4,1);Field $pm4 'ChildMotherPhone' 'Số điện thoại Mẹ' ''

 Add $mGrid2 $pm3;Add $mGrid2 $pm4;Add $form $mGrid2



 Field $form 'ChildEmergencyPhone' 'Người giám hộ / SĐT liên hệ khẩn cấp' ''



 [void](Disclosure $baseForm 'Gia đình · bố mẹ, liên hệ khẩn cấp' $familyForm)
 $form=$baseForm
 # --- NHÓM 4: NƠI Ở & CHUYỂN ĐỔI SÁP NHẬP PHƯỜNG ---
 $addrCard=New-Object Windows.Controls.Border;$addrCard.Background='#F0F7F4';$addrCard.BorderBrush='#B4D8CB';$addrCard.BorderThickness='1';$addrCard.CornerRadius='12';$addrCard.Padding='16';$addrCard.Margin='0,10,0,16'
 $as=Panel
 $at=Label 'Nơi ở của trẻ' 15;$at.FontWeight='Bold';$at.Foreground='#164B43';Add $as $at
 Add $as (Label 'Hỗ trợ chuyển đổi nơi ở linh hoạt giữa trước và sau khi sáp nhập đơn vị hành chính phường/xã (theo Nghị quyết sắp xếp đơn vị hành chính).' 12)

 $guideBox=New-Object Windows.Controls.Border;$guideBox.Background='#E8F4F0';$guideBox.BorderBrush='#95CFBE';$guideBox.BorderThickness='1';$guideBox.CornerRadius='8';$guideBox.Padding='10';$guideBox.Margin='0,6,0,10'
 $guidePanel=Panel
 $g1=Label '💡 Hướng dẫn nhập nơi ở và chuyển đổi phường:' 12;$g1.FontWeight='Bold';$g1.Foreground='#164B43';Add $guidePanel $g1
 $g2=Label '• Cô giáo CHỈ CẦN NHẬP: Tên Phường/Xã cũ (kèm Quận/Huyện, Tỉnh/TP nếu có, ví dụ: "Ngọc Thụy, Long Biên, Hà Nội" hoặc "Phường 5, Quận 3, TP.HCM"), KHÔNG CẦN nhập hết số nhà, ngõ ngách.' 11.5;$g2.Foreground='#205B51';Add $guidePanel $g2
 $g3=Label '• Bấm nút [📍 Chuyển đổi sang Phường mới] để hệ thống đổi sang tên đơn vị hành chính mới. Hệ thống KHÔNG tự động đổi ngầm khi lưu hồ sơ để cô chủ động kiểm tra.' 11.5;$g3.Foreground='#205B51';Add $guidePanel $g3
 $guideBox.Child=$guidePanel;[void](Disclosure $as 'Hướng dẫn chuyển đổi' $guideBox)

 Field $as 'ChildAddressOld' 'Địa chỉ trước sáp nhập' ''
 Field $as 'ChildAddressNew' 'Địa chỉ sau sáp nhập' ''

 $addrBar=New-Object Windows.Controls.WrapPanel
 $btnConvert=Button '📍 Chuyển đổi sang Phường mới' {
  $old=Value 'ChildAddressOld'
  if(-not $old){Notice 'Vui lòng nhập tên phường/xã cũ (kèm quận/huyện, tỉnh/tp nếu có) trước khi bấm chuyển đổi.';return}
  Status 'Đang tra cứu chuyển đổi sang tên phường/xã mới...'
  $res=Api 'ward_convert' @{address=$old;direction='old_to_new'}
  if($res.converted){
   SetValue 'ChildAddressNew' $res.result
   $src=if($res.source -eq 'geovina_api'){'🌐 GeoVina API'}else{'📋 Quy tắc nội bộ'}
   Status ($src+': '+$res.matched_old_ward+' ➔ '+$res.matched_new_ward)
   Notice ($res.note+"`n`nNguồn dữ liệu: "+$src+"`n`nNơi ở / Phường mới sau sáp nhập:`n"+$res.result)
  }else{
   SetValue 'ChildAddressNew' $old
   Notice ('Chưa có trong danh mục sáp nhập tự động. Đã sao chép sang ô nơi ở mới để cô chỉnh sửa theo thực tế:`n'+$old)
  }
 }
 $btnConvert.Style=$window.FindResource('Primary')
 Add $addrBar $btnConvert

 Add $addrBar (Button '⇄ Đổi chỗ Cũ ⇄ Mới' {
  $o=Value 'ChildAddressOld';$n=Value 'ChildAddressNew'
  SetValue 'ChildAddressOld' $n;SetValue 'ChildAddressNew' $o
 })

 Add $addrBar (Button '📜 Danh mục sáp nhập phường mẫu' {
  $rules=@($script:data.ward_rules)|Select-Object -First 10
  $txt="MỘT SỐ QUY TẮC SÁP NHẬP PHƯỜNG TIÊU BIỂU:`n`n"
  foreach($r in $rules){$txt+=('• '+$r.province+' ('+$r.district+'): '+$r.old_ward+' ➔ '+$r.new_ward+"`n")}
  $txt+="`n(Hệ thống nhận diện và thay thế tên phường cũ thành phường mới tương ứng)."
  Notice $txt
 })

 Add $as $addrBar
 $addrCard.Child=$as;[void](Disclosure $form 'Nơi ở · chuyển đổi phường / xã' $addrCard)



 $bar=New-Object Windows.Controls.WrapPanel

 $save=Button 'Lưu thông tin trẻ' {Save-Child};$save.Name='SaveChild';$script:ui.SaveChild=$save;$save.Style=$window.FindResource('Primary');Add $bar $save

 Add $bar (Button 'Nhập trẻ mới' {Show-Page 'children'})

 Add $form $bar



 # --- CỘT PHẢI: DANH SÁCH TRẺ & TIỆN ÍCH ---

 Add $list (Label 'Danh sách trẻ trong lớp' 18)

 $script:ui.ChildCountLabel=Label ('Tổng số: '+(@($script:data.child).Count.ToString())+' trẻ trong danh sách') 13

 $script:ui.ChildCountLabel.Foreground='#207465';$script:ui.ChildCountLabel.FontWeight='SemiBold';Add $list $script:ui.ChildCountLabel



 Field $list 'SearchChildren' 'Tìm tên trẻ, số điện thoại hoặc địa chỉ'

 $script:ui.SearchChildren.Add_TextChanged({Render-Children})



 $viewBar=New-Object Windows.Controls.WrapPanel;$viewBar.Margin='0,0,0,8'

 $script:addressViewMode='new'

 $script:ui.BtnToggleAddr=Button '📍 Đang xem nơi ở: SAU SÁP NHẬP (Bấm để đổi)' {

  if($script:addressViewMode -eq 'new'){

   $script:addressViewMode='old'

   $script:ui.BtnToggleAddr.Content='📍 Đang xem nơi ở: TRƯỚC SÁP NHẬP (Bấm để đổi)'

  }else{

   $script:addressViewMode='new'

   $script:ui.BtnToggleAddr.Content='📍 Đang xem nơi ở: SAU SÁP NHẬP (Bấm để đổi)'

  }

  Render-Children

 }

 Add $viewBar $script:ui.BtnToggleAddr

 Add $list $viewBar



 $box=New-Object Windows.Controls.ListBox;$box.Height=420;$script:ui.ChildrenList=$box;Add $list $box

 $box.Add_SelectionChanged({

  $i=$script:ui.ChildrenList.SelectedItem

  if($i -and $i.Tag){$r=$i.Tag;Status ('Đang chọn: '+$r.name+' ('+$r.code+')')}

 })



 $bar2=New-Object Windows.Controls.WrapPanel;$bar2.Margin='0,8,0,0'

 $btnTpl=Button '📄 Tải file Excel mẫu' {
  $path=Pick $true 'xlsx'
  if($path){
   $r=Api 'export_child_template' @{path=$path}
   Status ('Đã tạo file Excel mẫu: '+$path)
   Notice ('Đã tạo thành công file Excel mẫu danh sách lớp tại:`n'+$path+"`n`nCô giáo hãy mở file này, điền danh sách học sinh theo các cột mẫu, sau đó dùng nút [📥 Nạp danh sách từ Excel] để nạp tự động vào phần mềm.")
  }
 }
 Add $bar2 $btnTpl

 $btnImport=Button '📥 Nạp danh sách từ Excel' {
  $path=Pick $false 'xlsx'
  if($path){
   Status 'Đang đọc và nạp danh sách học sinh từ file Excel...'
   try{
    $r=Api 'import_children' @{path=$path}
    Refresh;Render-Children
    Status ('Đã nạp thành công '+$r.count+' trẻ từ file Excel.')
    Notice ('Đã nạp thành công '+$r.count+' trẻ vào danh sách lớp từ file Excel: '+$path+$(if($r.skipped -gt 0){"`n(Bỏ qua "+$r.skipped+" dòng trống / tiêu đề)"}))
   }catch{
    Notice ('Lỗi khi nạp file Excel: '+$_.Exception.Message)
   }
  }
 }
 $btnImport.Style=$window.FindResource('Primary')
 Add $bar2 $btnImport

 Add $bar2 (Button '📊 Xuất danh sách ra Excel' {
  $path=Pick $true 'xlsx'
  if($path){
   $r=Api 'export_records' @{kind='child';query=(Value 'SearchChildren');path=$path}
   Status ('Đã xuất '+$r.count+' trẻ: '+$path)
   Notice ('Đã xuất danh sách '+$r.count+' trẻ đầy đủ thông tin thể trạng, bố mẹ và nơi ở trước/sau sáp nhập sang file Excel: '+$path)
  }
 })

 Add $bar2 (Button 'Mở / Sửa' {Load-Child})

 Add $bar2 (Button 'Xóa trẻ' {Delete-Child})

 Add $bar2 (Button '📍 Chuyển đổi nơi ở cho tất cả trẻ' {Convert-All-Addresses})

 Add $list $bar2



 Render-Children

 Add (F 'PageBody') (Label 'Mẫu hỗ trợ quản lý hồ sơ trẻ' 20);Cards 'children'

}



function Render-Children {

 $box=$script:ui.ChildrenList;if(-not $box){return};$box.Items.Clear()

 $q=Value 'SearchChildren'

 $mode=$script:addressViewMode

 foreach($r in @($script:data.child)|Sort-Object name){

  if($q){

   $searchStr=($r.name+' '+$r.code+' '+$r.father_name+' '+$r.father_phone+' '+$r.mother_name+' '+$r.mother_phone+' '+$r.address_old+' '+$r.address_new)

   if($searchStr -notlike ('*'+$q+'*')){continue}

  }

  $i=New-Object Windows.Controls.ListBoxItem;$i.Tag=$r



  $w=if($r.weight){$r.weight+' kg'}else{'-'}

  $h=if($r.height){$r.height+' cm'}else{'-'}

  $nut=if($r.nutrition){' · '+$r.nutrition}else{''}

  $fInfo=if($r.father_name){'Bố: '+$r.father_name+$(if($r.father_phone){' ('+$r.father_phone+')'})}else{''}

  $mInfo=if($r.mother_name){'Mẹ: '+$r.mother_name+$(if($r.mother_phone){' ('+$r.mother_phone+')'})}else{''}

  $parentInfo=($fInfo+'  ·  '+$mInfo).Trim(' ','·')



  # Address display based on view mode

  if($mode -eq 'new'){

   $primaryAddr=if($r.address_new){$r.address_new}else{$r.address_old}

   $subAddr=if($r.address_old -and $r.address_old -ne $primaryAddr){'  (Trước sáp nhập: '+$r.address_old+')'}else{''}

   $addrText=('🏠 Nơi ở sau sáp nhập: '+$primaryAddr+$subAddr)

  }else{

   $primaryAddr=if($r.address_old){$r.address_old}else{$r.address_new}

   $subAddr=if($r.address_new -and $r.address_new -ne $primaryAddr){'  (Sau sáp nhập: '+$r.address_new+')'}else{''}

   $addrText=('🏠 Nơi ở trước sáp nhập: '+$primaryAddr+$subAddr)

  }



  $line1=($r.code+' · '+$r.name+' ('+$r.gender+' · '+$r.dob+') · Lớp: '+$r.class_name)

  $line2=('⚖️ Thể trạng: Cân nặng: '+$w+' | Chiều cao: '+$h+$nut)

  $line3=('👨‍👩‍👧 Gia đình: '+$parentInfo)

  $i.Content=($line1+"`n"+$line2+"`n"+$line3+"`n"+$addrText)

  $i.Padding='10';$i.BorderThickness='0,0,0,1';$i.BorderBrush='#EAEAEA'

  [void]$box.Items.Add($i)

 }

 if($script:ui.ChildCountLabel){$script:ui.ChildCountLabel.Text=('Tổng số: '+(@($script:data.child).Count.ToString())+' trẻ trong danh sách')}

}



function Save-Child {

 $item=@{

  code=(Value 'ChildCode');name=(Value 'ChildName');gender=(Value 'ChildGender');dob=(Value 'ChildDob');class_name=(Value 'ChildClass');

  weight=(Value 'ChildWeight');height=(Value 'ChildHeight');nutrition=(Value 'ChildNutrition');health_notes=(Value 'ChildHealthNotes');

  father_name=(Value 'ChildFatherName');father_phone=(Value 'ChildFatherPhone');

  mother_name=(Value 'ChildMotherName');mother_phone=(Value 'ChildMotherPhone');

  emergency_phone=(Value 'ChildEmergencyPhone');

  address_old=(Value 'ChildAddressOld');address_new=(Value 'ChildAddressNew')

 }

 if(-not $item.name){Notice 'Vui lòng nhập họ và tên trẻ.';return}

 if($script:childId){$item.id=$script:childId}

 $r=Api 'save' @{kind='child';item=$item}

 $script:childId=$r.id

 Refresh;Render-Children

 Status ('Đã lưu thông tin trẻ: '+$r.name+' ('+$r.code+')')

 $addrMsg=if($r.address_new){"`nNơi ở sau sáp nhập: "+$r.address_new}elseif($r.address_old){"`nNơi ở: "+$r.address_old}else{''}
 Notice ('Đã lưu thành công hồ sơ trẻ: '+$r.name+"`nThể trạng: "+$r.nutrition+$addrMsg)

}



function Load-Child {

 $i=$script:ui.ChildrenList.SelectedItem

 if(-not $i){Notice 'Chọn một trẻ trong danh sách để mở / sửa.';return}

 $r=$i.Tag;$script:childId=$r.id

 SetValue 'ChildCode' $r.code;SetValue 'ChildName' $r.name;SetValue 'ChildGender' $r.gender;SetValue 'ChildDob' $r.dob;SetValue 'ChildClass' $r.class_name

 SetValue 'ChildWeight' $r.weight;SetValue 'ChildHeight' $r.height;SetValue 'ChildNutrition' $r.nutrition;SetValue 'ChildHealthNotes' $r.health_notes

 SetValue 'ChildFatherName' $r.father_name;SetValue 'ChildFatherPhone' $r.father_phone

 SetValue 'ChildMotherName' $r.mother_name;SetValue 'ChildMotherPhone' $r.mother_phone

 SetValue 'ChildEmergencyPhone' $r.emergency_phone

 SetValue 'ChildAddressOld' $r.address_old;SetValue 'ChildAddressNew' $r.address_new

 Status ('Đang sửa hồ sơ trẻ: '+$r.name)

}



function Delete-Child {

 $i=$script:ui.ChildrenList.SelectedItem

 if($i -and (Confirm ('Xóa hồ sơ trẻ '+$i.Tag.name+' khỏi danh sách lớp?'))){

  [void](Api 'delete' @{id=$i.Tag.id})

  $script:childId=$null;Refresh;Render-Children

  Status 'Đã chuyển hồ sơ trẻ vào thùng rác dữ liệu.'

 }

}



function Convert-All-Addresses {

 # Collect all children needing conversion
 $toConvert=@()
 $idxMap=@{}
 $idx=0

 foreach($c in @($script:data.child)){

  if($c.address_old -and (-not $c.address_new -or $c.address_new -eq $c.address_old)){

   $toConvert+=$c.address_old

   $idxMap[$idx]=$c

   $idx++

  }

 }

 if($toConvert.Count -eq 0){Notice 'Tất cả trẻ đã có nơi ở sau sáp nhập hoặc chưa nhập địa chỉ cũ.';return}

 Status ('Đang gọi GeoVina API chuyển đổi hàng loạt '+$toConvert.Count+' địa chỉ...')

 $batchRes=Api 'ward_batch_convert' @{addresses=$toConvert}

 $count=0

 if($batchRes -and $batchRes.results){

  $results=@($batchRes.results)

  for($i=0;$i -lt $results.Count;$i++){

   $r=$results[$i]

   if($r.converted -and $idxMap.ContainsKey($i)){

    $child=$idxMap[$i]

    $child.address_new=$r.result

    [void](Api 'save' @{kind='child';item=$child})

    $count++

   }

  }

 }else{

  # Fallback: convert one by one if batch failed
  foreach($c in @($script:data.child)){

   if($c.address_old -and (-not $c.address_new -or $c.address_new -eq $c.address_old)){

    $res=Api 'ward_convert' @{address=$c.address_old;direction='old_to_new'}

    if($res.converted){$c.address_new=$res.result;[void](Api 'save' @{kind='child';item=$c});$count++}

   }

  }

 }

 Refresh;Render-Children

 Notice ('🌐 GeoVina API: Đã tự động chuyển đổi thành công nơi ở sau sáp nhập cho '+$count+' trẻ.')

}

function Show-Library {

 $p=F 'PageBody';$bar=New-Object Windows.Controls.WrapPanel

 Add $bar (Button 'Tài liệu mới' {Open-Editor 'Tài liệu mới' ''})

 Add $bar (Button 'Mở thư mục dữ liệu' {[void][Diagnostics.Process]::Start($script:data.root)})

 Add $p $bar;Field $p 'SearchLibrary' 'Tìm theo tiêu đề hoặc nội dung'

 $script:ui.SearchLibrary.Add_TextChanged({Render-Library})

 $box=New-Object Windows.Controls.ListBox;$box.Height=420;$script:ui.Library=$box;Add $p $box

 $bar=New-Object Windows.Controls.WrapPanel

 Add $bar (Button 'Mở tài liệu' {$i=$script:ui.Library.SelectedItem;if($i){$r=$i.Tag;Open-Editor $r.title $r.body $r.id $r.category}else{Notice 'Chọn tài liệu cần mở.'}})

 Add $bar (Button 'Xóa tài liệu' {$i=$script:ui.Library.SelectedItem;if($i -and (Confirm 'Xóa tài liệu đã chọn khỏi kho?')){[void](Api 'delete' @{id=$i.Tag.id});if($script:docId -eq $i.Tag.id){$script:docId=$null};Refresh;Render-Library}})

 Add $p $bar;Render-Library

}

function Render-Library {

 $box=$script:ui.Library;$box.Items.Clear();$q=Value 'SearchLibrary'

 foreach($r in $script:data.document){if($q -and ($r.title+' '+$r.body) -notlike ('*'+$q+'*')){continue};$i=New-Object Windows.Controls.ListBoxItem;$i.Tag=$r;$i.Content=$r.title+'  ·  '+$r.updated;$i.Padding='12';[void]$box.Items.Add($i)}

}

function Show-Calendar {

 $p=F 'PageBody';$script:taskId=$null

 Field $p 'TaskTitle' 'Việc cần làm';Field $p 'TaskDue' 'Hạn hoàn thành (yyyy-MM-dd)' (Get-Date -Format 'yyyy-MM-dd')

 Field $p 'TaskStatus' 'Trạng thái' '' @('Chưa làm','Đang làm','Hoàn thành')

 $bar=New-Object Windows.Controls.WrapPanel

 $save=Button 'Lưu công việc' {$item=@{title=(Value 'TaskTitle');due=(Value 'TaskDue');status=(Value 'TaskStatus')};if($script:taskId){$item.id=$script:taskId};$r=Api 'save' @{kind='task';item=$item};$script:taskId=$r.id;Refresh;Render-Tasks;Status 'Đã lưu công việc.'};$script:ui.SaveTask=$save;Add $bar $save

 Add $bar (Button 'Việc mới' {Show-Page 'calendar'});Add $p $bar

 $box=New-Object Windows.Controls.ListBox;$box.Height=290;$script:ui.Tasks=$box;Add $p $box

 $bar=New-Object Windows.Controls.WrapPanel

 Add $bar (Button 'Mở / sửa' {$i=$script:ui.Tasks.SelectedItem;if($i){$r=$i.Tag;$script:taskId=$r.id;SetValue 'TaskTitle' $r.title;SetValue 'TaskDue' $r.due;SetValue 'TaskStatus' $r.status}})

 Add $bar (Button 'Xóa công việc' {$i=$script:ui.Tasks.SelectedItem;if($i -and (Confirm 'Xóa công việc đã chọn?')){[void](Api 'delete' @{id=$i.Tag.id});$script:taskId=$null;Refresh;Render-Tasks}})

 Add $p $bar;Render-Tasks

}

function Render-Tasks {

 $script:ui.Tasks.Items.Clear();foreach($r in $script:data.task|Sort-Object due){$i=New-Object Windows.Controls.ListBoxItem;$i.Tag=$r;$i.Content=$r.due+' · '+$r.title+' · '+$r.status;$i.Padding='10';[void]$script:ui.Tasks.Items.Add($i)}

}

function Show-Settings {

 $p=F 'PageBody';$profile=$script:data.profile

 Field $p 'SettingName' 'Họ tên giáo viên' $profile.name;Field $p 'SettingSchool' 'Trường' $profile.agency

 Field $p 'SettingClass' 'Nhóm / lớp' $profile.classes;Field $p 'SettingAge' 'Độ tuổi' $profile.age $script:data.ages

 Field $p 'SettingYear' 'Năm học' $profile.year;Field $p 'SettingModel' 'Mã model OpenRouter' $profile.model

 Add $p (Label $(if($script:data.has_key){'API key đã lưu. Để trống để giữ khóa hiện tại.'}else{'API key OpenRouter — có thể cấu hình sau.'}) 12)

 $key=New-Object Windows.Controls.PasswordBox;$script:ui.Key=$key;Add $p $key

 $bar=New-Object Windows.Controls.WrapPanel

 $save=Button 'Lưu cài đặt' {

  $profile=@{name=(Value 'SettingName');agency=(Value 'SettingSchool');classes=(Value 'SettingClass');age=(Value 'SettingAge');year=(Value 'SettingYear');model=(Value 'SettingModel')}

  [void](Api 'settings' @{profile=$profile;key=$script:ui.Key.Password});$script:ui.Key.Clear();Refresh;Status 'Đã lưu thông tin lớp và cấu hình OpenRouter.'

 };$script:ui.SaveSettings=$save;Add $bar $save

 Add $bar (Button 'Xóa khóa API' {if(Confirm 'Xóa API key đã lưu trên máy?'){[void](Api 'settings' @{profile=@{};remove_key=$true});Refresh;Show-Page 'settings'}})

 Add $p $bar

 Add $p (Label 'Dữ liệu và trường học' 20)

 $bar=New-Object Windows.Controls.WrapPanel

 Add $bar (Button 'Sao lưu dữ liệu' {$path=Pick $true 'zip';if($path){[void](Api 'backup' @{path=$path});Status ('Đã sao lưu: '+$path)}})

 Add $bar (Button 'Cấu hình kết nối trường' {Set-SchoolConnection})

 Add $bar (Button 'Mở thư mục dữ liệu' {[void][Diagnostics.Process]::Start($script:data.root)})

 Add $p $bar

 Add $p (Label 'Cập nhật phần mềm' 20)

 $barUp=New-Object Windows.Controls.WrapPanel

 $btnCheckUpdate=Button 'Kiểm tra cập nhật' {Check-Update}
 $script:ui.CheckUpdate=$btnCheckUpdate
 Add $barUp $btnCheckUpdate
 Add $p $barUp

 Add $p (Label ('Dữ liệu của app: '+$script:data.root) 12)

 Add $p (Label 'Học liệu, sổ theo dõi, lịch và xuất tài liệu dùng được khi chưa có AI. Kết nối trường học mở cổng dùng chung để chia sẻ tài liệu đã xuất.' 13)

}

function Show-Activities {
 $p=F 'PageBody'

 $hero=New-Object Windows.Controls.Border;$hero.Background='White';$hero.BorderBrush='#A5D6A7';$hero.BorderThickness='1.5';$hero.CornerRadius='16';$hero.Padding='18';$hero.Margin='0,0,0,20'
 $hs=Panel
 $ht=Label 'Soạn hoạt động với AI' 18
 $ht.FontWeight='Bold';$ht.Foreground='#1B5E20';Add $hs $ht
 $hd=Label 'Chọn đề tài và thông tin lớp, rồi bấm Soạn với AI.' 13
 $hd.Foreground='#388E3C';$hd.Margin='0,0,0,12';Add $hs $hd

 $formGrid=New-Object Windows.Controls.Grid
 $col1=New-Object Windows.Controls.ColumnDefinition;$col1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$formGrid.ColumnDefinitions.Add($col1)
 $col2=New-Object Windows.Controls.ColumnDefinition;$col2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$formGrid.ColumnDefinitions.Add($col2)

 $leftCol=Panel;$leftCol.Margin='0,0,10,0';[Windows.Controls.Grid]::SetColumn($leftCol,0);Add $formGrid $leftCol
 $rightCol=Panel;$rightCol.Margin='10,0,0,0';[Windows.Controls.Grid]::SetColumn($rightCol,1);Add $formGrid $rightCol

 Field $leftCol 'ActTopic' 'Tên đề tài / Hoạt động trải nghiệm (*)' 'Khám phá sự chìm nổi của các vật'
 Field $leftCol 'ActAge' 'Độ tuổi của trẻ' $script:data.profile.age $script:data.ages
 $themes=if($script:data.themes){$script:data.themes}else{@('Trường mầm non','Bản thân','Gia đình','Nghề nghiệp','Thế giới thực vật','Thế giới động vật','Giao thông','Nước và các hiện tượng tự nhiên','Quê hương - Bác Hồ')}
 Field $leftCol 'ActTheme' 'Chủ đề năm học' 'Nước và các hiện tượng tự nhiên' $themes

 $methods=if($script:data.adv_methods){$script:data.adv_methods}else{@('STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)','STEAM (Quy trình EDP)','Montessori (5 góc)','Reggio Emilia (Dự án)','Học qua chơi & Lấy trẻ làm trung tâm')}
 Field $rightCol 'ActMethod' 'Phương pháp giáo dục áp dụng' $methods[0] $methods
 Field $rightCol 'ActDuration' 'Thời lượng dự kiến' '25–30 phút (Mẫu giáo nhỡ 4–5 tuổi)' @('15–20 phút (Nhà trẻ 24–36 tháng)','20–25 phút (Mẫu giáo bé 3–4 tuổi)','25–30 phút (Mẫu giáo nhỡ 4–5 tuổi)','30–35 phút (Mẫu giáo lớn 5–6 tuổi)')
 Field $rightCol 'ActMaterials' 'Học liệu & Đồ dùng sẵn có' 'Đồ tái chế an toàn (chai nhựa, bìa carton, cốc giấy, sỏi, lá cây)' @('Đồ tái chế an toàn (chai nhựa, bìa carton, cốc giấy, sỏi, lá cây)','Học liệu tự nhiên (lá khô, cánh hoa, hạt to an toàn)','Đồ chơi và đồ dùng có sẵn trong lớp','Không cần đồ dùng phức tạp')

 Add $hs $formGrid

 $actBar=New-Object Windows.Controls.WrapPanel;$actBar.Margin='0,14,0,0'
 $btnGenAct=Button 'Soạn với AI' {
  $topic=Value 'ActTopic'
  if(-not $topic){Notice 'Vui lòng nhập tên đề tài hoạt động.';return}
  Status 'Trợ lý AI đang thiết kế kế hoạch hoạt động giáo dục chi tiết...'
  try {
   $res=Api 'ai_activity_wizard' @{
    topic=$topic;
    age=(Value 'ActAge');
    theme=(Value 'ActTheme');
    method=(Value 'ActMethod');
    duration=(Value 'ActDuration');
    materials=(Value 'ActMaterials');
   }
   if($res -and $res.content){
    $script:ui.ActResultBox.Text=$res.content
    Status 'Đã soạn xong kế hoạch hoạt động giáo dục.'
   }
  } catch {
   Notice ('Lỗi: '+$_.Exception.Message)
  }
 }
 $btnGenAct.Style=$window.FindResource('Primary')
 Add $actBar $btnGenAct

 Add $actBar (Button 'Soạn nhanh' {
  $topic=Value 'ActTopic'
  if(-not $topic){Notice 'Vui lòng nhập tên đề tài hoạt động.';return}
  SetValue 'ActDuration' '15–20 phút (Nhà trẻ 24–36 tháng)'
  $btnGenAct.RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
 })

 Add $actBar (Button 'Mở mẫu trống' {Prepare-Template 'adv_method_activity'})
 Add $hs $actBar

 Add $hs (Label 'Bản soạn · có thể sửa trực tiếp' 13)
 $resBox=New-Object Windows.Controls.TextBox
 $resBox.AcceptsReturn=$true;$resBox.TextWrapping='Wrap';$resBox.VerticalScrollBarVisibility='Auto';$resBox.Height=180;$resBox.Background='#FFFFFF';$resBox.Padding='12';$resBox.FontSize=13
 $script:ui.ActResultBox=$resBox
 Add $hs $resBox

 $toolBar=New-Object Windows.Controls.WrapPanel;$toolBar.Margin='0,10,0,0'
 Add $toolBar (Button 'Chỉnh sửa & xuất file' {
  $txt=$script:ui.ActResultBox.Text.Trim()
  if($txt){Open-Editor (Value 'ActTopic') $txt $null 'activities'}else{Notice 'Chưa có nội dung để đưa sang Soạn thảo.'}
 })
 Add $toolBar (Button 'Sao chép' {
  Copy-Text $script:ui.ActResultBox.Text
 })
 Add $hs $toolBar

 $hero.Child=$hs;Add $p $hero

 Cards 'activities'
}

function Show-Parents {
 $p=F 'PageBody'

 $hero=New-Object Windows.Controls.Border;$hero.Background='White';$hero.BorderBrush='#FFE082';$hero.BorderThickness='1.5';$hero.CornerRadius='16';$hero.Padding='18';$hero.Margin='0,0,0,20'
 $hs=Panel
 $ht=Label 'Soạn tin nhắn phụ huynh' 18
 $ht.FontWeight='Bold';$ht.Foreground='#E65100';Add $hs $ht
 $hd=Label 'Chọn tình huống, soạn tin rồi sao chép để gửi.' 13
 $hd.Foreground='#EF6C00';$hd.Margin='0,0,0,12';Add $hs $hd

 $pScenarios=if($script:data.parent_scenarios){$script:data.parent_scenarios}else{@(
  'Bé va chạm / trầy xước nhẹ (Thông báo chân thành & Đã sơ cứu kịp thời)',
  'Bé bị bạn cắn hoặc cắn bạn (Xử lý thấu cảm, gắn kết gia đình)',
  'Bé sốt nhẹ / mệt / biếng ăn / nôn trớ trong ngày',
  'Khen ngợi bé có tiến bộ vượt bậc (Động viên, tạo niềm vui)',
  'Nhắc đón bé muộn / Dặn dò chuẩn bị đồ dùng cá nhân',
  'Kêu gọi phối hợp nguyên vật liệu tự nhiên / tái chế an toàn',
  'Thông báo hoạt động trải nghiệm / dã ngoại / ngày hội'
 )}

 Field $hs 'ParentScenario' 'Tình huống cần trao đổi với phụ huynh' $pScenarios[0] $pScenarios

 $childChoices=@('--- Chọn trẻ từ danh sách lớp ---')+(@($script:data.child)|ForEach-Object{$_.name})
 $cGrid=New-Object Windows.Controls.Grid
 $cg1=New-Object Windows.Controls.ColumnDefinition;$cg1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid.ColumnDefinitions.Add($cg1)
 $cg2=New-Object Windows.Controls.ColumnDefinition;$cg2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$cGrid.ColumnDefinitions.Add($cg2)

 $pc1=Panel;$pc1.Margin='0,0,10,0';[Windows.Controls.Grid]::SetColumn($pc1,0);Field $pc1 'ParentChildName' 'Họ và tên bé (*)' $(if(@($script:data.child).Count -gt 0){$script:data.child[0].name}else{'Bé Minh Khôi'})
 $pc2=Panel;$pc2.Margin='10,0,0,0';[Windows.Controls.Grid]::SetColumn($pc2,1);Field $pc2 'ParentChildPick' 'Hoặc chọn nhanh từ danh mục học sinh' '' $childChoices
 $script:ui.ParentChildPick.Add_SelectionChanged({
  $sel=Value 'ParentChildPick'
  if($sel -and $sel -ne '--- Chọn trẻ từ danh sách lớp ---'){SetValue 'ParentChildName' $sel}
 })
 Add $cGrid $pc1;Add $cGrid $pc2;Add $hs $cGrid

 Field $hs 'ParentDetails' 'Tình huống thực tế tại lớp' 'Lúc 10h bé vui chơi ở góc ngoài trời vấp nhẹ xước gối, cô đã rửa nước muối sinh lý và bôi thuốc, bé đã vui chơi và ăn cơm bình thường' $null $true

 $pBar=New-Object Windows.Controls.WrapPanel;$pBar.Margin='0,14,0,0'
 $btnGenMsg=Button 'Soạn tin với AI' {
  $name=Value 'ParentChildName'
  if(-not $name){Notice 'Vui lòng nhập tên bé.';return}
  Status 'Trợ lý AI đang soạn lời nhắn thấu cảm cho phụ huynh...'
  try {
   $res=Api 'ai_parent_message' @{
    scenario=(Value 'ParentScenario');
    child_name=$name;
    details=(Value 'ParentDetails');
   }
   if($res -and $res.content){
    $script:ui.ParentMsgPreview.Text=$res.content
    Status 'Đã soạn xong tin nhắn phụ huynh.'
   }
  } catch {
   Notice ('Lỗi: '+$_.Exception.Message)
  }
 }
 $btnGenMsg.Style=$window.FindResource('Primary')
 Add $pBar $btnGenMsg

 $btnCopyZalo=Button 'Sao chép tin nhắn' {
  Copy-Text $script:ui.ParentMsgPreview.Text
 }
 $btnCopyZalo.ToolTip='Sao chép nội dung đã kiểm tra để gửi cho phụ huynh'
 Add $pBar $btnCopyZalo

 Add $pBar (Button 'Mở mẫu thông báo' {Prepare-Template 'message'})
 Add $hs $pBar

 Add $hs (Label 'Tin nhắn · kiểm tra và sửa trước khi gửi' 13)
 $msgBox=New-Object Windows.Controls.TextBox
 $msgBox.AcceptsReturn=$true;$msgBox.TextWrapping='Wrap';$msgBox.VerticalScrollBarVisibility='Auto';$msgBox.Height=200;$msgBox.Background='#FFFFFF';$msgBox.Padding='12';$msgBox.FontSize=13
 $script:ui.ParentMsgPreview=$msgBox
 Add $hs $msgBox

 $hero.Child=$hs;Add $p $hero

 Cards 'parents'
}

function Show-Materials {
 $p=F 'PageBody'

 # Creative Play Studio (AI Studio)
 $hero=New-Object Windows.Controls.Border;$hero.Background='White';$hero.BorderBrush='#D1C4E9';$hero.BorderThickness='1.5';$hero.CornerRadius='16';$hero.Padding='18';$hero.Margin='0,0,0,20'
 $hs=Panel
 $ht=Label 'Sáng tác thơ & truyện' 18
 $ht.FontWeight='Bold';$ht.Foreground='#4A148C';Add $hs $ht
 $hd=Label 'Chọn thể loại và chủ đề để tạo học liệu cho lớp.' 13
 $hd.Foreground='#6A1B9A';$hd.Margin='0,0,0,12';Add $hs $hd

 $genres=if($script:data.creative_genres){$script:data.creative_genres}else{@(
  'Truyện ngắn có tên các bé trong lớp (kể trước giờ ngủ trưa)',
  'Bài thơ 4 chữ / 5 chữ ngắn dễ thuộc theo chủ đề',
  'Đồng dao / Vè vần điệu chuyển tiếp hoạt động',
  'Bộ 3 câu đố vui kích thích tư duy cho trẻ'
 )}
 Field $hs 'MatGenre' 'Thể loại sáng tác' $genres[0] $genres

 $defaultNames=if(@($script:data.child).Count -ge 2){$script:data.child[0].name+', '+$script:data.child[1].name}else{'Minh Khôi, Bảo An'}
 Field $hs 'MatChildren' 'Tên nhân vật / tên trẻ' $defaultNames
 Field $hs 'MatTopic' 'Chủ đề / Bài học giáo dục' 'Giữ gìn vệ sinh đôi bàn tay xinh và biết chia sẻ đồ chơi'

 $mBar=New-Object Windows.Controls.WrapPanel;$mBar.Margin='0,14,0,0'
 $btnGenMat=Button 'Sáng tác với AI' {
  Status 'AI đang sáng tác học liệu cho các con...'
  try {
   $res=Api 'ai_creative_studio' @{
    genre=(Value 'MatGenre');
    children_names=(Value 'MatChildren');
    topic=(Value 'MatTopic');
   }
   if($res -and $res.content){
    $script:ui.MatResultBox.Text=$res.content
    Status 'Đã sáng tác xong tác phẩm mầm non.'
   }
  } catch {
   Notice ('Lỗi: '+$_.Exception.Message)
  }
 }
 $btnGenMat.Style=$window.FindResource('Primary')
 Add $mBar $btnGenMat

 Add $mBar (Button 'Chỉnh sửa & xuất file' {
  $txt=$script:ui.MatResultBox.Text.Trim()
  if($txt){Open-Editor (Value 'MatTopic') $txt $null 'materials'}else{Notice 'Chưa có nội dung để đưa sang Soạn thảo.'}
 })
 Add $mBar (Button 'Sao chép' {
  Copy-Text $script:ui.MatResultBox.Text
 })
 Add $hs $mBar

 $matBox=New-Object Windows.Controls.TextBox
 $matBox.AcceptsReturn=$true;$matBox.TextWrapping='Wrap';$matBox.VerticalScrollBarVisibility='Auto';$matBox.Height=220;$matBox.Background='#FFFFFF';$matBox.Padding='12';$matBox.FontSize=13
 $script:ui.MatResultBox=$matBox
 Add $hs $matBox

 $hero.Child=$hs;Add $p $hero

 $p2=Section 'Dùng ngay cùng trẻ'
 Add $p2 (Button 'Mở trò chơi nhận biết màu sắc' {[void][Diagnostics.Process]::Start((Join-Path $PSScriptRoot '..\games\mau-sac.html'))})
 Add $p2 (Button 'Mở đồng hồ hoạt động' {[void][Diagnostics.Process]::Start((Join-Path $PSScriptRoot '..\games\dong-ho.html'))})
 Add $p2 (Label 'Giáo viên điều khiển trên màn hình chung; điều chỉnh thời gian và cách chơi theo độ tuổi.' 13)

 Cards 'materials'
}

function Launch-Situation-AI($sitName='Trẻ mới đi học khóc nhiều') {
 $age = if($script:data.profile.age){$script:data.profile.age}else{'Mẫu giáo 3–4 tuổi'}
 (F 'ChatPrompt').Text = "Hãy hướng dẫn sư phạm thực chiến cho giáo viên mầm non (nhóm lớp: $age) xử lý tình huống sau:`n`n- Tình huống: $sitName`n`nYêu cầu giải pháp:`n1. Hiểu đúng tâm lý của trẻ ở giai đoạn này`n2. Quy trình xử lý tại chỗ 3 bước (lời nói, hành động cụ thể của cô)`n3. Những điều TUYỆT ĐỐI KHÔNG ĐƯỢC LÀM`n4. Kịch bản trao đổi chân tình, xoa dịu phụ huynh cuối ngày."
 Show-Page 'chat'
}

function Launch-AdvMethod-AI($methodName='STEAM (Mô hình 5E)') {
 $age = if($script:data.profile.age){$script:data.profile.age}else{'Mẫu giáo 4–5 tuổi'}
 (F 'ChatPrompt').Text = "Hãy đóng vai Chuyên gia Giáo dục Mầm non, thiết kế chi tiết 01 Kế hoạch hoạt động giáo dục theo phương pháp tiên tiến sau:`n`n- Căn cứ pháp lý: Chương trình GDMN mới (VBHN 01/VBHN-BGDĐT & Thông tư 51/2020/TT-BGDĐT)`n- Phương pháp áp dụng: $methodName`n- Độ tuổi: $age`n- Yêu cầu cấu trúc:`n  1. Mục tiêu tích hợp (Kiến thức Khoa học/Giác quan, Kỹ năng công nghệ/kỹ thuật/toán/thực hành, Thái độ/Nghệ thuật theo phương pháp $methodName)`n  2. Chuẩn bị môi trường học tập mở, học liệu tự nhiên và vật liệu tái chế an toàn`n  3. Tiến trình tổ chức hoạt động chi tiết từng bước (cô gợi mở, đặt câu hỏi thế nào; trẻ trải nghiệm, thao tác gì)`n  4. Quan sát, hỗ trợ cá nhân trẻ nhút nhát và khơi gợi tư duy chủ động`n  5. Kết thúc, củng cố và điều chỉnh sau hoạt động.`n`nHãy tạo kế hoạch hoạt động hoàn chỉnh, sáng tạo, thực tế và sẵn sàng áp dụng ngay."
 Show-Page 'chat'
}

function Launch-SchoolStandards-AI($levelNum=2) {
 $schoolName = if($script:data.profile.agency){$script:data.profile.agency}else{'Trường Mầm non'}
 $levelDesc = switch($levelNum) {
  1 {'Mức 1 (Đạt chuẩn tối thiểu - Đạt kiểm định chất lượng Cấp độ 1)'}
  2 {'Mức 2 (Đạt chuẩn kiểm định Cấp độ 2 & Đạt Chuẩn Quốc gia Mức độ 1)'}
  3 {'Mức 3 (Đạt chuẩn kiểm định Cấp độ 3 & Đạt Chuẩn Quốc gia Mức độ 2)'}
  default {'Mức 2'}
 }
 (F 'ChatPrompt').Text = "Hãy thực hiện nghiệp vụ ĐÁNH GIÁ CHUẨN TRƯỜNG HỌC THEO THÔNG TƯ 19/2018/TT-BGDĐT VÀ THÔNG TƯ 13/2020/TT-BGDĐT:`n`n- Đơn vị: $schoolName`n- MỨC ĐỘ ĐÁNH GIÁ: $levelDesc`n`nNHIỆM VỤ CỦA BẠN (TỰ ĐỘNG LỌC NỘI DUNG THEO MỨC ĐỘ $levelNum):`n1. Tự động trích xuất và lọc đúng các tiêu chuẩn, tiêu chí và chỉ báo yêu cầu cho riêng Mức độ $levelNum trong 5 Tiêu chuẩn:`n   + Tiêu chuẩn 1: Tổ chức và quản lý nhà trường (10 tiêu chí)`n   + Tiêu chuẩn 2: Cán bộ quản lý, giáo viên, nhân viên (4 tiêu chí)`n   + Tiêu chuẩn 3: Cơ sở vật chất và thiết bị dạy học (6 tiêu chí - theo Thông tư 13/2020)`n   + Tiêu chuẩn 4: Quan hệ giữa nhà trường, gia đình và xã hội (2 tiêu chí)`n   + Tiêu chuẩn 5: Hoạt động và kết quả nuôi dưỡng, chăm sóc, giáo dục trẻ (5 tiêu chí)`n2. Đối chiếu thực trạng và đánh giá cụ thể từng tiêu chí (Đạt / Chưa đạt).`n3. Tổng hợp rõ ràng: Điểm mạnh nổi bật, Điểm yếu / Tồn tại cần khắc phục.`n4. Xây dựng Kế hoạch cải tiến chất lượng (giải pháp, lộ trình, người phụ trách).`n5. Lập Danh mục mã hóa minh chứng cần thu thập theo định dạng chuẩn [H1-1.01-01], [H2-2.01-01]... để nhà trường chuẩn bị hồ sơ kiểm định."
 Show-Page 'chat'
}

function Launch-SchoolStandards-FillAI {
 $schoolName = if($script:data.profile.agency){$script:data.profile.agency}else{'Trường Mầm non'}
 (F 'ChatPrompt').Text = "Hãy hoàn thiện BÁO CÁO VÀ BẢNG TỰ ĐÁNH GIÁ TRƯỜNG MẦM NON ĐẠT CHUẨN QUỐC GIA (Thông tư 19/2018/TT-BGDĐT & Thông tư 13/2020/TT-BGDĐT) cho cơ sở: $schoolName.`n`nYêu cầu lập bảng tổng hợp tự đánh giá đầy đủ 5 Tiêu chuẩn (25 Tiêu chí) đối chiếu qua cả 3 Mức độ: Mức 1 (Tối thiểu), Mức 2 (Chuẩn QG Mức 1), Mức 3 (Chuẩn QG Mức 2). Kèm theo phân tích Điểm mạnh, Điểm yếu, Kế hoạch cải tiến chất lượng và Danh mục mã minh chứng đầy đủ theo bảng mẫu chuẩn của Bộ GD&ĐT để nhà trường nộp Phòng GD&ĐT."
 Show-Page 'chat'
}

function Launch-PartyReview-AI {
 $name = if($script:data.profile.name){$script:data.profile.name}else{'Nguyễn Thị Lan'}
 $school = if($script:data.profile.agency){$script:data.profile.agency}else{'Trường Mầm non'}
 $class = if($script:data.profile.classes){$script:data.profile.classes}else{'Lớp Mẫu giáo Lớn'}
 (F 'ChatPrompt').Text = "Hãy soạn thảo BẢN KIỂM ĐIỂM ĐẢNG VIÊN CUỐI NĂM (MẪU 02-HD/BTCTW THEO QUY ĐỊNH 124-QĐ/TW) cho Giáo viên Mầm non:`n`n- Họ và tên Đảng viên: $name`n- Chi bộ: $school`n- Chức vụ chuyên môn: Giáo viên mầm non phụ trách $class`n`nYÊU CẦU VĂN PHONG VÀ CẤU TRÚC ĐẢNG CHUẨN MỰC:`n1. Phần I: Ưu điểm, kết quả công tác:`n   + Về tư tưởng chính trị, phẩm chất đạo đức lối sống, ý thức tổ chức kỷ luật, trách nhiệm nêu gương của nhà giáo.`n   + Về thực hiện chức trách nhiệm vụ được giao: Công tác nuôi dưỡng, chăm sóc, giáo dục trẻ; đổi mới phương pháp dạy học (STEAM, lấy trẻ làm trung tâm); bảo đảm an toàn tuyệt đối cho trẻ; quan hệ với phụ huynh.`n2. Phần II: Hạn chế, khuyết điểm và nguyên nhân thực tế trong công tác nuôi dạy trẻ.`n3. Phần III: Kết quả khắc phục khuyết điểm đã chỉ ra ở kỳ trước.`n4. Phần IV: Phương hướng, biện pháp khắc phục trong năm tiếp theo.`n5. Phần V: Tự nhận mức xếp loại chất lượng (Hoàn thành tốt nhiệm vụ / Hoàn thành xuất sắc nhiệm vụ).`n`nSoạn chi tiết, chân thành, sâu sát thực tế trường mầm non và đúng thể thức Đảng."
 Show-Page 'chat'
}

function Launch-PartyCommitment-AI {
 $name = if($script:data.profile.name){$script:data.profile.name}else{'Nguyễn Thị Lan'}
 $school = if($script:data.profile.agency){$script:data.profile.agency}else{'Trường Mầm non'}
 (F 'ChatPrompt').Text = "Hãy soạn BẢN CAM KẾT TU DƯỠNG, RÈN LUYỆN, PHẤN ĐẤU NĂM CỦA ĐẢNG VIÊN (Giáo viên mầm non tại $school, đồng chí $name) theo Quy định của Đảng:`n`nNội dung cam kết gồm 4 phần cốt lõi:`n1. Về tư tưởng chính trị: Kiên định mục tiêu lý tưởng, chấp hành chủ trương, chính sách.`n2. Về phẩm chất đạo đức, lối sống: Giữ gìn tư cách nhà giáo mầm non mẫu mực, trung thực, giản dị, yêu thương trẻ, chống tiêu cực lãng phí.`n3. Về thực hiện nhiệm vụ chuyên môn: Đảm bảo an toàn tuyệt đối tính mạng và sức khỏe cho trẻ, tích cực đổi mới phương pháp giáo dục tiên tiến, hoàn thành xuất sắc nhiệm vụ nuôi dạy trẻ.`n4. Về tổ chức kỷ luật và trách nhiệm nêu gương: Chấp hành Điều lệ Đảng, giữ gìn đoàn kết nội bộ, nêu gương sáng cho đồng nghiệp và phụ huynh.`n`nSoạn trang trọng, chuẩn thể thức văn bản Đảng."
 Show-Page 'chat'
}

function Launch-PartyMinutes-AI {
 $school = if($script:data.profile.agency){$script:data.profile.agency}else{'Trường Mầm non'}
 (F 'ChatPrompt').Text = "Hãy soạn BIÊN BẢN VÀ NGHỊ QUYẾT SINH HOẠT CHI BỘ ĐỊNH KỲ THÁNG CỦA CHI BỘ TRƯỜNG MẦM NON ($school):`n`nCấu trúc chuẩn:`n1. Thời gian, địa điểm, thành phần, chủ trì (Bí thư Chi bộ, Hiệu trưởng) và thư ký.`n2. Thông tin tình hình thời sự và quán triệt các văn bản chỉ đạo mới của Đảng ủy và ngành GD mầm non.`n3. Đánh giá công tác lãnh đạo của Chi bộ trong tháng qua: Công tác nuôi dạy trẻ, an toàn trường học, vệ sinh dinh dưỡng bán trú, công tác tư tưởng chính trị và xây dựng Đảng.`n4. Phương hướng nhiệm vụ trọng tâm tháng tới: Triển khai phương pháp giáo dục tiên tiến STEAM, chuẩn bị rà soát kiểm định trường chuẩn quốc gia, công tác phát triển đảng viên.`n5. Ý kiến thảo luận đóng góp của các đảng viên giáo viên.`n6. Kết luận của Bí thư Chi bộ và biểu quyết thông qua Nghị quyết Chi bộ.`n`nSoạn chi tiết, trang trọng, chuẩn mực sinh hoạt chi bộ trường học."
 Show-Page 'chat'
}

function Show-Legal {

 $p=F 'PageBody'

 $hero=New-Object Windows.Controls.Border;$hero.Background='#E8F2EE';$hero.CornerRadius='14';$hero.Padding='18';$hero.Margin='0,0,0,16'

 $hs=Panel

 Add $hs (Label 'Tra cứu văn bản giáo dục mầm non' 14)

 $syncMeta=$script:data.legal_sync

 $syncText='Tự động cập nhật khi có mạng'

 if($syncMeta -and $syncMeta.last_sync -and $syncMeta.last_sync -ne 'Chưa đồng bộ'){$syncText+=('  ·  Quét gần nhất: '+$syncMeta.last_sync)}

 $syncLabel=Label $syncText 12;$syncLabel.Foreground='#164B43';$syncLabel.FontWeight='SemiBold';Add $hs $syncLabel

 $topBar=New-Object Windows.Controls.WrapPanel

 Add $topBar (Button 'Cập nhật ngay' {

  Status 'Đang quét văn bản mới từ cổng thông tin…'

  try {

   $r=Api 'legal_sync'

   Refresh;Render-Legal

   Status ('Đã cập nhật xong: '+$r.total+' văn bản (có '+$r.new_count+' văn bản trực tuyến mới).')

   Notice ('Đã quét xong: Tìm thấy '+$r.new_count+' cập nhật trực tuyến mới từ các cổng chính thức.')

  } catch {

   Notice ('Không thể kết nối mạng: '+$_.Exception.Message+'. Đang hiển thị cơ sở dữ liệu đã tích hợp.')

  }

 })

 Add $topBar (Button 'Kiểm tra liên kết' {

  Status 'Đang kiểm tra đối chiếu link và nội dung về giáo viên của toàn bộ văn bản…'

  try {

   $r=Api 'legal_verify_all'

   Refresh;Render-Legal

   Notice ("KẾT QUẢ KIỂM TRA ĐƯỜNG DẪN TOÀN BỘ VĂN BẢN:`n`n- Tổng số văn bản: "+$r.total+"`n- Hợp lệ & chuẩn xác về giáo viên mầm non: "+$r.verified_count+"`n- Đã tự động khôi phục link chuẩn: "+$r.repaired_count+"`n- Không hợp lệ: "+$r.failed_count+"`n`nToàn bộ đường dẫn đã được đối chiếu đảm bảo đúng nội dung giáo viên mầm non.")

   Status ('Đã kiểm tra xong: '+$r.verified_count+'/'+$r.total+' link hợp lệ về giáo viên.')

  } catch {

   Notice ('Lỗi khi kiểm tra link: '+$_.Exception.Message)

  }

 })

 Add $topBar (Button 'Bộ GD&ĐT ↗' {[void][Diagnostics.Process]::Start('https://moet.gov.vn/van-ban/van-ban-quy-pham-phap-luat/Pages/default.aspx')})

 Add $topBar (Button 'Cổng Chính phủ ↗' {[void][Diagnostics.Process]::Start('https://vanban.chinhphu.vn')})

 Add $hs $topBar;$hero.Child=$hs;Add $p $hero



 # === TRUNG TÂM NGHIỆP VỤ & LIÊN KẾT TRỢ LÝ AI (THEO QUY ĐỊNH MỚI) ===
 $aiHub=New-Object Windows.Controls.Border
 $aiHub.Background='#F7FAF8'
 $aiHub.BorderBrush='#B4D4C8'
 $aiHub.BorderThickness='1.5'
 $aiHub.CornerRadius='14'
 $aiHub.Padding='16'
 $aiHub.Margin='0,0,0,16'

 $hubStack=Panel

 $hubTitle=Label 'Công cụ chuyên môn' 16
 $hubTitle.FontWeight='Bold'
 $hubTitle.Foreground='#173F39'
 Add $hubStack $hubTitle

 $hubDesc=Label 'Chuyên biệt cho Giáo viên & Trường Mầm non: Thiết kế hoạt động GD tiên tiến, Đánh giá trường chuẩn theo Mức độ 1, 2, 3, Bảng tự đánh giá Quốc gia và Cập nhật hồ sơ Đảng.' 12.5
 $hubDesc.Foreground='#466E63'
 $hubDesc.Margin='0,0,0,12'
 Add $hubStack $hubDesc

 $hubGrid=New-Object Windows.Controls.Grid
 $hgCol1=New-Object Windows.Controls.ColumnDefinition;$hgCol1.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$hubGrid.ColumnDefinitions.Add($hgCol1)
 $hgCol2=New-Object Windows.Controls.ColumnDefinition;$hgCol2.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$hubGrid.ColumnDefinitions.Add($hgCol2)
 $hgRow1=New-Object Windows.Controls.RowDefinition;[void]$hubGrid.RowDefinitions.Add($hgRow1)
 $hgRow2=New-Object Windows.Controls.RowDefinition;[void]$hubGrid.RowDefinitions.Add($hgRow2)

 # Ô 1: Phương pháp Giáo dục Tiên tiến
 $box1=New-Object Windows.Controls.Border;$box1.Background='#FFFFFF';$box1.BorderBrush='#C8E6C9';$box1.BorderThickness='1';$box1.CornerRadius='10';$box1.Padding='12';$box1.Margin='0,0,8,8'
 $b1s=Panel
 $b1Title=Label '🌟 1. PHƯƠNG PHÁP GD TIÊN TIẾN (STEAM, MONTESSORI...)' 13.5;$b1Title.FontWeight='Bold';$b1Title.Foreground='#2E7D32';Add $b1s $b1Title
 $b1Desc=Label 'Theo VBHN 01 & TT 51/2020: Soạn giáo án STEAM 5E, EDP, Montessori, Reggio Emilia, Học qua chơi lấy trẻ làm trung tâm.' 11.5;$b1Desc.Foreground='#558B2F';Add $b1s $b1Desc
 $b1Wrap=New-Object Windows.Controls.WrapPanel;$b1Wrap.Margin='0,6,0,0'
 Add $b1Wrap (Button '🔬 STEAM (Mô hình 5E)' {Launch-AdvMethod-AI 'STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)'})
 Add $b1Wrap (Button '⚙️ STEAM (Thiết kế EDP)' {Launch-AdvMethod-AI 'STEAM theo Quy trình thiết kế kỹ thuật EDP (Hỏi - Tưởng tượng - Kế hoạch - Chế tạo - Cải tiến)'})
 Add $b1Wrap (Button '🌿 Montessori' {Launch-AdvMethod-AI 'Phương pháp Montessori (5 lĩnh vực: Thực hành cuộc sống, Giác quan, Tự lập)'})
 Add $b1Wrap (Button '🎨 Reggio Emilia' {Launch-AdvMethod-AI 'Phương pháp Reggio Emilia (Học qua dự án, Xưởng sáng tạo Atelier, Môi trường là thầy)'})
 Add $b1Wrap (Button '🧸 Lấy trẻ làm trung tâm' {Launch-AdvMethod-AI 'Học qua chơi & Giáo dục lấy trẻ làm trung tâm (Thông tư 51/2020/TT-BGDĐT)'})
 Add $b1Wrap (Button '📄 Mở Mẫu Kế hoạch GD Tiên tiến' {Prepare-Template 'adv_method_activity'})
 Add $b1s $b1Wrap;$box1.Child=$b1s;[Windows.Controls.Grid]::SetColumn($box1, 0);[Windows.Controls.Grid]::SetRow($box1, 0);Add $hubGrid $box1

 # Ô 2: Đánh giá Chuẩn Trường học theo từng Mức độ
 $box2=New-Object Windows.Controls.Border;$box2.Background='#FFFFFF';$box2.BorderBrush='#BBDEFB';$box2.BorderThickness='1';$box2.CornerRadius='10';$box2.Padding='12';$box2.Margin='8,0,0,8'
 $b2s=Panel
 $b2Title=Label '🏛️ 2. ĐÁNH GIÁ CHUẨN TRƯỜNG THEO MỨC ĐỘ 1, 2, 3' 13.5;$b2Title.FontWeight='Bold';$b2Title.Foreground='#1565C0';Add $b2s $b2Title
 $b2Desc=Label 'Theo TT 19/2018 & TT 13/2020: AI tự động lọc 5 tiêu chuẩn & 25 tiêu chí theo từng mức độ để chỉ rõ Điểm mạnh, Tồn tại, Minh chứng.' 11.5;$b2Desc.Foreground='#1976D2';Add $b2s $b2Desc
 $b2Wrap=New-Object Windows.Controls.WrapPanel;$b2Wrap.Margin='0,6,0,0'
 Add $b2Wrap (Button '1️⃣ AI Đánh giá: Mức 1 (Tối thiểu / KĐCL Cấp 1)' {Launch-SchoolStandards-AI 1})
 Add $b2Wrap (Button '2️⃣ AI Đánh giá: Mức 2 (Chuẩn QG Mức 1)' {Launch-SchoolStandards-AI 2})
 Add $b2Wrap (Button '3️⃣ AI Đánh giá: Mức 3 (Chuẩn QG Mức 2)' {Launch-SchoolStandards-AI 3})
 Add $b2s $b2Wrap;$box2.Child=$b2s;[Windows.Controls.Grid]::SetColumn($box2, 1);[Windows.Controls.Grid]::SetRow($box2, 0);Add $hubGrid $box2

 # Ô 3: Bảng Tự Đánh giá Trường Chuẩn Quốc gia
 $box3=New-Object Windows.Controls.Border;$box3.Background='#FFFFFF';$box3.BorderBrush='#FFE082';$box3.BorderThickness='1';$box3.CornerRadius='10';$box3.Padding='12';$box3.Margin='0,8,8,0'
 $b3s=Panel
 $b3Title=Label '📊 3. BẢNG TỰ ĐÁNH GIÁ TRƯỜNG ĐẠT CHUẨN QG' 13.5;$b3Title.FontWeight='Bold';$b3Title.Foreground='#E65100';Add $b3s $b3Title
 $b3Desc=Label 'Biểu mẫu tổng hợp 5 tiêu chuẩn & 25 tiêu chí đầy đủ các mức độ theo Phụ lục TT 19/2018/TT-BGDĐT, sẵn sàng xuất Word/Excel nộp cấp trên.' 11.5;$b3Desc.Foreground='#EF6C00';Add $b3s $b3Desc
 $b3Wrap=New-Object Windows.Controls.WrapPanel;$b3Wrap.Margin='0,6,0,0'
 Add $b3Wrap (Button '📊 Mở Bảng tự đánh giá Chuẩn QG' {Prepare-Template 'school_standards_eval'})
 Add $b3Wrap (Button '🤖 AI Hỗ trợ điền hoàn thiện Bảng tự đánh giá' {Launch-SchoolStandards-FillAI})
 Add $b3s $b3Wrap;$box3.Child=$b3s;[Windows.Controls.Grid]::SetColumn($box3, 0);[Windows.Controls.Grid]::SetRow($box3, 1);Add $hubGrid $box3

 # Ô 4: Cập nhật Hồ sơ Đảng
 $box4=New-Object Windows.Controls.Border;$box4.Background='#FFFFFF';$box4.BorderBrush='#FFCDD2';$box4.BorderThickness='1';$box4.CornerRadius='10';$box4.Padding='12';$box4.Margin='8,8,0,0'
 $b4s=Panel
 $b4Title=Label '🚩 4. CẬP NHẬT HỒ SƠ ĐẢNG VIÊN & CHI BỘ' 13.5;$b4Title.FontWeight='Bold';$b4Title.Foreground='#C62828';Add $b4s $b4Title
 $b4Desc=Label 'Theo QĐ 124-QĐ/TW & HD 25-HD/BTCTW: Chuẩn hóa Bản kiểm điểm đảng viên cuối năm (Mẫu 02), Bản cam kết tu dưỡng và Biên bản sinh hoạt Chi bộ.' 11.5;$b4Desc.Foreground='#D32F2F';Add $b4s $b4Desc
 $b4Wrap=New-Object Windows.Controls.WrapPanel;$b4Wrap.Margin='0,6,0,0'
 Add $b4Wrap (Button '✍️ AI Soạn Bản kiểm điểm Đảng viên (Mẫu 02)' {Launch-PartyReview-AI})
 Add $b4Wrap (Button '📜 AI Soạn Bản cam kết tu dưỡng năm' {Launch-PartyCommitment-AI})
 Add $b4Wrap (Button '👥 AI Soạn Biên bản sinh hoạt Chi bộ' {Launch-PartyMinutes-AI})
 Add $b4Wrap (Button '📄 Mở Mẫu Kiểm điểm Đảng trong Soạn thảo' {Prepare-Template 'party_review'})
 Add $b4s $b4Wrap;$box4.Child=$b4s;[Windows.Controls.Grid]::SetColumn($box4, 1);[Windows.Controls.Grid]::SetRow($box4, 1);Add $hubGrid $box4

 Add $hubStack $hubGrid
 $aiHub.Child=$hubStack
 [void](Disclosure $p 'Công cụ chuyên môn · phương pháp, chuẩn trường, hồ sơ Đảng' $aiHub)



 Field $p 'SearchLegal' 'Tìm số hiệu, tên văn bản hoặc từ khóa'

 $script:ui.SearchLegal.Add_TextChanged({Render-Legal})



 $script:legalCategory='all'
 $categories=@(
  @('all','Tất cả văn bản'),@('thong_tu','Thông tư'),@('nghi_dinh','Nghị định'),
  @('cong_van','Công văn & hướng dẫn'),@('che_do','Chế độ & phụ cấp'),
  @('pp_tien_tien','Phương pháp giáo dục'),@('chuan_truong','Chuẩn trường'),@('ho_so_dang','Hồ sơ Đảng & chi bộ')
 )
 Add $p (Label 'Nhóm văn bản' 13)
 $filter=New-Object Windows.Controls.ComboBox;$filter.Width=280;$filter.HorizontalAlignment='Left'
 foreach($cat in $categories){$item=New-Object Windows.Controls.ComboBoxItem;$item.Content=$cat[1];$item.Tag=$cat[0];[void]$filter.Items.Add($item)}
 $filter.SelectedIndex=0
 $filter.Add_SelectionChanged({param($sender,$event)$script:legalCategory=[string]$sender.SelectedItem.Tag;Render-Legal})
 $script:ui.LegalCategory=$filter;Add $p $filter

  $grid=New-Object Windows.Controls.Grid

  $colLeft=New-Object Windows.Controls.ColumnDefinition;$colLeft.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$grid.ColumnDefinitions.Add($colLeft)

  $colRight=New-Object Windows.Controls.ColumnDefinition;$colRight.Width=New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star);[void]$grid.ColumnDefinitions.Add($colRight)



  $leftPanel=Panel;$leftPanel.Margin='0,0,16,0';Add $grid $leftPanel

  $rightPanel=Panel;[Windows.Controls.Grid]::SetColumn($rightPanel, 1);Add $grid $rightPanel

  Add $p $grid



  Add $leftPanel (Label 'Danh mục văn bản pháp luật mầm non' 16)

  $box=New-Object Windows.Controls.ListBox;$box.Height=480;$box.Padding='4';$script:ui.LegalList=$box

  $box.Add_SelectionChanged({Load-LegalDetail})

  Add $leftPanel $box



  $detailCard=New-Object Windows.Controls.Border;$detailCard.Background='White';$detailCard.BorderBrush='#D6E3DC';$detailCard.BorderThickness='1';$detailCard.CornerRadius='12';$detailCard.Padding='20';$detailCard.MinHeight=480

  $ds=Panel

  $script:ui.LegalDetailPanel=$ds

  $dNum=Label 'Chọn văn bản bên trái để xem tóm tắt và chi tiết' 18;$dNum.FontWeight='Bold';$script:ui.LegalDocNumber=$dNum;Add $ds $dNum

  $dTitle=Label '' 14;$dTitle.Foreground='#356D5C';$script:ui.LegalDocTitle=$dTitle;Add $ds $dTitle

  $dMeta=Label '' 12;$dMeta.Foreground='#668077';$script:ui.LegalDocMeta=$dMeta;Add $ds $dMeta



  $dVerifyCard=New-Object Windows.Controls.Border;$dVerifyCard.Background='#E8F5E9';$dVerifyCard.BorderBrush='#81C784';$dVerifyCard.BorderThickness='1';$dVerifyCard.CornerRadius='8';$dVerifyCard.Padding='10';$dVerifyCard.Margin='0,4,0,10'

  $dVerifyText=Label '' 12;$dVerifyText.FontWeight='SemiBold';$script:ui.LegalDocVerify=$dVerifyText;$script:ui.LegalDocVerifyCard=$dVerifyCard

  $dVerifyCard.Child=$dVerifyText;Add $ds $dVerifyCard



  $sumBox=New-Object Windows.Controls.TextBox;$sumBox.IsReadOnly=$true;$sumBox.AcceptsReturn=$true;$sumBox.TextWrapping='Wrap';$sumBox.VerticalScrollBarVisibility='Auto';$sumBox.Height=190;$sumBox.Background='#F7FAF8';$sumBox.BorderBrush='#CCE2D8';$sumBox.Padding='12';$sumBox.FontSize=13

  $script:ui.LegalDocSummary=$sumBox;Add $ds $sumBox



  $actBar=New-Object Windows.Controls.WrapPanel;$actBar.Margin='0,14,0,0'

  $btnUrl=Button 'Mở nguồn ↗' {

   $i=$script:ui.LegalList.SelectedItem

   if($i -and $i.Tag.url){[void][Diagnostics.Process]::Start([string]$i.Tag.url)}else{Notice 'Văn bản không có đường dẫn trực tuyến.'}

  }

  $btnVerify=Button '🔍 Kiểm tra link này' {

   $i=$script:ui.LegalList.SelectedItem

   if($i -and $i.Tag.url){

    Status 'Đang kiểm tra link…'

    try {

     $res=Api 'legal_verify' @{url=$i.Tag.url;number=$i.Tag.number;title=$i.Tag.title}

     if($res.valid){

      Notice ("✅ LIÊN KẾT CHUẨN XÁC VÀ HỢP LỆ VỀ GIÁO VIÊN!`n`n- Văn bản: "+$i.Tag.number+"`n- Lý do: "+$res.reason+"`n- Đường dẫn: "+$i.Tag.url)

     } else {

      Notice ("⚠️ LIÊN KẾT CÓ DẤU HIỆU SAI HOẶC KHÔNG PHẢI VỀ GIÁO VIÊN!`n`n- Lý do: "+$res.reason+"`n`nBạn có thể bấm nút 'Khôi phục link chuẩn' để lấy lại link Thư Viện Pháp Luật chính thức.")

     }

     Refresh;Render-Legal

    } catch {

     Notice ('Lỗi khi kiểm tra link: '+$_.Exception.Message)

    }

   } else {

    Notice 'Không tìm thấy liên kết để kiểm tra.'

   }

  }

  $btnRepair=Button '🔄 Khôi phục link chuẩn' {

   $i=$script:ui.LegalList.SelectedItem

   if($i -and $i.Tag.id){

    try {

     $rep=Api 'legal_repair_link' @{id=$i.Tag.id}

     if($rep.ok){

      Refresh;Render-Legal

      Notice ("Đã khôi phục liên kết chuẩn xác từ Thư Viện Pháp Luật thành công:`n`n"+$rep.url)

     } else {

      Notice ('Không thể khôi phục link: '+$rep.error)

     }

    } catch {

     Notice ('Lỗi: '+$_.Exception.Message)

    }

   }

  }

  $btnPlan=Button 'Tạo kế hoạch' {

   $i=$script:ui.LegalList.SelectedItem

   if($i){

    $doc=$i.Tag

    $body="# KẾ HOẠCH TRIỂN KHAI VĂN BẢN`n`nVăn bản: "+$doc.number+" - "+$doc.title+"`nCơ quan ban hành: "+$doc.issuer+"`nNgày ban hành: "+$doc.date+" · Hiệu lực: "+$doc.effective_date+"`n`n## 1. Tóm tắt điểm mới và quy định cốt lõi`n"+$doc.summary+"`n`n## 2. Nhiệm vụ cần điều chỉnh tại nhóm / lớp`n- [Ghi các việc cô cần điều chỉnh theo quy định mới]`n`n## 3. Kiến nghị và đề xuất với nhà trường`n- [CẦN BỔ SUNG]"

    Open-Editor ('Kế hoạch thực hiện '+$doc.number) $body $null 'legal'

   }

  }

  $btnAI=Button 'Hỏi AI' {

   $i=$script:ui.LegalList.SelectedItem

   if($i){

    $doc=$i.Tag

    (F 'ChatPrompt').Text="Hãy giải thích chi tiết quy định này và hướng dẫn những điểm giáo viên mầm non cần lưu ý khi thực hiện tại nhóm lớp:`n`nVăn bản: "+$doc.number+" ("+$doc.issuer+")`nTiêu đề: "+$doc.title+"`n`nNội dung chính:`n"+$doc.summary

    Show-Page 'chat'

   }

  }

  $btnAIAdv=Button '🌟 AI Soạn PP Tiên tiến' {
   $i=$script:ui.LegalList.SelectedItem
   $docNum=if($i){$i.Tag.number}else{'VBHN 01/VBHN-BGDĐT'}
   Launch-AdvMethod-AI ('Ứng dụng '+$docNum+' (STEAM 5E / Lấy trẻ làm trung tâm)')
  }

  $btnAISchoolStd=Button '🏛️ AI Đánh giá Chuẩn Trường' {
   Launch-SchoolStandards-AI 2
  }

  $btnStdTable=Button '📊 Bảng Tự Đánh giá Chuẩn' {
   Prepare-Template 'school_standards_eval'
  }

  $btnAIParty=Button '🚩 AI Soạn Kiểm điểm Đảng' {
   Launch-PartyReview-AI
  }

  Add $actBar $btnUrl;Add $actBar $btnPlan;Add $actBar $btnAI;Add $ds $actBar
  $more=New-Object Windows.Controls.WrapPanel
  foreach($b in @($btnVerify,$btnRepair,$btnAIAdv,$btnAISchoolStd,$btnStdTable,$btnAIParty)){Add $more $b}
  [void](Disclosure $ds 'Thao tác khác' $more)

  $detailCard.Child=$ds;Add $rightPanel $detailCard



  Render-Legal

  Cards 'legal'

}

function Render-Legal {

 $box=$script:ui.LegalList;if(-not $box){return};$box.Items.Clear()

 $q=Value 'SearchLegal';$cat=$script:legalCategory

 foreach($d in @($script:data.legal)){

  if($cat -eq 'nghi_dinh' -and $d.type -notlike '*Nghị định*'){continue}

  if($cat -eq 'thong_tu' -and $d.type -notlike '*Thông tư*'){continue}

  if($cat -eq 'cong_van' -and $d.type -notlike '*Công văn*' -and $d.category -notlike '*Công văn*'){continue}

  if($cat -eq 'che_do' -and $d.category -notlike '*Chế độ*' -and $d.category -notlike '*Phụ cấp*'){continue}

  if($cat -eq 'chuyen_mon' -and $d.category -notlike '*Chuyên môn*' -and $d.category -notlike '*Điều lệ*'){continue}

  if($cat -eq 'pp_tien_tien' -and $d.category -notlike '*Phương pháp*' -and $d.category -notlike '*Chương trình*'){continue}

  if($cat -eq 'chuan_truong' -and $d.category -notlike '*Chuẩn trường*' -and $d.category -notlike '*Kiểm định*'){continue}

  if($cat -eq 'ho_so_dang' -and $d.category -notlike '*Hồ sơ Đảng*' -and $d.category -notlike '*Đảng*'){continue}

  if($q){

   $text=($d.number+' '+$d.title+' '+$d.summary+' '+$d.issuer+' '+$d.category)

   if($text -notlike ('*'+$q+'*')){continue}

  }

  $i=New-Object Windows.Controls.ListBoxItem;$i.Tag=$d

  $vBadge=if($d.verified){' [✅ Chuẩn GV mầm non]'}else{' [⚠️ Cần kiểm tra]'}

  $i.Content=('['+$d.type+'] '+$d.number+$vBadge+"`n"+$d.title+"`nBan hành: "+$d.date+' · '+$d.status)

  $i.Padding='10';$i.BorderThickness='0,0,0,1';$i.BorderBrush='#EAEAEA'

  [void]$box.Items.Add($i)

 }

 if($box.Items.Count -gt 0){$box.SelectedIndex=0;Load-LegalDetail}

}

function Load-LegalDetail {

 $box=$script:ui.LegalList;if(-not $box -or -not $box.SelectedItem){return}

 $d=$box.SelectedItem.Tag

 $script:ui.LegalDocNumber.Text=($d.number+' ('+$d.status+')')

 $script:ui.LegalDocTitle.Text=$d.title

 $script:ui.LegalDocMeta.Text=('Cơ quan: '+$d.issuer+'  ·  Ngày ban hành: '+$d.date+'  ·  Hiệu lực: '+$d.effective_date+'  ·  Nguồn: '+$d.source_name)

 if($script:ui.LegalDocVerify -and $script:ui.LegalDocVerifyCard){

  if($d.verified){

   $script:ui.LegalDocVerifyCard.Background='#E8F5E9'

   $script:ui.LegalDocVerifyCard.BorderBrush='#81C784'

   $script:ui.LegalDocVerify.Foreground='#2E7D32'

   $note=if($d.verification_note){$d.verification_note}else{'Nội dung văn bản và đường dẫn đã được đối chiếu chuẩn xác về giáo viên mầm non.'}

   $script:ui.LegalDocVerify.Text='✅ ĐÃ XÁC THỰC: '+$note

  } else {

   $script:ui.LegalDocVerifyCard.Background='#FFF3E0'

   $script:ui.LegalDocVerifyCard.BorderBrush='#FFB74D'

   $script:ui.LegalDocVerify.Foreground='#E65100'

   $note=if($d.verification_note){$d.verification_note}else{'Đường dẫn cần được kiểm tra đối chiếu lại.'}

   $script:ui.LegalDocVerify.Text='⚠️ CẢNH BÁO: '+$note

  }

 }

 $script:ui.LegalDocSummary.Text="🎯 TÓM TẮT ĐIỂM MỚI VÀ TÁC ĐỘNG ĐẾN GIÁO VIÊN MẦM NON:`n`n"+$d.summary

}

function Show-Page($id){

 $script:page=$id;Refresh;$script:ui=@{};(F 'PageBody').Children.Clear()

 foreach($key in $script:nav.Keys){$script:nav[$key].Background=$(if($key -eq $id){'#356D5C'}else{'Transparent'})}

 (F 'EditorPanel').Visibility='Collapsed';(F 'ChatPanel').Visibility='Collapsed';(F 'PageScroll').Visibility='Visible'

 $meta=$script:data.pages|Where-Object{$_[0] -eq $id}|Select-Object -First 1

 if($meta){(F 'PageTitle').Text=$meta[1];(F 'PageSubtitle').Text=$meta[2];if($shortNames -and $shortNames.ContainsKey($id)){(F 'PageTitle').Text=$shortNames[$id]}}

 switch($id){

  'home' {Show-Home}

  'activities' {Show-Activities}

  'children' {Show-Children}

  'observations' {Show-Journal 'observation'}

  'care' {Show-Journal 'care'}

  'parents' {Show-Parents}

  'legal' {Show-Legal}

  'library' {Show-Library}

  'calendar' {Show-Calendar}

  'settings' {Show-Settings}

  'materials' {Show-Materials}

  'editor' {(F 'PageTitle').Text='Soạn tài liệu';(F 'PageSubtitle').Text='Chỉnh sửa, lưu và xuất hồ sơ của lớp';(F 'PageScroll').Visibility='Collapsed';(F 'EditorPanel').Visibility='Visible'}

  'chat' {(F 'PageScroll').Visibility='Collapsed';(F 'ChatPanel').Visibility='Visible'}

  default {Cards $id}

 }

 (F 'PageScroll').ScrollToTop()

}

Refresh

$navGroups=@(
 @('HẰNG NGÀY',@('home','activities','plans','materials')),
 @('LỚP CỦA CÔ',@('children','observations','care','parents','calendar')),
 @('TÀI LIỆU & HỖ TRỢ',@('professional','legal','library','chat','settings'))
)
$shortNames=@{care='Chăm sóc trẻ';parents='Tin nhắn phụ huynh';legal='Tra cứu văn bản';materials='Học liệu & trò chơi';children='Hồ sơ trẻ'}
foreach($group in $navGroups){
 $heading=Label $group[0] 10;$heading.Foreground='#A7C8BA';$heading.Margin='14,14,0,6';$heading.FontWeight='SemiBold';Add (F 'NavPanel') $heading
 foreach($id in $group[1]){
  $meta=$script:data.pages|Where-Object{$_[0] -eq $id}|Select-Object -First 1
  $title=if($shortNames.ContainsKey($id)){$shortNames[$id]}else{$meta[1]}
  $b=Button $title {param($sender,$event)Show-Page ([string]$sender.Tag)} $id
  $b.Style=$window.FindResource('Nav');$b.ToolTip=$meta[2];$b.Name='Nav_'+$id;$script:nav[$id]=$b;Add (F 'NavPanel') $b
 }
}

. (Join-Path $PSScriptRoot 'school-link.ps1')

(F 'BtnSchool').Add_Click({Open-SchoolWorkspace})
$bNav=F 'BtnCheckUpdateNav'
if($bNav){$bNav.Add_Click({Check-Update})}
$bTop=F 'BtnTopUpdate'
if($bTop){$bTop.Add_Click({Check-Update})}

(F 'BtnSaveDoc').Add_Click({Save-Document})

(F 'BtnDocAI').Add_Click({(F 'ChatPrompt').Text="Hãy hoàn thiện dự thảo sau theo thông tin đã có. Hỏi lại hoặc giữ [CẦN BỔ SUNG] nếu thiếu. Không bịa ghi nhận về trẻ.`n`n"+(F 'DocTitle').Text+"`n"+(F 'DocBody').Text;Show-Page 'chat'})

(F 'BtnImport').Add_Click({$path=Pick;if($path){$r=Api 'read' @{path=$path};Open-Editor ([IO.Path]::GetFileNameWithoutExtension($path)) $r.text}})

foreach($pair in @(@('BtnWord','docx'),@('BtnSlides','pptx'),@('BtnExcel','xlsx'))){$b=F $pair[0];$b.Tag=$pair[1];$b.Add_Click({param($s,$e)if(-not (F 'DocBody').Text.Trim()){Notice 'Nhập nội dung trước khi xuất.';return};$path=Pick $true ([string]$s.Tag);if($path){[void](Api 'export' @{title=(F 'DocTitle').Text;body=(F 'DocBody').Text;format=$s.Tag;path=$path});Status ('Đã xuất: '+$path)}})}

function Convert-MarkdownToInlines {
    param([string]$text)
    $inlines = New-Object System.Collections.Generic.List[System.Windows.Documents.Inline]
    $parts = [System.Text.RegularExpressions.Regex]::Split($text, '(\*\*.*?\*\*)')
    foreach ($part in $parts) {
        if ([string]::IsNullOrEmpty($part)) { continue }
        if ($part.StartsWith('**') -and $part.EndsWith('**') -and $part.Length -ge 4) {
            $inner = $part.Substring(2, $part.Length - 4)
            $bold = New-Object Windows.Documents.Bold
            [void]$bold.Inlines.Add((New-Object Windows.Documents.Run($inner)))
            [void]$inlines.Add($bold)
        } else {
            [void]$inlines.Add((New-Object Windows.Documents.Run($part)))
        }
    }
    return $inlines
}

function Build-FormattedBlock {
    param([string]$rawText)
    $panel = New-Object Windows.Controls.StackPanel
    $lines = $rawText -split "`r?`n"
    $i = 0
    while ($i -lt $lines.Length) {
        $line = $lines[$i]
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            $spacer = New-Object Windows.Controls.Border
            $spacer.Height = 8
            [void]$panel.Children.Add($spacer)
            $i++
            continue
        }
        if ($trimmed -match '^(#{1,3})\s+(.*)$') {
            $level = $matches[1].Length
            $headingText = $matches[2]
            $tb = New-Object Windows.Controls.TextBlock
            $tb.TextWrapping = [Windows.TextWrapping]::Wrap
            $tb.Margin = New-Object Windows.Thickness(0, 8, 0, 4)
            $tb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#13423B'))
            if ($level -eq 1) {
                $tb.FontSize = 17
                $tb.FontWeight = [Windows.FontWeights]::Bold
            } elseif ($level -eq 2) {
                $tb.FontSize = 15.5
                $tb.FontWeight = [Windows.FontWeights]::SemiBold
            } else {
                $tb.FontSize = 14.5
                $tb.FontWeight = [Windows.FontWeights]::SemiBold
            }
            foreach ($inl in (Convert-MarkdownToInlines $headingText)) { [void]$tb.Inlines.Add($inl) }
            [void]$panel.Children.Add($tb)
            $i++
            continue
        }
        if ($trimmed -match '^[-*•]\s+(.*)$') {
            $itemText = $matches[1]
            $dp = New-Object Windows.Controls.DockPanel
            $dp.Margin = New-Object Windows.Thickness(4, 2, 0, 2)
            $bullet = New-Object Windows.Controls.TextBlock
            $bullet.Text = "• "
            $bullet.FontWeight = [Windows.FontWeights]::Bold
            $bullet.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#207465'))
            $bullet.Margin = New-Object Windows.Thickness(0, 0, 6, 0)
            [Windows.Controls.DockPanel]::SetDock($bullet, [Windows.Controls.Dock]::Left)
            [void]$dp.Children.Add($bullet)
            $tb = New-Object Windows.Controls.TextBlock
            $tb.TextWrapping = [Windows.TextWrapping]::Wrap
            $tb.FontSize = 14
            $tb.LineHeight = 22
            $tb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#1D3531'))
            foreach ($inl in (Convert-MarkdownToInlines $itemText)) { [void]$tb.Inlines.Add($inl) }
            [void]$dp.Children.Add($tb)
            [void]$panel.Children.Add($dp)
            $i++
            continue
        }
        if ($trimmed -match '^(\d+[\.\)])\s+(.*)$') {
            $numPrefix = $matches[1]
            $itemText = $matches[2]
            $dp = New-Object Windows.Controls.DockPanel
            $dp.Margin = New-Object Windows.Thickness(4, 3, 0, 3)
            $numTb = New-Object Windows.Controls.TextBlock
            $numTb.Text = $numPrefix + " "
            $numTb.FontWeight = [Windows.FontWeights]::SemiBold
            $numTb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#207465'))
            $numTb.Margin = New-Object Windows.Thickness(0, 0, 6, 0)
            [Windows.Controls.DockPanel]::SetDock($numTb, [Windows.Controls.Dock]::Left)
            [void]$dp.Children.Add($numTb)
            $tb = New-Object Windows.Controls.TextBlock
            $tb.TextWrapping = [Windows.TextWrapping]::Wrap
            $tb.FontSize = 14
            $tb.LineHeight = 22
            $tb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#1D3531'))
            foreach ($inl in (Convert-MarkdownToInlines $itemText)) { [void]$tb.Inlines.Add($inl) }
            [void]$dp.Children.Add($tb)
            [void]$panel.Children.Add($dp)
            $i++
            continue
        }
        $tb = New-Object Windows.Controls.TextBlock
        $tb.TextWrapping = [Windows.TextWrapping]::Wrap
        $tb.FontSize = 14
        $tb.LineHeight = 22
        $tb.Margin = New-Object Windows.Thickness(0, 2, 0, 2)
        $tb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#1D3531'))
        foreach ($inl in (Convert-MarkdownToInlines $trimmed)) { [void]$tb.Inlines.Add($inl) }
        [void]$panel.Children.Add($tb)
        $i++
    }
    return $panel
}

function Add-ChatMessage {
    param(
        [Windows.Controls.StackPanel]$container,
        [Windows.Controls.ScrollViewer]$scroll,
        [string]$role,
        [string]$content,
        [string[]]$files = @()
    )
    $wrapper = New-Object Windows.Controls.Border
    $wrapper.Margin = New-Object Windows.Thickness(0, 0, 0, 14)

    if ($role -eq 'user') {
        $wrapper.HorizontalAlignment = [Windows.HorizontalAlignment]::Right
        $wrapper.MaxWidth = 680
        $wrapper.Background = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#EBF5F1'))
        $wrapper.BorderBrush = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#CCE4D9'))
        $wrapper.BorderThickness = New-Object Windows.Thickness(1)
        $wrapper.CornerRadius = New-Object Windows.CornerRadius(16, 16, 4, 16)
        $wrapper.Padding = New-Object Windows.Thickness(16, 12, 16, 12)

        $sp = New-Object Windows.Controls.StackPanel
        $head = New-Object Windows.Controls.DockPanel
        $head.Margin = New-Object Windows.Thickness(0, 0, 0, 6)
        $badge = New-Object Windows.Controls.TextBlock
        $badge.Text = "👩‍🏫 Cô / Thầy"
        $badge.FontSize = 12
        $badge.FontWeight = [Windows.FontWeights]::SemiBold
        $badge.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#165248'))
        [void]$head.Children.Add($badge)
        [void]$sp.Children.Add($head)

        if ($files -and $files.Count -gt 0) {
            $fp = New-Object Windows.Controls.WrapPanel
            $fp.Margin = New-Object Windows.Thickness(0, 0, 0, 6)
            foreach ($f in $files) {
                $fname = [System.IO.Path]::GetFileName($f)
                $fb = New-Object Windows.Controls.Border
                $fb.Background = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#D6EBE1'))
                $fb.CornerRadius = New-Object Windows.CornerRadius(6)
                $fb.Padding = New-Object Windows.Thickness(6, 2, 6, 2)
                $fb.Margin = New-Object Windows.Thickness(0, 0, 4, 4)
                $ft = New-Object Windows.Controls.TextBlock
                $ft.Text = "📎 " + $fname
                $ft.FontSize = 11
                $ft.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#134B42'))
                $fb.Child = $ft
                [void]$fp.Children.Add($fb)
            }
            [void]$sp.Children.Add($fp)
        }

        $tb = New-Object Windows.Controls.TextBlock
        $tb.Text = $content
        $tb.TextWrapping = [Windows.TextWrapping]::Wrap
        $tb.FontSize = 14
        $tb.LineHeight = 21
        $tb.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#183832'))
        [void]$sp.Children.Add($tb)

        $wrapper.Child = $sp
    }
    elseif ($role -eq 'thinking') {
        $wrapper.HorizontalAlignment = [Windows.HorizontalAlignment]::Left
        $wrapper.MaxWidth = 720
        $wrapper.Background = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#FFFFFF'))
        $wrapper.BorderBrush = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#E0EBE4'))
        $wrapper.BorderThickness = New-Object Windows.Thickness(1)
        $wrapper.CornerRadius = New-Object Windows.CornerRadius(16, 16, 16, 4)
        $wrapper.Padding = New-Object Windows.Thickness(16, 12, 16, 12)
        $wrapper.Tag = 'thinking_card'

        $sp = New-Object Windows.Controls.StackPanel
        $sp.Orientation = [Windows.Controls.Orientation]::Horizontal

        $icon = New-Object Windows.Controls.TextBlock
        $icon.Text = "✨ "
        $icon.FontSize = 15
        [void]$sp.Children.Add($icon)

        $txt = New-Object Windows.Controls.TextBlock
        $txt.Text = "Trợ lý Mầm non đang suy nghĩ và chuẩn bị nội dung..."
        $txt.FontSize = 13.5
        $txt.FontStyle = [Windows.FontStyles]::Italic
        $txt.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#58786F'))
        $txt.VerticalAlignment = [Windows.VerticalAlignment]::Center
        [void]$sp.Children.Add($txt)

        $wrapper.Child = $sp
    }
    else {
        $wrapper.HorizontalAlignment = [Windows.HorizontalAlignment]::Stretch
        $wrapper.Background = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#FFFFFF'))
        $wrapper.BorderBrush = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#DEE9E3'))
        $wrapper.BorderThickness = New-Object Windows.Thickness(1)
        $wrapper.CornerRadius = New-Object Windows.CornerRadius(16, 16, 16, 4)
        $wrapper.Padding = New-Object Windows.Thickness(20, 16, 20, 14)

        $sp = New-Object Windows.Controls.StackPanel

        $head = New-Object Windows.Controls.DockPanel
        $head.Margin = New-Object Windows.Thickness(0, 0, 0, 10)

        $avatar = New-Object Windows.Controls.Border
        $avatar.Width = 28
        $avatar.Height = 28
        $avatar.CornerRadius = New-Object Windows.CornerRadius(8)
        $avatar.Background = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#1C6A5D'))
        $avatar.Margin = New-Object Windows.Thickness(0, 0, 8, 0)
        $avTxt = New-Object Windows.Controls.TextBlock
        $avTxt.Text = "✨"
        $avTxt.FontSize = 14
        $avTxt.HorizontalAlignment = [Windows.HorizontalAlignment]::Center
        $avTxt.VerticalAlignment = [Windows.VerticalAlignment]::Center
        $avTxt.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#FFE8A3'))
        $avatar.Child = $avTxt
        [Windows.Controls.DockPanel]::SetDock($avatar, [Windows.Controls.Dock]::Left)
        [void]$head.Children.Add($avatar)

        $title = New-Object Windows.Controls.TextBlock
        $title.Text = "Trợ lý Giáo viên Mầm non"
        $title.FontWeight = [Windows.FontWeights]::Bold
        $title.FontSize = 13.5
        $title.Foreground = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString('#113832'))
        $title.VerticalAlignment = [Windows.VerticalAlignment]::Center
        [void]$head.Children.Add($title)

        [void]$sp.Children.Add($head)

        $bodyBlock = Build-FormattedBlock $content
        [void]$sp.Children.Add($bodyBlock)

        $actions = New-Object Windows.Controls.DockPanel
        $actions.Margin = New-Object Windows.Thickness(0, 12, 0, 0)

        $btnCopy = New-Object Windows.Controls.Button
        $btnCopy.Content = "📋 Sao chép"
        $btnCopy.Padding = New-Object Windows.Thickness(10, 5, 10, 5)
        $btnCopy.FontSize = 12
        $btnCopy.Margin = New-Object Windows.Thickness(0, 0, 8, 0)
        $btnCopy.Tag = $content
        $btnCopy.Add_Click({
            param($s,$e)
            try {
                [Windows.Clipboard]::SetText($s.Tag)
                $s.Content = "✓ Đã sao chép"
            } catch {}
        })
        [void]$actions.Children.Add($btnCopy)

        $btnEdit = New-Object Windows.Controls.Button
        $btnEdit.Content = "📝 Đưa vào Soạn thảo"
        $btnEdit.Padding = New-Object Windows.Thickness(10, 5, 10, 5)
        $btnEdit.FontSize = 12
        $btnEdit.Tag = $content
        $btnEdit.Add_Click({
            param($s,$e)
            try {
                Open-Editor 'Nội dung từ trợ lý mầm non' $s.Tag
            } catch {}
        })
        [void]$actions.Children.Add($btnEdit)

        [void]$sp.Children.Add($actions)

        $wrapper.Child = $sp
    }

    [void]$container.Children.Add($wrapper)
    if ($scroll) {
        $scroll.ScrollToEnd()
    }
    return $wrapper
}

(F 'BtnNewChat').Add_Click({
    if($script:job){Notice 'Hãy chờ hoặc hủy yêu cầu đang chạy.';return}
    $script:session=$null
    $script:lastAnswer=''
    $script:job=$null
    (F 'ChatHistory').Clear()
    (F 'ChatPrompt').Clear()
    $script:files=@()
    (F 'FileStatus').Text='Chưa đính kèm tài liệu'
    $att = F 'AttachedFilesPanel'
    if($att){$att.Visibility=[Windows.Visibility]::Collapsed}
    $msgs = F 'ChatMessages'
    if($msgs){
        $wel = F 'ChatWelcome'
        $toRemove = @()
        foreach($child in $msgs.Children){ if($child -ne $wel){ $toRemove += @($child) } }
        foreach($c in $toRemove){ [void]$msgs.Children.Remove($c) }
        if($wel){$wel.Visibility=[Windows.Visibility]::Visible}
    }
    (F 'BtnSend').IsEnabled=$true
    (F 'BtnCancel').IsEnabled=$false
    Status 'Đã tạo cuộc trò chuyện mới.'
})

(F 'BtnClearChat').Add_Click({
    if(Confirm 'Xóa tất cả hội thoại trong phiên này?'){
        [void](Api 'chat_clear')
        $script:session=$null
        $script:job=$null
        $script:lastAnswer=''
        (F 'ChatHistory').Clear()
        (F 'ChatPrompt').Clear()
        $script:files=@()
        (F 'FileStatus').Text='Chưa đính kèm tài liệu'
        $att = F 'AttachedFilesPanel'
        if($att){$att.Visibility=[Windows.Visibility]::Collapsed}
        $msgs = F 'ChatMessages'
        if($msgs){
            $wel = F 'ChatWelcome'
            $toRemove = @()
            foreach($child in $msgs.Children){ if($child -ne $wel){ $toRemove += @($child) } }
            foreach($c in $toRemove){ [void]$msgs.Children.Remove($c) }
            if($wel){$wel.Visibility=[Windows.Visibility]::Visible}
        }
        (F 'BtnSend').IsEnabled=$true
        (F 'BtnCancel').IsEnabled=$false
        Status 'Đã xóa hội thoại.'
    }
})

(F 'BtnAttach').Add_Click({
    $path=Pick
    if($path){
        $script:files+=@($path)
        (F 'FileStatus').Text=($script:files|ForEach-Object{[IO.Path]::GetFileName($_)}) -join ', '
        $att = F 'AttachedFilesPanel'
        if($att){$att.Visibility=[Windows.Visibility]::Visible}
    }
})

(F 'BtnClearFiles').Add_Click({
    $script:files=@()
    (F 'FileStatus').Text='Chưa đính kèm tài liệu'
    $att = F 'AttachedFilesPanel'
    if($att){$att.Visibility=[Windows.Visibility]::Collapsed}
})

(F 'BtnToEditor').Add_Click({
    if($script:lastAnswer){Open-Editor 'Nội dung từ trợ lý mầm non' $script:lastAnswer}
    else{Notice 'Chưa có câu trả lời để đưa vào tài liệu.'}
})

$chatToolbar=F 'ChatQuickBar'
if(-not $chatToolbar){$chatToolbar=(F 'BtnToEditor').Parent}
if($chatToolbar){
 Add $chatToolbar (Button '🌟 Soạn bài STEAM 5E' {Launch-AdvMethod-AI 'STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)'})
 Add $chatToolbar (Button '🏛️ Đánh giá Chuẩn Trường Mức 2' {Launch-SchoolStandards-AI 2})
 Add $chatToolbar (Button '📊 Hoàn thiện Bảng Chuẩn QG' {Launch-SchoolStandards-FillAI})
 Add $chatToolbar (Button '🚩 Kiểm điểm Đảng viên (Mẫu 02)' {Launch-PartyReview-AI})
 Add $chatToolbar (Button '😭 Xử lý: Trẻ khóc sáng sớm' {Launch-Situation-AI 'Trẻ mới đi học khóc nhiều, bám mẹ không chịu vào lớp'})
 Add $chatToolbar (Button '🦷 Xử lý: Trẻ cắn / đánh bạn' {Launch-Situation-AI 'Trẻ tranh giành đồ chơi, đánh hoặc cắn bạn'})
 Add $chatToolbar (Button '🥣 Xử lý: Trẻ biếng ăn / ngậm cơm' {Launch-Situation-AI 'Trẻ biếng ăn, ngậm cơm lâu, dễ nôn trớ'})
 Add $chatToolbar (Button '🚑 Sơ cứu: Hóc dị vật' {Launch-Situation-AI 'Xử lý sơ cấp cứu: Hóc dị vật đường thở (Thủ thuật vỗ lưng ấn ngực)'})
 Add $chatToolbar (Button '🚑 Sơ cứu: Sốt co giật' {Launch-Situation-AI 'Xử lý sơ cấp cứu: Sốt cao co giật ở trẻ mầm non'})
 Add $chatToolbar (Button '🗣️ Xoa dịu: Phụ huynh phàn nàn' {Launch-Situation-AI 'Phụ huynh bức xúc phàn nàn vì con bị muỗi cắn hoặc xước da'})
}

$bSteam = F 'BtnWelcomeSteam'
if($bSteam){$bSteam.Add_Click({Launch-AdvMethod-AI 'STEAM (Mô hình 5E: Gắn kết - Khám phá - Giải thích - Củng cố - Đánh giá)'})}
$bStd = F 'BtnWelcomeStandards'
if($bStd){$bStd.Add_Click({Launch-SchoolStandards-AI 2})}
$bCry = F 'BtnWelcomeCry'
if($bCry){$bCry.Add_Click({Launch-Situation-AI 'Trẻ mới đi học khóc nhiều, bám mẹ không chịu vào lớp'})}
$bBite = F 'BtnWelcomeBite'
if($bBite){$bBite.Add_Click({Launch-Situation-AI 'Trẻ tranh giành đồ chơi, đánh hoặc cắn bạn'})}

(F 'ChatPrompt').Add_KeyDown({
    param($s, $e)
    if ($e.Key -eq [Windows.Input.Key]::Enter) {
        $shift = [Windows.Input.Keyboard]::IsKeyDown([Windows.Input.Key]::LeftShift) -or [Windows.Input.Keyboard]::IsKeyDown([Windows.Input.Key]::RightShift)
        if (-not $shift) {
            $e.Handled = $true
            Click (F 'BtnSend')
        }
    }
})

(F 'BtnSend').Add_Click({
 Refresh;if(-not $script:data.has_key -or -not $script:data.profile.model){Notice 'Vào Cài đặt để nhập model và API key OpenRouter. Mẫu và sổ theo dõi vẫn dùng được khi chưa có AI.';return}
 $prompt=(F 'ChatPrompt').Text.Trim();if(-not $prompt){Notice 'Nhập yêu cầu trước khi gửi.';return}

 $r=Api 'chat_start' @{prompt=$prompt;session=$script:session;files=@($script:files)}
 $script:job=$r.job;$script:session=$r.session

 $wel = F 'ChatWelcome'
 if($wel){$wel.Visibility=[Windows.Visibility]::Collapsed}

 [void](Add-ChatMessage (F 'ChatMessages') (F 'ChatScroll') 'user' $prompt $script:files)
 (F 'ChatHistory').AppendText("`nCÔ / THẦY: "+$prompt+"`n")

 $script:thinkingCard = Add-ChatMessage (F 'ChatMessages') (F 'ChatScroll') 'thinking' ''
 (F 'ChatPrompt').Clear()
 $script:files=@();(F 'FileStatus').Text='Chưa đính kèm tài liệu'
 $att = F 'AttachedFilesPanel'
 if($att){$att.Visibility=[Windows.Visibility]::Collapsed}

 (F 'BtnSend').IsEnabled=$false;(F 'BtnCancel').IsEnabled=$true;Status 'Trợ lý đang soạn nội dung…'
})

(F 'BtnCancel').Add_Click({
 if($script:job){
  [void](Api 'chat_cancel' @{job=$script:job})
  $script:job=$null
  if($script:thinkingCard){
   [void](F 'ChatMessages').Children.Remove($script:thinkingCard)
   $script:thinkingCard=$null
  }
  (F 'BtnSend').IsEnabled=$true;(F 'BtnCancel').IsEnabled=$false;Status 'Đã hủy nhận kết quả của yêu cầu.'
 }
})

$poll=New-Object Windows.Threading.DispatcherTimer;$poll.Interval=[TimeSpan]::FromMilliseconds(700)

$poll.Add_Tick({
 if(-not $script:job){return}
 try{
  $r=Api 'chat_poll' @{job=$script:job}
  if($r.state -ne 'running'){
   $script:job=$null;(F 'BtnSend').IsEnabled=$true;(F 'BtnCancel').IsEnabled=$false
   if($script:thinkingCard){
    [void](F 'ChatMessages').Children.Remove($script:thinkingCard)
    $script:thinkingCard=$null
   }
   if($r.state -eq 'done'){
    $script:lastAnswer=$r.answer
    [void](Add-ChatMessage (F 'ChatMessages') (F 'ChatScroll') 'assistant' $r.answer)
    (F 'ChatHistory').AppendText("`nTRỢ LÝ: "+$r.answer+"`n");(F 'ChatHistory').ScrollToEnd()
    Status 'Đã soạn xong. Có thể đưa câu trả lời vào tài liệu.'
   }
   elseif($r.state -eq 'error'){Notice $r.error}else{Status 'Yêu cầu đã dừng.'}
  }
 }catch{
  $script:job=$null;(F 'BtnSend').IsEnabled=$true;(F 'BtnCancel').IsEnabled=$false
  if($script:thinkingCard){
   [void](F 'ChatMessages').Children.Remove($script:thinkingCard)
   $script:thinkingCard=$null
  }
  Notice $_.Exception.Message
 }
});$poll.Start()

$window.Add_Closing({param($s,$e)if($script:dirty -and (F 'DocBody').Text.Trim() -and -not $Smoke){if(-not (Confirm 'Tài liệu đang sửa chưa lưu. Đóng ứng dụng và bỏ thay đổi?')){$e.Cancel=$true}}})

$window.Add_Closed({$poll.Stop();$client.Dispose()})

Show-Page 'home'



function Screenshot($name){

 if(-not $ScreenshotDir){return};[void][IO.Directory]::CreateDirectory($ScreenshotDir);$window.UpdateLayout()

 $bmp=New-Object Windows.Media.Imaging.RenderTargetBitmap([int]$window.ActualWidth,[int]$window.ActualHeight,96,96,[Windows.Media.PixelFormats]::Pbgra32);$bmp.Render($window)

 $encoder=New-Object Windows.Media.Imaging.PngBitmapEncoder;$encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))

 $stream=[IO.File]::Create((Join-Path $ScreenshotDir ($name+'.png')));try{$encoder.Save($stream)}finally{$stream.Dispose()}

}

function Click($button){$button.RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))}

function Smoke-SimpleUI {
 Show-Page 'home'
 $quick=(F 'PageBody').Children|Where-Object{$_ -is [Windows.Controls.Primitives.UniformGrid]}|Select-Object -First 1
 Click $quick.Children[0]
 if($script:page -ne 'activities'){throw 'Home quick action failed'}
 $templates=(F 'PageBody').Children|Where-Object{$_ -is [Windows.Controls.Expander]}|Select-Object -First 1
 if($templates.IsExpanded){throw 'Templates must start collapsed'}
 $templates.IsExpanded=$true;$window.UpdateLayout();Click $templates.Content.Children[0]
 if($script:page -ne 'editor'){throw 'Template card failed'}
 Show-Page 'children'
 $form=(F 'PageBody').Children[0].Children[0]
 $groups=@($form.Children|Where-Object{$_ -is [Windows.Controls.Expander]})
 if($groups.Count -ne 3){throw 'Child detail groups missing'}
 foreach($group in $groups){$group.IsExpanded=$true;$window.UpdateLayout();$group.IsExpanded=$false}
 Show-Page 'legal';$script:ui.LegalCategory.SelectedIndex=1
 if($script:legalCategory -ne 'thong_tu'){throw 'Legal category filter failed'}
 $hub=(F 'PageBody').Children|Where-Object{$_ -is [Windows.Controls.Expander]}|Select-Object -First 1
 $hub.IsExpanded=$true;$window.UpdateLayout();Screenshot 'legal-tools';$hub.IsExpanded=$false
 $w=$window.Width;$h=$window.Height;$window.Width=1060;$window.Height=700
 foreach($page in @('home','children','activities','legal','professional')){Show-Page $page;Screenshot ($page+'-compact')}
 $window.Width=$w;$window.Height=$h
}

function Smoke-Actions {

 Smoke-SimpleUI
 Show-Page 'settings';SetValue 'SettingName' 'Giáo viên thử nghiệm';SetValue 'SettingClass' 'Lớp Lá';Click $script:ui.SaveSettings

 Prepare-Template 'activity';(F 'DocBody').AppendText("`nGhi chú kiểm thử bản mầm non.");Click (F 'BtnSaveDoc')

 Prepare-Template 'school_standards_eval';(F 'DocBody').AppendText("`nKiểm thử bảng tự đánh giá chuẩn.");Click (F 'BtnSaveDoc')

 Prepare-Template 'party_review';(F 'DocBody').AppendText("`nKiểm thử bản kiểm điểm đảng viên.");Click (F 'BtnSaveDoc')

 Show-Page 'children';SetValue 'ChildName' 'Nguyễn Minh Khôi';SetValue 'ChildWeight' '16.5';SetValue 'ChildHeight' '105';SetValue 'ChildFatherName' 'Nguyễn Văn Nam';SetValue 'ChildFatherPhone' '0912345678';SetValue 'ChildMotherName' 'Trần Thị Mai';SetValue 'ChildMotherPhone' '0987654321';SetValue 'ChildAddressOld' 'Số 25 Phường Phương Liên, Quận Đống Đa, Hà Nội';Click $script:ui.SaveChild

 [void](Api 'ward_convert' @{address='Số 25 Phường Phương Liên, Quận Đống Đa, Hà Nội';direction='old_to_new'})

 [void](Api 'export_records' @{kind='child';path=(Join-Path $script:data.root 'danh-sach-tre.xlsx')})

 Show-Page 'observations';SetValue 'Child' 'TRE-TEST-01';SetValue 'Notes' 'Trẻ chủ động lựa chọn góc xây dựng.';Click $script:ui.SaveRecord

 $script:ui.RecordList.SelectedIndex=0;Load-Record;SetValue 'Next' 'Chuẩn bị thêm khối gỗ.';Click $script:ui.SaveRecord

 Show-Page 'care';SetValue 'Child' 'TRE-TEST-01';SetValue 'Notes' 'Tham gia hoạt động cùng nhóm.';SetValue 'Meal' 'Ăn theo ghi nhận của giáo viên';Click $script:ui.SaveRecord

 Show-Page 'calendar';SetValue 'TaskTitle' 'Chuẩn bị góc thiên nhiên';Click $script:ui.SaveTask

 Show-Page 'legal';SetValue 'SearchLegal' '19/2018';[void](Api 'legal_verify_all')

 Refresh

 if(@($script:data.document).Count -lt 1 -or @($script:data.child).Count -lt 1 -or @($script:data.observation).Count -lt 1 -or @($script:data.care).Count -lt 1 -or @($script:data.task).Count -lt 1){throw 'Smoke: thiếu dữ liệu sau khi bấm lưu.'}

 $doc=$script:data.document[0]

 foreach($fmt in @('docx','pptx','xlsx')){[void](Api 'export' @{title=$doc.title;body=$doc.body;format=$fmt;path=(Join-Path $script:data.root ('smoke.'+$fmt))})}

 [void](Api 'export_records' @{kind='observation';path=(Join-Path $script:data.root 'so-theo-doi.xlsx')})

}

if($Smoke){

 $script:smokePages=@();$script:smokeIndex=-1;$timer=New-Object Windows.Threading.DispatcherTimer;$timer.Interval=[TimeSpan]::FromMilliseconds(350)

 $timer.Add_Tick({param($s,$e)

  try{

   if($script:smokeIndex -eq -1){

    Smoke-Actions

    if($SmokeAI){Show-Page 'chat';(F 'ChatPrompt').Text='Soạn hoạt động khám phá màu sắc cho trẻ 4–5 tuổi.';Click (F 'BtnSend')}

    $script:smokeIndex=0;return

   }

   if($script:smokeIndex -lt $script:data.pages.Count){$name=$script:data.pages[$script:smokeIndex][0];Click $script:nav[$name];$script:smokePages+=@($name);Screenshot $name;$script:smokeIndex++;return}

   if($SmokeAI){

    if($script:job){return}

    if(-not $script:lastAnswer){throw 'AI UI smoke: không nhận được câu trả lời.'}

    Click (F 'BtnToEditor');Click (F 'BtnSaveDoc')

   }

   Prepare-Template 'week';Screenshot 'editor';$s.Stop()

   [IO.File]::WriteAllText((Join-Path $script:data.root 'wpf-smoke.json'),(ConvertTo-Json @{pages=$script:smokePages;actions=@('home-shortcut','template-disclosure','child-detail-groups','legal-category-filter','compact-layout','settings','template','document-save','child-create-convert','observation-create-edit','care-save','task-save','legal-search','export-docx-pptx-xlsx','journal-export');ai_mock=[bool]$SmokeAI;errors=@($script:errors)} -Depth 8))

   $window.Close()

  }catch{$script:errors.Add($_.ToString());$s.Stop();[IO.File]::WriteAllText((Join-Path $script:data.root 'wpf-smoke.json'),(ConvertTo-Json @{pages=$script:smokePages;errors=@($script:errors)} -Depth 8));$window.Close()}

 });$timer.Start()

}elseif($ScreenshotDir){$window.Add_ContentRendered({Screenshot 'home'})}

[void]$window.ShowDialog()

if($script:errors.Count){exit 1}

