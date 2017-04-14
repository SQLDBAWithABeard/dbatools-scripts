# Requires -Version 4
# Requires module dbatools
Describe "Testing Database Collation" -Tag Detailed,Database,Collation{
## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
$SQLServers = (Get-VM -ComputerName $Config.CollationDatabaseDetailed.HyperV -ErrorAction SilentlyContinue| Where-Object {$_.Name -like "*$($Config.CollationDatabaseDetailed.NameSearch)*" -and $_.State -eq 'Running'}).Name
if(!$SQLServers){Write-Warning "No Servers to Look at - Check the config.json"}
foreach($Server in $SQLServers)
{
$CollationTests = Test-DbaDatabaseCollation -SqlServer $Server -Detailed
foreach($CollationTest in $CollationTests)
{
It "$($Collationtest.Server) database $($CollationTest.Database) should have the correct collation of $($CollationTest.ServerCollation)" -Skip:$($Config.CollationDatabaseDetailed.Skip){
$CollationTest.DatabaseCollation | Should Be $CollationTest.ServerCollation
}
}
}
}