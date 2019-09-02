use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property appletTitle : "iTunes Video Shuffle"

on run
	tell application "iTunes"
		
		display dialog "Whacha wanna watch?" buttons {"📺 TV Show", "🎲 RANDOM!", "🎬 Movie"} default button 2 with title appletTitle with icon note
		
		if button returned of result is "🎲 RANDOM!" then
			set theChoice to some item of {"📺 TV Show", "🎬 Movie"} as text
			if theChoice is "🎬 Movie" then
				my random_movie()
			else if theChoice is "📺 TV Show" then
				set options to "noOptions"
				my random_TVshow(options)
			end if
			
			
		else if button returned of result is "📺 TV Show" then
			set options to "withOptions"
			my random_TVshow(options)
		else if button returned of result is "🎬 Movie" then
			my random_movie()
		end if
		
		
		
	end tell
end run

on random_TVshow(options)
	tell application "iTunes"
		set tvShows to my get_TVshows()
		
		repeat
			if options is "withOptions" then
				
				set showRange to choose from list tvShows default items (items of tvShows) with prompt "Choose one or more TV shows" with title appletTitle with multiple selections allowed
				
				if showRange is false then return
				
				if (count of showRange) is 1 then
					set showSelection to showRange as text
					
					--get list of season numbers from iTunes
					set seasonsList to my get_seasons(showSelection)
					
					--offer list of seasons to pick from
					if seasonsList as text is not "0" then
						set seasonRange to choose from list seasonsList default items (items of seasonsList) with prompt "Choose one or more seasons" with title appletTitle with multiple selections allowed
					else
						set seasonRange to "0"
					end if
					
					if seasonRange is false then return
					
					set seasonSelection to some item of seasonRange --pick a random season from the selection
					
					set episodeList to name of (every track of playlist "TV Shows" whose show is showSelection and season number is seasonSelection) --get list of episodes from iTunes.
					
					set episodeSelection to some item of episodeList --pick a random episode from that list
					
				else
					--If more than one show was selected, pick a random episode of a random show among that selection
					set showSelection to some item of showRange
					
					set episodeSelection to name of some item of (every track of playlist "TV Shows" whose show is showSelection)
					set seasonSelection to season number of track episodeSelection of playlist "TV Shows"
					
				end if
				
				--show which episode has been picked, ask for confirmation or to pick another random episode
				if seasonSelection as text is not "0" then
					set confirmShow to showSelection & " Season " & seasonSelection
				else
					set confirmShow to showSelection
				end if
				
			else if options is "noOptions" then
				set episodeSelection to name of some track of playlist "TV Shows"
				set confirmShow to (get show of track episodeSelection of playlist "TV Shows")
				
			end if
			display alert confirmShow message "Episode: " & episodeSelection buttons {"🎲", "Watch Now", "Close"} default button 2 cancel button 3
			if button returned of result is "Watch Now" then
				exit repeat
			else
				if button returned of result is "Close" then return
			end if
		end repeat
		
		activate
		play track episodeSelection of playlist "TV Shows"
		
		return
		
	end tell
end random_TVshow

on get_TVshows()
	--Adapted from https://stackoverflow.com/a/43312010
	tell application "iTunes"
		tell tracks of playlist "TV Shows" to set {all_shows} to {show} --Get all shows
	end tell
	
	--Filter out duplicates
	return my filter_duplicates(all_shows)
end get_TVshows

on get_seasons(theShow)
	tell application "iTunes" to set seasonsList to season number of (every track of playlist "TV Shows" whose show is theShow)
	set seasonsList to my filter_duplicates(seasonsList) --get rid of duplicates
	return seasonsList
end get_seasons

on get_Movies()
	
	tell application "iTunes"
		set moviesList to name of tracks of playlist "Movies"
	end tell
	
end get_Movies

on random_movie()
	tell application "iTunes"
		repeat
			set movieSelection to some item of my get_Movies()
			set movieYear to year of track movieSelection of playlist "Movies"
			set movieLength to time of track movieSelection of playlist "Movies"
			display alert movieSelection & " (" & movieYear & ")" message "Length: " & movieLength buttons {"🎲", "Watch Now", "Close"} default button 2 cancel button 3
			if button returned of result is "Watch Now" then
				exit repeat
			else
				if button returned of result is "Close" then return
			end if
		end repeat
		activate
		tell playlist "Movies" to play track movieSelection
	end tell
end random_movie

on filter_duplicates(theList)
	--Adapted from https://stackoverflow.com/a/43312010
	set uniqueItems to {}
	repeat with i from 1 to count items in theList
		set currentItem to item i of theList
		if currentItem is not equal to "" and currentItem is not in uniqueItems then
			set end of uniqueItems to currentItem
		end if
	end repeat
	return uniqueItems
end filter_duplicates
