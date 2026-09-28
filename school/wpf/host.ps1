param([string]$ScreenshotDir, [switch]$Smoke,[switch]$VerifyAI)
$ErrorActionPreference = 'Continue'
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Windows.Forms

# Thiết lập Application User Model ID để Windows Taskbar hiển thị đúng icon ứng dụng giáo dục
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
    [Shell32Helper]::SetCurrentProcessExplicitAppUserModelID("TroLyGiaoDuc.QuanTriTruongHoc.Desktop") | Out-Null
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
$script:TrangHienTai = 'TrangChu'
$script:DangDatNav = $false
$script:wired = New-Object 'System.Collections.Generic.HashSet[string]'

$script:iconPath = Join-Path $PSScriptRoot 'icon.ico'
$script:appIcon = $null
if (Test-Path $script:iconPath) {
    try {
        $script:appIcon = [Windows.Media.Imaging.BitmapFrame]::Create([Uri]$script:iconPath)
    } catch {}
}

function Api([string]$action, $body = @{}) {
    try {
        $script:client.Headers['Content-Type'] = 'application/json; charset=utf-8'
        $json = ConvertTo-Json -InputObject $body -Depth 30 -Compress
        $reply = $script:client.UploadString(($env:TROLY_BRIDGE_URL + '/' + $action), $json) | ConvertFrom-Json
        if (-not $reply.ok) { throw $reply.error }
        return $reply.data
    } catch {
        Write-Warning "Api error on ${action}: $($_.Exception.Message)"
        throw
    }
}
function Refresh-State {
    try {
        $script:data = Api 'state'
    } catch {
        $script:data = @{ profile = @{}; task = @(); document = @(); template = @(); incoming = @(); chat = @() }
    }
    if (-not $script:data.task -and $script:data.tasks) { $rawTasks = $script:data.tasks } else { $rawTasks = @($script:data.task) }
    $normTasks = @()
    foreach ($t in $rawTasks) {
        $done = ($t.done -eq $true -or $t.state -eq 'Hoàn thành')
        $date = $(if ($t.date) { $t.date } elseif ($t.due) { $t.due } else { '' })
        $t | Add-Member -NotePropertyName 'done' -NotePropertyValue $done -Force
        $t | Add-Member -NotePropertyName 'state' -NotePropertyValue $(if ($done) { 'Hoàn thành' } else { 'Chưa hoàn thành' }) -Force
        $t | Add-Member -NotePropertyName 'date' -NotePropertyValue $date -Force
        $t | Add-Member -NotePropertyName 'due' -NotePropertyValue $date -Force
        $normTasks += $t
    }
    $script:data | Add-Member -NotePropertyName 'tasks' -NotePropertyValue $normTasks -Force
    $script:data | Add-Member -NotePropertyName 'task' -NotePropertyValue $normTasks -Force

    if (-not $script:data.document -and $script:data.documents) { $rawDocs = $script:data.documents } else { $rawDocs = @($script:data.document) }
    $script:data | Add-Member -NotePropertyName 'documents' -NotePropertyValue $rawDocs -Force
    $script:data | Add-Member -NotePropertyName 'document' -NotePropertyValue $rawDocs -Force

    if (-not $script:data.template -and $script:data.templates) { $rawTemps = $script:data.templates } else { $rawTemps = @($script:data.template) }
    $script:data | Add-Member -NotePropertyName 'templates' -NotePropertyValue $rawTemps -Force
    $script:data | Add-Member -NotePropertyName 'template' -NotePropertyValue $rawTemps -Force
}
Refresh-State

[xml]$xml = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'layout.xaml'), [System.Text.Encoding]::UTF8)
$window = [Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))
$window.Title = 'Trợ lý Quản trị trường học · Bản độc lập'
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
function Notice([string]$text) { if($Smoke){return}; [void][Windows.MessageBox]::Show($window,$text,'Trợ lý Quản trị trường học','OK','Information') }

function Text([string]$content, [double]$size, [string]$hex) {
    $b = New-Object Windows.Controls.TextBlock
    $b.Text = $content; $b.FontSize = $size; $b.Foreground = Brush $hex; $b.TextWrapping = 'Wrap'
    return $b
}

function Button([string]$content, [string]$action, $arg = $null, [string]$style = 'Nut') {
    $b = New-Object Windows.Controls.Button
    $b.Content = $content; $b.Style = $window.FindResource($style)
    $act = {
        try {
            switch ($action) {
                'page' { Show-Page $arg }
                'start' { Start-Work $arg }
                'mission' { Start-Mission $arg }
                'export_word' {
                    $p = Save-Path 'van-ban.docx' 'Word Document (*.docx)|*.docx'
                    if ($p) {
                        $item = Api 'export' @{format='docx'; path=$p; title=$arg.title; body=$arg.body}
                        Notice ("Đã xuất tài liệu Word thành công: " + $p)
                    }
                }
            }
        } catch {
            Notice ("Thao tác không hoàn tất: " + $_.Exception.Message)
        }
    }.GetNewClosure()
    $b.Add_Click($act)
    return $b
}

function Wire([string]$name, [scriptblock]$handler) {
    if (-not $name -or $script:wired.Contains($name)) { return }
    $ctrl = F $name
    if ($ctrl) {
        if(-not $script:clickHandlers){$script:clickHandlers=@{}}
        $script:clickHandlers[$name]=$handler
        $act = {
            param($sender,$eventArgs)
            try {
                $callback=$script:clickHandlers[$sender.Name]
                & $callback $sender $eventArgs
            } catch {
                Notice ("Lỗi khi thực hiện: " + $_.Exception.Message)
            }
        }
        $ctrl.Add_Click($act)
        [void]$script:wired.Add($name)
    }
}

function Path-Data([string]$svg) {
    [Windows.Media.Geometry]::Parse($svg)
}

function Open-File([string]$path) {
    if (Test-Path $path) { [Diagnostics.Process]::Start((New-Object Diagnostics.ProcessStartInfo $path -Property @{UseShellExecute=$true})) }
}

function Select-Files([string]$filter = 'All Files (*.*)|*.*') {
    $d = New-Object Windows.Forms.OpenFileDialog
    $d.Filter = $filter; $d.Multiselect = $true
    if ($d.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) { return $d.FileNames }
    return @()
}

function Save-Path([string]$file, [string]$filter = 'Word Document (*.docx)|*.docx') {
    $d = New-Object Windows.Forms.SaveFileDialog
    $d.FileName = $file; $d.Filter = $filter
    if ($d.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) { return $d.FileName }
    return $null
}

# ==================== ĐIỀU HƯỚNG VÀ ROUTING 16 TRANG ====================
$script:Trang = @('TrangChu', 'NhiemVu', 'SoanVanBan', 'Mau', 'ToChuyenMon', 'BanGiamHieu', 'CongTacDang', 'TroChuyen', 'CongViec', 'Lich', 'TongHop', 'TraCuu', 'ThuVien', 'TienIch', 'VanBanDen', 'CaiDat')
$script:NAV_CHA = @{ Mau = 'SoanVanBan'; Lich = 'CongViec'; TongHop = 'TienIch'; TraCuu = 'TienIch'; VanBanDen = 'TienIch'; ToChuyenMon = 'TienIch' }

function Show-Page([string]$ten) {
    try {
        $script:currentPage = $ten
        $script:TrangHienTai = $ten
        foreach ($t in $script:Trang) {
            $pg = F "Pg$t"
            if ($pg) { $pg.Visibility = $(if ($t -eq $ten) { 'Visible' } else { 'Collapsed' }) }
        }
        $script:DangDatNav = $true
        $navCha = $(if ($script:NAV_CHA[$ten]) { $script:NAV_CHA[$ten] } else { $ten })
        $nav = F ("Nav" + $navCha)
        if ($nav) { $nav.IsChecked = $true }
        $script:DangDatNav = $false

        Update-Header
        Lam-Moi $ten
    } catch {
        Notice ("Lỗi khi chuyển trang $ten : " + $_.Exception.Message)
    }
}

function Update-Header {
    try {
        $prof = $script:data.profile
        $userTxt = F 'TxtTenNguoiDung'
        if ($userTxt) { $userTxt.Text = $(if ($prof.name) { $prof.name } else { 'Thầy/cô Hiệu trưởng' }) }
        $posTxt = F 'TxtChucVu'
        if ($posTxt) { $posTxt.Text = $(if ($prof.position) { $prof.position } else { 'Ban giám hiệu' }) }
        $abbrTxt = F 'TxtVietTat'
        if ($abbrTxt) {
            $abbrTxt.Text = $(if ($prof.name) {
                $parts = $prof.name.Split(' ')
                if ($parts.Length -gt 1) { ($parts[0].Substring(0,1) + $parts[-1].Substring(0,1)).ToUpper() } else { $parts[0].Substring(0,2).ToUpper() }
            } else { 'HT' })
        }
    } catch {}
}

# ==================== RENDER TỪNG TRANG (LAM-MOI) ====================
function Lam-Moi([string]$ten) {
    Refresh-State
    $nay = Get-Date
    switch ($ten) {
        'TrangChu' { Render-Home }
        'NhiemVu' { Render-Missions }
        'BanGiamHieu' { Render-BGH }
        'ToChuyenMon' { Render-ToChuyenMon }
        'TroChuyen' { Render-Chat }
        'SoanVanBan' { Render-SoanVanBan }
        'Mau' { Render-Templates }
        'CongViec' { Render-Tasks }
        'Lich' { Render-Calendar }
        'TongHop' { Render-Aggregation }
        'TraCuu' { Render-Search }
        'ThuVien' { Render-Library }
        'CongTacDang' { Render-CongTacDang }
        'VanBanDen' { Render-Incoming }
        'TienIch' { Render-TienIch }
        'CaiDat' { Render-Settings }
    }
}

# 1. TRANG CHỦ
function Render-Home {
    $nay = Get-Date
    $buoi = 'buổi sáng'
    if ($nay.Hour -ge 11 -and $nay.Hour -lt 13) { $buoi = 'buổi trưa' }
    elseif ($nay.Hour -ge 13 -and $nay.Hour -lt 18) { $buoi = 'buổi chiều' }
    elseif ($nay.Hour -ge 18) { $buoi = 'buổi tối' }

    $prof = $script:data.profile
    $ai = $(if ($prof.name) { $prof.name } else { 'thầy/cô' })
    $txtChao = F 'TxtChao'
    if ($txtChao) { $txtChao.Text = "Chào $buoi, $ai!" }

    $thu = @('Chủ nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy')[[int]$nay.DayOfWeek]
    $txtNgay = F 'TxtNgay'
    if ($txtNgay) { $txtNgay.Text = "$thu, $($nay.Day) tháng $($nay.Month) năm $($nay.Year)" }

    $txtNamHoc = F 'TxtNamHoc'
    if ($txtNamHoc) {
        $y = $nay.Year; if ($nay.Month -lt 8) { $y-- }
        $txtNamHoc.Text = "Năm học $y – $($y + 1)"
    }

    # Công việc hôm nay
    $p = F 'DsViecHomNay'
    if ($p) {
        $p.Children.Clear()
        $tasks = @($script:data.tasks | Where-Object { -not $_.done } | Select-Object -First 5)
        foreach ($t in $tasks) {
            $sp = New-Object Windows.Controls.StackPanel
            $sp.Orientation = 'Horizontal'; $sp.Margin = '0,4,0,4'
            $dot = New-Object Windows.Controls.Border
            $dot.Width = 8; $dot.Height = 8; $dot.CornerRadius = 4; $dot.Background = Brush '#2F6FE0'; $dot.Margin = '0,6,10,0'; $dot.VerticalAlignment = 'Top'
            $tBlock = Text ($t.title + $(if ($t.date) { " (" + $t.date + ")" } else { "" })) 13.5 '#1F3354'
            [void]$sp.Children.Add($dot)
            [void]$sp.Children.Add($tBlock)
            [void]$p.Children.Add($sp)
        }
        if ($tasks.Count -eq 0) {
            [void]$p.Children.Add((Text 'Hôm nay chưa có việc gấp cần xử lý. Bấm "Xem việc" để thêm công việc mới.' 13 '#8A98AB'))
        }
    }

    # Văn bản gần đây
    $pGanDay = F 'DsGanDay'
    if ($pGanDay) {
        $pGanDay.Children.Clear()
        $docs = @($script:data.documents | Select-Object -First 5)
        foreach ($d in $docs) {
            $b = New-Object Windows.Controls.Border
            $b.Background = Brush '#F8FAFC'; $b.BorderBrush = Brush '#E2E8F0'; $b.BorderThickness = 1; $b.CornerRadius = 8; $b.Padding = '12,8'; $b.Margin = '0,0,0,6'; $b.Cursor = 'Hand'
            $g = New-Object Windows.Controls.Grid
            $c1 = New-Object Windows.Controls.ColumnDefinition; $c1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
            $c2 = New-Object Windows.Controls.ColumnDefinition; $c2.Width = [Windows.GridLength]::Auto
            [void]$g.ColumnDefinitions.Add($c1); [void]$g.ColumnDefinitions.Add($c2)
            $titleTxt = Text $d.title 13.5 '#0B2B6B'; $titleTxt.FontWeight = 'SemiBold'
            $btnWord = Button 'Xuất Word' 'export_word' $d 'Lien'
            [Windows.Controls.Grid]::SetColumn($titleTxt, 0)
            [Windows.Controls.Grid]::SetColumn($btnWord, 1)
            [void]$g.Children.Add($titleTxt); [void]$g.Children.Add($btnWord)
            $b.Child = $g
            [void]$pGanDay.Children.Add($b)
        }
        if ($docs.Count -eq 0) {
            [void]$pGanDay.Children.Add((Text 'Chưa có văn bản nào được lưu trữ. Chọn "Soạn văn bản" để bắt đầu.' 13 '#8A98AB'))
        }
    }
}

# 2. NHIỆM VỤ QUẢN TRỊ TRƯỜNG HỌC
function Render-Missions {
    try {
        $missions = Api 'missions'
        foreach ($m in $missions) {
            $tagId = $m.id.Replace('-', '_')
            $cardName = "NvO_$tagId"
            $border = F $cardName
            if ($border) {
                $border.Tag = $m
                $border.Cursor = 'Hand'
                $border.Add_MouseLeftButtonUp({
                    param($s, $e)
                    $missionData = $s.Tag
                    Start-Mission $missionData
                })
            }
        }
    } catch {}
}

function Start-Mission($m) {
    $prompt = $(if ($m.prompt) { $m.prompt } else { "Soạn dự thảo và tư vấn thực hiện nhiệm vụ: $($m.title)" })
    Start-Work $prompt
}

# 3. BAN GIÁM HIỆU
function Render-BGH {
    $hn = Get-Date
    $lbl = F 'TieuDeViecThang'
    if ($lbl) { $lbl.Text = "Việc tháng $($hn.Month) của Ban giám hiệu" }
    $txtViec = F 'TxtViecThang'
    if ($txtViec) {
        $tasks = @($script:data.tasks | Where-Object { -not $_.done })
        if ($tasks.Count -gt 0) {
            $lines = @($tasks | Select-Object -First 10 | ForEach-Object { "• $($_.date) - $($_.title)" })
            $txtViec.Text = $lines -join "`n"
        } else {
            $txtViec.Text = "Chưa có danh sách việc trong tháng. Bấm ""Lập việc tháng này"" để trợ lý tự động phân tích lịch năm học và gợi ý các đầu việc trọng tâm cho Hiệu trưởng và Phó Hiệu trưởng."
        }
    }
}

# 4. TỔ CHUYÊN MÔN
function Render-ToChuyenMon {
    $txtDsTo = F 'TxtDsTo'
    if ($txtDsTo) {
        $txtDsTo.Text = "Hệ thống các tổ chuyên môn: Tổ 1, Tổ 2, Tổ 3, Tổ 4, Tổ 5, Tổ Văn phòng - Ngoại ngữ.`nQuản lý nộp kế hoạch bài dạy, kế hoạch giáo dục tổ chuyên môn và biên bản sinh hoạt chuyên đề."
    }
}

# 5. SOẠN VĂN BẢN
function Render-SoanVanBan {}

# 6. MẪU VĂN BẢN (THEO NĐ 30 VÀ ĐẢNG)
function Render-Templates {
    $lv = F 'LvMau'
    if ($lv) {
        try {
            $templates = Api 'templates'
            $items = @()
            foreach ($t in $templates) {
                $laDang = $t.title -like 'dang-*'
                $nguon = $(if ($laDang) { 'Văn bản của Đảng' } else { 'Nghị định 30/2020' })
                $items += [pscustomobject]@{
                    Ten = $t.title
                    Nguon = $nguon
                    CanCu = $(if ($laDang) { 'HD 05-HD/VPTW' } else { 'Nghị định 30/2020/NĐ-CP' })
                    Template = $t
                }
            }
            $lv.ItemsSource = $items
        } catch {}
    }
}

# 7. CÔNG VIỆC
function Render-Tasks {
    $p = F 'DsViec'
    if ($p) {
        $p.Children.Clear()
        $tasks = @($script:data.tasks | Sort-Object done, date)
        foreach ($t in $tasks) {
            $b = New-Object Windows.Controls.Border
            $b.Background = $(if ($t.done) { Brush '#F1F5F9' } else { Brush 'White' })
            $b.BorderBrush = Brush '#E2E8F0'; $b.BorderThickness = 1; $b.CornerRadius = 8; $b.Padding = '12,8'; $b.Margin = '0,0,0,6'
            $g = New-Object Windows.Controls.Grid
            $c1 = New-Object Windows.Controls.ColumnDefinition; $c1.Width = [Windows.GridLength]::Auto
            $c2 = New-Object Windows.Controls.ColumnDefinition; $c2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
            $c3 = New-Object Windows.Controls.ColumnDefinition; $c3.Width = [Windows.GridLength]::Auto
            [void]$g.ColumnDefinitions.Add($c1); [void]$g.ColumnDefinitions.Add($c2); [void]$g.ColumnDefinitions.Add($c3)

            $chk = New-Object Windows.Controls.CheckBox
            $chk.IsChecked = [bool]$t.done; $chk.Margin = '0,2,10,0'; $chk.VerticalAlignment = 'Center'
            $chk.Tag = $t
            $chk.Add_Click({
                param($s, $e)
                $item = $s.Tag; $item.done = [bool]$s.IsChecked
                [void](Api 'save' @{kind='task'; item=$item})
                Render-Tasks
            })

            $sp = New-Object Windows.Controls.StackPanel
            $tColor = $(if ($t.done) { '#94A3B8' } else { '#1E293B' })
            $tTxt = Text $t.title 14 $tColor
            [void]$sp.Children.Add($tTxt)
            if ($t.date) {
                $dTxt = Text ("Hạn: " + $t.date) 12 '#64748B'
                [void]$sp.Children.Add($dTxt)
            }

            $btnDel = Button 'Xóa' 'del_task' $t 'Lien'
            $btnDel.Tag = $t
            $btnDel.Add_Click({
                param($s, $e)
                [void](Api 'delete' @{key=$s.Tag.id})
                Render-Tasks
            })

            [Windows.Controls.Grid]::SetColumn($chk, 0)
            [Windows.Controls.Grid]::SetColumn($sp, 1)
            [Windows.Controls.Grid]::SetColumn($btnDel, 2)
            [void]$g.Children.Add($chk); [void]$g.Children.Add($sp); [void]$g.Children.Add($btnDel)
            $b.Child = $g
            [void]$p.Children.Add($b)
        }
        if ($tasks.Count -eq 0) {
            [void]$p.Children.Add((Text 'Chưa có công việc nào. Nhập nội dung ở trên rồi bấm "Thêm việc".' 13 '#8A98AB'))
        }
    }
}

# 8. LỊCH CÔNG TÁC
function Render-Calendar {
    $lv = F 'LvLich'
    if ($lv) {
        $docs = @($script:data.documents | Where-Object { $_.title -like '*lich*' -or $_.title -like '*kế hoạch*' })
        $lv.ItemsSource = $docs
    }
    $pMoc = F 'DsMoc'
    if ($pMoc) {
        $pMoc.Children.Clear()
        $mocs = @(
            @{ Moc = 'Khai giảng năm học mới'; Ngay = '05/09' },
            @{ Moc = 'Thi giữa học kỳ 1'; Ngay = 'Tuần 9 (Tháng 11)' },
            @{ Moc = 'Sơ kết học kỳ 1'; Ngay = 'Tuần 18 (Tháng 01)' },
            @{ Moc = 'Thi giữa học kỳ 2'; Ngay = 'Tuần 27 (Tháng 03)' },
            @{ Moc = 'Xét hoàn thành chương trình / Lễ bế giảng'; Ngay = 'Trước 31/05' }
        )
        foreach ($m in $mocs) {
            $g = New-Object Windows.Controls.Grid; $g.Margin = '0,4,0,4'
            $c1 = New-Object Windows.Controls.ColumnDefinition; $c1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
            $c2 = New-Object Windows.Controls.ColumnDefinition; $c2.Width = [Windows.GridLength]::Auto
            [void]$g.ColumnDefinitions.Add($c1); [void]$g.ColumnDefinitions.Add($c2)
            $t1 = Text $m.Moc 13.5 '#1E293B'
            $t2 = Text $m.Ngay 13.5 '#2F6FE0'; $t2.FontWeight = 'SemiBold'
            [Windows.Controls.Grid]::SetColumn($t1, 0); [Windows.Controls.Grid]::SetColumn($t2, 1)
            [void]$g.Children.Add($t1); [void]$g.Children.Add($t2)
            [void]$pMoc.Children.Add($g)
        }
    }
}

# 9. TỔNG HỢP DỮ LIỆU
function Render-Aggregation {
    $lv = F 'LvDuLieu'
    if ($lv) {
        $docs = @($script:data.documents | Where-Object { $_.title -like '*số liệu*' -or $_.title -like '*tổng hợp*' -or $_.title -like '*báo cáo*' })
        $lv.ItemsSource = $docs
    }
}

# 10. TRA CỨU CĂN CỨ PHÁP LÝ
function Render-Search {
    $lv = F 'LvCanCu'
    if ($lv) {
        $items = @(
            [pscustomobject]@{ VanBan = 'Nghị định 30/2020/NĐ-CP'; Ngay = '05/03/2020'; NoiDung = 'Quy định về công tác văn thư, thể thức trình bày văn bản hành chính'; TinhTrang = 'Đang có hiệu lực' },
            [pscustomobject]@{ VanBan = 'Thông tư 28/2020/TT-BGDĐT'; Ngay = '04/09/2020'; NoiDung = 'Điều lệ trường Tiểu học'; TinhTrang = 'Đang có hiệu lực' },
            [pscustomobject]@{ VanBan = 'Thông tư 32/2020/TT-BGDĐT'; Ngay = '15/09/2020'; NoiDung = 'Điều lệ trường THCS, THPT và trường phổ thông có nhiều cấp học'; TinhTrang = 'Đang có hiệu lực' },
            [pscustomobject]@{ VanBan = 'Thông tư 52/2020/TT-BGDĐT'; Ngay = '31/12/2020'; NoiDung = 'Điều lệ trường Mầm non'; TinhTrang = 'Đang có hiệu lực' },
            [pscustomobject]@{ VanBan = 'Quy định 24-QĐ/TW'; Ngay = '30/07/2021'; NoiDung = 'Thi hành Điều lệ Đảng'; TinhTrang = 'Đang có hiệu lực' },
            [pscustomobject]@{ VanBan = 'Hướng dẫn 05-HD/VPTW'; Ngay = '23/11/2020'; NoiDung = 'Thể thức văn bản của Đảng'; TinhTrang = 'Đang có hiệu lực' }
        )
        $lv.ItemsSource = $items
    }
}

# 11. THƯ VIỆN VĂN BẢN
function Render-Library {
    $lv = F 'LvThuVien'
    if ($lv) {
        $docs = $script:data.documents
        $filterTxt = F 'TxtTimVB'
        if ($filterTxt -and $filterTxt.Text) {
            $kw = $filterTxt.Text.ToLower()
            $docs = @($docs | Where-Object { $_.title.ToLower().Contains($kw) })
        }
        $lv.ItemsSource = $docs
    }
}

# 12. CÔNG TÁC ĐẢNG
function Render-CongTacDang {
    $txt = F 'TxtToChucDang'
    if ($txt) {
        $prof = $script:data.profile
        $chiBo = $(if ($prof.party_org) { $prof.party_org } else { 'Chi bộ Trường học' })
        $txt.Text = "Tổ chức Đảng: $chiBo`nBí thư chi bộ: $($prof.principal)`nSinh hoạt chi bộ định kỳ: Ngày 03 hàng tháng.`nQuản lý nghị quyết chi bộ, hồ sơ phát triển đảng viên và kiểm tra giám sát."
    }
    $lv = F 'LvDang'
    if ($lv) {
        $lv.ItemsSource = @($script:data.documents | Where-Object { $_.title -like '*đảng*' -or $_.title -like '*chi bộ*' })
    }
}

# 13. VĂN BẢN ĐẾN
function Render-Incoming {
    $lv = F 'LvVBDen'
    if ($lv) {
        $incoming = @($script:data.documents | Where-Object { $_.title -like '*đến*' -or $_.title -like '*công văn*' })
        $lv.ItemsSource = $incoming
    }
}

# 14. CÔNG CỤ TIỆN ÍCH
function Render-TienIch {}

# 15. CÀI ĐẶT HỆ THỐNG
(F 'BtnSaveOpenRouterKey').Add_Click({
    try {
        $key=(F 'PwOpenRouterKey').Password.Trim()
        if(-not $key){Notice 'Nhập API key OpenRouter trước khi lưu. Khóa đã lưu vẫn được giữ nguyên.';return}
        [void](Api 'settings' @{profile=@{provider='OpenRouter'};key=$key})
        (F 'PwOpenRouterKey').Clear()
        Refresh-State;Render-Settings
        Notice 'Đã lưu API key OpenRouter.'
    } catch {Notice ('Không thể lưu API key: '+$_.Exception.Message)}
})
function Render-Settings {
    (F 'TxtOpenRouterKeyState').Text=$(if($script:data.has_key){'Đã lưu API key. Để trống để giữ khóa hiện tại.'}else{'Chưa có API key. Nhập khóa của bạn rồi bấm Lưu.'})
    try {
        $prof = $script:data.profile
        $parentName = $(if ($prof.parent) { $prof.parent } else { "Trường học" })
        $levelName = $(if ($prof.school_level) { $prof.school_level } else { "Tiểu học / THCS" })
        $princName = $(if ($prof.principal) { $prof.principal } else { $(if ($prof.name) { $prof.name } else { "(chưa cập nhật)" }) })
        $vpName = $(if ($prof.vice_principals) { $prof.vice_principals } else { "(chưa khai báo)" })
        $partyName = $(if ($prof.party_org) { $prof.party_org } else { "(chưa khai báo)" })
        $iofficeName = $(if ($prof.ioffice) { $prof.ioffice } else { "(chưa cấu hình)" })

        $dong = @(
            "Tên trường: $parentName",
            "Cấp học: $levelName",
            "Hiệu trưởng: $princName",
            "Phó Hiệu trưởng: $vpName",
            "Chi bộ / Đảng ủy: $partyName",
            "Địa chỉ iOffice: $iofficeName"
        )
        $txtThongTin = F 'TxtThongTinTruong'
        if ($txtThongTin) { $txtThongTin.Text = $dong -join "`n" }

        $txtIntro = F 'TxtGioiThieu'
        if ($txtIntro) {
            $txtIntro.Text = "Trợ lý Quản trị trường học · Phiên bản Độc lập`nKết nối máy chủ hệ thống giáo dục dùng chung`nSoạn thảo và thẩm định thể thức theo Nghị định 30/2020/NĐ-CP và Hướng dẫn 05-HD/VPTW của Ban Chấp hành Trung ương Đảng."
        }
    } catch {
        Write-Warning "Error in Render-Settings: $($_.Exception.Message)"
    }
}

# ==================== TRÒ CHUYỆN AI & XEM DẠNG WORD ====================
function Update-WordButton {
    $btn = F 'BtnCheDoWord'
    $txt = F 'TxtCheDoWord'
    if ($btn -and $txt) {
        if ($script:wordView) {
            $txt.Text = "Xem dạng Chat"
            $btn.ToolTip = "Chuyển về khung chat tin nhắn thông thường"
        } else {
            $txt.Text = "Xem dạng Word"
            $btn.ToolTip = "Mô phỏng văn bản trên khổ giấy A4 theo thể thức Nghị định 30/2020"
        }
    }
}

function Create-WordPage([string]$bodyContent, [string]$docTitle = "DỰ THẢO VĂN BẢN") {
    $page = New-Object Windows.Controls.StackPanel
    $page.Background = Brush 'White'
    $page.Margin = '0,0,0,24'
    $page.Padding = '50,42,40,42'
    $page.Width = 794
    $page.MinHeight = 1123

    # Header thể thức văn bản hành chính theo NĐ 30/2020
    $headerGrid = New-Object Windows.Controls.Grid
    $c1 = New-Object Windows.Controls.ColumnDefinition; $c1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    $c2 = New-Object Windows.Controls.ColumnDefinition; $c2.Width = New-Object Windows.GridLength(1.3, [Windows.GridUnitType]::Star)
    [void]$headerGrid.ColumnDefinitions.Add($c1); [void]$headerGrid.ColumnDefinitions.Add($c2)

    $leftHeader = New-Object Windows.Controls.StackPanel
    $cqName = $(if ($script:data.profile.parent) { $script:data.profile.parent.ToUpper() } else { "ỦY BAN NHÂN DÂN" })
    $t1 = Text $cqName 12.5 '#1F2937'; $t1.FontFamily = 'Times New Roman'; $t1.TextAlignment = 'Center'
    $schoolName = $(if ($script:data.profile.name) { $script:data.profile.name.ToUpper() } else { "TRƯỜNG TIỂU HỌC QUẢNG CHÂU 1" })
    $t2 = Text $schoolName 12.5 '#111827'; $t2.FontFamily = 'Times New Roman'; $t2.FontWeight = 'Bold'; $t2.TextAlignment = 'Center'
    $t3 = Text "Số: ... /QĐ-THQC1" 12 '#374151'; $t3.FontFamily = 'Times New Roman'; $t3.FontStyle = 'Italic'; $t3.TextAlignment = 'Center'; $t3.Margin = '0,4,0,0'
    [void]$leftHeader.Children.Add($t1); [void]$leftHeader.Children.Add($t2); [void]$leftHeader.Children.Add($t3)

    $rightHeader = New-Object Windows.Controls.StackPanel
    $q1 = Text "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM" 12.5 '#111827'; $q1.FontFamily = 'Times New Roman'; $q1.FontWeight = 'Bold'; $q1.TextAlignment = 'Center'
    $q2 = Text "Độc lập - Tự do - Hạnh phúc" 13 '#111827'; $q2.FontFamily = 'Times New Roman'; $q2.FontWeight = 'Bold'; $q2.TextAlignment = 'Center'
    $qLine = New-Object Windows.Shapes.Line; $qLine.X1 = 0; $qLine.X2 = 140; $qLine.Stroke = Brush '#111827'; $qLine.StrokeThickness = 1; $qLine.HorizontalAlignment = 'Center'; $qLine.Margin = '0,2,0,4'
    $nay = Get-Date
    $q3 = Text "..., ngày $($nay.Day) tháng $($nay.Month) năm $($nay.Year)" 12.5 '#374151'; $q3.FontFamily = 'Times New Roman'; $q3.FontStyle = 'Italic'; $q3.TextAlignment = 'Center'
    [void]$rightHeader.Children.Add($q1); [void]$rightHeader.Children.Add($q2); [void]$rightHeader.Children.Add($qLine); [void]$rightHeader.Children.Add($q3)

    [Windows.Controls.Grid]::SetColumn($leftHeader, 0)
    [Windows.Controls.Grid]::SetColumn($rightHeader, 1)
    [void]$headerGrid.Children.Add($leftHeader); [void]$headerGrid.Children.Add($rightHeader)
    [void]$page.Children.Add($headerGrid)

    $sep = New-Object Windows.Shapes.Line
    $sep.X1 = 0; $sep.X2 = 180; $sep.Stroke = Brush '#9CA3AF'; $sep.StrokeThickness = 0.8; $sep.HorizontalAlignment = 'Center'; $sep.Margin = '0,14,0,16'
    [void]$page.Children.Add($sep)

    # Thân văn bản
    $rawLines = $bodyContent.Split("`n")
    foreach ($line in $rawLines) {
        $trim = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trim)) {
            $space = New-Object Windows.Controls.Border; $space.Height = 6
            [void]$page.Children.Add($space)
            continue
        }
        if ($trim -eq '---' -or $trim -eq '***') { continue }
        $cleanHeader = ($trim -replace '^\*\*|\*\*$', '') -replace '^\#+\s*', ''

        if ($cleanHeader -match '^(QUYẾT ĐỊNH|KẾ HOẠCH|TỜ TRÌNH|BÁO CÁO|THÔNG BÁO|CÔNG VĂN|NGHỊ QUYẾT|BIÊN BẢN)(:)?$') {
            $h = Text $cleanHeader 15.5 '#111827'
            $h.FontFamily = 'Times New Roman'; $h.FontWeight = 'Bold'; $h.TextAlignment = 'Center'; $h.Margin = '0,14,0,6'
            [void]$page.Children.Add($h)
            continue
        }
        if ($cleanHeader -match '^(Về việc|V/v)\s+') {
            $sub = Text $cleanHeader 13 '#1F2937'
            $sub.FontFamily = 'Times New Roman'; $sub.FontWeight = 'Bold'; $sub.FontStyle = 'Italic'; $sub.TextAlignment = 'Center'; $sub.Margin = '0,0,0,12'
            [void]$page.Children.Add($sub)
            continue
        }
        if ($trim -match '^(Căn cứ|Xét đề nghị)') {
            $cc = Text ($trim -replace '^\*\*|\*\*$', '') 13.5 '#111827'
            $cc.FontFamily = 'Times New Roman'; $cc.FontStyle = 'Italic'; $cc.Margin = '24,2,0,3'; $cc.TextAlignment = 'Justify'
            [void]$page.Children.Add($cc)
            continue
        }
        $pClean = $trim -replace '\*\*', ''
        $p = Text $pClean 13.5 '#111827'
        $p.FontFamily = 'Times New Roman'; $p.TextAlignment = 'Justify'; $p.Margin = '24,2,0,3'
        [void]$page.Children.Add($p)
    }

    # Nơi nhận & Người ký
    $footerGrid = New-Object Windows.Controls.Grid; $footerGrid.Margin = '0,20,0,0'
    $fc1 = New-Object Windows.Controls.ColumnDefinition; $fc1.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    $fc2 = New-Object Windows.Controls.ColumnDefinition; $fc2.Width = New-Object Windows.GridLength(1, [Windows.GridUnitType]::Star)
    [void]$footerGrid.ColumnDefinitions.Add($fc1); [void]$footerGrid.ColumnDefinitions.Add($fc2)

    $nnStack = New-Object Windows.Controls.StackPanel
    $nnTitle = Text "Nơi nhận:" 12 '#111827'; $nnTitle.FontFamily = 'Times New Roman'; $nnTitle.FontWeight = 'Bold'; $nnTitle.FontStyle = 'Italic'
    $nn1 = Text "- Như Điều 3;" 11.5 '#374151'; $nn1.FontFamily = 'Times New Roman'
    $nn2 = Text "- Phòng GD&ĐT (để b/c);" 11.5 '#374151'; $nn2.FontFamily = 'Times New Roman'
    $nn3 = Text "- Lưu: VT." 11.5 '#374151'; $nn3.FontFamily = 'Times New Roman'
    [void]$nnStack.Children.Add($nnTitle); [void]$nnStack.Children.Add($nn1); [void]$nnStack.Children.Add($nn2); [void]$nnStack.Children.Add($nn3)

    $kyStack = New-Object Windows.Controls.StackPanel
    $kyChucVu = Text "HIỆU TRƯỞNG" 13.5 '#111827'; $kyChucVu.FontFamily = 'Times New Roman'; $kyChucVu.FontWeight = 'Bold'; $kyChucVu.TextAlignment = 'Center'
    $kyTen = Text ($script:data.profile.principal) 13.5 '#111827'; $kyTen.FontFamily = 'Times New Roman'; $kyTen.FontWeight = 'Bold'; $kyTen.TextAlignment = 'Center'; $kyTen.Margin = '0,55,0,0'
    [void]$kyStack.Children.Add($kyChucVu); [void]$kyStack.Children.Add($kyTen)

    [Windows.Controls.Grid]::SetColumn($nnStack, 0)
    [Windows.Controls.Grid]::SetColumn($kyStack, 1)
    [void]$footerGrid.Children.Add($nnStack); [void]$footerGrid.Children.Add($kyStack)
    [void]$page.Children.Add($footerGrid)

    return $page
}

function Show-WordPreview {
    try {
        $chatPanel = F 'CuonNoiDung'
        $wordBorder = F 'KhungWordDocLap'
        $wordContent = F 'DsNoiDungWord'
        $statusText = F 'NhanTrangThaiWord'

        if (-not $wordBorder) { return }

        if (-not $script:wordView) {
            $wordBorder.Visibility = 'Collapsed'
            if ($chatPanel) { $chatPanel.Visibility = 'Visible' }
            Update-WordButton
            return
        }

        if ($chatPanel) { $chatPanel.Visibility = 'Collapsed' }
        $wordBorder.Visibility = 'Visible'
        Update-WordButton

        if ($wordContent) {
            $wordContent.Children.Clear()
            $lastBotMsg = $null
            if ($script:session -and $script:session.messages) {
                for ($i = $script:session.messages.Count - 1; $i -ge 0; $i--) {
                    if ($script:session.messages[$i].role -eq 'assistant') {
                        $lastBotMsg = $script:session.messages[$i].content
                        break
                    }
                }
            }
            if (-not $lastBotMsg) {
                $lastDoc = @($script:data.documents | Select-Object -First 1)
                if ($lastDoc.Count -gt 0) { $lastBotMsg = $lastDoc[0].body }
            }
            if (-not $lastBotMsg) {
                $lastBotMsg = "CHƯA CÓ NỘI DUNG VĂN BẢN`n`nHãy yêu cầu Trợ lý soạn một văn bản (như Kế hoạch, Quyết định, Báo cáo) hoặc chọn một mẫu từ Thư viện để xem định dạng trang Word A4 tại đây."
            }
            $docPage = Create-WordPage $lastBotMsg "VĂN BẢN TRƯỜNG HỌC"
            [void]$wordContent.Children.Add($docPage)
            if ($statusText) { $statusText.Text = "Đang xem định dạng Word A4 chuẩn Nghị định 30/2020/NĐ-CP" }
        }
    } catch {
        Write-Warning "Error in Show-WordPreview: $($_.Exception.Message)"
    }
}

function Render-Chat {
    try {
        $p = F 'DsNoiDung'
        if (-not $p) { return }
        $p.Children.Clear()

        # Gợi ý câu lệnh nhanh
        $pGoiY = F 'DsGoiY'
        if ($pGoiY -and $pGoiY.Children.Count -eq 0) {
            $goiYs = @(
                'Lập Kế hoạch giáo dục nhà trường năm học mới',
                'Soạn Quyết định thành lập Hội đồng tự đánh giá',
                'Dự thảo Nghị quyết sinh hoạt chi bộ tháng này',
                'Lập Lịch công tác tuần cho Ban giám hiệu',
                'Soạn Báo cáo sơ kết học kỳ 1 của nhà trường',
                'Tư vấn quy trình xử lý đơn thư, khiếu nại'
            )
            foreach ($g in $goiYs) {
                $bt = New-Object Windows.Controls.Button
                $bt.Content = $g; $bt.Style = $window.FindResource('Nut'); $bt.Margin = '0,0,8,8'; $bt.Padding = '12,6'; $bt.Tag = $g
                $bt.Add_Click({
                    param($s, $e)
                    $txtHoi = F 'TxtHoi'
                    if ($txtHoi) { $txtHoi.Text = $s.Tag; $txtHoi.Focus() | Out-Null }
                })
                [void]$pGoiY.Children.Add($bt)
            }
        }

        # Hiển thị lịch sử chat
        if ($script:session -and $script:session.messages) {
            foreach ($msg in $script:session.messages) {
                $isUser = $msg.role -eq 'user'
                $b = New-Object Windows.Controls.Border
                $b.CornerRadius = 14
                $b.Padding = '16,12'
                $b.Margin = $(if ($isUser) { '80,6,0,6' } else { '0,6,80,6' })
                $b.Background = $(if ($isUser) { Brush '#2F6FE0' } else { Brush 'White' })
                $b.HorizontalAlignment = $(if ($isUser) { 'Right' } else { 'Left' })
                if (-not $isUser) {
                    $b.BorderBrush = Brush '#E2E8F0'; $b.BorderThickness = 1
                }

                $sp = New-Object Windows.Controls.StackPanel
                $mColor = $(if ($isUser) { 'White' } else { '#1E293B' })
                $t = Text $msg.content $script:fontSize $mColor
                [void]$sp.Children.Add($t)

                if (-not $isUser) {
                    $actionPanel = New-Object Windows.Controls.StackPanel
                    $actionPanel.Orientation = 'Horizontal'; $actionPanel.Margin = '0,8,0,0'
                    $btnXuatWord = Button 'Xuất file Word (.docx)' 'export_word' @{title="Van-ban-tro-ly"; body=$msg.content} 'Lien'
                    [void]$actionPanel.Children.Add($btnXuatWord)
                    [void]$sp.Children.Add($actionPanel)
                }

                $b.Child = $sp
                [void]$p.Children.Add($b)
            }
        }

        # Cập nhật danh sách việc đã giao ở cột bên phải
        $pCotViec = F 'DsViecDaGiao'
        if ($pCotViec) {
            $pCotViec.Children.Clear()
            try {
                $chats = Api 'chats'
                foreach ($c in $chats) {
                    $btnItem = New-Object Windows.Controls.Button
                    $btnItem.Content = $(if ($c.title) { $c.title } else { "Phiên làm việc" })
                    $btnItem.Style = $window.FindResource('Lien')
                    $btnItem.Margin = '0,4,0,4'; $btnItem.Tag = $c
                    $btnItem.Add_Click({
                        param($s, $e)
                        $script:session = $s.Tag
                        Render-Chat
                        if ($script:wordView) { Show-WordPreview }
                    })
                    [void]$pCotViec.Children.Add($btnItem)
                }
            } catch {}
        }

        if ($script:wordView) { Show-WordPreview }
    } catch {
        Write-Warning "Error in Render-Chat: $($_.Exception.Message)"
    }
}

function Start-Work([string]$prompt='') {
    $script:session=$null;$script:attachments=@()
    Show-Page 'TroChuyen'
    (F 'TxtHoi').Text=$prompt
    [void](F 'TxtHoi').Focus()
}
function Send-Chat {
    try {
        $txtHoi = F 'TxtHoi'
        if (-not $txtHoi -or [string]::IsNullOrWhiteSpace($txtHoi.Text)) { return }
        $prompt = $txtHoi.Text.Trim()
        $files=@($script:attachments | ForEach-Object {$_.path})
        $job=Api 'chat_start' @{id=$script:session.id;prompt=$prompt;files=$files}
        $script:jobs[$job.job]=@{session=$job.session;prompt=$prompt;attachments=@($script:attachments)}
        Refresh-State
        $script:session=@($script:data.chat | Where-Object {$_.id -eq $job.session}) | Select-Object -First 1
        $txtHoi.Text = ''
        $script:attachments = @()
        (F 'KhungTienTrinh').Visibility='Visible'
        (F 'TxtSoViecChay').Text='AI đang xử lý...'
        Render-Chat
        if ($script:wordView) { Show-WordPreview }
    } catch {
        Notice ("Lỗi khi gửi yêu cầu AI: " + $_.Exception.Message)
    }
}

function Update-AIJobs {
    foreach($id in @($script:jobs.Keys)){
        $state=Api 'chat_poll' @{job=$id}
        if($state.state -notin @('done','error','cancelled')){continue}
        $context=$script:jobs[$id];$script:jobs.Remove($id)
        if($script:session.id -eq $context.session){
            if($state.state -in @('error','cancelled')){
                (F 'TxtHoi').Text=$context.prompt
                $script:attachments=@($context.attachments)
            }
            Refresh-State
            $script:session=@($script:data.chat | Where-Object {$_.id -eq $context.session}) | Select-Object -First 1
            Render-Chat
        }
        if($state.state -eq 'error'){Notice ("Lỗi khi gửi yêu cầu AI: "+$state.error)}
    }
    (F 'KhungTienTrinh').Visibility=$(if($script:jobs.Count){'Visible'}else{'Collapsed'})
    (F 'TxtSoViecChay').Text=$(if($script:jobs.Count){'Đang xử lý: '+$script:jobs.Count+' việc'}else{''})
}
function Stop-AIJobs {
    foreach($id in @($script:jobs.Keys)){[void](Api 'chat_cancel' @{job=$id})}
    Update-AIJobs
}

function School-Settings-Dialog {
    $d = New-Object Windows.Window
    $d.Title = 'Thông tin trường học & Ban Giám hiệu'
    $d.Owner = $window; $d.Width = 680; $d.Height = 620
    $d.WindowStartupLocation = 'CenterOwner'; $d.Background = Brush '#F4F7FC'
    $panel = New-Object Windows.Controls.StackPanel; $panel.Margin = 24
    $inputs = @{}
    $fields = @(
        @('parent', 'Tên trường học'),
        @('school_level', 'Cấp học (Tiểu học / THCS / THPT / Mầm non)'),
        @('name', 'Họ và tên Hiệu trưởng'),
        @('position', 'Chức vụ người đứng đầu'),
        @('vice_principals', 'Họ tên các Phó Hiệu trưởng'),
        @('party_org', 'Tên Chi bộ / Đảng ủy trường'),
        @('year', 'Năm học'),
        @('location', 'Địa danh (Tỉnh / Huyện / Xã)'),
        @('ioffice', 'Địa chỉ hệ thống iOffice nhà trường')
    )
    foreach ($f in $fields) {
        [void]$panel.Children.Add((Text $f[1] 13 '#334155'))
        $box = New-Object Windows.Controls.TextBox
        $box.Style = $window.FindResource('Nhap')
        $box.Text = [string]$script:data.profile.($f[0])
        [void]$panel.Children.Add($box)
        $inputs[$f[0]] = $box
    }
    $btnSave = New-Object Windows.Controls.Button
    $btnSave.Content = 'Lưu thông tin trường học'
    $btnSave.Style = $window.FindResource('NutChinh')
    $btnSave.Margin = '0,16,0,0'; $btnSave.Height = 38
    $btnSave.Add_Click({
        $profile = @{}
        foreach ($p in $script:data.profile.PSObject.Properties) { $profile[$p.Name] = $p.Value }
        foreach ($k in $inputs.Keys) { $profile[$k] = $inputs[$k].Text.Trim() }
        [void](Api 'settings' @{profile=$profile})
        $d.DialogResult = $true
    })
    [void]$panel.Children.Add($btnSave)
    $scroll = New-Object Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = 'Auto'
    $scroll.Content = $panel
    $d.Content = $scroll
    [void]$d.ShowDialog()
    Refresh-State; Update-Header; Render-Settings
}

# ==================== GẮN EVENT TOÀN BỘ NÚT BẤM ====================
# 1. Menu chính (Sidebar)
foreach ($t in $script:Trang) {
    $nav = F "Nav$t"
    if ($nav) {
        $nav.Add_Checked({
            param($s, $e)
            if ($script:DangDatNav) { return }
            $pageName = $s.Name.Substring(3)
            if ($script:TrangHienTai -ne $pageName) { Show-Page $pageName }
        })
    }
}

# 2. Trang chủ
Wire 'BtnKhaiBaoNhanh' { School-Settings-Dialog }
Wire 'BtnVanBanMoi' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Dự thảo văn bản hành chính mới theo Nghị định 30/2020/NĐ-CP:' }
Wire 'BtnXemViec' { Show-Page 'CongViec' }
Wire 'BtnXemVanBan' { Show-Page 'ThuVien' }
Wire 'BtnGiaoViecSoan' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Soạn thảo văn bản chỉ đạo, điều hành của nhà trường theo Nghị định 30/2020/NĐ-CP:' }
Wire 'BtnRaSoatFile' {
    $files = Select-Files 'Văn bản (*.docx;*.pdf;*.txt)|*.docx;*.pdf;*.txt|All Files (*.*)|*.*'
    if ($files.Length -gt 0) {
        foreach ($f in $files) { $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) } }
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = 'Rà soát tính pháp lý, thể thức trình bày theo Nghị định 30/2020/NĐ-CP và nội dung văn bản đính kèm. Nêu rõ các điểm cần sửa đổi, bổ sung.'
    } else {
        Show-Page 'ThuVien'
    }
}

# 3. Trò chuyện & Word Mode
Wire 'BtnGuiHoi' { Send-Chat }
$txtHoiBox = F 'TxtHoi'
if ($txtHoiBox) {
    $txtHoiBox.Add_KeyDown({
        param($s, $e)
        if ($e.Key -eq [Windows.Input.Key]::Enter -and ($e.KeyboardDevice.Modifiers -band [Windows.Input.ModifierKeys]::Shift) -eq 0) {
            $e.Handled = $true
            Send-Chat
        }
    })
}

Wire 'BtnCheDoWord' {
    $script:wordView = -not $script:wordView
    Show-WordPreview
}

Wire 'BtnXoaTatCaChat' {
    if (-not $Smoke) {
        $res = [Windows.MessageBox]::Show($window, 'Thầy/cô có chắc chắn muốn xóa toàn bộ lịch sử trò chuyện và việc đã giao không?', 'Xác nhận xóa lịch sử', 'YesNo', 'Question')
        if ($res -ne 'Yes') { return }
    }
    try {
        $chats = Api 'chats'
        foreach ($c in $chats) { [void](Api 'delete' @{key=$c.id; id=$c.id}) }
        $script:session = $null
        Notice 'Đã xóa toàn bộ lịch sử trò chuyện và việc đã giao thành công.'
        Render-Chat
        if ($script:wordView) { Show-WordPreview }
    } catch {
        Notice ("Lỗi khi xóa lịch sử: " + $_.Exception.Message)
    }
}

Wire 'BtnChatMoi' {
    $script:session = $null
    Render-Chat
    if ($script:wordView) { Show-WordPreview }
}

Wire 'BtnChuTo' {
    if ($script:fontSize -lt 24) { $script:fontSize += 1; Render-Chat }
}

Wire 'BtnChuNho' {
    if ($script:fontSize -gt 12) { $script:fontSize -= 1; Render-Chat }
}

Wire 'BtnCotViec' {
    $cot = F 'CotPhai'
    if ($cot) {
        $cot.Visibility = $(if ($cot.Visibility -eq 'Visible') { 'Collapsed' } else { 'Visible' })
    }
}

Wire 'BtnDinhKem' {
    $files = Select-Files 'Tài liệu (*.docx;*.xlsx;*.pdf;*.txt)|*.docx;*.xlsx;*.pdf;*.txt|All Files (*.*)|*.*'
    foreach ($f in $files) {
        $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) }
    }
    if ($files.Length -gt 0) {
        Notice ("Đã đính kèm " + $files.Length + " tệp vào phiên làm việc.")
    }
}

# 4. Công việc & Lịch
Wire 'BtnThemViec' {
    $txtViec = F 'TxtNoiDungViec'
    $dpNgay = F 'DpNgayViec'
    if ($txtViec -and -not [string]::IsNullOrWhiteSpace($txtViec.Text)) {
        $dateStr = $(if ($dpNgay -and $dpNgay.SelectedDate) { $dpNgay.SelectedDate.Value.ToString('yyyy-MM-dd') } else { (Get-Date).ToString('yyyy-MM-dd') })
        [void](Api 'save' @{kind='task'; item=@{title=$txtViec.Text.Trim(); due=$dateStr; date=$dateStr; done=$false; state='Chưa hoàn thành'}})
        $txtViec.Text = ''
        Refresh-State; Render-Tasks
    }
}

Wire 'BtnXoaViecXong' {
    $tasks = @($script:data.tasks | Where-Object { $_.done -or $_.state -eq 'Hoàn thành' })
    foreach ($t in $tasks) { [void](Api 'delete' @{id=$t.id; key=$t.id}) }
    Refresh-State; Render-Tasks
}

Wire 'BtnMoFileViec' {
    $rows = @($script:data.tasks | ForEach-Object { ,@($_.title, $(if ($_.due){$_.due}else{$_.date}), $(if ($_.done){'Hoàn thành'}else{'Chưa hoàn thành'})) })
    $r = Api 'export' @{format='xlsx'; title='Cong-viec-nha-truong'; headers=@('Nội dung công việc','Hạn hoàn thành','Trạng thái'); rows=$rows}
    Open-File $r.path
}
Wire 'BtnVbTuCongViec' { Show-Page 'VanBanDen' }
Wire 'BtnVbIOffice' { Show-Page 'VanBanDen' }
Wire 'BtnSoTheoDoi' { Show-Page 'CongViec' }
Wire 'BtnSoTheoDoi2' { Show-Page 'CongViec' }
Wire 'BtnLapLichTuan' { Show-Page 'CongViec'; Refresh-State; Render-Tasks; Notice 'Đã mở công việc và lịch. Các việc, hạn và trạng thái được xử lý cục bộ.' }
Wire 'BtnCapNhatMoc' {
    $d=New-Object Windows.Window;$d.Title='Cập nhật mốc năm học';$d.Owner=$window;$d.Width=620;$d.Height=500;$d.WindowStartupLocation='CenterOwner'
    $p=New-Object Windows.Controls.StackPanel;$p.Margin=20
    [void]$p.Children.Add((Text 'MỐC THỜI GIAN NĂM HỌC' 15 '#0B2B6B'))
    $txt=New-Object Windows.Controls.TextBox;$txt.AcceptsReturn=$true;$txt.Height=300;$txt.VerticalScrollBarVisibility='Auto';$txt.Padding=10
    $old=@($script:data.memory|Where-Object{$_.id -eq 'moc_nam_hoc'}|Select-Object -First 1)
    $txt.Text=$(if($old){$old.body}else{"Khai giảng: 05/09`nGiữa học kỳ I: Tuần 9`nSơ kết học kỳ I: Tuần 18`nGiữa học kỳ II: Tuần 27`nTổng kết năm học: Trước 31/05"})
    [void]$p.Children.Add($txt)
    $save=New-Object Windows.Controls.Button;$save.Content='Lưu mốc năm học';$save.Margin='0,14,0,0';$save.Padding='10'
    $save.Add_Click({[void](Api 'save' @{kind='memory';item=@{id='moc_nam_hoc';title='Mốc năm học';body=$txt.Text}});$d.Close();Refresh-State;Notice 'Đã lưu mốc năm học cục bộ.'})
    [void]$p.Children.Add($save);$d.Content=$p;[void]$d.ShowDialog()
}
Wire 'BtnMoLichNamHoc' {
    $files = Select-Files 'Kế hoạch năm học (*.docx;*.xlsx;*.pdf)|*.docx;*.xlsx;*.pdf'
    if ($files.Length -gt 0) { Open-File $files[0] } else { Show-Page 'Lich' }
}

# 5. Ban giám hiệu & Tổ chuyên môn
Wire 'BtnViecThang' { Show-Page 'CongViec' }
Wire 'BtnMoCongViec' { Show-Page 'CongViec' }
Wire 'BtnGiaoViecBGH' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Lập kế hoạch phân công nhiệm vụ trong Ban Giám hiệu theo vị trí việc làm' }
Wire 'BtnDsTo' { Show-Page 'ToChuyenMon' }
Wire 'BtnMoThuMucTo' { Open-File $script:data.root }
Wire 'BtnMoThuMucTo2' { Open-File $script:data.root }
Wire 'BtnGiaoViecTo' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Hướng dẫn sinh hoạt tổ chuyên môn theo nghiên cứu bài học và kế hoạch giáo dục' }
Wire 'BtnMoVBTo' { Show-Page 'ThuVien' }
Wire 'BtnDuyetVBTo' {
    $files = Select-Files 'Kế hoạch / Bài dạy / Biên bản (*.docx;*.pdf;*.txt)|*.docx;*.pdf;*.txt'
    if ($files.Length -gt 0) {
        foreach ($f in $files) { $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) } }
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = 'Thẩm định, duyệt và góp ý chuyên môn cho hồ sơ tổ chuyên môn đính kèm theo quy định. Nêu rõ ưu điểm, hạn chế và kết luận đánh giá.'
    } else {
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = 'Góp ý và phê duyệt kế hoạch giáo dục / biên bản sinh hoạt của Tổ chuyên môn.'
    }
}

# 6. Mẫu văn bản & Soạn thảo
Wire 'BtnXemMau' {
    $lv = F 'LvMau'
    if ($lv -and $lv.SelectedItem) {
        $item = $lv.SelectedItem
        $t = $item.Template
        $title = $item.Ten
        $body = $(if ($t -and $t.body) { $t.body } else { "Mẫu: $title" })
        $p = Save-Path ($title + '.docx') 'Word Document (*.docx)|*.docx'
        if ($p) {
            [void](Api 'export' @{format='docx'; title=$title; body=$body; path=$p})
            Open-File $p
            Notice ("Đã xuất và mở mẫu dạng Word: " + $p)
        }
    } else {
        Show-Page 'Mau'
        Notice "Vui lòng chọn một mẫu văn bản trong danh sách để xem dạng Word."
    }
}
Wire 'BtnSoanTheoMau' {
    $lv = F 'LvMau'
    if ($lv -and $lv.SelectedItem) {
        $item = $lv.SelectedItem
        $t = $item.Template
        $body = $(if ($t -and $t.body) { $t.body } else { $item.Ten })
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = "Soạn thảo văn bản theo mẫu dưới đây. Hãy điền đầy đủ căn cứ, nơi nhận và nội dung chi tiết theo đúng thể thức Nghị định 30/2020:`n`n" + $body
    } else {
        Show-Page 'Mau'
        Notice "Vui lòng chọn một mẫu văn bản trong danh sách để bắt đầu soạn."
    }
}
Wire 'BtnHuongDanTheThuc' {
    Notice "HƯỚNG DẪN THỂ THỨC VĂN BẢN (NGHỊ ĐỊNH 30/2020/NĐ-CP)`n`n1. Thành phần thể thức chính:`n- Quốc hiệu và Tiêu ngữ`n- Tên cơ quan, tổ chức ban hành văn bản`n- Số, ký hiệu của văn bản`n- Địa danh và thời gian ban hành`n- Tên loại và trích yếu nội dung văn bản`n- Nội dung văn bản (các Điều, Khoản, Điểm)`n- Chức vụ, họ tên và chữ ký người có thẩm quyền`n- Dấu, chữ ký số của cơ quan`n- Nơi nhận văn bản`n`n2. Định dạng: Font Times New Roman, khổ A4, căn lề trên/dưới 20-25mm, trái 30-35mm, phải 15-20mm."
}
Wire 'BtnMauRieng' {
    $p = Join-Path $script:data.root 'mau-rieng'; if (-not (Test-Path $p)) { [void][IO.Directory]::CreateDirectory($p) }
    Open-File $p
}
Wire 'BtnQuyTrinhRieng' {
    $p = Join-Path $script:data.root 'bo-nho'; if (-not (Test-Path $p)) { [void][IO.Directory]::CreateDirectory($p) }
    Open-File $p
}

# 7. Công tác Đảng
Wire 'BtnKhaiBaoDang' { School-Settings-Dialog }
Wire 'BtnDsDangVien' {
    Show-Page 'CongTacDang'
    Notice "Hồ sơ đảng viên chi bộ được quản lý trong mục Công tác Đảng. Bấm 'Giao việc' để soạn nghị quyết hoặc báo cáo chi bộ."
}
Wire 'BtnToChucDang' { Show-Page 'CongTacDang' }
Wire 'BtnGiaoViecDang' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Dự thảo Nghị quyết sinh hoạt chi bộ định kỳ tháng này theo Hướng dẫn 05-HD/VPTW' }
Wire 'BtnMoVBDang' { Show-Page 'ThuVien' }
Wire 'BtnMoThuMucDang' { Open-File $script:data.root }

# 8. Việc của tôi (Nhiệm vụ)
Wire 'BtnKhaiBaoNV' { School-Settings-Dialog }
Wire 'BtnSapXepNV' { Notice "Đã sắp xếp danh mục nhiệm vụ theo đề cương quản trị trường học." }
Wire 'BtnViecThangNV' { Show-Page 'CongViec' }
Wire 'BtnMoCongViecNV' { Show-Page 'CongViec' }
Wire 'BtnQuayLaiNV' { Show-Page 'NhiemVu' }
Wire 'BtnTheNV' { Show-Page 'NhiemVu' }
Wire 'BtnHoSoNV' { Open-File $script:data.root }
Wire 'BtnGiaoViecNV' { Show-Page 'TroChuyen'; (F 'TxtHoi').Text = 'Giao nhiệm vụ chuyên môn và kiểm tra thực hiện nhiệm vụ' }

# 9. Cài đặt, Tra cứu & Tiện ích
Wire 'BtnKhaiBao' { School-Settings-Dialog }
Wire 'BtnCapNhatTruong' { School-Settings-Dialog }
Wire 'BtnHuongDan' {
    Notice "Trợ lý Quản trị trường học hỗ trợ Hiệu trưởng, Phó Hiệu trưởng và Tổ chuyên môn soạn thảo Kế hoạch, Quyết định, Báo cáo, Nghị quyết Đảng theo thể thức Nghị định 30/2020 và hướng dẫn của Đảng."
}
Wire 'BtnTraCuu' {
    $q = F 'TxtCauHoi'
    if ($q -and $q.Text) {
        Show-Page 'TraCuu'
        Render-Search
        Notice "Đã mở kho căn cứ pháp lý cục bộ để tra cứu: $($q.Text). Dùng AI chỉ khi cần giải thích sâu nội dung văn bản."
    } else {
        Show-Page 'TraCuu'
    }
}
Wire 'BtnMoCanCu' { Show-Page 'TraCuu' }
Wire 'BtnCanCuTruong' { Show-Page 'TraCuu' }
Wire 'BtnTongHopFile' {
    $files = Select-Files 'Tài liệu báo cáo, số liệu (*.xlsx;*.docx;*.pdf;*.csv)|*.xlsx;*.docx;*.pdf;*.csv'
    if ($files.Length -gt 0) {
        foreach ($f in $files) { $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) } }
    }
    Show-Page 'TroChuyen'
    (F 'TxtHoi').Text = "Phân tích và tổng hợp số liệu báo cáo của nhà trường từ các tài liệu đính kèm"
}
Wire 'BtnPhanCongFile' {
    $files = Select-Files 'Bảng phân công chuyên môn (*.xlsx;*.csv;*.docx)|*.xlsx;*.csv;*.docx'
    if ($files.Length -gt 0) {
        foreach ($f in $files) { $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) } }
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = "Rà soát bảng phân công chuyên môn giáo viên đính kèm: định mức tiết dạy, kiểm tra trùng lịch và cân đối số tiết/tuần."
    }
}
Wire 'BtnMoDuLieu' { Open-File $script:data.root }
Wire 'BtnMoThuMucSanPham' { Open-File $script:data.root }
Wire 'BtnMoVB' { Show-Page 'ThuVien' }
Wire 'BtnMoThuMucChua' { Open-File $script:data.root }
Wire 'BtnSuaTiep' {
    $lv = F 'LvThuVien'
    if ($lv -and $lv.SelectedItem) {
        Show-Page 'TroChuyen'; (F 'TxtHoi').Text = "Chỉnh sửa, hoàn thiện tiếp văn bản: " + $lv.SelectedItem.title + "`n`n" + $lv.SelectedItem.body
    } else {
        Show-Page 'ThuVien'
    }
}
Wire 'BtnRaSoatVB' {
    $lv = F 'LvThuVien'
    if ($lv -and $lv.SelectedItem) {
        Show-Page 'TroChuyen'; (F 'TxtHoi').Text = "Rà soát thể thức văn bản theo Nghị định 30/2020 và kiểm tra nội dung: " + $lv.SelectedItem.title + "`n`n" + $lv.SelectedItem.body
    } else {
        Show-Page 'ThuVien'
    }
}
Wire 'BtnTomTat' {
    $files = Select-Files 'Văn bản cần tóm tắt (*.docx;*.pdf;*.txt)|*.docx;*.pdf;*.txt'
    if ($files.Length -gt 0) {
        foreach ($f in $files) { $script:attachments += @{ path = $f; name = [IO.Path]::GetFileName($f) } }
        Show-Page 'TroChuyen'
        (F 'TxtHoi').Text = "Tóm tắt nội dung chỉ đạo trọng tâm và trích xuất các công việc nhà trường cần thực hiện từ văn bản đính kèm."
    }
}
Wire 'BtnPhieuGQ' {
    Show-Page 'TroChuyen'
    (F 'TxtHoi').Text = "Lập Phiếu giải quyết văn bản đến gồm: Tên cơ quan gửi, Trích yếu, Ý kiến phân công của Hiệu trưởng, Người thực hiện và Hạn nộp báo cáo."
}
Wire 'BtnMoVBDen' { Open-File (Join-Path $script:data.root 'van-ban-den') }
Wire 'BtnMoGoc' { Open-File $script:data.root }
Wire 'BtnMoThuMuc' { Open-File $script:data.root }
Wire 'BtnXoaLichSu' {
    try {
        $chats = Api 'chats'
        foreach ($c in $chats) { [void](Api 'delete' @{key=$c.id; id=$c.id}) }
        $script:session = $null
        Notice 'Đã xóa lịch sử trò chuyện.'
        Render-Chat
    } catch {}
}
Wire 'BtnKichHoat' {
    Notice "Trợ lý Quản trị trường học · Bản độc lập kết nối trường học.`nMọi chức năng đã sẵn sàng hoạt động."
}
Wire 'BtnCapNhatFile' {
    $files = Select-Files 'Gói cập nhật (*.exe;*.zip)|*.exe;*.zip'
    if ($files.Length -gt 0) { Open-File $files[0] } else { Check-Update }
}
Wire 'BtnLienHe' {
    Notice "THÔNG TIN HỖ TRỢ KỸ THUẬT`n- Phần mềm: Trợ lý Quản trị trường học · Bản độc lập`n- Kết nối máy chủ trường: Cài đặt → Địa chỉ máy chủ"
}
Wire 'BtnViecMoiNho' { Start-Work }
Wire 'BtnPhongTo' {
    $cot = F 'CotPhai'
    if ($cot) { $cot.Visibility = $(if ($cot.Visibility -eq 'Visible') { 'Collapsed' } else { 'Visible' }) }
}
Wire 'BtnDungChat' { Stop-AIJobs }
Wire 'BtnBoQuyTrinh' {
    $kq = F 'KhungQuyTrinh'; if ($kq) { $kq.Visibility = 'Collapsed' }
}

# Update & Backup (B03 fix: passing path=$p)
Wire 'BtnKiemTraCapNhat' { Check-Update }
Wire 'BtnCapNhatChan' { Check-Update }
Wire 'BtnTruongHocChung' { Open-SchoolWorkspace }
Wire 'BtnDiaChiMayChu' { Set-SchoolConnection }
Wire 'BtnSaoLuu' {
    $p = Save-Path 'SaoLuu_QuanTriTruongHoc.zip' 'Zip Archive (*.zip)|*.zip'
    if ($p) {
        [void](Api 'backup' @{path=$p; target=$p})
        Notice ("Đã sao lưu toàn bộ dữ liệu quản trị trường học vào: " + $p)
    }
}
Wire 'BtnSaoLuuChan' {
    $p = Save-Path 'SaoLuu_QuanTriTruongHoc.zip' 'Zip Archive (*.zip)|*.zip'
    if ($p) {
        [void](Api 'backup' @{path=$p; target=$p})
        Notice ("Đã sao lưu toàn bộ dữ liệu quản trị trường học vào: " + $p)
    }
}


# Menu góc người dùng
$mnKhaiBao = F 'MnKhaiBao'; if ($mnKhaiBao) { $mnKhaiBao.Add_Click({ Show-Page 'CaiDat' }) }
$mnThongTin = F 'MnThongTin'; if ($mnThongTin) { $mnThongTin.Add_Click({ Show-Page 'CaiDat' }) }
$mnDangNhap = F 'MnDangNhap'; if ($mnDangNhap) { $mnDangNhap.Add_Click({ Show-Page 'CaiDat' }) }
$mnCaiDat = F 'MnCaiDat'; if ($mnCaiDat) { $mnCaiDat.Add_Click({ Show-Page 'CaiDat' }) }

# Tìm nhanh ở Header
$txtTimNhanh = F 'TxtTimNhanh'
if ($txtTimNhanh) {
    $txtTimNhanh.Add_KeyDown({
        param($s, $e)
        if ($e.Key -eq [Windows.Input.Key]::Enter -and -not [string]::IsNullOrWhiteSpace($txtTimNhanh.Text)) {
            $q = $txtTimNhanh.Text.Trim()
            $txtTimNhanh.Text = ''
            Show-Page 'TroChuyen'
            (F 'TxtHoi').Text = $q
            Send-Chat
        }
    })
}

# Khởi động tại TrangChu
Show-Page 'TrangChu'
$timer=New-Object Windows.Threading.DispatcherTimer
$timer.Interval=[TimeSpan]::FromMilliseconds(600)
$timer.Add_Tick({try{Update-AIJobs}catch{Notice $_.Exception.Message}})
$timer.Start()
$window.Add_Closed({$timer.Stop();$script:client.Dispose()})

if($VerifyAI){
    $check=Join-Path $PSScriptRoot 'verify-ai.ps1'
    if(-not (Test-Path $check)){$check=Join-Path $PSScriptRoot '../../scripts/verify-ai.ps1'}
    . $check
    exit $script:verifyExitCode
}
if ($Smoke) {
    $window.Show()
    [Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 800
    $window.Close()
    exit 0
}

. (Join-Path $PSScriptRoot 'school-link.ps1')
[void]$window.ShowDialog()
