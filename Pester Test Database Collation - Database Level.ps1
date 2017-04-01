
Describe "Testing Database Collation" {
    $SQLServers = (Get-VM -ComputerName HYPERVServer | Where-Object {$_.Name -like '*SQL*' -and $_.State -eq 'Running'}).Name
    foreach($Server in $SQLServers)
    {
        $CollationTests = Test-DbaDatabaseCollation -SqlServer $Server
        foreach($CollationTest in $CollationTests)
        {
            It "$($Collationtest.Server) database $($CollationTest.Database) should have the correct collation" {
                $CollationTest.IsEqual | Should Be $true
            }
        }
    }
}