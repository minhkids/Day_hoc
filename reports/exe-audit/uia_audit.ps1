param([string]$App='school')
$ErrorActionPreference='Stop'
Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes
$root='E:\git_hub\Day_hoc'
$folder=if($App -eq 'school'){'TroLyQuanTriTruongHoc-DocLap'}else{'TroLyGiaoVien-DocLap'}
$env:TROLY_SCHOOL_DATA_DIR="$root\reports\exe-audit\school\data"
$env:TROLY_TEACHER_DATA_DIR="$root\reports\exe-audit\teacher\data"
$p=Start-Process -FilePath "$root\exe\$folder\$folder.exe" -ArgumentList @('--screenshots',"$root\reports\exe-audit\$App\manual") -PassThru -WindowStyle Hidden
try {
 Start-Sleep -Seconds 4
 $wins=[Windows.Automation.AutomationElement]::RootElement.FindAll([Windows.Automation.TreeScope]::Children,[Windows.Automation.Condition]::TrueCondition)
 $w=$null
 foreach($item in $wins){if($item.Current.Name -like 'Trợ lý*' -and (($App -eq 'school' -and $item.Current.Name -like '*Quản trị*') -or ($App -eq 'teacher' -and $item.Current.Name -like '*Giáo viên*'))){$w=$item;break}}
 if(-not $w){throw 'Window not found'}
 $controls=$w.FindAll([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.Condition]::TrueCondition)
 $items=@(foreach($c in $controls){[pscustomobject]@{id=$c.Current.AutomationId;name=$c.Current.Name;type=$c.Current.ControlType.ProgrammaticName;enabled=$c.Current.IsEnabled}})
 $items | ConvertTo-Json -Depth 5 | Set-Content "$root\reports\exe-audit\$App\uia-controls.json" -Encoding UTF8

 $results=@()
 foreach($nav in @($items | Where-Object {$_.id -like 'Nav*'})){
  $condition=New-Object Windows.Automation.PropertyCondition([Windows.Automation.AutomationElement]::AutomationIdProperty,$nav.id)
  $c=$w.FindFirst([Windows.Automation.TreeScope]::Descendants,$condition)
  $c.GetCurrentPattern([Windows.Automation.SelectionItemPattern]::Pattern).Select()
  Start-Sleep -Milliseconds 300
  $all=$w.FindAll([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.Condition]::TrueCondition)
  $visible=@(foreach($a in $all){if(-not $a.Current.IsOffscreen){[pscustomobject]@{id=$a.Current.AutomationId;name=$a.Current.Name;type=$a.Current.ControlType.ProgrammaticName}}})
  $results+=@{nav=$nav.id;controls=$visible}
 }
 $results | ConvertTo-Json -Depth 7 | Set-Content "$root\reports\exe-audit\$App\uia-pages.json" -Encoding UTF8
 $nav=$w.FindFirst([Windows.Automation.TreeScope]::Descendants,(New-Object Windows.Automation.PropertyCondition([Windows.Automation.AutomationElement]::AutomationIdProperty,'NavTrangChu')))
 $nav.GetCurrentPattern([Windows.Automation.SelectionItemPattern]::Pattern).Select()
 $b=$w.FindFirst([Windows.Automation.TreeScope]::Descendants,(New-Object Windows.Automation.PropertyCondition([Windows.Automation.AutomationElement]::AutomationIdProperty,'BtnKhaiBaoNhanh')))
 if($b){$b.GetCurrentPattern([Windows.Automation.InvokePattern]::Pattern).Invoke();Start-Sleep -Milliseconds 700}
 $all=$w.FindAll([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.Condition]::TrueCondition)
 @(foreach($a in $all){if(-not $a.Current.IsOffscreen){[pscustomobject]@{id=$a.Current.AutomationId;name=$a.Current.Name;type=$a.Current.ControlType.ProgrammaticName}}}) | ConvertTo-Json -Depth 5 | Set-Content "$root\reports\exe-audit\$App\uia-after-settings-click.json" -Encoding UTF8
 Write-Output "Navigated $($results.Count) sidebar entries and clicked settings shortcut"

} finally {if($w){try{$w.GetCurrentPattern([Windows.Automation.WindowPattern]::Pattern).Close()}catch{}}}
