param([string]$OutputDir, [string]$Layout)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase
[xml]$xml = [IO.File]::ReadAllText($Layout)
$window = [Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))
$window.Width = 1600; $window.Height = 940
$window.WindowStartupLocation = 'Manual'; $window.Left = -20000; $window.Top = 0
$window.ShowInTaskbar = $false
function F($n) { $window.FindName($n) }
$logo = Join-Path $PSScriptRoot 'logo.png'
if (Test-Path $logo) { (F 'ImgLogo').Source = New-Object Windows.Media.Imaging.BitmapImage([Uri]$logo) }
$window.Add_ContentRendered({
    (F 'TxtChao').Text = 'Chào buổi tối, anh/chị!'
    (F 'TxtNgay').Text = (Get-Date).ToString('dddd, dd MMMM yyyy', [Globalization.CultureInfo]::GetCultureInfo('vi-VN'))
    (F 'TxtNamHoc').Text = 'Năm học 2026 – 2027'
    $script:pages = @('TrangChu','SoanVanBan','TroChuyen','NhiemVu','DonVi','CaiDat')
    $script:index = 0
    $timer = New-Object Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromMilliseconds(500)
    $timer.Add_Tick({ param($s,$e)
        if ($script:index -ge $script:pages.Count) { $s.Stop(); $window.Close(); return }
        $page = $script:pages[$script:index]
        foreach ($node in (F 'VungTrang').Children) { $node.Visibility = 'Collapsed' }
        (F ('Pg' + $page)).Visibility = 'Visible'
        $nav = F ('Nav' + $page); if ($nav) { $nav.IsChecked = $true }
        $window.UpdateLayout()
        $visual = $window.Content
        $bitmap = New-Object Windows.Media.Imaging.RenderTargetBitmap([int]$visual.ActualWidth,[int]$visual.ActualHeight,96,96,[Windows.Media.PixelFormats]::Pbgra32)
        $bitmap.Render($visual)
        $encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
        $stream = [IO.File]::Create((Join-Path $OutputDir ('chuyen-vien-' + $page + '.png')))
        try { $encoder.Save($stream) } finally { $stream.Close() }
        $script:index++
    })
    $timer.Start()
})
[void]$window.ShowDialog()
