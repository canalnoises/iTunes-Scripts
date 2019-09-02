use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- Combine Play Count
-- Isaac Nelson 18 Apr 2018

set totalPlays to 0
set songList to ""

tell application "iTunes"
	
	display alert "Combine play count or sync play count?" buttons {"Cancel", "Combine", "Sync"} cancel button 1
	if button returned of result is "Combine" then
		set sel to selection
		repeat with i from 1 to count items in sel
			set thisSong to (item i of sel)
			set thisPlaycount to (played count of thisSong)
			set totalPlays to totalPlays + thisPlaycount
			set songList to songList & return & "\"" & (name of thisSong as text) & "\" on " & (artist of thisSong as text) & "'s album \"" & (album of thisSong as text) & "\"" & return
		end repeat
		display alert "The play count of these songs will be each set to their combined count (" & totalPlays & "):" message songList buttons {"Cancel", "OK"} cancel button 1
		if button returned of result is "OK" then
			repeat with i from 1 to count items in sel
				set played count of item i of sel to totalPlays
			end repeat
		end if
		
	else if button returned of result is "Sync" then
		set sel to selection
		repeat with i from 1 to count items in sel
			set thisSong to (item i of sel)
			set thisPlaycount to (played count of thisSong)
			if thisPlaycount > totalPlays then
				set totalPlays to thisPlaycount
			end if
			set songList to songList & return & "\"" & (name of thisSong as text) & "\" on " & (artist of thisSong as text) & "'s album \"" & (album of thisSong as text) & "\"" & return
			
		end repeat
		display alert "The play count of these songs will be each set to the highest play count of the set (" & totalPlays & "):" message songList buttons {"Cancel", "OK"} cancel button 1
		if button returned of result is "OK" then
			repeat with i from 1 to count items in sel
				set played count of item i of sel to totalPlays
			end repeat
		end if
	end if
	
end tell
