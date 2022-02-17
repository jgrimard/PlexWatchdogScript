# PlexWatchdogScript
Powershell scripts that periodically checks whether the local plex related websites are responding correctly, and restarts the services if not.

### To use
Create 2 tasks in Task Scheduler:
<ol>
 <li>"Plex Media Server" To start Plex Media Server at system startup.</li>
   <ul>
   <li>Action = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"</li>
   </ul>
 <li>"Plex Watchdog" To run this script every 5 minutes, check "Run whether user is logged on or not" to avoid a powershell window.</li>
   <ul>
   <li>Action = powershell -File "C:\xxxxxxxx\PMSWatchdog.ps1"</li>
   </ul>
</ol>
