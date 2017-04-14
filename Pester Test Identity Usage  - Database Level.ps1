Describe "Testing how full the Identity columns are" {
    ## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
    $SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name
    foreach($SQLServer in $SQLServers)
    {
        Context "Testing $SQLServer" {
            $dbs = (Connect-DbaSqlServer -SqlServer $SQLServer).Databases.Name
            foreach($db in $dbs)
            {
                It "$db on $SQLServer identity columns are less than 90% full" {
                    (Test-DbaIdentityUsage -SqlInstance $SQLServer -Databases $db -Threshold 90 -WarningAction SilentlyContinue).PercentUsed | Should Be
                }
            }
        }
    }
}