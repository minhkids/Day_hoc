param([string]$App='school')
Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes
$root='E:\git_hub\Day_hoc';$folder='TroLyQuanTriTruongHoc-DocLap';$data="$root\reports\exe-audit\rerun\school\ui-data";New-Item -ItemType Directory -Force $data|Out-Null;$env:TROLY_SCHOOL_DATA_DIR=$data
$p=Start-Process -FilePath "$root\exe\$folder\$folder.exe" -ArgumentList @('--screenshots',"$root\reports\exe-audit\rerun\school\ui") -PassThru -WindowStyle Hidden
$ok=$false;$err='';try{
 Start-Sleep -Seconds 4;$wins=[Windows.Automation.AutomationElement]::RootElement.FindAll([Windows.Automation.TreeScope]::Children,[Windows.Automation.Condition]::TrueCondition);$w=$null
 foreach($x in $wins){if($x.Current.Name -like '*Quản trị trường học*'){$w=$x;break}};if(-not $w){throw 'window not found'}
 function C($id){$w.FindFirst([Windows.Automation.TreeScope]::Descendants,(New-Object Windows.Automation.PropertyCondition([Windows.Automation.AutomationElement]::AutomationIdProperty,$id)))}
 $nav=C 'NavCongViec';$nav.GetCurrentPattern([Windows.Automation.SelectionItemPattern]::Pattern).Select();Start-Sleep -Milliseconds 500
 $box=C 'TxtNoiDungViec';$box.GetCurrentPattern([Windows.Automation.ValuePattern]::Pattern).SetValue('UI test cong viec')
 $btn=C 'BtnThemViec';$btn.GetCurrentPattern([Windows.Automation.InvokePattern]::Pattern).Invoke();Start-Sleep -Milliseconds 700
 $all=$w.FindAll([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.Condition]::TrueCondition);$names=@($all|ForEach-Object{$_.Current.Name})
 if($names -contains 'UI test cong viec'){$ok=$true}else{$err='task not visible after save'}
 $names | ConvertTo-Json | Set-Content "$root\reports\exe-audit\rerun\school\ui-task-names.json" -Encoding UTF8
}catch{$err=$_.Exception.Message}finally{if($w){try{$w.GetCurrentPattern([Windows.Automation.WindowPattern]::Pattern).Close()}catch{}}}
[pscustomobject]@{ok=$ok;error=$err}|ConvertTo-Json
