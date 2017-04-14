## This is getting a list of server name from Hyper-V - You can chagne this to a list of SQL instances
$SQLServers = (Get-VM -ComputerName beardnuc | Where-Object {$_.Name -like '*SQL*' -and $_.Name -ne 'SQL2008Ser2008' -and $_.State -eq 'Running'}).Name
foreach($SQLServer in $SQLServers)
{
    Describe "$SQLServer - Testing how full the Identity columns are" {
            $dbs = (Connect-DbaSqlServer -SqlServer $SQLServer).Databases.Name
            foreach($db in $dbs)
            {
                Context "Testing $db" {
                $Tests = Test-DbaIdentityUsage -SqlInstance $SQLServer -Databases $db -WarningAction SilentlyContinue
                foreach($test in $tests)
                {
                    It "$($test.Column) identity column in $($Test.Table) is less than 90% full" {
                        $Test.PercentUsed | Should BeLessThan 90
                    }
                }
            }
        }
    }
}