$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase
$root = Split-Path $PSScriptRoot -Parent
foreach ($package in @('TroLyGiaoVien-DocLap','TroLyQuanTriTruongHoc-DocLap','TroLyChuyenVien-DocLap')) {
    $folder = Join-Path $root "dist\$package\_internal\wpf"
    $errors = $null; $tokens = $null
    [void][Management.Automation.Language.Parser]::ParseFile((Join-Path $folder 'host.ps1'),[ref]$tokens,[ref]$errors)
    if ($errors.Count) { throw "$package has syntax errors: $errors" }
    [xml]$xml = [IO.File]::ReadAllText((Join-Path $folder 'layout.xaml'))
    $window = [Windows.Markup.XamlReader]::Load((New-Object Xml.XmlNodeReader $xml))
    $original = $window.Content
    . (Join-Path $folder 'school-link.ps1')
    if ($window.Content.Children.Count -ne 2) { throw 'Toolbar was not attached' }
    if ($window.Content.Children[1] -ne $original) { throw 'Original UI was lost' }
    if ($schoolOpen.Content -ne 'Trường học chung') { throw 'Invalid toolbar text' }
    if (-not $window.FindName('TxtHoi')) { throw 'Original WPF namescope broken' }
    $window.Close()
    Write-Output "PASS: $package toolbar, original content and namescope"
}
