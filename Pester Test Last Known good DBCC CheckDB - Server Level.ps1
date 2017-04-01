
Describe "Testing Last Known Good DBCC" {
    $SQLServers = (Get-VM -ComputerName HYPERVServer | Where-Object {$_.Name -like '*SQL*' -and $_.State -eq 'Running'}).Name
    $testCases= @()
    $SQLServers.ForEach{$testCases += @{Name = $_}}
    It "<Name> databases have all had a successful CheckDB within the last 7 days" -TestCases $testCases {
        Param($Name)
        $DBCC = Get-DbaLastGoodCheckDb -SqlServer $Name -Detailed
        $DBCC.Status -contains 'New database, not checked yet'| Should Be $false
        $DBCC.Status -contains 'CheckDb should be performed'| Should Be $false
    }
}