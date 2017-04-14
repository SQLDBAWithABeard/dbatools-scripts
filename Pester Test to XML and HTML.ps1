$Date = Get-Date -Format ddMMyyyHHmmss
$tempFolder = 'c:\temp\BackupTests\'
Push-Location $tempFolder
$XML = $tempFolder + "BackupTestResults_$Date.xml"
$script = 'C:\temp\BackupPester.ps1' # name and location of the pester test - use one of these https://github.com/SQLDBAWithABeard/dbatools-scripts
Invoke-Pester -Script $Script -OutputFile $xml -OutputFormat NUnitXml

#download and extract ReportUnit.exe
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
