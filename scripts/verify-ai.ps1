# Called only by --verify-ai with an isolated data directory and explicit report path.
$ErrorActionPreference='Stop'
$script:verifyExitCode=1
$report=@{app=$env:TROLY_VERIFY_APP;model='';pages=@();buttons=@();checks=@();errors=@()}
function Notice($text){throw [string]$text}
function Click-TestButton($name){
    $control=F $name
    if(-not $control){throw "Missing button: $name"}
    $control.RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
}
function Wait-TestAnswer {
    $deadline=[DateTime]::UtcNow.AddSeconds(210)
    do {
        [Windows.Forms.Application]::DoEvents()
        $state=Api 'state'
        $id=if($env:TROLY_VERIFY_APP -eq 'school'){$script:session.id}else{$script:session}
        $conversation=@($state.chat | Where-Object {$_.id -eq $id}) | Select-Object -First 1
        $answers=@($conversation.messages | Where-Object {$_.role -eq 'assistant'})
        if($answers.Count -gt $script:answerCount){
            $script:answerCount=$answers.Count
            return [string]$answers[-1].content
        }
        foreach($jobId in @($script:jobs.Keys)){
            $job=Api 'chat_poll' @{job=$jobId}
            if($job.state -eq 'error'){throw $job.error}
        }
        Start-Sleep -Milliseconds 100
    } while([DateTime]::UtcNow -lt $deadline)
    throw 'AI button did not produce an answer within 210 seconds'
}
try {
    if(-not $env:TROLY_AI_REPORT -or -not $env:TROLY_VERIFY_APP){throw 'Use scripts/verify_packaged_ai.py to isolate verification data'}
    $state=Api 'state';$report.model=$state.profile.model
    if($report.model -ne 'nvidia/nemotron-3-super-120b-a12b:free'){throw 'Wrong packaged model'}
    $window.Left=-20000;$window.Top=0;$window.ShowInTaskbar=$false
    $window.Show();[Windows.Forms.Application]::DoEvents()
    $ns=New-Object Xml.XmlNamespaceManager($xml.NameTable);$ns.AddNamespace('x','http://schemas.microsoft.com/winfx/2006/xaml')
    foreach($node in $xml.SelectNodes('//*[@x:Name]',$ns)){
        $name=$node.GetAttribute('Name','http://schemas.microsoft.com/winfx/2006/xaml')
        if($name.StartsWith('Nav') -and (F $name) -is [Windows.Controls.RadioButton]){
            Click-TestButton $name;$window.UpdateLayout();$report.pages+=$name.Substring(3)
        }
    }
    foreach($pair in @(@('BtnGiaoViecSoan','TxtYChinh'),@('BtnGiaoViecNV','TxtYChinhNV'),@('BtnGiaoViecKT','TxtYChinhKT'),@('BtnGiaoViecCN','TxtYChinhCN'),@('BtnGiaoViecDV','TxtYChinhDV'),@('BtnGiaoViecBGH',''),@('BtnGiaoViecTo',''),@('BtnGiaoViecDang',''),@('BtnTraCuu','TxtCauHoi'))){
        # School's lookup button opens its local legal library, not AI chat.
        if($env:TROLY_VERIFY_APP -eq 'school' -and $pair[0] -eq 'BtnTraCuu'){continue}
        if(F $pair[0]){
            if($pair[1] -and (F $pair[1])){(F $pair[1]).Text='Kiem thu yeu cau AI'}
            Click-TestButton $pair[0]
            if([string]::IsNullOrWhiteSpace((F 'TxtHoi').Text)){throw "Button did not prepare a prompt: $($pair[0])"}
            $report.buttons+=$pair[0]
        }
    }
    if($env:TROLY_VERIFY_APP -eq 'school'){
        $mission=@(Api 'missions')[0];Start-Mission $mission
        if([string]::IsNullOrWhiteSpace((F 'TxtHoi').Text)){throw 'Mission did not prepare prompt'}
        $report.buttons+='mission'
    }
    Click-TestButton 'BtnViecMoiNho'
    if($script:session){throw 'New conversation did not clear the current session'}
    $report.buttons+='BtnViecMoiNho'
    $script:session=$null;$script:attachments=@();$script:answerCount=0
    Show-Page 'TroChuyen'
    (F 'TxtHoi').Text='Soan 3 gach dau dong bang tieng Viet ve ke hoach to chuc ngay doc sach trong truong. Du lieu gia lap; khong dung ten nguoi. Toi da 80 tu.'
    $clock=[Diagnostics.Stopwatch]::StartNew()
    Click-TestButton 'BtnGuiHoi';$clock.Stop()
    if($clock.Elapsed.TotalSeconds -gt 10){throw 'Send button blocked the UI'}
    $report.checks+=@{name='nonblocking_send';status='passed';seconds=$clock.Elapsed.TotalSeconds}
    $answer=Wait-TestAnswer
    if($answer.Length -lt 20){throw 'Draft response is empty or too short'}
    $report.checks+=@{name='draft_via_send_button';chars=$answer.Length;status='passed'}
    $file=$env:TROLY_VERIFY_DOCUMENT
    # Replace only the OS file picker; invoke the app's real review-button handler.
    function Pick-Files {return $env:TROLY_VERIFY_DOCUMENT}
    function Select-Files {param($filter,[switch]$Multiple) return $env:TROLY_VERIFY_DOCUMENT}
    Click-TestButton 'BtnRaSoatFile'
    $report.buttons+='BtnRaSoatFile'
    $paths=if($env:TROLY_VERIFY_APP -eq 'school'){@($script:attachments | ForEach-Object {$_.path})}else{@($script:attachments)}
    if($paths -notcontains $file){throw 'Review button lost its selected attachment'}
    $selectedId=if($env:TROLY_VERIFY_APP -eq 'school'){$script:session.id}else{$script:session}
    $selected=@((Api 'state').chat | Where-Object {$_.id -eq $selectedId}) | Select-Object -First 1
    $script:answerCount=@($selected.messages | Where-Object {$_.role -eq 'assistant'}).Count
    (F 'TxtHoi').Text='Doc tai lieu dinh kem. Chi tra loi ma kiem thu va so hoc sinh trong tai lieu.'
    Click-TestButton 'BtnGuiHoi';$answer=Wait-TestAnswer
    if($answer -notmatch 'AI-CHECK-7429' -or $answer -notmatch '128'){throw 'Attachment content did not reach the model'}
    $report.checks+=@{name='docx_attachment';status='passed'}
    $script:attachments=@()
    (F 'TxtHoi').Text='Khong doc file moi: nhac lai ma kiem thu trong cau tra loi truoc, chi ghi ma.'
    Click-TestButton 'BtnGuiHoi';$answer=Wait-TestAnswer
    if($answer -notmatch 'AI-CHECK-7429'){throw 'Conversation context was lost'}
    $report.checks+=@{name='conversation_history';status='passed'}
    $export=Api 'export' @{format='docx';title='AI verification';body=$answer}
    if(-not (Test-Path $export.path)){throw 'AI result Word export failed'}
    $report.checks+=@{name='export_word';status='passed'}
    if($script:errors -and $script:errors.Count){throw ($script:errors -join "`n")}
    $script:verifyExitCode=0
} catch {
    $report.errors+=($_.Exception.ToString()+"`n"+$_.ScriptStackTrace)
} finally {
    if($env:TROLY_AI_REPORT){[IO.File]::WriteAllText($env:TROLY_AI_REPORT,($report | ConvertTo-Json -Depth 8),[Text.Encoding]::UTF8)}
    if($timer){$timer.Stop()}
    $window.Close()
}
