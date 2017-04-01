Describe "Testing Last Known Good DBCC" {
    $SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name
    foreach($Server in $SQLServers)
    {
        $DBCCTests = Get-DbaLastGoodCheckDb -SqlServer $Server -Detailed
        foreach($DBCCTest in $DBCCTests)
        {
            It "$($DBCCTest.Server) database $($DBCCTest.Database) had a successful CheckDB"{
            $DBCCTest.Status | Should Be 'Ok'
            }
            It "$($DBCCTest.Server) database $($DBCCTest.Database) had a CheckDB run in the last 3 days" {
            $DBCCTest.DaysSinceLastGoodCheckdb | Should BeLessThan 3
            }   
            It "$($DBCCTest.Server) database $($DBCCTest.Database) has Data Purity Enabled" {
            $DBCCTest.DataPurityEnabled| Should Be $true
            }    
        }
    }
}