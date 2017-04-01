
Describe "Testing Last Known Good DBCC" {
    $SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name
    $testCases= @()
    $SQLServers.ForEach{$testCases += @{Name = $_}}
    It "<Name> databases have all had a successful CheckDB" -TestCases $testCases {
        Param($Name)
        $DBCC = Get-DbaLastGoodCheckDb -SqlServer $Name -Detailed
        ($DBCC.LastGoodCheckDb -contains $null) | Should Be $false
    }
    It "<Name> databases have all had a CheckDB run in the last 3 days" -TestCases $testCases {
        Param($Name)
        $DBCC = Get-DbaLastGoodCheckDb -SqlServer $Name -Detailed
        ($DBCC | Measure-Object -Property  DaysSinceLastGoodCheckdb -Maximum).Maximum | Should BeLessThan 3
    }

}