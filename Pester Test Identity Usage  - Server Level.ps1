Describe "Testing how full the Identity columns are" {
## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
$SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name

$testCases= @()
$SQLServers.ForEach{$testCases += @{Name = $_}}
It "<Name> databases all have identity columns less than 90% full" -TestCases $testCases {
Param($Name)
(Test-DbaIdentityUsage -SqlInstance $Name -Threshold 90 -WarningAction SilentlyContinue).PercentUsed | Should Be
}
}