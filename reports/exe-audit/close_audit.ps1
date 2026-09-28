Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes
$root=[Windows.Automation.AutomationElement]::RootElement
$wins=$root.FindAll([Windows.Automation.TreeScope]::Children,[Windows.Automation.Condition]::TrueCondition)
foreach($w in $wins){if($w.Current.Name -like 'Trợ lý Quản trị*'){ $w.GetCurrentPattern([Windows.Automation.WindowPattern]::Pattern).Close() }}
