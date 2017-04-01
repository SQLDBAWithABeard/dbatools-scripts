Import-Module dbatools

$TestServer = ''
$Server = ''
$servers = '',''
$Results = $servers.ForEach{Test-DbaLastBackup -SqlServer $_ -Destination $TestServer -MaxMB 5}
Describe "Last Backup Test results - NOTE THIS IGNORES Skipped restores, File Exists and BackupFiles" {
    foreach($result in $results)
    {
        It "$($Result.Database) on $($Result.SourceServer) File Should Exist" {
            $Result.FileExists| Should Not Be 'False'
        }
        It "$($Result.Database) on $($Result.SourceServer) Restore should be Success" {
            $Result.RestoreResult| Should Not Be 'False'
        }
        It "$($Result.Database) on $($Result.SourceServer) DBCC should be Success" {
            $Result.DBCCResult| Should Not Be 'False'
        }
        It "$($Result.Database) on $($Result.SourceServer) Backup Should be less than a week old" {
            $Result.BackupTaken| Should BeGreaterThan (Get-Date).AddDays(-7)
        }
    }
}