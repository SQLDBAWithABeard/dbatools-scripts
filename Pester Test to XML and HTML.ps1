$Date = Get-Date -Format ddMMyyyHHmmss
$tempFolder = 'c:\temp\BackupTests\'
$pesterLocation = 'GIT:\dbatools-scripts'
Push-Location $tempFolder
$XML = $tempFolder + "TestResults_$Date.xml"
$script = 'C:\temp\BackupPester.ps1' # name and location of the pester test - use one of these https://github.com/SQLDBAWithABeard/dbatools-scripts
cd $pesterLocation
Invoke-Pester -Tag Server -OutputFile $xml -OutputFormat NUnitXml # You can use Server, Database, Detailed, Backup, DBCC, Column, Identity, Collation

#download and extract ReportUnit.exe
Push-Location $tempFolder
$url = 'http://relevantcodes.com/Tools/ReportUnit/reportunit-1.2.zip'
$fullPath = Join-Path $tempFolder $url.Split("/")[-1]
$reportunit = $tempFolder + '\reportunit.exe'
if((Test-Path $reportunit) -eq $false)
{
(New-Object Net.WebClient).DownloadFile($url,$fullPath)
Expand-Archive -Path $fullPath -DestinationPath $tempFolder
}

#run reportunit against report.xml and display result in browser
$HTML = $tempFolder  + 'index.html'
& .\reportunit.exe $tempFolder
Invoke-Item $HTML
