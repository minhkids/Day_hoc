Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes
$ws=[Windows.Automation.AutomationElement]::RootElement.FindAll([Windows.Automation.TreeScope]::Children,[Windows.Automation.Condition]::TrueCondition)
foreach($w in $ws){if($w.Current.Name -like 'Trợ lý*'){
 $a=$w.FindAll([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.Condition]::TrueCondition)
 foreach($c in $a){if($c.Current.ControlType.ProgrammaticName -eq 'ControlType.Window' -or $c.Current.ControlType.ProgrammaticName -eq 'ControlType.Text'){if(-not $c.Current.IsOffscreen){Write-Output ($c.Current.AutomationId+': '+$c.Current.Name)}}}
 foreach($c in $a){if($c.Current.Name -eq 'OK'){$c.GetCurrentPattern([Windows.Automation.InvokePattern]::Pattern).Invoke()}}
}}
