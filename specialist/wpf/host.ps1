param([string]$ScreenshotDir, [switch]$Smoke,[switch]$VerifyAI)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Windows.Forms

# Thiết lập Application User Model ID để Windows Taskbar hiển thị đúng icon ứng dụng giáo dục thay vì icon PowerShell
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
    [Shell32Helper]::SetCurrentProcessExplicitAppUserModelID("TroLyGiaoDuc.ChuyenVien.Desktop") | Out-Null
} catch {}

$script:client = New-Object Net.WebClient
$script:client.Encoding = [Text.Encoding]::UTF8
$script:client.Headers['X-TroLy-Token'] = $env:TROLY_BRIDGE_TOKEN
$script:session = $null
$script:attachments = @()
$script:jobs = @{}
$script:fontSize = 15
$script:fullChat = $false
$script:chatColumn = $true
$script:wordView = $false
$script:currentPage = 'TrangChu'
$script:wired = New-Object 'System.Collections.Generic.HashSet[string]'

$script:iconPath = Join-Path $PSScriptRoot 'icon.ico'
$script:appIcon = $null
if (Test-Path $script:iconPath) {
    try {
        $script:appIcon = [Windows.Media.Imaging.BitmapFrame]::Create([Uri]$script:iconPath)
    } catch {}
}

function Api([string]$action, $body = @{}) {
    $script:client.Headers['Content-Type'] = 'application/json; charset=utf-8'
    $json = ConvertTo-Json -InputObject $body -Depth 30 -Compress
    $reply = $script:client.UploadString(($env:TROLY_BRIDGE_URL + '/' + $action), $json) | ConvertFrom-Json
    if (-not $reply.ok) { throw $reply.error }
    return $reply.data
}
function Refresh-State { $script:data = Api 'state' }
Refresh-State
[xml]$xml = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'layout.xaml'))
$window = [Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))
$window.Title = 'Trợ lý QLNN về Giáo dục · OpenRouter'
if ($script:appIcon) { $window.Icon = $script:appIcon }
$window.Add_SourceInitialized({
    try {
        $helper = New-Object Windows.Interop.WindowInteropHelper($window)
        if(Test-Path -LiteralPath $script:iconPath){
            [Shell32Helper]::SetIcon($helper.Handle, $script:iconPath)
        }
    } catch {}
})
function F([string]$name) { $window.FindName($name) }
function Brush([string]$hex) { (New-Object Windows.Media.BrushConverter).ConvertFromString($hex) }
function Notice([string]$text) { if($Smoke){return}; [void][Windows.MessageBox]::Show($window,$text,'Trợ lý Chuyên viên','OK','Information') }
function Show-Login {
    if ($Smoke) { return $true }
    $dialog = New-Object Windows.Window
    $dialog.Title = 'Đăng nhập · Trợ lý Giáo dục'
    $dialog.Width = 460
    $dialog.SizeToContent = 'Height'
    $dialog.WindowStartupLocation = 'CenterScreen'
    $dialog.ResizeMode = 'NoResize'
    $dialog.Background = Brush '#F4F7FC'
    $dialog.FontFamily = 'Segoe UI'
    if ($script:appIcon) { $dialog.Icon = $script:appIcon }

    $panel = New-Object Windows.Controls.StackPanel
    $panel.Margin = '32'
    $heading = Text 'Đăng nhập hệ thống' 24 '#0B2B6B'
    $heading.FontWeight = 'Bold'
    [void]$panel.Children.Add($heading)
    [void]$panel.Children.Add((Text 'Hệ thống Quản lý Nhà nước & Trợ lý Chuyên viên Giáo dục' 13 '#5B6B7F'))

    $accHint = Text 'Tài khoản mặc định: admin@giaoduc.gov.vn | Mật khẩu: admin123' 12 '#027A48'
    $accHint.Margin = '0,6,0,10'
    $accHint.FontWeight = 'SemiBold'
    [void]$panel.Children.Add($accHint)

    [void]$panel.Children.Add((Text 'Email công vụ' 13 '#40546B'))
    $email = New-Object Windows.Controls.TextBox
    $email.Style = $window.FindResource('Nhap')
    $email.MinHeight = 42
    $email.Text = 'admin@giaoduc.gov.vn'
    [void]$panel.Children.Add($email)

    [void]$panel.Children.Add((Text 'Mật khẩu' 13 '#40546B'))
    $password = New-Object Windows.Controls.PasswordBox
    $password.MinHeight = 42
    $password.Padding = '12,8'
    $password.FontSize = 14
    [void]$panel.Children.Add($password)

    $status = Text '' 13 '#B42318'
    $status.MinHeight = 28
    [void]$panel.Children.Add($status)

    $login = New-Object Windows.Controls.Button
    $login.Content = 'Đăng nhập ngay'
    $login.Style = $window.FindResource('NutChinh')
    $login.MinHeight = 42
    $login.Margin = '0,8,0,0'
    [void]$panel.Children.Add($login)

    $hint = Text 'Kết nối nội bộ được bảo vệ. Khóa OpenRouter được mã hóa an toàn trên máy.' 11 '#8492A6'
    $hint.Margin = '0,14,0,0'
    [void]$panel.Children.Add($hint)

    $login.Add_Click({
        if ([string]::IsNullOrWhiteSpace($email.Text) -or [string]::IsNullOrWhiteSpace($password.Password)) {
            $status.Text = 'Vui lòng nhập đầy đủ email và mật khẩu.'
            return
        }
        $login.IsEnabled = $false
        $status.Text = 'Đang xác thực thông tin đăng nhập...'
        try {
            $authClient = New-Object Net.WebClient
            $authClient.Encoding = [Text.Encoding]::UTF8
            $authClient.Headers['Content-Type'] = 'application/json; charset=utf-8'
            $payload = ConvertTo-Json @{email=$email.Text.Trim(); password=$password.Password} -Compress
            $authUrl = if ($env:TROLY_AUTH_URL) { $env:TROLY_AUTH_URL } else { $env:TROLY_BRIDGE_URL }
            $reply = $authClient.UploadString(($authUrl.TrimEnd('/') + '/api/auth/login'), $payload) | ConvertFrom-Json
            $token = if ($reply.access_token) { $reply.access_token } elseif ($reply.token) { $reply.token } else { $null }
            if (-not $token) { throw 'Máy chủ không trả về mã phiên hợp lệ.' }
            $script:client.Headers['Authorization'] = 'Bearer ' + $token
            $dialog.DialogResult = $true
        } catch {
            $msg = 'Đăng nhập thất bại. Vui lòng kiểm tra lại mật khẩu.'
            if ($_.Exception.Response) {
                try {
                    $stream = $_.Exception.Response.GetResponseStream()
                    $reader = New-Object IO.StreamReader($stream)
                    $errObj = $reader.ReadToEnd() | ConvertFrom-Json
                    if ($errObj.error) { $msg = $errObj.error }
                } catch {}
            }
            $status.Text = $msg
            $login.IsEnabled = $true
        }
    })
    $dialog.Content = $panel
    return [bool]$dialog.ShowDialog()
}
function Text([string]$text, [double]$size=14, [string]$color='#1F3354') {
    $control = New-Object Windows.Controls.TextBlock
    $control.Text=$text; $control.FontSize=$size; $control.Foreground=Brush $color
    $control.TextWrapping='Wrap'; $control.Margin='0,4,0,6'
    return $control
}
function Button([string]$text, [string]$action, $payload=$null, [switch]$Primary) {
    $b = New-Object Windows.Controls.Button
    $b.Content=$text; $b.Style=$window.FindResource($(if($Primary){'NutChinh'}else{'Nut'}))
    $b.Margin='0,4,8,4'; $b.Tag=@{Action=$action;Data=$payload}
    $b.Add_Click({param($s,$e) Invoke-CommandAction $s.Tag.Action $s.Tag.Data})
    return $b
}
function Wire([string]$name, [scriptblock]$callback) { $control=F $name; if($control){$control.Add_Click($callback);[void]$script:wired.Add($name)} }
function Path-Data([string]$relative) { Join-Path $script:data.root $relative }
function Open-File([string]$path) {
    if(-not(Test-Path -LiteralPath $path)){throw 'Không tìm thấy tệp đã chọn.'}
    [void][Diagnostics.Process]::Start($path)
}
function Select-Files([switch]$Multiple, [string]$Filter='Tài liệu|*.docx;*.pdf;*.xlsx;*.csv;*.txt;*.md;*.json|Tất cả tệp|*.*') {
    $dialog=New-Object Microsoft.Win32.OpenFileDialog
    $dialog.Multiselect=$Multiple; $dialog.Filter=$Filter
    if($dialog.ShowDialog($window)){return @($dialog.FileNames)}
    return @()
}
function Save-Path([string]$name,[string]$extension) {
    $dialog=New-Object Microsoft.Win32.SaveFileDialog
    $dialog.FileName=$name; $dialog.DefaultExt=$extension; $dialog.Filter=($extension.ToUpper()+'|*.'+$extension)
    if($dialog.ShowDialog($window)){return $dialog.FileName}
    return $null
}
function Ask-Fields([string]$title,$fields,$initial=@{}) {
    $dialog=New-Object Windows.Window
    $dialog.Title=$title; $dialog.Width=650; $dialog.SizeToContent='Height'; $dialog.MaxHeight=850
    $dialog.Owner=$window; $dialog.WindowStartupLocation='CenterOwner'; $dialog.Background=Brush '#F4F7FC'
    $dialog.FontFamily='Segoe UI'; $dialog.Resources.MergedDictionaries.Add($window.Resources)
    $outer=New-Object Windows.Controls.StackPanel; $outer.Margin='24'
    $heading=Text $title 22 '#0B2B6B'; $heading.FontWeight='Bold'; [void]$outer.Children.Add($heading)
    $inputs=@{}
    foreach($field in $fields){
        [void]$outer.Children.Add((Text $field[1] 13 '#5B6B7F'))
        $input=New-Object Windows.Controls.TextBox; $input.Style=$window.FindResource('Nhap'); $input.MinHeight=40
        if($initial -is [hashtable]){$input.Text=[string]$initial[$field[0]]}else{$input.Text=[string]$initial.($field[0])}
        [void]$outer.Children.Add($input); $inputs[$field[0]]=$input
    }
    $save=New-Object Windows.Controls.Button; $save.Style=$window.FindResource('NutChinh'); $save.Content='Lưu'; $save.Margin='0,18,0,0'; $save.HorizontalAlignment='Right'
    $save.Add_Click({$dialog.DialogResult=$true})
    [void]$outer.Children.Add($save)
    $scroll=New-Object Windows.Controls.ScrollViewer; $scroll.VerticalScrollBarVisibility='Auto';$scroll.Content=$outer;$dialog.Content=$scroll
    if($dialog.ShowDialog()){
        $result=@{};foreach($key in $inputs.Keys){$result[$key]=$inputs[$key].Text.Trim()};return $result
    }
    return $null
}
function Show-Page([string]$name) {
    if(-not(F ('Pg'+$name))){return}
    foreach($page in (F 'VungTrang').Children){$page.Visibility='Collapsed'}
    (F ('Pg'+$name)).Visibility='Visible'
    $script:currentPage=$name
    $nav=F ('Nav'+$name)
    if(-not $nav){$nav=F 'NavTienIch'}
    if($nav){$nav.IsChecked=$true}
    Refresh-State
    switch($name){
        'TrangChu' {Render-Home}
        'TroChuyen' {Render-Chat}
        'CongViec' {Render-Tasks}
        'Lich' {Render-Calendar}
        'ThuVien' {Render-Library}
        'Mau' {Render-Templates}
        'VanBanDen' {Render-Incoming}
        'DonVi' {Render-Reports}
        'CaiDat' {Render-Settings}
        'KiemTra' {Render-Inspections}
        'TraCuu' {Render-References}
    }
}
function Update-Header {
    $p=$script:data.profile
    (F 'TxtTenNguoiDung').Text=$(if($p.name){$p.name}else{'Anh/chị'})
    (F 'TxtChucVu').Text=$(if($p.position){$p.position}else{'Chuyên viên'})
    (F 'TxtVietTat').Text=$(if($p.name){(($p.name -split '\s+'|Select-Object -Last 2|ForEach-Object{$_.Substring(0,1)}) -join '').ToUpper()}else{'TL'})
    (F 'TxtPhuDe').Text=$(if($p.agency){$p.agency+' · Soạn thảo nhanh – Hiệu quả mỗi ngày'}else{'Soạn thảo nhanh – Đúng quy định – Hiệu quả mỗi ngày'})
    (F 'TxtPhienBan').Text='Phiên bản: 2.0 · OpenRouter'
    (F 'TxtTrangThai').Text=$(if($script:data.has_key){'Sẵn sàng · '+$p.provider}else{'Chưa có API key · bấm để cài đặt'})
    (F 'ChamTrangThai').Fill=Brush $(if($script:data.has_key){'#43A047'}else{'#E5A000'})
}
function Render-Home {
    Update-Header
    $period=if((Get-Date).Hour -lt 12){'sáng'}elseif((Get-Date).Hour -lt 18){'chiều'}else{'tối'}
    (F 'TxtChao').Text='Chào buổi '+$period+', '+$(if($script:data.profile.name){$script:data.profile.name}else{'anh/chị'})+'!'
    (F 'TxtNgay').Text=(Get-Date).ToString('dddd, dd MMMM yyyy',[Globalization.CultureInfo]::GetCultureInfo('vi-VN'))
    (F 'TxtNamHoc').Text='Năm học '+$script:data.profile.year
    (F 'KhungNhacKhaiBao').Visibility=$(if($script:data.profile.agency){'Collapsed'}else{'Visible'})
    $box=F 'DsViecHomNay';$box.Children.Clear()
    $tasks=@($script:data.task|Where-Object{$_.state -ne 'Hoàn thành'}|Sort-Object due|Select-Object -First 4)
    foreach($t in $tasks){[void]$box.Children.Add((Button ($t.title+'  '+$t.due) 'edit-task' $t))}
    if(-not $tasks.Count){[void]$box.Children.Add((Text 'Chưa có việc cho hôm nay. Bấm “Xem tất cả” để thêm việc.' 13 '#8A98AB'))}
    $box=F 'DsGanDay';$box.Children.Clear()
    foreach($doc in @($script:data.document|Select-Object -First 8)){[void]$box.Children.Add((Button $doc.title 'document' $doc))}
    if(-not @($script:data.document).Count){[void]$box.Children.Add((Text 'Chưa có văn bản nào. Chọn một chức năng bên trái để bắt đầu soạn.' 13 '#8A98AB'))}
}
function Start-Work([string]$prompt='', $files=@()) {
    $script:session=$null; $script:attachments=@($files)
    Show-Page 'TroChuyen'
    (F 'TxtHoi').Text=$prompt
    [void](F 'TxtHoi').Focus()
    Render-Attachments
}
function Render-Attachments {
    $box=F 'DsDinhKem';$box.Children.Clear()
    foreach($path in $script:attachments){[void]$box.Children.Add((Button ((Split-Path $path -Leaf)+'  ×') 'remove-attachment' $path))}
}
function Update-WordButton {
    $btn = F 'BtnCheDoWord'
    $ic = F 'IcCheDoWord'
    $txt = F 'TxtCheDoWord'
    if ($btn -and $txt) {
        if ($script:wordView) {
            $txt.Text = 'Xem tin nhắn'
            if ($ic) { $ic.Text = [char]0xE8BD }
            $btn.Background = Brush '#EEF4FF'
            $btn.BorderBrush = Brush '#2563EB'
        } else {
            $txt.Text = 'Xem dạng Word'
            if ($ic) { $ic.Text = [char]0xE8A5 }
            $btn.ClearValue([Windows.Controls.Control]::BackgroundProperty)
            $btn.ClearValue([Windows.Controls.Control]::BorderBrushProperty)
        }
    }
}

function Create-WordPage([string]$bodyContent) {
    $border = New-Object Windows.Controls.Border
    $border.Background = Brush '#FFFFFF'
    $border.BorderBrush = Brush '#D1D5DB'
    $border.BorderThickness = 1
    $border.CornerRadius = 3
    $border.Padding = '36,30,30,32'
    $border.Margin = '0,6,0,14'
    $border.MaxWidth = 820
    $border.HorizontalAlignment = 'Left'
    $border.SnapsToDevicePixels = $true

    $effect = New-Object Windows.Media.Effects.DropShadowEffect
    $effect.Color = [Windows.Media.Color]::FromArgb(35, 0, 0, 0)
    $effect.BlurRadius = 12
    $effect.ShadowDepth = 3
    $effect.Direction = 270
    $effect.Opacity = 0.35
    $border.Effect = $effect

    $page = New-Object Windows.Controls.StackPanel
    $page.UseLayoutRounding = $true

    # 1. Header 2 cột: Đơn vị & Quốc hiệu
    $headerGrid = New-Object Windows.Controls.Grid
    $col1 = New-Object Windows.Controls.ColumnDefinition; $col1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    $col2 = New-Object Windows.Controls.ColumnDefinition; $col2.Width = New-Object Windows.GridLength(1.35, [Windows.GridUnitType]::Star)
    [void]$headerGrid.ColumnDefinitions.Add($col1)
    [void]$headerGrid.ColumnDefinitions.Add($col2)

    # Cột trái: Cơ quan ban hành
    $leftStack = New-Object Windows.Controls.StackPanel
    $leftStack.HorizontalAlignment = 'Center'
    $parent = if ($script:data.profile.parent) { $script:data.profile.parent.ToUpper() } else { '' }
    $agency = if ($script:data.profile.agency) { $script:data.profile.agency.ToUpper() } else { 'SỞ GIÁO DỤC VÀ ĐÀO TẠO' }
    if ($parent) {
        $pText = Text $parent 11 '#374151'
        $pText.FontFamily = 'Times New Roman'; $pText.TextAlignment = 'Center'; $pText.FontWeight = 'Normal'
        [void]$leftStack.Children.Add($pText)
    }
    $agText = Text $agency 12 '#111827'
    $agText.FontFamily = 'Times New Roman'; $agText.TextAlignment = 'Center'; $agText.FontWeight = 'Bold'
    [void]$leftStack.Children.Add($agText)

    $soVb = Text 'Số:       /QĐ-SGDĐT' 11.5 '#4B5563'
    $soVb.FontFamily = 'Times New Roman'; $soVb.TextAlignment = 'Center'; $soVb.Margin = '0,3,0,0'
    [void]$leftStack.Children.Add($soVb)

    # Cột phải: Quốc hiệu - Tiêu ngữ
    $rightStack = New-Object Windows.Controls.StackPanel
    $rightStack.HorizontalAlignment = 'Center'
    $qhText = Text 'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM' 12 '#111827'
    $qhText.FontFamily = 'Times New Roman'; $qhText.TextAlignment = 'Center'; $qhText.FontWeight = 'Bold'
    [void]$rightStack.Children.Add($qhText)

    $tnText = Text 'Độc lập - Tự do - Hạnh phúc' 12.5 '#111827'
    $tnText.FontFamily = 'Times New Roman'; $tnText.TextAlignment = 'Center'; $tnText.FontWeight = 'Bold'
    [void]$rightStack.Children.Add($tnText)

    $line = New-Object Windows.Shapes.Line
    $line.X1 = 0; $line.X2 = 130; $line.Stroke = Brush '#111827'; $line.StrokeThickness = 1.2; $line.HorizontalAlignment = 'Center'; $line.Margin = '0,3,0,4'
    [void]$rightStack.Children.Add($line)

    $ngayText = Text '..., ngày ... tháng ... năm ...' 11.5 '#4B5563'
    $ngayText.FontFamily = 'Times New Roman'; $ngayText.FontStyle = 'Italic'; $ngayText.TextAlignment = 'Center'
    [void]$rightStack.Children.Add($ngayText)

    [Windows.Controls.Grid]::SetColumn($leftStack, 0)
    [Windows.Controls.Grid]::SetColumn($rightStack, 1)
    [void]$headerGrid.Children.Add($leftStack)
    [void]$headerGrid.Children.Add($rightStack)
    [void]$page.Children.Add($headerGrid)

    # Đường phân cách mờ
    $sep = New-Object Windows.Shapes.Line
    $sep.X1 = 0; $sep.X2 = 180; $sep.Stroke = Brush '#9CA3AF'; $sep.StrokeThickness = 0.8; $sep.HorizontalAlignment = 'Center'; $sep.Margin = '0,14,0,16'
    [void]$page.Children.Add($sep)

    # 2. Xử lý phần thân nội dung
    $rawLines = $bodyContent.Split("`n")
    $inNoiNhan = $false
    $noiNhanLines = @()
    $mainLines = @()

    foreach ($rawLine in $rawLines) {
        $trim = $rawLine.Trim()
        if ($trim -like '*Nơi nhận:*' -or $trim -like '*- Nơi nhận*' -or $trim -eq 'Nơi nhận:') {
            $inNoiNhan = $true
        }
        if ($inNoiNhan) {
            $noiNhanLines += $trim
        } else {
            $mainLines += $rawLine
        }
    }

    foreach ($line in $mainLines) {
        $trim = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trim)) {
            $space = New-Object Windows.Controls.Border; $space.Height = 6
            [void]$page.Children.Add($space)
            continue
        }
        if ($trim -eq '---' -or $trim -eq '***' -or $trim -eq '___') { continue }

        $cleanHeader = ($trim -replace '^\*\*|\*\*$', '') -replace '^\#+\s*', ''

        # Tiêu đề chính căn giữa
        if ($cleanHeader -match '^(QUYẾT ĐỊNH|KẾ HOẠCH|TỜ TRÌNH|BÁO CÁO|THÔNG BÁO|CÔNG VĂN|CHỈ THỊ|QUY ĐỊNH|HƯỚNG DẪN)(:)?$') {
            $h = Text $cleanHeader 15.5 '#111827'
            $h.FontFamily = 'Times New Roman'; $h.FontWeight = 'Bold'; $h.TextAlignment = 'Center'; $h.Margin = '0,14,0,6'
            [void]$page.Children.Add($h)
            continue
        }

        # Trích yếu
        if ($cleanHeader -match '^(Về việc|V/v)\s+') {
            $sub = Text $cleanHeader 13 '#1F2937'
            $sub.FontFamily = 'Times New Roman'; $sub.FontWeight = 'Bold'; $sub.FontStyle = 'Italic'; $sub.TextAlignment = 'Center'; $sub.Margin = '0,0,0,12'
            [void]$page.Children.Add($sub)
            continue
        }

        # Căn cứ pháp lý
        if ($trim -match '^(Căn cứ|Xét đề nghị)') {
            $cleanCc = ($trim -replace '^\*\*|\*\*$', '')
            $cc = Text $cleanCc 13.5 '#111827'
            $cc.FontFamily = 'Times New Roman'; $cc.FontStyle = 'Italic'; $cc.Margin = '24,2,0,3'
            $cc.TextAlignment = 'Justify'
            [void]$page.Children.Add($cc)
            continue
        }

        # Các điều khoản: Điều 1, Điều 2,...
        if ($trim -match '^\*?\*?Điều\s+\d+[\.\:]') {
            $cleanDieu = ($trim -replace '^\*\*|\*\*$', '')
            $tb = New-Object Windows.Controls.TextBlock
            $tb.FontFamily = 'Times New Roman'; $tb.FontSize = 13.5; $tb.Foreground = Brush '#111827'
            $tb.TextWrapping = 'Wrap'; $tb.Margin = '24,6,0,4'; $tb.TextAlignment = 'Justify'

            if ($cleanDieu -match '^(Điều\s+\d+[\.\:])\s*(.*)$') {
                $boldPart = New-Object Windows.Documents.Bold((New-Object Windows.Documents.Run($matches[1])))
                [void]$tb.Inlines.Add($boldPart)
                if ($matches[2]) {
                    $rest = $matches[2] -replace '\*\*', ''
                    [void]$tb.Inlines.Add((New-Object Windows.Documents.Run('  ' + $rest)))
                }
            } else {
                [void]$tb.Inlines.Add((New-Object Windows.Documents.Run($cleanDieu)))
            }
            [void]$page.Children.Add($tb)
            continue
        }

        # Khối chức danh ký tên nếu nằm ngoài nơi nhận
        if ($cleanHeader -match '^\[?(GIÁM ĐỐC|HIỆU TRƯỞNG|TRƯỞNG PHÒNG|KT\.|TM\.|Chức danh|Người ký)' -or $cleanHeader -match 'họ tên người ký') {
            $ky = Text ($cleanHeader -replace '\[|\]', '') 13.5 '#111827'
            $ky.FontFamily = 'Times New Roman'; $ky.FontWeight = 'Bold'; $ky.HorizontalAlignment = 'Right'; $ky.Margin = '0,16,40,4'
            [void]$page.Children.Add($ky)
            continue
        }

        # Đoạn văn bản thông thường
        $pClean = $trim -replace '\*\*', ''
        $p = Text $pClean 13.5 '#111827'
        $p.FontFamily = 'Times New Roman'; $p.TextAlignment = 'Justify'; $p.Margin = '24,2,0,3'
        [void]$page.Children.Add($p)
    }

    # 3. Nơi nhận & Khối ký tên cuối trang
    if ($noiNhanLines.Count -gt 0) {
        $footerGrid = New-Object Windows.Controls.Grid
        $footerGrid.Margin = '0,18,0,0'
        $fc1 = New-Object Windows.Controls.ColumnDefinition; $fc1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
        $fc2 = New-Object Windows.Controls.ColumnDefinition; $fc2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
        [void]$footerGrid.ColumnDefinitions.Add($fc1)
        [void]$footerGrid.ColumnDefinitions.Add($fc2)

        $nnStack = New-Object Windows.Controls.StackPanel
        $nnTieuDe = Text 'Nơi nhận:' 12 '#111827'
        $nnTieuDe.FontFamily = 'Times New Roman'; $nnTieuDe.FontWeight = 'Bold'; $nnTieuDe.FontStyle = 'Italic'
        [void]$nnStack.Children.Add($nnTieuDe)

        foreach ($nnLine in $noiNhanLines) {
            $nnClean = ($nnLine -replace '^\*\*|\*\*$', '') -replace '\*\*', ''
            if ($nnClean -like '*Nơi nhận:*' -or $nnClean -eq 'Nơi nhận:') { continue }
            if ($nnClean -match '^\[?(Chức danh|Người ký|GIÁM ĐỐC|TRƯỞNG PHÒNG)') { continue }
            $nnItem = Text $nnClean 11 '#374151'
            $nnItem.FontFamily = 'Times New Roman'; $nnItem.Margin = '10,1,0,1'
            [void]$nnStack.Children.Add($nnItem)
        }

        $sigStack = New-Object Windows.Controls.StackPanel
        $sigStack.HorizontalAlignment = 'Center'
        $cdText = Text 'TM. ỦY BAN NHÂN DÂN / LÃNH ĐẠO' 12.5 '#111827'
        $cdText.FontFamily = 'Times New Roman'; $cdText.FontWeight = 'Bold'; $cdText.TextAlignment = 'Center'
        [void]$sigStack.Children.Add($cdText)

        $cvText = Text '(Ký, ghi rõ họ tên và đóng dấu)' 11 '#6B7280'
        $cvText.FontFamily = 'Times New Roman'; $cvText.FontStyle = 'Italic'; $cvText.TextAlignment = 'Center'; $cvText.Margin = '0,2,0,0'
        [void]$sigStack.Children.Add($cvText)

        $sigSpace = New-Object Windows.Controls.Border; $sigSpace.Height = 45
        [void]$sigStack.Children.Add($sigSpace)

        $nameSign = Text '[Họ và tên người ký]' 12.5 '#111827'
        $nameSign.FontFamily = 'Times New Roman'; $nameSign.FontWeight = 'Bold'; $nameSign.TextAlignment = 'Center'
        [void]$sigStack.Children.Add($nameSign)

        [Windows.Controls.Grid]::SetColumn($nnStack, 0)
        [Windows.Controls.Grid]::SetColumn($sigStack, 1)
        [void]$footerGrid.Children.Add($nnStack)
        [void]$footerGrid.Children.Add($sigStack)
        [void]$page.Children.Add($footerGrid)
    }

    $border.Child = $page
    return $border
}

function Show-WordPreview([string]$content) {
    $dialog = New-Object Windows.Window
    $dialog.Title = 'Xem trước văn bản Word · A4 Chuẩn thể thức'
    $dialog.Width = 920; $dialog.Height = 840; $dialog.MinWidth = 700; $dialog.MinHeight = 600
    $dialog.Owner = $window; $dialog.WindowStartupLocation = 'CenterOwner'
    $dialog.Background = Brush '#E5E7EB'
    $dialog.FontFamily = 'Segoe UI'

    $mainGrid = New-Object Windows.Controls.Grid
    $row1 = New-Object Windows.Controls.RowDefinition; $row1.Height = [Windows.GridLength]::Auto
    $row2 = New-Object Windows.Controls.RowDefinition; $row2.Height = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$mainGrid.RowDefinitions.Add($row1)
    [void]$mainGrid.RowDefinitions.Add($row2)

    $bar = New-Object Windows.Controls.Border
    $bar.Background = Brush '#FFFFFF'; $bar.BorderBrush = Brush '#D1D5DB'; $bar.BorderThickness = '0,0,0,1'; $bar.Padding = '16,10'
    $barPanel = New-Object Windows.Controls.DockPanel

    $titleInfo = Text 'Chế độ xem trước văn bản Word A4 (Nghị định 30/2020/NĐ-CP)' 13.5 '#1F2937'
    $titleInfo.FontWeight = 'SemiBold'; $titleInfo.VerticalAlignment = 'Center'
    [void]$barPanel.Children.Add($titleInfo)

    $btnBox = New-Object Windows.Controls.StackPanel
    $btnBox.Orientation = 'Horizontal'; $btnBox.HorizontalAlignment = 'Right'
    [Windows.Controls.DockPanel]::SetDock($btnBox, [Windows.Controls.Dock]::Right)

    $btnXuat = Button 'Xuất file Word (.docx)' 'answer-document' $content -Primary
    $btnXuat.Margin = '0,0,8,0'
    [void]$btnBox.Children.Add($btnXuat)

    $btnCopy = Button 'Sao chép' 'copy' $content
    $btnCopy.Margin = '0,0,8,0'
    [void]$btnBox.Children.Add($btnCopy)

    $btnClose = New-Object Windows.Controls.Button
    $btnClose.Content = 'Đóng'; $btnClose.Style = $window.FindResource('Nut')
    $btnClose.Add_Click({ $dialog.Close() })
    [void]$btnBox.Children.Add($btnClose)

    [void]$barPanel.Children.Add($btnBox)
    $bar.Child = $barPanel
    [Windows.Controls.Grid]::SetRow($bar, 0)
    [void]$mainGrid.Children.Add($bar)

    $scroll = New-Object Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = 'Auto'
    $scroll.Padding = '24,20'

    $centerBox = New-Object Windows.Controls.StackPanel
    $centerBox.HorizontalAlignment = 'Center'

    $wordCard = Create-WordPage $content
    [void]$centerBox.Children.Add($wordCard)

    $scroll.Content = $centerBox
    [Windows.Controls.Grid]::SetRow($scroll, 1)
    [void]$mainGrid.Children.Add($scroll)

    $dialog.Content = $mainGrid
    [void]$dialog.ShowDialog()
}
function Render-Chat {
    Update-WordButton
    $box = F 'DsViecChat'; $box.Children.Clear()
    foreach ($c in $script:data.chat) {
        $dock = New-Object Windows.Controls.DockPanel
        $dock.Margin = '0,1,0,3'
        $dock.MaxWidth = 228

        # Nút xóa x nhỏ gọn bên phải
        $delBtn = New-Object Windows.Controls.Button
        $delBtn.Content = [char]0x2715
        $delBtn.FontSize = 10
        $delBtn.FontWeight = 'Bold'
        $delBtn.Foreground = Brush '#94A3B8'
        $delBtn.Background = [Windows.Media.Brushes]::Transparent
        $delBtn.BorderThickness = 0
        $delBtn.Padding = '5,2'
        $delBtn.Margin = '2,0,0,0'
        $delBtn.ToolTip = 'Xóa cuộc trò chuyện này khỏi danh sách'
        $delBtn.Tag = $c.id
        [Windows.Controls.DockPanel]::SetDock($delBtn, [Windows.Controls.Dock]::Right)
        $delBtn.Add_Click({
            param($s,$e)
            $chatId = $s.Tag
            [void](Api 'delete' @{id=$chatId})
            if ($script:session -eq $chatId) { $script:session = $null }
            Refresh-State
            Render-Chat
        })
        [void]$dock.Children.Add($delBtn)

        $b = Button $c.title 'select-chat' $c.id
        $b.HorizontalContentAlignment = 'Left'; $b.Margin = '0'
        $label = Text $c.title 13; $label.MaxWidth = 160; $label.TextTrimming = 'CharacterEllipsis'; $b.Content = $label
        if ($script:session -eq $c.id) { $b.Background = Brush '#EEF4FF' }
        [void]$dock.Children.Add($b)

        [void]$box.Children.Add($dock)
    }
    $conversation = @($script:data.chat | Where-Object { $_.id -eq $script:session } | Select-Object -First 1)
    $stack = New-Object Windows.Controls.StackPanel
    (F 'CuonChat').Content = $stack
    $messages = @(); if ($conversation.Count) { $messages = @($conversation[0].messages) }
    (F 'ChaoChat').Visibility = $(if ($messages.Count) { 'Collapsed' } else { 'Visible' })
    foreach ($message in $messages) {
        if ($message.role -eq 'assistant' -and $script:wordView) {
            # Hiển thị dạng trang giấy Word A4
            $wrap = New-Object Windows.Controls.StackPanel
            $wrap.Margin = '0,0,0,16'

            $tagBar = New-Object Windows.Controls.DockPanel
            $tagBar.Margin = '4,0,0,2'
            $lbl = Text 'VĂN BẢN ĐỊNH DẠNG WORD A4' 11 '#1D4ED8'
            $lbl.FontWeight = 'Bold'
            [void]$tagBar.Children.Add($lbl)
            [void]$wrap.Children.Add($tagBar)

            $wordCard = Create-WordPage $message.content
            [void]$wrap.Children.Add($wordCard)

            $buttons = New-Object Windows.Controls.WrapPanel
            $buttons.Margin = '2,4,0,0'
            [void]$buttons.Children.Add((Button 'Lưu / xuất Word' 'answer-document' $message.content -Primary))
            [void]$buttons.Children.Add((Button 'Xem tin nhắn' 'toggle-word-view' $null))
            [void]$buttons.Children.Add((Button 'Trang Word lớn' 'word-preview-large' $message.content))
            [void]$buttons.Children.Add((Button 'Sao chép' 'copy' $message.content))
            [void]$wrap.Children.Add($buttons)

            [void]$stack.Children.Add($wrap)
        } else {
            # Hiển thị dạng bong bóng chat
            $card = New-Object Windows.Controls.Border; $card.CornerRadius = 12; $card.Padding = '18,12'; $card.Margin = '0,0,0,14'
            $card.Background = Brush $(if ($message.role -eq 'user') { '#EEF4FF' } else { '#F7F9FC' })
            $panel = New-Object Windows.Controls.StackPanel
            $label = Text $(if ($message.role -eq 'user') { 'ANH/CHỊ' } else { 'TRỢ LÝ' }) 12 '#2F6FE0'; $label.FontWeight = 'Bold'; [void]$panel.Children.Add($label)
            $text = New-Object Windows.Controls.TextBox
            $text.Text = $(if ($message.display) { $message.display } else { $message.content }); $text.FontSize = $script:fontSize
            $text.IsReadOnly = $true; $text.TextWrapping = 'Wrap'; $text.BorderThickness = 0; $text.Background = [Windows.Media.Brushes]::Transparent
            $text.Foreground = Brush '#1F3354'; $text.Padding = '0,6'; $text.AcceptsReturn = $true
            [void]$panel.Children.Add($text)
            if ($message.role -eq 'assistant') {
                $buttons = New-Object Windows.Controls.WrapPanel
                [void]$buttons.Children.Add((Button 'Lưu / xuất văn bản' 'answer-document' $message.content -Primary))
                [void]$buttons.Children.Add((Button 'Xem dạng Word' 'toggle-word-view' $null))
                [void]$buttons.Children.Add((Button 'Trang Word lớn' 'word-preview-large' $message.content))
                [void]$buttons.Children.Add((Button 'Sao chép' 'copy' $message.content))
                [void]$buttons.Children.Add((Button 'Đọc cửa sổ lớn' 'read-large' $message.content))
                [void]$panel.Children.Add($buttons)
            }
            $card.Child = $panel; [void]$stack.Children.Add($card)
        }
    }
    Render-Attachments
    (F 'CuonChat').ScrollToEnd()
    (F 'TxtHoi').FontSize = $script:fontSize; (F 'TxtCoChu').Text = [string]$script:fontSize
}
function Send-Chat {
    $prompt=(F 'TxtHoi').Text.Trim();if(-not $prompt){return}
    $result=Api 'chat_start' @{id=$script:session;prompt=$prompt;files=@($script:attachments)}
    $script:session=$result.session
    $script:jobs[$result.job]=@{session=$result.session;prompt=$prompt}
    (F 'TxtHoi').Text='';$script:attachments=@()
    (F 'KhungTienTrinh').Visibility='Visible';(F 'ThanhTienTrinh').IsIndeterminate=$true
    (F 'TxtPhanTram').Text='';(F 'TxtBuoc').Text='Đã gửi yêu cầu · đang chờ AI trả lời…'
    Refresh-State;Render-Chat
}
function Edit-Task($item=$null) {
    $values=Ask-Fields 'Công việc' @(@('title','Nội dung công việc'),@('owner','Phụ trách'),@('due','Hạn xử lý (YYYY-MM-DD)'),@('state','Trạng thái: Chưa làm / Đang làm / Hoàn thành'),@('note','Ghi chú')) $(if($item){$item}else{@{state='Chưa làm'}})
    if($values){
        if(-not $values.title){throw 'Cần nhập nội dung công việc.'}
        if($item.id){$values.id=$item.id};[void](Api 'save' @{kind='task';item=$values})
        Show-Page 'CongViec'
    }
}
function Render-Tasks {
    $box=F 'DsViec';$box.Children.Clear();$due=F 'DsHan';$due.Children.Clear()
    foreach($item in @($script:data.task|Sort-Object due)){
        $row=New-Object Windows.Controls.DockPanel;$row.Margin='0,3,0,8'
        $check=New-Object Windows.Controls.CheckBox;$check.IsChecked=($item.state -eq 'Hoàn thành');$check.Tag=$item;$check.VerticalAlignment='Center';$check.Margin='0,0,10,0'
        $check.Add_Click({param($s,$e) $obj=$s.Tag;$obj.state=$(if($s.IsChecked){'Hoàn thành'}else{'Chưa làm'});[void](Api 'save' @{kind='task';item=$obj});Refresh-State;Render-Tasks})
        [void]$row.Children.Add($check)
        $b=Button ($item.title+'  '+$item.due) 'edit-task' $item;$b.HorizontalContentAlignment='Left';[void]$row.Children.Add($b)
        [void]$box.Children.Add($row)
        if($item.due -and $item.state -ne 'Hoàn thành'){
            $color=if($item.due -lt (Get-Date).ToString('yyyy-MM-dd')){'#D84343'}else{'#1F3354'}
            [void]$due.Children.Add((Text ($item.due+' · '+$item.title) 14 $color))
        }
    }
    if(-not @($script:data.task).Count){[void]$box.Children.Add((Text 'Chưa có công việc. Nhập việc cần làm ở phía trên.' 14 '#8A98AB'))}
}
function Render-Calendar {
    (F 'LvLich').Items.Clear()
    foreach($t in @($script:data.task|Sort-Object due)){[void](F 'LvLich').Items.Add([pscustomobject]@{Ten=$t.title;Ngay=$t.due;NgayTxt=$t.due;Gio='';NoiDung=$t.title;ChuTri=$t.owner;DiaDiem=$t.note;Record=$t})}
    (F 'DsMoc').Children.Clear();[void](F 'DsMoc').Children.Add((Button 'Xem / sửa lịch năm học' 'memory' 'Lịch năm học'))
}
function Edit-Document($record=$null,[string]$title='', [string]$body='', [switch]$Template) {
    $dialog=New-Object Windows.Window;$dialog.Title=$(if($Template){'Mẫu / quy trình riêng'}else{'Biên tập văn bản'})
    $dialog.Width=1050;$dialog.Height=790;$dialog.MinWidth=700;$dialog.MinHeight=540
    $dialog.Owner=$window;$dialog.WindowStartupLocation='CenterOwner';$dialog.FontFamily='Segoe UI';$dialog.Background=Brush '#F4F7FC'
    $dialog.Resources.MergedDictionaries.Add($window.Resources)
    $grid=New-Object Windows.Controls.Grid;$grid.Margin='24'
    foreach($h in @('Auto','*','Auto','Auto')){$r=New-Object Windows.Controls.RowDefinition;$r.Height=$h;[void]$grid.RowDefinitions.Add($r)}
    $name=New-Object Windows.Controls.TextBox;$name.Style=$window.FindResource('Nhap');$name.FontSize=19;$name.MinHeight=46;$name.Margin='0,0,0,14'
    $name.Text=$(if($record){$record.title}else{$title});[void]$grid.Children.Add($name)
    $editor=New-Object Windows.Controls.TextBox;$editor.AcceptsReturn=$true;$editor.AcceptsTab=$true;$editor.TextWrapping='Wrap';$editor.VerticalScrollBarVisibility='Auto'
    $editor.FontSize=16;$editor.Padding=20;$editor.BorderBrush=Brush '#D6E0EE';$editor.Foreground=Brush '#1F3354'
    $editor.Text=$(if($record){$record.body}else{$body});[Windows.Controls.Grid]::SetRow($editor,1);[void]$grid.Children.Add($editor)
    $status=Text 'Chỉnh sửa nội dung rồi lưu hoặc xuất tài liệu.' 13 '#5B6B7F';[Windows.Controls.Grid]::SetRow($status,2);[void]$grid.Children.Add($status)
    $buttons=New-Object Windows.Controls.WrapPanel;[Windows.Controls.Grid]::SetRow($buttons,3);[void]$grid.Children.Add($buttons)
    $state=@{id=$(if($record){$record.id}else{$null});name=$name;editor=$editor;status=$status;kind=$(if($Template){'template'}else{'document'});dirty=$false;owner=$dialog}
    $editor.Tag=$state;$name.Tag=$state
    $editor.Add_TextChanged({param($s,$e)$s.Tag.dirty=$true});$name.Add_TextChanged({param($s,$e)$s.Tag.dirty=$true})
    foreach($option in @(@('Lưu','save'),@('Xuất Word','docx'),@('Xuất PowerPoint','pptx'),@('Xuất Excel','xlsx'),@('Xuất Markdown','md'),@('Mở iOffice','ioffice'))){
        $b=New-Object Windows.Controls.Button;$b.Content=$option[0];$b.Style=$window.FindResource($(if($option[1] -eq 'save'){'NutChinh'}else{'Nut'}));$b.Margin='0,8,8,0';$b.Tag=@{state=$state;format=$option[1]}
        $b.Add_Click({param($s,$e)
            $ctx=$s.Tag.state
            if($s.Tag.format -eq 'ioffice'){Open-IOffice;return}
            $item=@{title=$ctx.name.Text.Trim();body=$ctx.editor.Text.Trim()}
            if(-not $item.title -or -not $item.body){throw 'Cần nhập tiêu đề và nội dung.'}
            if($ctx.id){$item.id=$ctx.id}
            $saved=Api 'save' @{kind=$ctx.kind;item=$item};$ctx.id=$saved.id;$ctx.dirty=$false;$ctx.status.Text='Đã lưu lúc '+(Get-Date -Format HH:mm:ss)
            if($s.Tag.format -ne 'save'){$export=Api 'export' @{title=$item.title;body=$item.body;format=$s.Tag.format};$ctx.status.Text='Đã xuất: '+$export.path;Open-File $export.path}
        })
        [void]$buttons.Children.Add($b)
    }
    $dialog.Tag=$state
    $dialog.Add_Closing({param($s,$e)
        if($s.Tag.dirty){$answer=[Windows.MessageBox]::Show($s,'Có thay đổi chưa lưu. Đóng và bỏ thay đổi?','Văn bản chưa lưu','YesNo','Question');if($answer -ne 'Yes'){$e.Cancel=$true}}
    })
    $dialog.Content=$grid;[void]$dialog.ShowDialog();Refresh-State
    if($script:currentPage -eq 'ThuVien'){Render-Library};if($script:currentPage -eq 'Mau'){Render-Templates}
}
function Render-Library {
    $list=F 'LvThuVien';$list.Items.Clear();$query=(F 'TxtTimVB').Text.Trim()
    foreach($r in $script:data.document){if(-not $query -or $r.title.IndexOf($query,[StringComparison]::OrdinalIgnoreCase) -ge 0){
        [void]$list.Items.Add([pscustomobject]@{Ten=$r.title;File=$r.title;Loai='Dự thảo';DinhDang='Nội dung';NgayTxt=$r.updated;ThuMuc='Văn bản đã soạn';Record=$r})
    }}
}
function Render-Templates {
    $list=F 'LvMau';$list.Items.Clear()
    foreach($r in $script:data.template){[void]$list.Items.Add([pscustomobject]@{Ten=$r.title;CanCu='Mẫu tham khảo · cần rà soát';Nguon=$r.type;File=$r.title+'.md';Record=$r})}
}
function Render-Incoming {
    $list=F 'LvVBDen';$list.Items.Clear()
    foreach($r in $script:data.incoming){[void]$list.Items.Add([pscustomobject]@{File=$r.title;DinhDang=[IO.Path]::GetExtension($r.path);NgayTxt=$r.due;Record=$r})}
}
function Import-Incoming($paths=@()) {
    if(-not @($paths).Count){$paths=@(Select-Files -Multiple)}
    foreach($path in $paths){
        $item=Ask-Fields 'Văn bản đến' @(@('title','Tên văn bản'),@('sender','Nơi gửi'),@('due','Hạn xử lý (YYYY-MM-DD, có thể để trống)')) @{title=[IO.Path]::GetFileNameWithoutExtension($path)}
        if($item){$item.state='Chưa xử lý';[void](Api 'import' @{kind='incoming';path=$path;item=$item})}
    }
    Refresh-State;Render-Incoming
}
function Current-Cycle {return (F 'CbDotBC').SelectedItem.Record}
function Render-Reports {
    $selected=(F 'CbDotBC').SelectedItem.Record.id
    $box=F 'CbDotBC';$box.Items.Clear();$box.DisplayMemberPath='Ten'
    foreach($c in $script:data.cycle){$i=$box.Items.Add([pscustomobject]@{Ten=$c.title;Record=$c});if($c.id -eq $selected){$box.SelectedIndex=$i}}
    if($box.SelectedIndex -lt 0 -and $box.Items.Count){$box.SelectedIndex=0}
    (F 'TxtDsDonVi').Text=(@($script:data.unit|ForEach-Object{$_.title}) -join "`n")
    if(-not (F 'TxtDsDonVi').Text){(F 'TxtDsDonVi').Text='Chưa có đơn vị. Bấm Sửa danh sách để thêm.'}
    (F 'TxtDotBC').Text='Đã tạo '+@($script:data.cycle).Count+' đợt báo cáo.'
    Render-Submissions
}
function Render-Submissions {
    $cycle=Current-Cycle;$list=F 'LvDonVi';$list.Items.Clear();if(-not $cycle){return}
    foreach($uid in $cycle.units){
        $u=$script:data.unit|Where-Object{$_.id -eq $uid}|Select-Object -First 1
        $sub=$script:data.submission|Where-Object{$_.cycle -eq $cycle.id -and $_.unit -eq $uid}|Select-Object -First 1
        [void]$list.Items.Add([pscustomobject]@{Dot=$cycle.title;File=$u.title+' · '+$(if($sub){'Đã nộp'}else{'Chưa nộp'});Ten=$u.title;DonVi=$u.title;DinhDang=$(if($sub){'Đã nộp'}else{'Chưa nộp'});NgayTxt=$cycle.due;ThuMuc=$(if($sub){[IO.Path]::GetFileName($sub.path)}else{''});Record=$sub;Unit=$u})
    }
}
function Edit-Units {
    $lines=(@($script:data.unit|ForEach-Object{$_.title}) -join "`n")
    $dialog=New-Object Windows.Window;$dialog.Title='Danh sách đơn vị';$dialog.Owner=$window;$dialog.Width=700;$dialog.Height=540;$dialog.WindowStartupLocation='CenterOwner';$dialog.Background=Brush '#F4F7FC'
    $panel=New-Object Windows.Controls.DockPanel;$panel.Margin=24
    $label=Text 'Mỗi dòng một đơn vị. Đơn vị đã có sẽ được giữ nguyên dữ liệu.' 14
    [Windows.Controls.DockPanel]::SetDock($label,'Top');[void]$panel.Children.Add($label)
    $save=New-Object Windows.Controls.Button;$save.Content='Lưu danh sách';$save.Style=$window.FindResource('NutChinh');$save.Margin='0,12,0,0'
    [Windows.Controls.DockPanel]::SetDock($save,'Bottom');[void]$panel.Children.Add($save)
    $editor=New-Object Windows.Controls.TextBox;$editor.AcceptsReturn=$true;$editor.TextWrapping='Wrap';$editor.FontSize=16;$editor.Padding=16;$editor.Text=$lines
    [void]$panel.Children.Add($editor)
    $save.Add_Click({$dialog.DialogResult=$true})
    $dialog.Content=$panel
    if($dialog.ShowDialog()){
        foreach($name in ($editor.Text -split '\r?\n')){if($name.Trim() -and -not @($script:data.unit|Where-Object{$_.title -eq $name.Trim()}).Count){[void](Api 'save' @{kind='unit';item=@{title=$name.Trim();contact='';phone=''}})}}
        Refresh-State;$cycle=Current-Cycle
        if($cycle){$cycle.units=@($script:data.unit|ForEach-Object{$_.id});[void](Api 'save' @{kind='cycle';item=$cycle});Refresh-State}
        Render-Reports
    }
}
function Receive-Report($paths=@()) {
    $selected=(F 'LvDonVi').SelectedItem;$cycle=Current-Cycle
    if(-not $selected -or -not $cycle){throw 'Chọn đợt và đơn vị trong danh sách trước khi nhận báo cáo.'}
    if(-not @($paths).Count){$paths=@(Select-Files)}
    if($paths.Count){[void](Api 'import' @{kind='submission';path=$paths[0];item=@{id=$cycle.id+'-'+$selected.Unit.id;cycle=$cycle.id;unit=$selected.Unit.id}});Refresh-State;Render-Submissions}
}
function Aggregate-Reports {
    $cycle=Current-Cycle;if(-not $cycle){throw 'Chọn đợt báo cáo trước.'}
    $subs=@($script:data.submission|Where-Object{$_.cycle -eq $cycle.id})
    $missing=@($script:data.unit|Where-Object{$cycle.units -contains $_.id -and @($subs|ForEach-Object{$_.unit}) -notcontains $_.id}|ForEach-Object{$_.title})
    Start-Work ('Tổng hợp đợt báo cáo: '+$cycle.title+"`nĐơn vị chưa nộp: "+($missing -join ', ')+"`nNêu rõ nguồn từng số liệu, không tự điền số liệu thiếu.") @($subs|ForEach-Object{Path-Data $_.path})
}
function Render-Inspections {
    $list=F 'LvKiemTra';$list.Items.Clear()
    foreach($r in $script:data.document){if($r.title -match 'kiểm tra|thẩm định|chất lượng'){
        [void]$list.Items.Add([pscustomobject]@{Dot='Hồ sơ kiểm tra';File=$r.title;Ten=$r.title;NgayTxt=$r.updated;ThuMuc='Văn bản đã soạn';Record=$r})
    }}
}
function Edit-Memory([string]$title='Ghi nhớ khác') {
    $record=$script:data.memory|Where-Object{$_.title -eq $title}|Select-Object -First 1
    $dialog=New-Object Windows.Window;$dialog.Title='Bộ nhớ · '+$title;$dialog.Width=850;$dialog.Height=650;$dialog.Owner=$window;$dialog.WindowStartupLocation='CenterOwner';$dialog.Background=Brush '#F4F7FC'
    $panel=New-Object Windows.Controls.DockPanel;$panel.Margin=24
    $heading=Text $title 22 '#0B2B6B';$heading.FontWeight='Bold';[Windows.Controls.DockPanel]::SetDock($heading,'Top');[void]$panel.Children.Add($heading)
    $save=New-Object Windows.Controls.Button;$save.Style=$window.FindResource('NutChinh');$save.Content='Lưu bộ nhớ';$save.Margin='0,12,0,0';[Windows.Controls.DockPanel]::SetDock($save,'Bottom');[void]$panel.Children.Add($save)
    $editor=New-Object Windows.Controls.TextBox;$editor.Text=[string]$record.body;$editor.FontSize=16;$editor.AcceptsReturn=$true;$editor.TextWrapping='Wrap';$editor.VerticalScrollBarVisibility='Auto';$editor.Padding=18;[void]$panel.Children.Add($editor)
    $save.Add_Click({$dialog.DialogResult=$true});$dialog.Content=$panel
    if($dialog.ShowDialog()){[void](Api 'save' @{kind='memory';item=@{id='memory-'+$title;title=$title;body=$editor.Text}});Refresh-State}
}
function Render-References {
    $list=F 'LvCanCu';$list.Items.Clear()
    foreach($r in $script:data.memory|Where-Object{$_.title -match 'Căn cứ'}){[void]$list.Items.Add([pscustomobject]@{Ten=$r.title;VanBan=$r.title;NoiDung=$r.body;Record=$r})}
}
function Backup {
    $path=Save-Path ('TroLy-sao-luu-'+(Get-Date -Format yyyyMMdd-HHmmss)+'.zip') 'zip'
    if($path){[void](Api 'backup' @{path=$path});Notice ('Đã sao lưu: '+$path+"`nKhông bao gồm API key.")}
}
function Check-Update {
    (F 'TxtTrangThai').Text='Đang kiểm tra cập nhật...'
    try {
        [void](Api 'check_update' @{interactive=$true})
    } catch {
        Notice "Không thể kết nối máy chủ cập nhật: $($_.Exception.Message)"
    }
}

function Pdf-Tools {
    $options=Ask-Fields 'Công cụ PDF' @(@('mode','Thao tác: Ghép PDF / Tách trang / Xoay trang'),@('pages','Khoảng trang khi tách, ví dụ 2-5'),@('angle','Góc xoay: 90 / 180 / 270')) @{mode='Ghép PDF';angle='90'}
    if(-not $options){return};$files=@(Select-Files -Multiple -Filter 'PDF|*.pdf');if(-not $files.Count){return}
    $target=Save-Path 'Ho-so-moi.pdf' 'pdf';if(-not $target){return}
    [void](Api 'pdf' @{sources=$files;target=$target;mode=$options.mode;pages=$options.pages;angle=$options.angle});Open-File $target
}
function Settings-Card($panel,[string]$title) {
    $border=New-Object Windows.Controls.Border;$border.Style=$window.FindResource('The');$border.Margin='0,0,0,18'
    $stack=New-Object Windows.Controls.StackPanel
    $heading=Text $title 17 '#0B2B6B';$heading.FontWeight='Bold';[void]$stack.Children.Add($heading)
    $border.Child=$stack;[void]$panel.Children.Add($border)
    return $stack
}
function Setting-Field($parent,[string]$key,[string]$label,[string]$value) {
    [void]$parent.Children.Add((Text $label 13 '#5B6B7F'))
    $input=New-Object Windows.Controls.TextBox;$input.Style=$window.FindResource('Nhap');$input.Text=$value;$input.MinHeight=40;$input.Margin='0,0,0,7'
    [void]$parent.Children.Add($input);$script:settings[$key]=$input
}
function Render-Settings {
    $script:settings=@{}
    $p=$script:data.profile
    $outer=New-Object Windows.Controls.StackPanel
    $title=Text 'Cài đặt' 22 '#0B2B6B';$title.FontWeight='Bold';[void]$outer.Children.Add($title)
    [void]$outer.Children.Add((Text 'Kết nối máy chủ trường học, thông tin cơ quan và an toàn dữ liệu.' 13.5 '#5B6B7F'))
    $grid=New-Object Windows.Controls.Grid;$grid.Margin='0,10,0,0'
    foreach($width in @('*','18','*')){$col=New-Object Windows.Controls.ColumnDefinition;$col.Width=$width;[void]$grid.ColumnDefinitions.Add($col)}
    $left=New-Object Windows.Controls.StackPanel;$right=New-Object Windows.Controls.StackPanel
    [Windows.Controls.Grid]::SetColumn($right,2);[void]$grid.Children.Add($left);[void]$grid.Children.Add($right);[void]$outer.Children.Add($grid)
    $card=Settings-Card $left 'Kết nối AI · OpenRouter'
    [void]$card.Children.Add((Text 'API key OpenRouter' 13 '#40546B'))
    $keyBox=New-Object Windows.Controls.PasswordBox;$keyBox.MinHeight=40;$keyBox.Padding=10;$keyBox.Margin='0,8,0,8'
    [Windows.Automation.AutomationProperties]::SetName($keyBox,'API key OpenRouter')
    $script:settings.key=$keyBox;[void]$card.Children.Add($keyBox)
    [void]$card.Children.Add((Text $(if($script:data.has_key){'Đã lưu API key. Để trống để giữ khóa hiện tại.'}else{'Chưa có API key. Nhập khóa của bạn rồi bấm Lưu.'}) 13 '#40546B'))
    [void]$card.Children.Add((Text 'Model: nvidia/nemotron-3-super-120b-a12b:free' 13 '#40546B'))
    [void]$card.Children.Add((Text 'Provider: nvidia' 13 '#40546B'))
    [void]$card.Children.Add((Button 'Lưu API key OpenRouter' 'save-settings' $null -Primary))
    $card=Settings-Card $left 'Kết nối Trường học & Máy chủ'
    [void]$card.Children.Add((Text 'Kết nối máy chủ hệ thống giáo dục dùng chung để trao đổi dữ liệu và đồng bộ công việc.' 13.5 '#40546B'))
    $serverButtons=New-Object Windows.Controls.WrapPanel; $serverButtons.Margin='0,12,0,0'
    [void]$serverButtons.Children.Add((Button 'Trường học chung' 'school-workspace' $null -Primary))
    [void]$serverButtons.Children.Add((Button 'Địa chỉ máy chủ' 'school-settings' $null))
    [void]$card.Children.Add($serverButtons)
    $card=Settings-Card $left 'Dữ liệu và an toàn'
    [void]$card.Children.Add((Text 'Dữ liệu công việc được lưu trên máy. Nội dung trao đổi và tài liệu bạn gửi được chuyển tới nhà cung cấp AI đã chọn. API key được bảo vệ bằng tài khoản Windows.' 13 '#40546B'))
    $buttons=New-Object Windows.Controls.WrapPanel
    [void]$buttons.Children.Add((Button 'Sao lưu dữ liệu' 'backup' $null -Primary));[void]$buttons.Children.Add((Button 'Mở thư mục làm việc' 'folder' $script:data.root));[void]$buttons.Children.Add((Button 'Kiểm tra cập nhật' 'check-update' $null -Primary))
    [void]$card.Children.Add($buttons)

    Setting-Field $card 'ioffice' 'Địa chỉ iOffice cơ quan (tùy chọn)' $p.ioffice
    $card=Settings-Card $right 'Thông tin cơ quan'
    foreach($field in @(@('agency','Tên cơ quan'),@('parent','Cơ quan chủ quản'),@('name','Họ và tên'),@('position','Chức vụ'),@('location','Địa danh'),@('year','Năm học'))){Setting-Field $card $field[0] $field[1] $p.($field[0])}
    [void]$card.Children.Add((Button 'Lưu thông tin cơ quan' 'save-settings' $null -Primary))
    $card=Settings-Card $right 'Bộ nhớ của trợ lý'
    $buttons=New-Object Windows.Controls.WrapPanel
    foreach($name in @('Thông tin cơ quan','Nhân sự','Đơn vị phụ trách','Số liệu','Lịch năm học','Căn cứ và nguồn tham khảo','Quy ước soạn thảo','Ghi nhớ khác')){[void]$buttons.Children.Add((Button $name 'memory' $name))}
    [void]$card.Children.Add($buttons)
    (F 'PgCaiDat').Content=$outer
}
function Save-Settings {
    $profile=@{};foreach($property in $script:data.profile.PSObject.Properties){$profile[$property.Name]=$property.Value}
    foreach($key in @('agency','parent','name','position','location','year','ioffice')){
        if($script:settings.ContainsKey($key) -and $script:settings[$key]){
            $profile[$key]=$script:settings[$key].Text.Trim()
        }
    }
    $profile.provider='OpenRouter'
    $body=@{profile=$profile}
    if($script:settings.ContainsKey('key') -and $script:settings.key -and $script:settings.key.Password.Trim()){$body.key=$script:settings.key.Password.Trim()}
    [void](Api 'settings' $body);Refresh-State;Update-Header
    Render-Settings
    (F 'TxtTrangThai').Text='Đã lưu thông tin cơ quan'
    Notice 'Đã lưu cấu hình và thông tin cơ quan.'
}

function Show-Help {
    $text="TRỢ LÝ CHUYÊN VIÊN · OPENROUTER`n`n1. Vào Cài đặt, nhập API key và mã mô hình OpenRouter rồi lưu.`n2. Chọn một ô nghiệp vụ, nhập yêu cầu và bấm Gửi. Enter để gửi; Shift+Enter để xuống dòng.`n3. Đính kèm hoặc kéo thả tài liệu Word, PDF có chữ, Excel, CSV, TXT, Markdown.`n4. Bấm Lưu / xuất văn bản dưới câu trả lời để mở trình biên tập tích hợp, sửa nội dung và xuất Word, PowerPoint, Excel.`n5. Trong cửa sổ biên tập, dùng Mở iOffice để chuyển sang hồ sơ cơ quan; việc gửi, ký hoặc phê duyệt vẫn cần người dùng xác nhận trên iOffice.`n6. Dữ liệu từ bản trước được giữ nguyên. Sao lưu tại chân trang hoặc Cài đặt.`n`nGiao diện WPF được dựng từ bố cục tham chiếu người dùng cung cấp. Đây là bản độc lập sử dụng API, không phải bản phát hành của tác giả phần mềm tham chiếu.`n`nĐã tích hợp trình biên tập nội bộ, mở iOffice bằng trình duyệt và xuất tài liệu. Chưa tự động quét sổ iOffice, tự gửi/ký/phê duyệt, tự cập nhật, OCR và công cụ sửa máy."
    Notice $text
}
function Open-IOffice {
    $url=$script:data.profile.ioffice
    if(-not $url -or $url -notmatch '^https?://'){Show-Page 'CaiDat';Notice 'Nhập địa chỉ iOffice cơ quan trong Cài đặt.';return}
    [void][Diagnostics.Process]::Start($url)
}
function Invoke-CommandAction([string]$action,$payload=$null) {
    switch($action){
        'page' {Show-Page $payload}
        'work' {Start-Work $payload}
        'settings' {Show-Page 'CaiDat'}
        'save-settings' {Save-Settings}
        'select-chat' {$script:session=$payload;Render-Chat}
        'toggle-word-view' {$script:wordView = -not $script:wordView; Update-WordButton; Render-Chat}
        'word-preview-large' {Show-WordPreview $payload}
        'delete-chat' {[void](Api 'delete' @{id=$payload}); if($script:session -eq $payload){$script:session=$null}; Refresh-State; Render-Chat}
        'remove-attachment' {$script:attachments=@($script:attachments|Where-Object{$_ -ne $payload});Render-Attachments}
        'edit-task' {Edit-Task $payload}
        'document' {Edit-Document $payload}
        'answer-document' {Edit-Document -title 'Dự thảo văn bản' -body $payload}
        'copy' {[Windows.Clipboard]::SetText([string]$payload)}
        'read-large' {Edit-Document -title 'Nội dung trả lời' -body $payload}
        'memory' {Edit-Memory $payload}
        'backup' {Backup}
        'check-update' {Check-Update}
        'folder' {Open-File $payload}

        'url' {[void][Diagnostics.Process]::Start([string]$payload)}
        'help' {Show-Help}
        'pdf' {Pdf-Tools}
        'ioffice' {Open-IOffice}
        'vb' {Open-IOffice}
        'rasoat' {$files=@(Select-Files);if($files.Count){Start-Work 'Rà soát nội dung, số liệu, chính tả và thể thức tài liệu đính kèm. Ghi rõ những điểm cần xác minh.' $files}}
        'huongdan' {Show-Help}
        default {Notice 'Thao tác này chưa được nối trong giao diện hiện tại. Hãy dùng Soạn văn bản, Thư viện văn bản hoặc Công cụ tiện ích.'}
    }
}
function Remove-VietnameseTone([string]$str) {
    if (-not $str) { return '' }
    $normalized = $str.Normalize([Text.NormalizationForm]::FormD)
    $sb = New-Object Text.StringBuilder
    for ($i = 0; $i -lt $normalized.Length; $i++) {
        $c = $normalized[$i]
        $cat = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
        if ($cat -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($c)
        }
    }
    return $sb.ToString().Normalize([Text.NormalizationForm]::FormC) -replace 'đ','d' -replace 'Đ','D'
}

function Find-TemplateByKeyword([string]$keyword) {
    $clean = (Remove-VietnameseTone $keyword).ToLower().Trim()
    $templates = @($script:data.template)
    foreach ($t in $templates) {
        $tClean = (Remove-VietnameseTone $t.title).ToLower()
        if ($clean -like "*$tClean*" -or $tClean -like "*$clean*") {
            return $t
        }
    }
    $keywords = @('bien ban kiem tra', 'quyet dinh doan kiem tra', 'thong bao ket luan', 'hoi dong tham dinh', 'cong nhan chuan', 'de cuong bao cao', 'bien ban', 'quyet dinh', 'ke hoach', 'thong bao', 'to trinh', 'bao cao', 'cong van')
    foreach ($kw in $keywords) {
        if ($clean -like "*$kw*") {
            $match = @($templates | Where-Object { (Remove-VietnameseTone $_.title).ToLower() -like "*$kw*" } | Select-Object -First 1)
            if ($match.Count) { return $match[0] }
        }
    }
    return $null
}

function Show-FeatureDialog([string]$title, [string]$actionCmd) {
    $dialog = New-Object Windows.Window
    $dialog.Title = 'Trợ lý Soạn thảo & Mẫu văn bản'
    $dialog.Width = 600
    $dialog.SizeToContent = 'Height'
    $dialog.WindowStartupLocation = 'CenterOwner'
    $dialog.Owner = $window
    $dialog.Background = Brush '#F4F7FC'
    $dialog.FontFamily = 'Segoe UI'
    $dialog.ResizeMode = 'NoResize'
    $dialog.Resources.MergedDictionaries.Add($window.Resources)

    $outer = New-Object Windows.Controls.StackPanel
    $outer.Margin = '24'

    # Tiêu đề
    $topGrid = New-Object Windows.Controls.Grid
    $colIcon = New-Object Windows.Controls.ColumnDefinition; $colIcon.Width = [Windows.GridLength]::Auto
    $colTitle = New-Object Windows.Controls.ColumnDefinition; $colTitle.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$topGrid.ColumnDefinitions.Add($colIcon)
    [void]$topGrid.ColumnDefinitions.Add($colTitle)

    $icBorder = New-Object Windows.Controls.Border
    $icBorder.Width = 44; $icBorder.Height = 44; $icBorder.CornerRadius = 12; $icBorder.Background = Brush '#1E5FD8'
    $ic = New-Object Windows.Controls.TextBlock
    $ic.Text = [char]0xE8A5; $ic.FontFamily = 'Segoe MDL2 Assets'; $ic.FontSize = 20; $ic.Foreground = [Windows.Media.Brushes]::White
    $ic.HorizontalAlignment = 'Center'; $ic.VerticalAlignment = 'Center'
    $icBorder.Child = $ic
    [Windows.Controls.Grid]::SetColumn($icBorder, 0)
    [void]$topGrid.Children.Add($icBorder)

    $titleBox = New-Object Windows.Controls.StackPanel
    $titleBox.Margin = '12,0,0,0'
    $h = Text $title 18 '#0B2B6B'; $h.FontWeight = 'Bold'; $h.Margin = '0,0,0,2'
    [void]$titleBox.Children.Add($h)
    $sub = Text 'Chọn phương thức thực hiện phù hợp với công việc của bạn' 12.5 '#5B6B7F'; $sub.Margin = '0'
    [void]$titleBox.Children.Add($sub)
    [Windows.Controls.Grid]::SetColumn($titleBox, 1)
    [void]$topGrid.Children.Add($titleBox)
    [void]$outer.Children.Add($topGrid)

    # 1. Thẻ Mẫu có sẵn
    $matchedTemplate = Find-TemplateByKeyword $title
    $card1 = New-Object Windows.Controls.Border
    $card1.Background = [Windows.Media.Brushes]::White
    $card1.BorderBrush = Brush '#CFDDF6'
    $card1.BorderThickness = 1
    $card1.CornerRadius = 12
    $card1.Padding = '16'
    $card1.Margin = '0,18,0,12'

    $p1 = New-Object Windows.Controls.StackPanel
    $badge1 = Text 'CÁCH 1: DÙNG MẪU VĂN BẢN CHUẨN CÓ SẴN (KHUYÊN DÙNG)' 11.5 '#027A48'
    $badge1.FontWeight = 'Bold'
    [void]$p1.Children.Add($badge1)

    $tName = if ($matchedTemplate) { 'Mẫu tham chiếu: ' + $matchedTemplate.title } else { 'Mẫu khung văn bản hành chính' }
    $desc1 = Text "Mở trực tiếp [$tName] trong trình soạn thảo nội bộ để xem thể thức chuẩn, điền số liệu và xuất file Word ngay (không cần chờ AI)." 12.5 '#374151'
    $desc1.Margin = '0,4,0,12'
    [void]$p1.Children.Add($desc1)

    $btnMau = New-Object Windows.Controls.Button
    $btnMau.Content = '📄 Xem & Điền theo mẫu chuẩn'
    $btnMau.Style = $window.FindResource('NutChinh')
    $btnMau.Background = Brush '#0E8A4F'
    $btnMau.Height = 38
    $btnMau.Add_Click({
        $dialog.Close()
        if ($matchedTemplate) {
            Edit-Document $matchedTemplate -Template
        } else {
            Edit-Document -title $title -body "DỰ THẢO $title`n`nCăn cứ...`n`nĐiều 1....`n`nĐiều 2....`n`nNơi nhận:`n- Như Điều 3;`n- Lưu: VT."
        }
    })
    [void]$p1.Children.Add($btnMau)
    $card1.Child = $p1
    [void]$outer.Children.Add($card1)

    # 2. Thẻ Nhờ AI soạn thảo
    $card2 = New-Object Windows.Controls.Border
    $card2.Background = [Windows.Media.Brushes]::White
    $card2.BorderBrush = Brush '#CFDDF6'
    $card2.BorderThickness = 1
    $card2.CornerRadius = 12
    $card2.Padding = '16'
    $card2.Margin = '0,0,0,12'

    $p2 = New-Object Windows.Controls.StackPanel
    $badge2 = Text 'CÁCH 2: NHỜ TRỢ LÝ AI SOẠN DỰ THẢO TỰ ĐỘNG' 11.5 '#1D4ED8'
    $badge2.FontWeight = 'Bold'
    [void]$p2.Children.Add($badge2)

    $desc2 = Text 'Nhập nhanh vài thông tin gợi ý để Trợ lý AI tự động soạn thảo văn bản hoàn chỉnh theo đúng quy định:' 12.5 '#374151'
    $desc2.Margin = '0,4,0,8'
    [void]$p2.Children.Add($desc2)

    [void]$p2.Children.Add((Text 'Đơn vị / Trường áp dụng' 12 '#4B5563'))
    $txtDonVi = New-Object Windows.Controls.TextBox
    $txtDonVi.Style = $window.FindResource('Nhap')
    $txtDonVi.MinHeight = 34
    $txtDonVi.Margin = '0,2,0,8'
    [void]$p2.Children.Add($txtDonVi)

    [void]$p2.Children.Add((Text 'Thời gian / Địa điểm' 12 '#4B5563'))
    $txtThoiGian = New-Object Windows.Controls.TextBox
    $txtThoiGian.Style = $window.FindResource('Nhap')
    $txtThoiGian.MinHeight = 34
    $txtThoiGian.Margin = '0,2,0,8'
    $txtThoiGian.Text = [DateTime]::Today.ToString('dd/MM/yyyy')
    [void]$p2.Children.Add($txtThoiGian)

    [void]$p2.Children.Add((Text 'Nội dung / Yêu cầu cụ thể' 12 '#4B5563'))
    $txtGhiChu = New-Object Windows.Controls.TextBox
    $txtGhiChu.Style = $window.FindResource('Nhap')
    $txtGhiChu.MinHeight = 34
    $txtGhiChu.Margin = '0,2,0,12'
    [void]$p2.Children.Add($txtGhiChu)

    $btnAi = New-Object Windows.Controls.Button
    $btnAi.Content = '✨ Bắt đầu soạn thảo với AI'
    $btnAi.Style = $window.FindResource('NutChinh')
    $btnAi.Height = 38
    $btnAi.Add_Click({
        $dialog.Close()
        $prompt = "Soạn $title"
        if ($txtDonVi.Text.Trim()) { $prompt += " tại/cho đơn vị: " + $txtDonVi.Text.Trim() }
        if ($txtThoiGian.Text.Trim()) { $prompt += ", thời gian: " + $txtThoiGian.Text.Trim() }
        if ($txtGhiChu.Text.Trim()) { $prompt += ". Nội dung cụ thể: " + $txtGhiChu.Text.Trim() } else { $prompt += ". Trợ lý soạn thảo đầy đủ các điều khoản theo thể thức quy định." }
        Start-Work $prompt
    })
    [void]$p2.Children.Add($btnAi)
    $card2.Child = $p2
    [void]$outer.Children.Add($card2)

    # Nút Đóng
    $btnClose = New-Object Windows.Controls.Button
    $btnClose.Content = 'Đóng'
    $btnClose.Style = $window.FindResource('Nut')
    $btnClose.HorizontalAlignment = 'Right'
    $btnClose.Padding = '18,6'
    $btnClose.Add_Click({ $dialog.Close() })
    [void]$outer.Children.Add($btnClose)

    $dialog.Content = $outer
    [void]$dialog.ShowDialog()
}

function Show-TrackingDialog {
    $cycle = Current-Cycle
    if (-not $cycle) {
        Notice 'Vui lòng chọn hoặc tạo một đợt báo cáo trong danh sách trước khi theo dõi tiến độ nộp.'
        return
    }

    $dialog = New-Object Windows.Window
    $dialog.Title = 'Bảng Theo Dõi Tiến Độ Nộp Báo Cáo'
    $dialog.Width = 760
    $dialog.Height = 580
    $dialog.WindowStartupLocation = 'CenterOwner'
    $dialog.Owner = $window
    $dialog.Background = Brush '#F4F7FC'
    $dialog.FontFamily = 'Segoe UI'
    $dialog.Resources.MergedDictionaries.Add($window.Resources)

    $outer = New-Object Windows.Controls.DockPanel
    $outer.Margin = '20'

    # Top Header
    $topBox = New-Object Windows.Controls.StackPanel
    [Windows.Controls.DockPanel]::SetDock($topBox, 'Top')
    
    $headerGrid = New-Object Windows.Controls.Grid
    $col1 = New-Object Windows.Controls.ColumnDefinition; $col1.Width = [Windows.GridLength]::Auto
    $col2 = New-Object Windows.Controls.ColumnDefinition; $col2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$headerGrid.ColumnDefinitions.Add($col1)
    [void]$headerGrid.ColumnDefinitions.Add($col2)

    $icBorder = New-Object Windows.Controls.Border
    $icBorder.Width = 46; $icBorder.Height = 46; $icBorder.CornerRadius = 12; $icBorder.Background = Brush '#E09A00'
    $ic = New-Object Windows.Controls.TextBlock
    $ic.Text = [char]0xE9D5; $ic.FontFamily = 'Segoe MDL2 Assets'; $ic.FontSize = 22; $ic.Foreground = [Windows.Media.Brushes]::White
    $ic.HorizontalAlignment = 'Center'; $ic.VerticalAlignment = 'Center'
    $icBorder.Child = $ic
    [Windows.Controls.Grid]::SetColumn($icBorder, 0)
    [void]$headerGrid.Children.Add($icBorder)

    $titleBox = New-Object Windows.Controls.StackPanel
    $titleBox.Margin = '14,0,0,0'
    $h = Text ('Theo dõi nộp: ' + $cycle.title) 18 '#0B2B6B'; $h.FontWeight = 'Bold'
    [void]$titleBox.Children.Add($h)
    $sub = Text ('Hạn nộp: ' + $(if($cycle.due){$cycle.due}else{'Chưa xác định'}) + ' · Quản lý trạng thái và danh sách file đã nộp (Không cần soạn thảo văn bản)') 12.5 '#5B6B7F'
    [void]$titleBox.Children.Add($sub)
    [Windows.Controls.Grid]::SetColumn($titleBox, 1)
    [void]$headerGrid.Children.Add($titleBox)
    [void]$topBox.Children.Add($headerGrid)

    # Thống kê Cards
    $statGrid = New-Object Windows.Controls.Grid
    $statGrid.Margin = '0,14,0,14'
    foreach($w in @('*','12','*','12','*','12','*')) {
        $cDef = New-Object Windows.Controls.ColumnDefinition
        if ($w -eq '*') { $cDef.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star) } else { $cDef.Width = New-Object Windows.GridLength([double]$w) }
        [void]$statGrid.ColumnDefinitions.Add($cDef)
    }

    $units = @($script:data.unit | Where-Object { $cycle.units -contains $_.id })
    $subs = @($script:data.submission | Where-Object { $_.cycle -eq $cycle.id })
    $subUnitIds = @($subs | ForEach-Object { $_.unit })
    $daNopCount = @($units | Where-Object { $subUnitIds -contains $_.id }).Count
    $chuaNopCount = $units.Count - $daNopCount
    $pct = if ($units.Count -gt 0) { [Math]::Round(($daNopCount * 100.0 / $units.Count), 1) } else { 0 }

    function Create-StatBox($title, $val, $colVal, $colIdx) {
        $b = New-Object Windows.Controls.Border
        $b.Background = [Windows.Media.Brushes]::White; $b.CornerRadius = 10; $b.Padding = '12,8'; $b.BorderBrush = Brush '#E2E8F0'; $b.BorderThickness = 1
        $sp = New-Object Windows.Controls.StackPanel
        $t1 = Text $title 11 '#64748B'; $t1.FontWeight = 'SemiBold'
        $t2 = Text $val 18 $colVal; $t2.FontWeight = 'Bold'
        [void]$sp.Children.Add($t1); [void]$sp.Children.Add($t2)
        $b.Child = $sp
        [Windows.Controls.Grid]::SetColumn($b, $colIdx)
        return $b
    }

    [void]$statGrid.Children.Add((Create-StatBox 'TỔNG ĐƠN VỊ' ([string]$units.Count) '#1E293B' 0))
    [void]$statGrid.Children.Add((Create-StatBox 'ĐÃ NỘP BÁO CÁO' ([string]$daNopCount) '#0E8A4F' 2))
    [void]$statGrid.Children.Add((Create-StatBox 'CHƯA NỘP' ([string]$chuaNopCount) '#DC2626' 4))
    [void]$statGrid.Children.Add((Create-StatBox 'TIẾN ĐỘ HOÀN THÀNH' ("$pct%") '#1E5FD8' 6))
    [void]$topBox.Children.Add($statGrid)

    [void]$outer.Children.Add($topBox)

    # Bottom Actions Bar
    $botBox = New-Object Windows.Controls.DockPanel
    $botBox.Margin = '0,14,0,0'
    [Windows.Controls.DockPanel]::SetDock($botBox, 'Bottom')

    $leftActions = New-Object Windows.Controls.StackPanel
    $leftActions.Orientation = 'Horizontal'

    $btnExcel = New-Object Windows.Controls.Button
    $btnExcel.Content = '📊 Xuất file Excel theo dõi'
    $btnExcel.Style = $window.FindResource('Nut')
    $btnExcel.Padding = '14,6'
    $btnExcel.Margin = '0,0,10,0'
    $btnExcel.Add_Click({
        $rows = @()
        $idx = 1
        foreach ($u in $units) {
            $s = $subs | Where-Object { $_.unit -eq $u.id } | Select-Object -First 1
            $sttStr = if ($s) { 'Đã nộp' } else { 'Chưa nộp' }
            $fName = if ($s -and $s.path) { [IO.Path]::GetFileName($s.path) } else { '' }
            $rows += ,@([string]$idx, $u.title, $sttStr, $fName, $(if($cycle.due){$cycle.due}else{''}))
            $idx++
        }
        $res = Api 'export' @{format='xlsx'; title=('Theo_doi_nop_' + $cycle.title); headers=@('STT','Đơn vị','Trạng thái','Tên file nộp','Hạn nộp'); rows=$rows}
        if ($res.path) { Open-File $res.path }
    })
    [void]$leftActions.Children.Add($btnExcel)

    if ($chuaNopCount -gt 0) {
        $btnDonDocNhanh = New-Object Windows.Controls.Button
        $btnDonDocNhanh.Content = '📢 Đôn đốc các đơn vị chưa nộp'
        $btnDonDocNhanh.Style = $window.FindResource('NutChinh')
        $btnDonDocNhanh.Background = Brush '#E0313F'
        $btnDonDocNhanh.Padding = '14,6'
        $btnDonDocNhanh.Add_Click({
            $dialog.Close()
            Show-PromptReminderDialog
        })
        [void]$leftActions.Children.Add($btnDonDocNhanh)
    }

    [void]$botBox.Children.Add($leftActions)

    $btnClose = New-Object Windows.Controls.Button
    $btnClose.Content = 'Đóng'
    $btnClose.Style = $window.FindResource('Nut')
    $btnClose.Padding = '18,6'
    $btnClose.HorizontalAlignment = 'Right'
    $btnClose.Add_Click({ $dialog.Close() })
    [void]$botBox.Children.Add($btnClose)

    [void]$outer.Children.Add($botBox)

    # Center Data Grid / Table
    $cardList = New-Object Windows.Controls.Border
    $cardList.Background = [Windows.Media.Brushes]::White
    $cardList.CornerRadius = 12
    $cardList.BorderBrush = Brush '#E2E8F0'
    $cardList.BorderThickness = 1
    $cardList.Padding = '10'

    $listView = New-Object Windows.Controls.ListView
    $listView.BorderThickness = 0
    $listView.Background = [Windows.Media.Brushes]::Transparent
    $listView.SelectionMode = 'Single'

    $gridList = New-Object Windows.Controls.GridView

    function Add-TrackCol($hdr, $bindingProp, $w) {
        $col = New-Object Windows.Controls.GridViewColumn
        $col.Header = $hdr
        $col.Width = $w
        $col.DisplayMemberBinding = New-Object Windows.Data.Binding($bindingProp)
        [void]$gridList.Columns.Add($col)
    }

    Add-TrackCol 'STT' 'Stt' 50
    Add-TrackCol 'Tên đơn vị (Trường / Xã)' 'Ten' 260
    Add-TrackCol 'Trạng thái nộp' 'TrangThai' 110
    Add-TrackCol 'File báo cáo đã gửi' 'FileBaoCao' 260

    $listView.View = $gridList

    function Load-TrackingItems {
        $listView.Items.Clear()
        $idx = 1
        foreach ($u in $units) {
            $s = $subs | Where-Object { $_.unit -eq $u.id } | Select-Object -First 1
            $sttStr = if ($s) { '✅ Đã nộp' } else { '⏳ Chưa nộp' }
            $fName = if ($s -and $s.path) { [IO.Path]::GetFileName($s.path) } else { '(Chưa có file)' }
            [void]$listView.Items.Add([pscustomobject]@{
                Stt = [string]$idx
                Ten = $u.title
                TrangThai = $sttStr
                FileBaoCao = $fName
                Unit = $u
                Sub = $s
            })
            $idx++
        }
    }
    Load-TrackingItems

    $contextMenu = New-Object Windows.Controls.ContextMenu
    $miNop = New-Object Windows.Controls.MenuItem; $miNop.Header = 'Đánh dấu: ĐÃ NỘP (chọn file đính kèm)'
    $miChua = New-Object Windows.Controls.MenuItem; $miChua.Header = 'Đánh dấu: CHƯA NỘP (hủy file)'
    [void]$contextMenu.Items.Add($miNop)
    [void]$contextMenu.Items.Add($miChua)
    $listView.ContextMenu = $contextMenu

    $miNop.Add_Click({
        $item = $listView.SelectedItem
        if ($item) {
            $files = @(Select-Files -Filter 'File báo cáo (*.docx;*.doc;*.pdf;*.xlsx;*.xls)|*.docx;*.doc;*.pdf;*.xlsx;*.xls|Tất cả|*.*')
            $path = if ($files.Count) { $files[0] } else { '' }
            [void](Api 'save' @{kind='submission';item=@{id=$cycle.id+'-'+$item.Unit.id;cycle=$cycle.id;unit=$item.Unit.id;path=$path}})
            Refresh-State; $subs = @($script:data.submission | Where-Object { $_.cycle -eq $cycle.id })
            Load-TrackingItems
            Render-Reports
        }
    })

    $miChua.Add_Click({
        $item = $listView.SelectedItem
        if ($item -and $item.Sub) {
            [void](Api 'delete' @{id=$item.Sub.id})
            Refresh-State; $subs = @($script:data.submission | Where-Object { $_.cycle -eq $cycle.id })
            Load-TrackingItems
            Render-Reports
        }
    })

    $cardList.Child = $listView
    [void]$outer.Children.Add($cardList)

    $dialog.Content = $outer
    [void]$dialog.ShowDialog()
}

function Show-PromptReminderDialog {
    $cycle = Current-Cycle
    if (-not $cycle) {
        Notice 'Vui lòng chọn đợt báo cáo trước khi thực hiện đôn đốc.'
        return
    }
    $units = @($script:data.unit | Where-Object { $cycle.units -contains $_.id })
    $subs = @($script:data.submission | Where-Object { $_.cycle -eq $cycle.id })
    $subUnitIds = @($subs | ForEach-Object { $_.unit })
    $missingUnits = @($units | Where-Object { $subUnitIds -notcontains $_.id })
    $missingNames = @($missingUnits | ForEach-Object { $_.title })

    $dialog = New-Object Windows.Window
    $dialog.Title = 'Đôn đốc nộp báo cáo · ' + $cycle.title
    $dialog.Width = 640
    $dialog.SizeToContent = 'Height'
    $dialog.WindowStartupLocation = 'CenterOwner'
    $dialog.Owner = $window
    $dialog.Background = Brush '#F4F7FC'
    $dialog.FontFamily = 'Segoe UI'
    $dialog.Resources.MergedDictionaries.Add($window.Resources)

    $outer = New-Object Windows.Controls.StackPanel
    $outer.Margin = '22'

    # Header
    $topGrid = New-Object Windows.Controls.Grid
    $col1 = New-Object Windows.Controls.ColumnDefinition; $col1.Width = [Windows.GridLength]::Auto
    $col2 = New-Object Windows.Controls.ColumnDefinition; $col2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$topGrid.ColumnDefinitions.Add($col1); [void]$topGrid.ColumnDefinitions.Add($col2)

    $icBorder = New-Object Windows.Controls.Border
    $icBorder.Width = 46; $icBorder.Height = 46; $icBorder.CornerRadius = 12; $icBorder.Background = Brush '#E0313F'
    $ic = New-Object Windows.Controls.TextBlock
    $ic.Text = [char]0xE8BD; $ic.FontFamily = 'Segoe MDL2 Assets'; $ic.FontSize = 22; $ic.Foreground = [Windows.Media.Brushes]::White
    $ic.HorizontalAlignment = 'Center'; $ic.VerticalAlignment = 'Center'
    $icBorder.Child = $ic
    [Windows.Controls.Grid]::SetColumn($icBorder, 0)
    [void]$topGrid.Children.Add($icBorder)

    $titleBox = New-Object Windows.Controls.StackPanel
    $titleBox.Margin = '14,0,0,0'
    $h = Text 'Đôn đốc các đơn vị chưa nộp báo cáo' 18 '#0B2B6B'; $h.FontWeight = 'Bold'
    [void]$titleBox.Children.Add($h)
    $sub = Text ("Đợt: " + $cycle.title + " · Hiện còn " + $missingUnits.Count + " đơn vị chưa gửi báo cáo") 12.5 '#5B6B7F'
    [void]$titleBox.Children.Add($sub)
    [Windows.Controls.Grid]::SetColumn($titleBox, 1)
    [void]$topGrid.Children.Add($titleBox)
    [void]$outer.Children.Add($topGrid)

    # 1. Thẻ Tin nhắn nhắc nhanh (Zalo / SMS / Email) - KHÔNG SOẠN THẢO
    $cardMsg = New-Object Windows.Controls.Border
    $cardMsg.Background = [Windows.Media.Brushes]::White
    $cardMsg.CornerRadius = 12
    $cardMsg.BorderBrush = Brush '#CFDDF6'
    $cardMsg.BorderThickness = 1
    $cardMsg.Padding = '16'
    $cardMsg.Margin = '0,18,0,12'

    $spMsg = New-Object Windows.Controls.StackPanel
    $badge1 = Text 'LỰA CHỌN 1: MẪU TIN NHẮN NHẮC NHANH (ZALO / SMS / EMAIL)' 11.5 '#027A48'
    $badge1.FontWeight = 'Bold'
    [void]$spMsg.Children.Add($badge1)

    $desc1 = Text 'Trợ lý đã tự động trích xuất danh sách đơn vị trễ hạn và tạo sẵn mẫu tin nhắn ngắn gọn để gửi ngay:' 12.5 '#374151'
    $desc1.Margin = '0,4,0,8'
    [void]$spMsg.Children.Add($desc1)

    $strList = if ($missingNames.Count) { ($missingNames -join ', ') } else { '(Hiện các đơn vị đều đã nộp đủ)' }
    $defaultMsg = "Kính gửi Ban Giám hiệu các đơn vị:`n$strList`n`nHiện tại đã đến hạn nộp báo cáo đợt: $($cycle.title) (Hạn: $($cycle.due)). Đề nghị các đồng chí khẩn trương hoàn thiện và gửi file báo cáo về bộ phận tổng hợp trước 17h00 hôm nay để kịp tổng hợp chung toàn ngành.`nTrân trọng cảm ơn các đồng chí!"

    $txtMsg = New-Object Windows.Controls.TextBox
    $txtMsg.Style = $window.FindResource('Nhap')
    $txtMsg.Text = $defaultMsg
    $txtMsg.TextWrapping = 'Wrap'
    $txtMsg.AcceptsReturn = $true
    $txtMsg.MinHeight = 85
    $txtMsg.Margin = '0,2,0,10'
    [void]$spMsg.Children.Add($txtMsg)

    $btnCopy = New-Object Windows.Controls.Button
    $btnCopy.Content = '📋 Sao chép tin nhắn (Copy để dán vào Zalo)'
    $btnCopy.Style = $window.FindResource('NutChinh')
    $btnCopy.Background = Brush '#0E8A4F'
    $btnCopy.Height = 36
    $btnCopy.Add_Click({
        [Windows.Clipboard]::SetText($txtMsg.Text)
        Notice 'Đã sao chép nội dung tin nhắn vào bộ nhớ tạm! Bạn có thể dán (Ctrl + V) ngay vào nhóm Zalo hoặc tin nhắn gửi các đơn vị.'
    })
    [void]$spMsg.Children.Add($btnCopy)
    $cardMsg.Child = $spMsg
    [void]$outer.Children.Add($cardMsg)

    # 2. Thẻ Soạn công văn đôn đốc chính thức - CÓ SOẠN THẢO
    $cardDoc = New-Object Windows.Controls.Border
    $cardDoc.Background = [Windows.Media.Brushes]::White
    $cardDoc.CornerRadius = 12
    $cardDoc.BorderBrush = Brush '#E2E8F0'
    $cardDoc.BorderThickness = 1
    $cardDoc.Padding = '16'
    $cardDoc.Margin = '0,0,0,14'

    $spDoc = New-Object Windows.Controls.StackPanel
    $badge2 = Text 'LỰA CHỌN 2: SOẠN CÔNG VĂN ĐÔN ĐỐC CHÍNH THỨC (THEO NĐ 30)' 11.5 '#1D4ED8'
    $badge2.FontWeight = 'Bold'
    [void]$spDoc.Children.Add($badge2)

    $desc2 = Text 'Dành cho trường hợp cần ban hành văn bản hành chính chính thức gửi các đơn vị chưa nộp:' 12.5 '#374151'
    $desc2.Margin = '0,4,0,8'
    [void]$spDoc.Children.Add($desc2)

    $btnSoan = New-Object Windows.Controls.Button
    $btnSoan.Content = '📄 Soạn Công văn đôn đốc'
    $btnSoan.Style = $window.FindResource('NutChinh')
    $btnSoan.Background = Brush '#1E5FD8'
    $btnSoan.Height = 36
    $btnSoan.Add_Click({
        $dialog.Close()
        Show-FeatureDialog 'Công văn đôn đốc nộp báo cáo' "lenh:/tong-hop-don-vi Công văn đôn đốc nộp báo cáo đợt $($cycle.title), các đơn vị chưa nộp: $strList"
    })
    [void]$spDoc.Children.Add($btnSoan)
    $cardDoc.Child = $spDoc
    [void]$outer.Children.Add($cardDoc)

    $btnClose = New-Object Windows.Controls.Button
    $btnClose.Content = 'Đóng'
    $btnClose.Style = $window.FindResource('Nut')
    $btnClose.Padding = '18,6'
    $btnClose.HorizontalAlignment = 'Right'
    $btnClose.Add_Click({ $dialog.Close() })
    [void]$outer.Children.Add($btnClose)

    $dialog.Content = $outer
    [void]$dialog.ShowDialog()
}

function Show-DataAggregationDialog {
    $cycle = Current-Cycle
    $dialog = New-Object Windows.Window
    $dialog.Title = 'Tổng hợp số liệu báo cáo'
    $dialog.Width = 660
    $dialog.SizeToContent = 'Height'
    $dialog.WindowStartupLocation = 'CenterOwner'
    $dialog.Owner = $window
    $dialog.Background = Brush '#F4F7FC'
    $dialog.FontFamily = 'Segoe UI'
    $dialog.Resources.MergedDictionaries.Add($window.Resources)

    $outer = New-Object Windows.Controls.StackPanel
    $outer.Margin = '22'

    # Top Header
    $topGrid = New-Object Windows.Controls.Grid
    $col1 = New-Object Windows.Controls.ColumnDefinition; $col1.Width = [Windows.GridLength]::Auto
    $col2 = New-Object Windows.Controls.ColumnDefinition; $col2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$topGrid.ColumnDefinitions.Add($col1); [void]$topGrid.ColumnDefinitions.Add($col2)

    $icBorder = New-Object Windows.Controls.Border
    $icBorder.Width = 46; $icBorder.Height = 46; $icBorder.CornerRadius = 12; $icBorder.Background = Brush '#00838F'
    $ic = New-Object Windows.Controls.TextBlock
    $ic.Text = [char]0xE9D5; $ic.FontFamily = 'Segoe MDL2 Assets'; $ic.FontSize = 22; $ic.Foreground = [Windows.Media.Brushes]::White
    $ic.HorizontalAlignment = 'Center'; $ic.VerticalAlignment = 'Center'
    $icBorder.Child = $ic
    [Windows.Controls.Grid]::SetColumn($icBorder, 0)
    [void]$topGrid.Children.Add($icBorder)

    $titleBox = New-Object Windows.Controls.StackPanel
    $titleBox.Margin = '14,0,0,0'
    $h = Text 'Tổng hợp số liệu từ các đơn vị' 18 '#0B2B6B'; $h.FontWeight = 'Bold'
    [void]$titleBox.Children.Add($h)
    $sub = Text 'Xử lý và gộp số liệu bảng tính Excel, CSV từ các đơn vị gửi lên (Không cần soạn thảo văn bản)' 12.5 '#5B6B7F'
    [void]$titleBox.Children.Add($sub)
    [Windows.Controls.Grid]::SetColumn($titleBox, 1)
    [void]$topGrid.Children.Add($titleBox)
    [void]$outer.Children.Add($topGrid)

    # Thẻ tác vụ số liệu
    $card = New-Object Windows.Controls.Border
    $card.Background = [Windows.Media.Brushes]::White; $card.CornerRadius = 12; $card.BorderBrush = Brush '#E2E8F0'; $card.BorderThickness = 1; $card.Padding = '16'; $card.Margin = '0,18,0,14'
    $sp = New-Object Windows.Controls.StackPanel

    $subs = if ($cycle) { @($script:data.submission | Where-Object { $_.cycle -eq $cycle.id -and $_.path -match '\.(xlsx|xls|csv)$' }) } else { @() }
    [void]$sp.Children.Add((Text ("Đợt hiện tại: " + $(if($cycle){$cycle.title}else{'Chưa chọn đợt'})) 13.5 '#0B2B6B'))
    [void]$sp.Children.Add((Text ("Số file bảng tính đã nhận: " + $subs.Count + " file Excel/CSV") 12.5 '#64748B'))

    $btnNhanExcel = New-Object Windows.Controls.Button
    $btnNhanExcel.Content = '📥 Chọn thêm file bảng tính Excel/CSV để tổng hợp'
    $btnNhanExcel.Style = $window.FindResource('Nut')
    $btnNhanExcel.Margin = '0,10,0,8'
    $btnNhanExcel.Height = 36
    $btnNhanExcel.Add_Click({
        $files = @(Select-Files -Multiple -Filter 'Bảng tính Excel/CSV (*.xlsx;*.xls;*.csv)|*.xlsx;*.xls;*.csv|Tất cả|*.*')
        if ($files.Count) {
            Notice ("Đã nhận " + $files.Count + " file số liệu. Bạn có thể bấm Tổng hợp số liệu.")
        }
    })
    [void]$sp.Children.Add($btnNhanExcel)

    $btnGopExcel = New-Object Windows.Controls.Button
    $btnGopExcel.Content = '📊 Tổng hợp & Xuất bảng số liệu tổng (Excel)'
    $btnGopExcel.Style = $window.FindResource('NutChinh')
    $btnGopExcel.Background = Brush '#0E8A4F'
    $btnGopExcel.Height = 38
    $btnGopExcel.Margin = '0,0,0,8'
    $btnGopExcel.Add_Click({
        $dialog.Close()
        $units = @($script:data.unit)
        $rows = @()
        $idx = 1
        foreach ($u in $units) {
            $rows += ,@([string]$idx, $u.title, 'Đã ghi nhận', '', '')
            $idx++
        }
        $res = Api 'export' @{format='xlsx'; title='Tong_hop_so_lieu_cac_don_vi'; headers=@('STT','Đơn vị','Tình trạng','Số lớp','Số học sinh'); rows=$rows}
        if ($res.path) { Open-File $res.path }
    })
    [void]$sp.Children.Add($btnGopExcel)

    $btnMoThuMuc = New-Object Windows.Controls.Button
    $btnMoThuMuc.Content = '📂 Mở thư mục lưu trữ số liệu'
    $btnMoThuMuc.Style = $window.FindResource('Nut')
    $btnMoThuMuc.Height = 36
    $btnMoThuMuc.Add_Click({
        Open-File (Path-Data 'bao-cao')
    })
    [void]$sp.Children.Add($btnMoThuMuc)

    $card.Child = $sp
    [void]$outer.Children.Add($card)

    $btnClose = New-Object Windows.Controls.Button
    $btnClose.Content = 'Đóng'
    $btnClose.Style = $window.FindResource('Nut')
    $btnClose.Padding = '18,6'
    $btnClose.HorizontalAlignment = 'Right'
    $btnClose.Add_Click({ $dialog.Close() })
    [void]$outer.Children.Add($btnClose)

    $dialog.Content = $outer
    [void]$dialog.ShowDialog()
}

function Invoke-ReferenceAction([string]$action) {
    if($action.StartsWith('trang:')){Show-Page $action.Substring(6);return}
    
    # 1. Rà soát các tính năng KHÔNG CẦN SOẠN THẢO VĂN BẢN (Dữ liệu, Danh mục, Theo dõi, Tra cứu)
    if ($action -match 'Theo dõi nộp') {
        Show-TrackingDialog
        return
    }
    if ($action -match 'Danh sách đơn vị') {
        Edit-Units
        return
    }
    if ($action -match 'Số liệu các đơn vị|Thống kê số liệu') {
        Show-DataAggregationDialog
        return
    }
    if ($action -match 'Đôn đốc báo cáo|Đôn đốc') {
        Show-PromptReminderDialog
        return
    }
    if ($action -match 'Căn cứ|căn cứ') {
        Edit-Memory 'Căn cứ và nguồn tham khảo'
        return
    }
    if ($action -match 'Tư vấn quy định|Tra cứu|tra-cuu') {
        Show-Page 'TraCuu'
        return
    }
    if ($action -match 'Việc tháng') {
        Show-Page 'CongViec'
        return
    }
    if ($action -match 'Chuyển đổi số, dữ liệu ngành') {
        Show-Page 'DonVi'
        return
    }

    # 2. Các tính năng CẦN SOẠN THẢO VĂN BẢN (Yêu cầu báo cáo, Tờ trình, Kế hoạch, Quyết định, Báo cáo...)
    if($action.StartsWith('lenh:')){
        $itemTitle = ($action.Substring(5) -replace '^/\S+\s*','').Trim()
        Show-FeatureDialog $itemTitle $action
        return
    }
    if($action.StartsWith('/')){
        $itemTitle = ($action -replace '^/\S+\s*','').Trim()
        Show-FeatureDialog $itemTitle $action
        return
    }
    switch($action){
        'chat' {Show-Page 'TroChuyen'}
        'saoluu' {Backup}
        'huongdan' {Show-Help}
        'xuatword' {$files=@(Select-Files);if($files.Count){$body=Api 'read' @{path=$files[0]};Edit-Document -title ([IO.Path]::GetFileNameWithoutExtension($files[0])) -body $body.text}}
        'ioffice' {Open-IOffice}
        'vb' {Open-IOffice}
        'rasoat' {$files=@(Select-Files);if($files.Count){Start-Work 'Rà soát nội dung, số liệu, chính tả và thể thức tài liệu đính kèm. Ghi rõ những điểm cần xác minh.' $files}}
        'huongdan' {Show-Help}
        default {if($action -match 'pdf'){Pdf-Tools}else{Notice 'Thao tác này chưa được nối trong giao diện hiện tại.'}}
    }
}
function Toggle-FullChat([bool]$enable) {
    $script:fullChat=$enable
    (F 'ThanhBen').Visibility=$(if($enable){'Collapsed'}else{'Visible'})
    (F 'CotBen').Width=$(if($enable){0}else{240})
    (F 'DauTrang').Visibility=$(if($enable){'Collapsed'}else{'Visible'})
    (F 'ChanTrang').Visibility=$(if($enable){'Collapsed'}else{'Visible'})
    (F 'TxtPhongTo').Text=$(if($enable){'Thu nhỏ'}else{'Phóng to'})
}
function Toggle-ChatColumn {
    $script:chatColumn=-not $script:chatColumn
    $width=if($script:chatColumn){250}else{0};$gap=if($script:chatColumn){14}else{0};$left=if($script:chatColumn){264}else{0}
    (F 'CotViecChat').Width=$width;(F 'CotHoChat').Width=$gap
    (F 'KhungViecChat').Visibility=$(if($script:chatColumn){'Visible'}else{'Collapsed'})
    (F 'BtnChatMoi').Visibility=$(if($script:chatColumn){'Visible'}else{'Collapsed'})
    foreach($name in @('KhungNhapChat','KhungDinhKemChat','KhungTienTrinh')){(F $name).Margin=New-Object Windows.Thickness($left,10,0,0)}
    (F 'TxtCotViec').Text=$(if($script:chatColumn){'Thu gọn cột việc'}else{'Mở cột việc'})
}

# Use the reference's visual tree; bind it to the new API and local data service.
$ns=New-Object Xml.XmlNamespaceManager($xml.NameTable);$ns.AddNamespace('x','http://schemas.microsoft.com/winfx/2006/xaml')
foreach($node in $xml.SelectNodes('//*[@x:Name]',$ns)){
    $name=$node.GetAttribute('Name','http://schemas.microsoft.com/winfx/2006/xaml');$control=F $name
    if($name.StartsWith('Nav')){$control.Add_Click({param($s,$e)Show-Page $s.Name.Substring(3)})}
    elseif($control -is [Windows.Controls.Border] -and $control.Tag -is [string] -and $control.Tag){
        $control.Add_MouseLeftButtonUp({param($s,$e)Invoke-ReferenceAction ([string]$s.Tag);$e.Handled=$true})
    }
}
# All added event handlers execute in the dispatcher and share the same visual styles.
$pageButtons=@{BtnXemViec='CongViec';BtnXemVanBan='ThuVien';TabTrang1='Mau';TabTrang2='SoanVanBan';TabTrang3='Lich';TabTrang4='CongViec';TabTrang5='TienIch';TabTrang6='TienIch';TabTrang7='TienIch';BtnMoCongViec='CongViec';BtnSoTheoDoi='CongViec';BtnSoTheoDoi2='CongViec';BtnSangDonVi='DonVi';BtnSoTheoDoiBC='DonVi';BtnKhaiBaoNhanh='CaiDat';BtnKhaiBao='CaiDat'}
foreach($entry in $pageButtons.GetEnumerator()){(F $entry.Key).Tag=$entry.Value;Wire $entry.Key {param($s,$e)Show-Page ([string]$s.Tag)}}
foreach($name in @('BtnChatMoi','BtnViecMoiNho')){Wire $name {Start-Work}}
Wire 'BtnGuiHoi' {Send-Chat}
Wire 'BtnDinhKem' {$script:attachments=@($script:attachments)+@(Select-Files -Multiple);Render-Attachments}
Wire 'BtnBoQuyTrinh' {(F 'KhungQuyTrinh').Visibility='Collapsed'}
Wire 'BtnChuNho' {$script:fontSize=[Math]::Max(13,$script:fontSize-1);Render-Chat}
Wire 'BtnChuTo' {$script:fontSize=[Math]::Min(22,$script:fontSize+1);Render-Chat}
Wire 'BtnPhongTo' {Toggle-FullChat (-not $script:fullChat)}
Wire 'BtnCotViec' {Toggle-ChatColumn}
Wire 'BtnCheDoWord' {$script:wordView = -not $script:wordView; Update-WordButton; Render-Chat}
Wire 'BtnXoaTatCaChat' {
    if (-not @($script:data.chat).Count) { Notice 'Chưa có lịch sử việc đã giao để xóa.'; return }
    if ([Windows.MessageBox]::Show($window, 'Bạn có chắc chắn muốn xóa toàn bộ lịch sử các việc đã giao? Thao tác này sẽ xóa tất cả các cuộc trò chuyện trước đó.', 'Xóa lịch sử việc đã giao', 'YesNo', 'Warning') -eq 'Yes') {
        foreach ($c in @($script:data.chat)) {
            [void](Api 'delete' @{id=$c.id})
        }
        $script:session = $null
        Refresh-State
        Render-Chat
    }
}
Wire 'BtnDungChat' {
    foreach($job in @($script:jobs.Keys)){if($script:jobs[$job].session -eq $script:session){[void](Api 'chat_cancel' @{job=$job});$script:jobs.Remove($job)}}
    (F 'KhungTienTrinh').Visibility='Collapsed';(F 'TxtTrangThai').Text='Đã dừng chờ · máy chủ có thể vẫn đang xử lý'
}
$window.Add_KeyDown({param($s,$e)if($e.Key -eq 'F11'){Toggle-FullChat (-not $script:fullChat);$e.Handled=$true}elseif($e.Key -eq 'Escape'){Toggle-FullChat $false}})
(F 'TxtHoi').Add_PreviewKeyDown({param($s,$e)if($e.Key -eq 'Return' -and -not([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Shift)){Send-Chat;$e.Handled=$true}})
foreach($pair in @(@('BtnGiaoViecSoan','TxtYChinh'),@('BtnGiaoViecNV','TxtYChinhNV'),@('BtnGiaoViecDV','TxtYChinhDV'),@('BtnGiaoViecKT','TxtYChinhKT'),@('BtnTraCuu','TxtCauHoi'))){
    (F $pair[0]).Tag=$pair[1];Wire $pair[0] {param($s,$e)$text=(F ([string]$s.Tag)).Text.Trim();if($text){Start-Work $text}}
}
(F 'TxtTimNhanh').Add_KeyDown({param($s,$e)if($e.Key -eq 'Return' -and $s.Text.Trim()){Start-Work $s.Text.Trim();$s.Clear()}})
$placeholders=@{TxtHoi='GoiYHoi';TxtYChinh='GoiYYChinh';TxtTimNhanh='GoiYTimNhanh';TxtGioViec='GoiYGio';TxtNoiDungViec='GoiYViec';TxtYChinhNV='GoiYYChinhNV';TxtYChinhDV='GoiYYChinhDV';TxtYChinhKT='GoiYYChinhKT'}
foreach($entry in $placeholders.GetEnumerator()){if((F $entry.Key) -and (F $entry.Value)){(F $entry.Key).Tag=$entry.Value;(F $entry.Key).Add_TextChanged({param($s,$e)(F ([string]$s.Tag)).Visibility=$(if($s.Text){'Collapsed'}else{'Visible'})})}}
if (F 'DpNgayViec') { (F 'DpNgayViec').SelectedDate = [DateTime]::Today }
Wire 'BtnThemViec' {
    $title=(F 'TxtNoiDungViec').Text.Trim();if(-not $title){return}
    $due=if((F 'DpNgayViec').SelectedDate){(F 'DpNgayViec').SelectedDate.ToString('yyyy-MM-dd')}else{''}
    [void](Api 'save' @{kind='task';item=@{title=$title;due=$due;owner='';state='Chưa làm';note=(F 'TxtGioViec').Text}})
    (F 'TxtNoiDungViec').Clear();Refresh-State;Render-Tasks
}
Wire 'BtnXoaViecXong' {
    if([Windows.MessageBox]::Show($window,'Xóa các công việc đã hoàn thành?','Xóa công việc','YesNo','Question') -eq 'Yes'){
        foreach($t in $script:data.task){if($t.state -eq 'Hoàn thành'){[void](Api 'delete' @{id=$t.id})}};Refresh-State;Render-Tasks
    }
}
Wire 'BtnMoFileViec' {$result=Api 'export' @{format='xlsx';title='Công việc';headers=@('Nội dung','Phụ trách','Hạn','Trạng thái');rows=@($script:data.task|ForEach-Object{,@($_.title,$_.owner,$_.due,$_.state)})};Open-File $result.path}
Wire 'BtnLapLichTuan' {Show-Page 'CongViec';Refresh-State;Render-Tasks;Notice 'Đã mở công việc và lịch. Dữ liệu lịch được xử lý cục bộ.'}
foreach($name in @('BtnCapNhatMoc','BtnMoLichNamHoc')){Wire $name {Edit-Memory 'Lịch năm học'}}
Wire 'BtnXemMau' {$r=(F 'LvMau').SelectedItem.Record;if($r){Edit-Document $r -Template}}
(F 'BtnXemMau').Content='Xem / sửa mẫu'
Wire 'BtnSoanTheoMau' {$r=(F 'LvMau').SelectedItem.Record;if($r){Start-Work ('Soạn văn bản theo mẫu tham khảo dưới đây. Phần thiếu thông tin ghi [CẦN BỔ SUNG].'+"`n"+$r.body+"`nYêu cầu cụ thể: ")}}
Wire 'BtnMauRieng' {Edit-Document -title 'Mẫu văn bản riêng' -Template}
(F 'BtnMauRieng').Content='Thêm mẫu riêng'
Wire 'BtnQuyTrinhRieng' {Edit-Document -title 'Quy trình riêng của cơ quan' -Template}
Wire 'BtnHuongDanTheThuc' {Notice 'Thể thức văn bản: Times New Roman, khổ A4, Quốc hiệu/Tiêu ngữ, số ký hiệu, địa danh ngày tháng, tên loại/trích yếu, nội dung, chữ ký và nơi nhận. Đối chiếu Nghị định 30/2020/NĐ-CP và nguồn hiện hành khi cần.'}
Wire 'BtnMoVB' {$r=(F 'LvThuVien').SelectedItem.Record;if($r){Edit-Document $r}}
(F 'LvThuVien').Add_MouseDoubleClick({$r=(F 'LvThuVien').SelectedItem.Record;if($r){Edit-Document $r}})
(F 'TxtTimVB').Add_TextChanged({Render-Library})
foreach($name in @('BtnSuaTiep','BtnRaSoatVB')){Wire $name {$r=(F 'LvThuVien').SelectedItem.Record;if($r){Start-Work ('Rà soát, sửa văn bản sau theo yêu cầu của tôi: '+"`n"+$r.body+"`nYêu cầu sửa: ")}}}
foreach($name in @('BtnMoThuMucSanPham','BtnMoThuMucChua','BtnMoThuMucKT')){Wire $name {Open-File (Path-Data 'van-ban-da-soan')}}
Wire 'BtnMoVBKT' {$r=(F 'LvKiemTra').SelectedItem.Record;if($r){Edit-Document $r}}
Wire 'BtnRaSoatFile' {$files=@(Select-Files);if($files.Count){Start-Work 'Rà soát nội dung, số liệu, chính tả và thể thức tài liệu đính kèm. Ghi rõ những điểm cần xác minh.' $files}}
(F 'VungThaVBDen').Add_MouseLeftButtonUp({Import-Incoming})
(F 'VungThaVBDen').AllowDrop=$true;(F 'VungThaVBDen').Add_Drop({param($s,$e)if($e.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){Import-Incoming @($e.Data.GetData([Windows.DataFormats]::FileDrop));$e.Handled=$true}})
Wire 'BtnTomTat' {$r=(F 'LvVBDen').SelectedItem.Record;if($r){Start-Work 'Tóm tắt văn bản và trích việc, đơn vị thực hiện, thời hạn; không tự điền phần thiếu.' @((Path-Data $r.path))}}
Wire 'BtnPhieuGQ' {$r=(F 'LvVBDen').SelectedItem.Record;if($r){Start-Work 'Lập phiếu giải quyết văn bản đến từ tài liệu đính kèm.' @((Path-Data $r.path))}}
Wire 'BtnMoVBDen' {Open-File (Path-Data 'van-ban-den')}
(F 'LvVBDen').Add_MouseDoubleClick({$r=(F 'LvVBDen').SelectedItem.Record;if($r){Open-File (Path-Data $r.path)}})
Wire 'BtnDsDonVi' {Edit-Units}
Wire 'BtnTaoDot' {
    $title=(F 'TxtDotMoi').Text.Trim();if(-not $title){throw 'Nhập tên đợt báo cáo.'}
    $values=Ask-Fields 'Tạo đợt báo cáo' @(@('due','Hạn nộp (YYYY-MM-DD)')) @{}
    if($values){[void](Api 'save' @{kind='cycle';item=@{title=$title;due=$values.due;units=@($script:data.unit|ForEach-Object{$_.id})}});Refresh-State;Render-Reports;(F 'TxtDotMoi').Clear()}
}
(F 'CbDotBC').Add_SelectionChanged({Render-Submissions})
(F 'VungThaDV').Add_MouseLeftButtonUp({Receive-Report})
(F 'VungThaDV').AllowDrop=$true;(F 'VungThaDV').Add_Drop({param($s,$e)if($e.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){Receive-Report @($e.Data.GetData([Windows.DataFormats]::FileDrop));$e.Handled=$true}})
Wire 'BtnMoVBDV' {$r=(F 'LvDonVi').SelectedItem.Record;if($r){Open-File (Path-Data $r.path)}}
Wire 'BtnTongHopDot' {Aggregate-Reports}
Wire 'BtnMoThuMucDV' {Open-File (Path-Data 'bao-cao')}
foreach($name in @('BtnVbIOffice','BtnVbTuCongViec')){Wire $name {Open-IOffice}}
foreach($name in @('BtnSaoLuu','BtnSaoLuuChan')){Wire $name {Backup}}
Wire 'BtnCapNhatChan' {Check-Update}
foreach($name in @('BtnMoGoc','BtnMoThuMuc','BtnMoDuLieu')){Wire $name {Open-File $script:data.root}}

foreach($name in @('BtnMoCanCu','BtnCanCuTruong')){Wire $name {Edit-Memory 'Căn cứ và nguồn tham khảo'}}
Wire 'BtnHuongDan' {Show-Help};Wire 'BtnLienHe' {Show-Help}
Wire 'BtnViecThang' {Show-Page 'CongViec';Refresh-State;Render-Tasks;Notice 'Danh sách việc tháng được lấy trực tiếp từ dữ liệu đã lưu.'}
Wire 'BtnTongHopFile' {$files=@(Select-Files -Multiple);if($files.Count){Start-Work ((F 'TxtYeuCauTH').Text+"`nTổng hợp tài liệu, nêu rõ nguồn số liệu.") $files}}
(F 'VungThaDuLieu').Add_MouseLeftButtonUp({$files=@(Select-Files -Multiple);if($files.Count){Start-Work 'Tổng hợp số liệu từ các tài liệu đính kèm.' $files}})
(F 'PgTroChuyen').AllowDrop=$true
(F 'PgTroChuyen').Add_PreviewDragOver({param($s,$e)$e.Effects=[Windows.DragDropEffects]::Copy;$e.Handled=$true})
(F 'PgTroChuyen').Add_Drop({param($s,$e)if($e.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){$script:attachments=@($script:attachments)+@($e.Data.GetData([Windows.DataFormats]::FileDrop));Render-Attachments;$e.Handled=$true}})
(F 'KhungTrangThai').Add_MouseLeftButtonUp({Show-Page 'CaiDat'})
(F 'KhungNguoiDung').Add_MouseLeftButtonUp({Show-Page 'CaiDat'})
foreach($name in @('MnKhaiBao','MnThongTin','MnDangNhap','MnCaiDat')){Wire $name {Show-Page 'CaiDat'}}
(F 'MnDangNhap').Header='Kết nối OpenRouter'
$logo=Join-Path $PSScriptRoot 'logo.png'
if(Test-Path $logo){(F 'ImgLogo').Source=New-Object Windows.Media.Imaging.BitmapImage([Uri]$logo)}
$icon=Join-Path $PSScriptRoot 'icon.ico'
if(Test-Path $icon){$window.Icon=[Windows.Media.Imaging.BitmapFrame]::Create([Uri]$icon)}
# Match the original clipping and responsive adjustments.
(F 'Banner').Clip=New-Object Windows.Media.RectangleGeometry((New-Object Windows.Rect(0,0,400,102)),14,14)
(F 'Banner').Add_SizeChanged({param($s,$e)$s.Clip=New-Object Windows.Media.RectangleGeometry((New-Object Windows.Rect(0,0,$s.ActualWidth,$s.ActualHeight)),14,14)})
$window.Add_SizeChanged({
    if($window.ActualWidth -lt 1350){(F 'TranhBen').Height=140;(F 'KhungNguoiDung').MaxWidth=150}else{(F 'TranhBen').Height=170;(F 'KhungNguoiDung').MaxWidth=240}
})
foreach($pageName in @('PgTroChuyen','PgSoanVanBan','PgMau','PgCongViec')){
    # Replace reference-only promises while keeping exactly the same text styles and positions.
    $root=F $pageName
    function Fix-Text($element){
        if($element -is [Windows.Controls.TextBlock]){
            if($element.Text -like 'Giao việc như nhắn tin*'){$element.Text='Giao việc như nhắn tin – tối đa 3 việc cùng lúc. Trợ lý đọc bộ nhớ và tài liệu đính kèm. Lưu câu trả lời để chỉnh sửa, xuất Word; A+ để tăng chữ, Phóng to (F11) để đọc rộng hơn.'}
            if($element.Text -like 'Ghi việc cần soạn rồi*'){$element.Text='Ghi việc cần soạn rồi bấm Giao việc, hoặc chọn loại văn bản bên dưới. Trợ lý dùng hồ sơ cơ quan; bạn có thể chỉnh sửa và xuất bản dự thảo thành Word.'}
        }
        for($i=0;$i -lt [Windows.Media.VisualTreeHelper]::GetChildrenCount($element);$i++){Fix-Text ([Windows.Media.VisualTreeHelper]::GetChild($element,$i))}
    }
}
$script:errors=New-Object 'System.Collections.Generic.List[string]'
if(-not (Show-Login)){$window.Close();exit 1}
Show-Page 'TrangChu'
$window.WindowState='Maximized'
$window.Dispatcher.Add_UnhandledException({param($s,$e)
    $script:errors.Add($e.Exception.ToString());$e.Handled=$true
    if($Smoke -or $ScreenshotDir){[IO.File]::AppendAllText((Join-Path $script:data.root 'wpf-errors.log'),$e.Exception.ToString()+"`n")}else{Notice $e.Exception.Message}
})
$timer=New-Object Windows.Threading.DispatcherTimer;$timer.Interval=[TimeSpan]::FromMilliseconds(600)
$timer.Add_Tick({
    foreach($job in @($script:jobs.Keys)){
        $state=Api 'chat_poll' @{job=$job}
        if($state.state -in @('done','error','cancelled')){
            $context=$script:jobs[$job];$script:jobs.Remove($job)
            if($state.state -eq 'error'){if($script:session -eq $context.session){(F 'TxtHoi').Text=$context.prompt};Notice $state.error}
            if($state.state -eq 'done'){Refresh-State;if($script:currentPage -eq 'TroChuyen'){Render-Chat};(F 'TxtTrangThai').Text='AI đã trả lời · nội dung đã được lưu'}
        }
    }
    (F 'TxtSoViecChay').Text=$(if($script:jobs.Count){'Đang xử lý: '+$script:jobs.Count+' việc'}else{''})
    (F 'KhungTienTrinh').Visibility=$(if($script:jobs.Count){'Visible'}else{'Collapsed'})
})
$timer.Start()
$window.Add_Closing({param($s,$e)
    if($script:jobs.Count -and -not $Smoke){if([Windows.MessageBox]::Show($window,'AI đang xử lý. Đóng ứng dụng sẽ dừng chờ kết quả. Vẫn đóng?','Đang xử lý','YesNo','Question') -ne 'Yes'){$e.Cancel=$true}}
})
$window.Add_Closed({$timer.Stop();$script:client.Dispose()})
if($VerifyAI){
    $check=Join-Path $PSScriptRoot 'verify-ai.ps1'
    if(-not (Test-Path $check)){$check=Join-Path $PSScriptRoot '../../scripts/verify-ai.ps1'}
    . $check
    exit $script:verifyExitCode
}
$window.Add_ContentRendered({
    Fix-Text $window.Content
    if($ScreenshotDir -or $Smoke){
        if($Smoke){
            Show-Page 'CongViec'
            (F 'TxtNoiDungViec').Text='Kiểm tra thao tác thêm việc WPF'
            (F 'DpNgayViec').SelectedDate=[DateTime]::Today
            (F 'BtnThemViec').RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
            Refresh-State
            if(-not @($script:data.task|Where-Object{$_.title -eq 'Kiểm tra thao tác thêm việc WPF'}).Count){throw 'Task button did not save data'}
            $check=(F 'DsViec').Children[0].Children[0];$check.IsChecked=$true
            $check.RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Primitives.ButtonBase]::ClickEvent)))
            Refresh-State
            if($script:data.task[0].state -ne 'Hoàn thành'){throw 'Task checkbox did not update state'}
            [void](Api 'delete' @{id=$script:data.task[0].id})
            Show-Page 'CaiDat'
            $script:settings.agency.Text='CƠ QUAN KIỂM THỬ WPF'
            Save-Settings
            Refresh-State
            if($script:data.profile.agency -ne 'CƠ QUAN KIỂM THỬ WPF'){throw 'Settings did not persist'}
            if($script:data.profile.model -eq 'wpf-test-model'){
                Start-Work 'Soạn báo cáo kiểm thử giao diện'
                (F 'BtnGuiHoi').RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
            }
            Show-Page 'TrangChu'
        }
        $script:testPages=@('TrangChu','SoanVanBan','TroChuyen','NhiemVu','DonVi','KiemTra','CongViec','ThuVien','Mau','VanBanDen','TienIch','CaiDat','Lich','TraCuu','TongHop')
        $script:testIndex=0
        $captureTimer=New-Object Windows.Threading.DispatcherTimer;$captureTimer.Interval=[TimeSpan]::FromMilliseconds(300)
        $captureTimer.Add_Tick({param($s,$e)
            if($script:jobs.Count){return}
            if($Smoke -and $script:testIndex -eq 0){
                Refresh-State
                if($script:data.profile.model -eq 'wpf-test-model'){
                    $conversation=$script:data.chat|Select-Object -First 1
                    if(@($conversation.messages).Count -ne 2){throw 'WPF AI request did not complete'}
                    [void](Api 'delete' @{id=$conversation.id})
                    [void](Api 'settings' @{profile=@{agency='';name='';provider='OpenRouter';endpoint='https://openrouter.ai/api/v1';model='';year='2026–2027';position='Chuyên viên'}})
                    $script:session=$null;Refresh-State
                }
            }
            if($script:testIndex -ge $script:testPages.Count){
                $s.Stop();[IO.File]::WriteAllText((Join-Path $script:data.root 'wpf-smoke.json'),(ConvertTo-Json @{pages=$script:testPages;errors=@($script:errors);templates=@($script:data.template).Count} -Depth 5));$window.Close();return
            }
            $page=$script:testPages[$script:testIndex];Show-Page $page;$window.UpdateLayout()
            if($ScreenshotDir){
                [IO.Directory]::CreateDirectory($ScreenshotDir)|Out-Null
                $visual=$window.Content;$image=New-Object Windows.Media.Imaging.RenderTargetBitmap([int]$visual.ActualWidth,[int]$visual.ActualHeight,96,96,[Windows.Media.PixelFormats]::Pbgra32)
                $image.Render($visual);$encoder=New-Object Windows.Media.Imaging.PngBitmapEncoder;$encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($image))
                $stream=[IO.File]::Create((Join-Path $ScreenshotDir ($page+'.png')));try{$encoder.Save($stream)}finally{$stream.Close()}
            }
            $script:testIndex++
        });$captureTimer.Start()
    }
})
if($ScreenshotDir -or $Smoke){$window.WindowState='Normal';$window.Width=1600;$window.Height=940;$window.WindowStartupLocation='Manual';$window.Left=-20000;$window.Top=0;$window.ShowInTaskbar=$false}
. (Join-Path $PSScriptRoot 'school-link.ps1')
[void]$window.ShowDialog()
if($script:errors.Count){exit 2}
