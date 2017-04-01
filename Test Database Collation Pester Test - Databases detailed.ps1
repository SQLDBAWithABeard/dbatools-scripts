Describe "Testing Database Collation" {
    $SQLServers = (Get-VM -ComputerName HYPERV Server | Where-Object {$_.Name -like '*SQL*' -and $_.State -eq 'Running'}).Name
    foreach($Server in $SQLServers)
    {
        $CollationTests = Test-DbaDatabaseCollation -SqlServer $Server -Detailed
        foreach($CollationTest in $CollationTests)
        {
            It "$($Collationtest.Server) database $($CollationTest.Database) should have the correct collation of $($CollationTest.ServerCollation)" {
                $CollationTest.DatabaseCollation | Should Be $CollationTest.ServerCollation
            }
        }
    }
}