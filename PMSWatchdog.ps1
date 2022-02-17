# JG 2/16/2022
# Powershell script that checks whether the local plex website is responding correctly, and restarts the process if not.
# Create 2 tasks in Task Scheduler:
#  1) "Plex Media Server" To start Plex Media Server at system startup.
#    a) Action = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"
#  2) "Plex Watchdog" To run this script every 5 minutes, check "Run whether user is logged on or not" to avoid a powershell window.
#    a) Action = powershell -File "C:\xxxxxxxx\PMSWatchdog.ps1"
# Based on https://github.com/Suron12/PlexWatchdogScript
#
$HTTP_Request = [System.Net.WebRequest]::Create('http://localhost:32400/web/index.html')
$HTTP_Request.Timeout = 15000
$HTTP_Response = try {$HTTP_Request.GetResponse()} catch {"Webpage Timeout"}
$HTTP_Status = try {[int]$HTTP_Response.StatusCode} catch {"Webpage Timeout"}
$mypath = $MyInvocation.MyCommand.Path # Get the path of the currently running ps1 script
$log_path = Split-Path $mypath -Parent

function WriteLog
{
    Param ([string]$LogString)
    $LogFile = -join($log_path, "\PMSWatchdog.log" ) # Create the log file in the same folder as the .ps1 file
    $DateTime = Get-Date -Format "[dddd MM/dd/yy hh:mm:ss tt]" 
    $LogMessage = "$Datetime $LogString"
    Add-content $LogFile -value $LogMessage
}

If ($HTTP_Status -eq 200) { 
    WriteLog "Plex is responding correctly" # Comment this out if you only want to log when Plex fails
}
Else {
    WriteLog "Plex is not responding! Restarting Plex ..."; 
    Stop-Process -processname "Plex Media Server" -ErrorAction Ignore
    Start-ScheduledTask "\Jason\Plex Media Server"
    Start-Sleep -Seconds 5
}

