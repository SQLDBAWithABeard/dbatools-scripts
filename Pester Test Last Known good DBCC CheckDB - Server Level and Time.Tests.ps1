# Requires -Version 4
# Requires module dbatools
Describe "Testing Last Known Good DBCC" -Tag Detailed,DBCC{
        if($($Config.DBCCServerTime.Skip))
        {
            continue
        }
 ## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
$SQLServers = (Get-VM -ComputerName $Config.DBCCServerTime.HyperV -ErrorAction SilentlyContinue| Where-Object {$_.Name -like "*$($Config.DBCCServerTime.NameSearch)*" -and $_.State -eq 'Running'}).Name
if(!$SQLServers){Write-Warning "No Servers to Look at - Check the config.json"}
 $testCases= @()
    $SQLServers.ForEach{$testCases += @{Name = $_}}
    It "<Name> databases have all had a successful CheckDB" -TestCases $testCases {
        Param($Name)
        $DBCC = Get-DbaLastGoodCheckDb -SqlServer $Name -Detailed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        ($DBCC.LastGoodCheckDb -contains $null) | Should Be $false
    }
    It "<Name> databases have all had a CheckDB run in the last $($Config.DBCCServerTime.Daysold) days" -TestCases $testCases {
        Param($Name)
        $DBCC = Get-DbaLastGoodCheckDb -SqlServer $Name -Detailed -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        ($DBCC | Measure-Object -Property  DaysSinceLastGoodCheckdb -Maximum).Maximum | Should BeLessThan  $($Config.DBCCServerTime.Daysold) 
    }

}