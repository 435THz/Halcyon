--[[
    init.lua
    Created: 06/28/2021 23:00:22
    Description: Autogenerated script file for the map guild_heros_room.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.guild_heros_room.guild_heros_room_ch_1'
require 'ground.guild_heros_room.guild_heros_room_ch_2'
require 'ground.guild_heros_room.guild_heros_room_ch_3'
require 'ground.guild_heros_room.guild_heros_room_helper'


-- Package name
local guild_heros_room = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_heros_room.Init
--Engine callback function
function guild_heros_room.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_heros_room<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


end

---guild_heros_room.Enter
--Engine callback function
function guild_heros_room.Enter(map)
	guild_heros_room.PlotScripting()
end

---guild_heros_room.Exit
--Engine callback function
function guild_heros_room.Exit(map)


end

---guild_heros_room.Update
--Engine callback function
function guild_heros_room.Update(map)


end

function guild_heros_room.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_heros_room.PlotScripting()
end

function guild_heros_room.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_heros_room.PlotScripting()
	--if generic morning is flagged, prioritize that.
	if SV.TemporaryFlags.MorningWakeup or SV.TemporaryFlags.Bedtime then 
		if SV.TemporaryFlags.Bedtime then guild_heros_room_helper.Bedtime(true) end
		if SV.TemporaryFlags.MorningWakeup then guild_heros_room_helper.Morning(true) end
	else
		--plot scripting
		if SV.ChapterProgression.Chapter == 1 then
			if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then
				guild_heros_room_ch_1.RoomIntro()
			else
				GAME:FadeIn(20)
			end		
		elseif SV.ChapterProgression.Chapter == 2 then
			if not SV.Chapter2.FirstMorningMeetingDone then 
				guild_heros_room_ch_2.FirstMorning()
			elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then
				guild_heros_room_ch_2.FirstNightBedtalk()
			elseif SV.Chapter2.FinishedRiver then
				guild_heros_room_ch_2.PostRiverBedtalk()
			else
				GAME:FadeIn(20)
			end
		elseif SV.ChapterProgression.Chapter == 3 then 
			if not SV.Chapter3.ShowedTitleCard then 
				guild_heros_room_ch_3.FirstMorning()
			elseif SV.Chapter3.DefeatedBoss and not SV.Chapter3.RootSceneTransition then
				guild_heros_room_ch_3.PostOutlawBedtalkFirstHalf()
			elseif SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene then
				guild_heros_room_ch_3.PostOutlawBedtalkSecondHalf()
			else
				GAME:FadeIn(20)
			end
		else
			GAME:FadeIn(20)
		end
	end
end



function guild_heros_room.Book_Action(obj, activator)
	UI:ResetSpeaker(false)
	local hero = GAME:GetPlayerPartyMember(0)
	local partner = GAME:GetPlayerPartyMember(1)
	local hero_ground = CH('PLAYER')
	local partner_ground = CH('Teammate1')
	partner_ground.IsInteracting = true
	GROUND:CharSetAnim(partner_ground, 'None', true)
	GROUND:CharSetAnim(hero_ground, 'None', true)		
    GeneralFunctions.TurnTowardsLocation(hero_ground, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
    GeneralFunctions.TurnTowardsLocation(partner_ground, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
	
	
	
	local choices = {"Change nicknames", "Change team name", "Nothing"}
	UI:BeginChoiceMenu("What would you like to do?", choices, 1, #choices)
	UI:WaitForChoice()
	local choice_result = UI:ChoiceResult()
	
	if choice_result ~= #choices then
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Opening', 0, 0, 0, Direction.Left)	  
	    GROUND:ObjectSetAnim(obj, 6, 0, 3, Direction.Left, 1)
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Opening', 0, 3, 3, Direction.Left)
		GAME:WaitFrames(40)
	end
	
	if choice_result == 1 then
		UI:BeginChoiceMenu("Whose name would you like to change?", {hero_ground:GetDisplayName(), partner_ground:GetDisplayName(), "Neither"}, 1, 3)
		UI:WaitForChoice()
		local name_result = UI:ChoiceResult()

		if name_result == 1 then
			local name = hero.Nickname
			UI:NameMenu("What is your name?", "Press " .. STRINGS:LocalKeyString(9) .. " to keep the old nickname.", 60)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			--if no name given, set name to previous name
			if result == "" then result = name end
			GAME:SetCharacterNickname(hero, result)
			UI:WaitShowDialogue("Your name is now " .. hero_ground:GetDisplayName() .. "!")
		elseif name_result == 2 then
			local name = partner.Nickname
			UI:NameMenu("What is your partner's name?", "Press " .. STRINGS:LocalKeyString(9) .. " to keep the old nickname.", 60)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			--if no name given, set name to previous name
			if result == "" then result = name end
			GAME:SetCharacterNickname(partner, result)
			UI:WaitShowDialogue("Your partner's name is now " .. partner_ground:GetDisplayName() .. "!")
		end
		
	elseif choice_result == 2 then
		local name = _DATA.Save.ActiveTeam.Name
		UI:NameMenu("What is your team's name?", "Press " .. STRINGS:LocalKeyString(9) .. " to keep the old team name.", 60)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		--if no name given, set name to previous name
		if result == "" then result = name end
		GAME:SetTeamName(result)
		UI:WaitShowDialogue("Your team's name is now Team " .. GAME:GetTeamName() .. "!")
	end
	
	if choice_result ~= #choices then
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Closing', 0, 0, 0, Direction.Left)
		GROUND:ObjectSetAnim(obj, 6, 0, 3, Direction.Left, 1)
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Closing', 0, 3, 3, Direction.Left)	  
	end
	
end



---------------------------------
-- Event Trigger
-- This is a temporary object created by a script used to trigger events that only happen
-- once, typically a cutscene of sorts for a particular chapter.
---------------------------------
function guild_heros_room.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_heros_room_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end













function guild_heros_room.Save_Point_Touch(obj, activator)
	if SV.ChapterProgression.Chapter == 1 then
		guild_heros_room_ch_1.Save_Bed_Dialogue(obj, activator)--partner talks to you a bit in chapter 1 before you try to save, as going to sleep is the trigger to end the chapter
	else
		GeneralFunctions.PromptSaveAndQuit()
	end
end
-------------------------------


-- Entities Callbacks
-------------------------------
function guild_heros_room.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

---------------------------
-- Map Transitions
---------------------------
function guild_heros_room.Bedroom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.TemporaryFlags.JustWokeUp then --skip the hallway if we just woke up and queue up the morning 
	GAME:FadeOut(false, 40)--longer fade out because we're about to go into a cutscene
	SV.TemporaryFlags.JustWokeUp = false
	--SV.TemporaryFlags.MorningAddress = true
	GAME:EnterGroundMap("guild_third_floor_lobby", "Guild_Third_Floor_Lobby_Right_Marker")
	SV.partner.Spawn = 'Guild_Third_Floor_Lobby_Right_Marker_Partner'
  else
	GAME:FadeOut(false, 20)--shorter fade out for generic exit
	GAME:EnterGroundMap("guild_bedroom_hallway", "Guild_Bedroom_Hallway_Right_Marker")
	SV.partner.Spawn = 'Guild_Bedroom_Hallway_Right_Marker_Partner'
  end
end

return guild_heros_room

