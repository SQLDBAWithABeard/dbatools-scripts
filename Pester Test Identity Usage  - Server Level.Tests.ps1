# Requires -Version 4
# Requires module dbatools
Describe "Testing how full the Identity columns are" -Tag Server,Identity {
## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
$SQLServers = (Get-VM -ComputerName $Config.IdentityServer.HyperV -ErrorAction SilentlyContinue| Where-Object {$_.Name -like "*$($Config.IdentityServer.NameSearch)*" -and $_.State -eq 'Running'}).Name
if(!$SQLServers){Write-Warning "No Servers to Look at - Check the config.json"}
$testCases= @()
$SQLServers.ForEach{$testCases += @{Name = $_}}
It "<Name> databases all have identity columns less than $($Config.IdentityServer.Percent) % full" -TestCases $testCases  -Skip:$($Config.IdentityServer.Skip){
Param($Name)
(Test-DbaIdentityUsage -SqlInstance $Name -Threshold $($Config.IdentityServer.Percent) -WarningAction SilentlyContinue).PercentUsed | Should Be
}
}