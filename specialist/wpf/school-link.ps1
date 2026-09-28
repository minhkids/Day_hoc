# Shared by the three WPF desktop applications.
$script:schoolConfig = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'TroLyTruongHocChung\connection.txt'
function Open-SchoolWorkspace {
    $address = ''
    if (Test-Path -LiteralPath $script:schoolConfig) { $address = [IO.File]::ReadAllText($script:schoolConfig).Trim() }
    if (-not $address) { Set-SchoolConnection; return }
    $uri = $null
    if (-not [Uri]::TryCreate($address, [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -notin @('http','https') -or $uri.UserInfo) {
        [void][Windows.MessageBox]::Show('Địa chỉ máy chủ không hợp lệ. Hãy cấu hình lại.'); return
    }
    Start-Process -FilePath $uri.AbsoluteUri
}
function Set-SchoolConnection {
    $dialog = New-Object Windows.Window
    $dialog.Title = 'Kết nối trường học chung'; $dialog.Width = 560; $dialog.Height = 260
    $dialog.Owner = $window; $dialog.WindowStartupLocation = 'CenterOwner'; $dialog.ResizeMode = 'NoResize'
    $panel = New-Object Windows.Controls.StackPanel; $panel.Margin = '20'
    $label = New-Object Windows.Controls.TextBlock
    $label.Text = "Nhập địa chỉ máy chủ của trường (do quản trị cung cấp).`nVí dụ: https://truong.example.vn hoặc http://192.168.1.10:8765"
    $label.TextWrapping = 'Wrap'; $label.Margin = '0,0,0,12'; [void]$panel.Children.Add($label)
    $box = New-Object Windows.Controls.TextBox; $box.Padding = '8'
    if (Test-Path -LiteralPath $script:schoolConfig) { $box.Text = [IO.File]::ReadAllText($script:schoolConfig) }
    else { $box.Text = 'http://localhost:8765' }
    [void]$panel.Children.Add($box)
    $save = New-Object Windows.Controls.Button; $save.Content = 'Lưu và mở trường học'; $save.Margin = '0,15,0,0'; $save.Padding = '10'
    $save.Add_Click({
        $uri = $null
        if (-not [Uri]::TryCreate($box.Text.Trim(), [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -notin @('http','https') -or $uri.UserInfo) {
            [void][Windows.MessageBox]::Show($dialog,'Nhập địa chỉ http:// hoặc https:// hợp lệ.'); return
        }
        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($script:schoolConfig))
        [IO.File]::WriteAllText($script:schoolConfig,$uri.AbsoluteUri)
        $dialog.Close(); Open-SchoolWorkspace
    })
    [void]$panel.Children.Add($save); $dialog.Content = $panel; [void]$dialog.ShowDialog()
}

