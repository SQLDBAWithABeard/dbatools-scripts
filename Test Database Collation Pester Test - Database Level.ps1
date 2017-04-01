
Describe "Testing Database Collation" {
    $SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name
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