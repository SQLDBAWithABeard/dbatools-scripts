
Describe "Testing Database Collation" {
    $SQLServers = (Get-VM -ComputerName HYPERVServer | Where-Object {$_.Name -like '*SQL*' -and $_.State -eq 'Running'}).Name
    $testCases= @()
    $SQLServers.ForEach{$testCases += @{Name = $_}}
    It "<Name> databases have the right collation" -TestCases $testCases {
        Param($Name)
        $Collation = Test-DbaDatabaseCollation -SqlServer $Name
        $Collation.IsEqual -contains $false | Should Be $false
    }

}