use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- Opens the selected tracks in MusicBrainz Picard (https://picard.musicbrainz.org)
-- Tracks stored in iCloud can't be opened in Picard if they haven't been downloaded to the computer. If the script can't get the file location it will assume the track is in iCloud and will offer to download it.

-- Written by Isaac Nelson (canalnoises@me.com)
-- Last update 2 Sep 2019

--Quit Picard if it is already running
try
	tell application "MusicBrainz Picard" to quit
end try

tell application "iTunes"
	set sel to selection
	repeat with t in sel
		
		try
			get location of t
		on error
			display dialog "Couldn't get location of " & name of selection & return & return & "Do you want to try downloading it from iCloud?" buttons {"Cancel", "Download"}
			if button returned of result is "Download" then
				download selection
			else if button returned of result is "Cancel" then
				return
			end if
		end try
		
		set trackFile to location of t
		set trackFile to POSIX path of trackFile
		
		tell application "Finder"
			do shell script "open -b org.musicbrainz.picard " & quoted form of trackFile --MusicBrainz Picard 1.x, 2.1.x
			--do shell script "open -b 'MusicBrainz Picard' " & quoted form of trackFile --MusicBrains Picard 2.0.x
		end tell
	end repeat
	delay 2
	
	tell application "System Events"
		repeat 6 times
			keystroke tab
		end repeat
		keystroke "a" using command down --select all files
		keystroke "u" using command down --cluster files
		delay 1
		keystroke "y" using command down --scan selected files
		delay 2
		keystroke tab
		key code 125 --down arrow
		key code 124 --right arrow
	end tell
	
end tell
