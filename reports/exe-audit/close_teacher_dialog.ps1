Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes
$ws=[Windows.Automation.AutomationElement]::RootElement.FindAll([Windows.Automation.TreeScope]::Children,[Windows.Automation.Condition]::TrueCondition)
foreach($w in $ws){if($w.Current.Name -like 'Trợ lý Giáo viên*'){
 $dialogs=$w.FindAll([Windows.Automation.TreeScope]::Descendants,(New-Object Windows.Automation.PropertyCondition([Windows.Automation.AutomationElement]::ControlTypeProperty,[Windows.Automation.ControlType]::Window)))
 foreach($d in $dialogs){try{$d.GetCurrentPattern([Windows.Automation.WindowPattern]::Pattern).Close()}catch{}}
}}
