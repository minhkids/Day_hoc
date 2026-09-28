param([string]$PayloadRoot)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase
$repo=Split-Path $PSScriptRoot -Parent
function F($name){return $script:window.FindName($name)}
function Notice($message){$script:notice=$message}
function Api($action,$body){
    if($action -ne 'settings'){throw "Unexpected action: $action"}
    $script:saved=$body
    $script:data.has_key=$true
}
function Refresh {}
function Refresh-State {}
function Update-Header {}
function Import-Function($ast,$name){
    $node=$ast.Find({param($n) $n -is [Management.Automation.Language.FunctionDefinitionAst] -and $n.Name -eq $name}.GetNewClosure(),$true)
    if(-not $node){throw "Missing function: $name"}
    # Dot-source at script scope so event handlers can resolve these functions.
    return $node.Extent.Text
}
foreach($app in @('teacher','school','specialist')){
    $wpf=Join-Path $repo ($app+'\wpf')
    if($PayloadRoot){
        $folder=@{teacher='TroLyGiaoVien-DocLap';school='TroLyQuanTriTruongHoc-DocLap';specialist='TroLyChuyenVien-DocLap'}[$app]
        $wpf=Join-Path $PayloadRoot ($app+'\'+$folder+'\_internal\wpf')
    }
    $tokens=$null;$errors=$null
    $ast=[Management.Automation.Language.Parser]::ParseFile((Join-Path $wpf 'host.ps1'),[ref]$tokens,[ref]$errors)
    if($errors.Count){throw ($errors | Out-String)}
    $reader=New-Object Xml.XmlNodeReader ([xml](Get-Content (Join-Path $wpf 'layout.xaml') -Raw -Encoding UTF8))
    $script:window=[Windows.Markup.XamlReader]::Load($reader)
    $script:data=[pscustomobject]@{profile=[pscustomobject]@{name='Test';agency='School';provider='OpenRouter';model='nvidia/nemotron-3-super-120b-a12b:free'};has_key=$false;root=$env:TEMP}
    $script:saved=$null
    if($app -eq 'specialist'){
        foreach($name in @('Text','Brush','Settings-Card','Setting-Field','Render-Settings','Save-Settings')){
            . ([scriptblock]::Create((Import-Function $ast $name)))
        }
        function Button($text,$action,$value,[switch]$Primary){
            $b=New-Object Windows.Controls.Button;$b.Content=$text
            if($action -eq 'save-settings'){$b.Add_Click({Save-Settings})}
            return $b
        }
        Render-Settings
        if($script:settings.ContainsKey('model') -or $script:settings.ContainsKey('provider')){throw 'Model/provider must not be editable'}
        $script:settings.key.Password=' fake-openrouter-test-key '
        Save-Settings
        if($script:settings.key.Password){throw 'Password field was not cleared'}
    }else{
        . ([scriptblock]::Create((Import-Function $ast 'Render-Settings')))
        Render-Settings
        if(-not (F 'PwOpenRouterKey') -or -not (F 'BtnSaveOpenRouterKey')){throw 'API key controls missing'}
        $eventNode=$ast.Find({param($n) $n -is [Management.Automation.Language.InvokeMemberExpressionAst] -and $n.Member.Value -eq 'Add_Click' -and $n.Extent.Text.StartsWith("(F 'BtnSaveOpenRouterKey')")},$true)
        if(-not $eventNode){throw 'Save handler missing'}
        . ([scriptblock]::Create($eventNode.Extent.Text))
        (F 'PwOpenRouterKey').Password=' fake-openrouter-test-key '
        (F 'BtnSaveOpenRouterKey').RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
        if((F 'PwOpenRouterKey').Password){throw 'Password field was not cleared'}
        if((F 'TxtOpenRouterKeyState').Text -notlike 'Đã lưu*'){throw 'Saved-key state was not refreshed'}
    }
    if($script:saved.key -ne 'fake-openrouter-test-key'){throw "$app did not save the trimmed API key"}
    if($script:saved.profile.provider -ne 'OpenRouter'){throw "$app did not select OpenRouter"}
    $script:window.Close()
    Write-Output "PASS ${app}: WPF settings render, masked key input, save handler and cleared field"
}
