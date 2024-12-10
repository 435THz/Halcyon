--[[
    init.lua
    Created: 06/28/2021 23:00:22
    Description: Autogenerated script file for the map guild_heros_room.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_ch_1'
require 'halcyon.ground.guild_heros_room.guild_heros_room_ch_2'
require 'halcyon.ground.guild_heros_room.guild_heros_room_ch_3'
require 'halcyon.ground.guild_heros_room.guild_heros_room_ch_4'
require 'halcyon.ground.guild_heros_room.guild_heros_room_ch_5'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'


-- Package name
local guild_heros_room = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---guild_heros_room.Init
--Engine callback function
function guild_heros_room.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_heros_room<<=')
	
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

--Check if a new story event needs to be triggered for a generic day end
function guild_heros_room.CheckTriggerEvent()
	
	--once bronze rank is obtained in chapter 3, flag chapter 4 to start.
	if SV.ChapterProgression.Chapter == 3 and SV.Chapter3.DefeatedBoss and _DATA.Save.ActiveTeam.Rank ~= "normal" and not SV.TemporaryFlags.Bedtime then
		SV.ChapterProgression.Chapter = 4
		SV.ChapterProgression.UnlockedAssembly = true
		SV.TemporaryFlags.MorningAddress = false--unflag the generic address so the special one can play 
		SV.TemporaryFlags.MorningWakeup = false--unflag the generic wakeup so the card can play out properly
		SV.ChapterProgression.CurrentStoryDungeon = "apricorn_grove" 
		SV.Dojo.NewMazeUnlocked = true
		SV.metano_cafe.NewDrinkUnlocked = true
		GAME:UnlockDungeon("apricorn_grove")
		GAME:UnlockDungeon("flying_maze")--unlock new mazes at ledian dojo
		GAME:UnlockDungeon("rock_maze")--unlock new mazes at ledian dojo
		GAME:WaitFrames(60)
		GeneralFunctions.PromptChapterSaveAndQuit("guild_heros_room", "Main_Entrance_Marker", 2)
	end
	
	--Start Chapter 5 a few in game days after beating Apricorn Grove.
	if SV.ChapterProgression.Chapter == 4 and SV.Chapter4.FinishedGrove and SV.ChapterProgression.DaysPassed >= SV.ChapterProgression.DaysToReach then
		SV.ChapterProgression.Chapter = 5
		SV.TemporaryFlags.MorningAddress = false--unflag the generic address so the special one can play 
		SV.TemporaryFlags.MorningWakeup = false--unflag the generic wakeup so the card can play out properly
		SV.ChapterProgression.CurrentStoryDungeon = ""--clear this; it won't be needed for the expedition
		SV.Dojo.NewMazeUnlocked = true
		--SV.metano_cafe.NewDrinkUnlocked = true
		--GAME:UnlockDungeon("apricorn_grove")
		GAME:UnlockDungeon("electric_maze")--unlock new mazes at ledian dojo
		GAME:UnlockDungeon("bug_maze")--unlock new mazes at ledian dojo
		GAME:WaitFrames(60)
		GeneralFunctions.PromptChapterSaveAndQuit("guild_heros_room", "Main_Entrance_Marker", 2)
	end
		
end

function guild_heros_room.PlotScripting()
	--if generic morning is flagged, prioritize that.
	if SV.TemporaryFlags.MorningWakeup or SV.TemporaryFlags.Bedtime then 
		if SV.TemporaryFlags.Bedtime then guild_heros_room_helper.Bedtime(true) end
	
		--Does a new story event need to be triggered?
		guild_heros_room.CheckTriggerEvent()
	
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
			if not SV.Chapter2.FinishedFirstWakeup then 
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
		elseif SV.ChapterProgression.Chapter == 4 then
			if not SV.Chapter4.ShowedTitleCard then 
				guild_heros_room_ch_4.ShowTitleCard()
			elseif SV.Chapter4.FinishedGrove and not SV.Chapter4.FinishedBedtimeCutscene then
				guild_heros_room_ch_4.PostGroveBedtalk()	
			else
				GAME:FadeIn(20)
			end
		elseif SV.ChapterProgression.Chapter == 5 then 
			if not SV.Chapter5.ShowedTitleCard then
				guild_heros_room_ch_5.ShowTitleCard()
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
	
	--Change where the choice menu goes; put it on the left because of placement of book in the map.
	--UI:SetChoiceLoc(8, 102)
	
	local choices = {"Change scarves", "Change nicknames", "Change team name", "Check rank", "Nothing"}
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
		local state = 1
		while state > 0 do
			UI:BeginChoiceMenu("Whose scarf would you like to change?", {hero_ground:GetDisplayName(), partner_ground:GetDisplayName(), "Neither"}, 1, 3)
			UI:WaitForChoice()
			local chara_choice = UI:ChoiceResult()
			local chara
			
			if chara_choice == 1 then 
				chara = hero_ground
			elseif chara_choice == 2 then
				chara = partner_ground
			else
				state = -1
				break
			end
			
			--check if sprites exist for that pokemon
			--Current form updates from base form when a new ground/map is entered. Need to change both so the base form is updated proper, and current form needs to change to visually show it without reloading map.
			local monId = RogueEssence.Dungeon.MonsterID(chara.CurrentForm.Species, chara.CurrentForm.Form, 'normal_black', chara.CurrentForm.Gender)
			local fallback = RogueEssence.Content.GraphicsManager.GetFallbackForm(RogueEssence.Content.GraphicsManager.CharaIndex, monId:ToCharID())
			if fallback.Skin == monId:ToCharID().Skin then			
				UI:BeginChoiceMenu("Which color would you like?", {"Black", "Blue", "Cyan", "Green", "Magenta", "Orange", "Pink", "Purple", "Red", "White", "Yellow", "No scarf"}, 1, 12)
				UI:WaitForChoice()
				local scarf_choice = UI:ChoiceResult()
				local current_skin = chara.CurrentForm.Skin
				local new_skin
				if scarf_choice == 1 then
					new_skin = "normal_black"
				elseif scarf_choice == 2 then
					new_skin = "normal_blue"
				elseif scarf_choice == 3 then
					new_skin = "normal_cyan"
				elseif scarf_choice == 4 then
					new_skin = "normal_green"
				elseif scarf_choice == 5 then
					new_skin = "normal_magenta"
				elseif scarf_choice == 6 then
					new_skin = "normal_orange"
				elseif scarf_choice == 7 then
					new_skin = "normal_pink"
				elseif scarf_choice == 8 then
					new_skin = "normal_purple"
				elseif scarf_choice == 9 then
					new_skin = "normal_red"
				elseif scarf_choice == 10 then
					new_skin = "normal_white"
				elseif scarf_choice == 11 then
					new_skin = "normal_yellow"
				elseif scarf_choice == 12 then
					new_skin = "normal"
				else 
					new_skin = current_skin
				end
			
				if new_skin ~= current_skin then 
					GAME:FadeOut(false, 20)
					chara.Data.BaseForm = RogueEssence.Dungeon.MonsterID(chara.CurrentForm.Species, chara.CurrentForm.Form, new_skin, chara.CurrentForm.Gender)
					chara.Data.CurrentForm = RogueEssence.Dungeon.MonsterID(chara.CurrentForm.Species, chara.CurrentForm.Form, new_skin, chara.CurrentForm.Gender)
					GAME:WaitFrames(20)
					SOUND:PlayBattleSE('_UNK_EVT_023')
					GAME:WaitFrames(40)
					GAME:FadeIn(20)
					
					GAME:WaitFrames(40)
					if chara_choice == 1 then
						GeneralFunctions.HeroDialogue(chara, "(Looking good!)", "Normal")
					else
						UI:SetSpeaker(chara)
						UI:WaitShowDialogue("Looking good!")
					end
					GAME:WaitFrames(20)
				end
				
				state = -1
			else
				UI:WaitShowDialogue("There aren't scarf sprites made yet for this Pokémon.[pause=0] Check back later!")
				state = -1
			end

		end 
	
	elseif choice_result == 2 then
		UI:BeginChoiceMenu("Whose name would you like to change?", {hero_ground:GetDisplayName(), partner_ground:GetDisplayName(), "Neither"}, 1, 3)
		UI:WaitForChoice()
		local name_result = UI:ChoiceResult()

		if name_result == 1 then
			local name = hero.Nickname
			UI:NameMenu("What is your name?", "Press [ESC] to keep the old nickname.", 60)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			--if no name given, set name to previous name
			if result == "" then result = name end
			GAME:SetCharacterNickname(hero, result)
			UI:WaitShowDialogue("Your name is now " .. hero_ground:GetDisplayName() .. "!")
		elseif name_result == 2 then
			local name = partner.Nickname
			UI:NameMenu("What is your partner's name?", "Press [ESC] to keep the old nickname.", 60)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			--if no name given, set name to previous name
			if result == "" then result = name end
			GAME:SetCharacterNickname(partner, result)
			UI:WaitShowDialogue("Your partner's name is now " .. partner_ground:GetDisplayName() .. "!")
		end
		
	elseif choice_result == 3 then
		local name = _DATA.Save.ActiveTeam.Name
		UI:NameMenu("What is your team's name?", "Press [ESC] to keep the old team name.", 60)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		--if no name given, set name to previous name
		if result == "" then result = name end
		GAME:SetTeamName(result)
		UI:WaitShowDialogue("Your team's name is now Team " .. GAME:GetTeamName() .. "!")
	elseif choice_result == 4 then
		local current_rank = _DATA.Save.ActiveTeam.Rank
		local next_rank = _DATA:GetRank(current_rank).Next
		local to_go = _DATA:GetRank(current_rank).FameToNext - _DATA.Save.ActiveTeam.Fame 

		UI:WaitShowDialogue("Your team is currently [color=#FFA5FF]" .. current_rank:gsub("^%l", string.upper) .. " Rank[color].")
		UI:WaitShowDialogue("You need [color=#00FFFF]" .. to_go .. "[color] Adventurer Rank Points to become [color=#FFA5FF]" .. next_rank:gsub("^%l", string.upper) .. " Rank[color].")
	end

	if choice_result ~= #choices then
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Closing', 0, 0, 0, Direction.Left)
		GROUND:ObjectSetAnim(obj, 6, 0, 3, Direction.Left, 1)
		GROUND:ObjectSetDefaultAnim(obj, 'Diary_Red_Closing', 0, 3, 3, Direction.Left)	
		GAME:WaitFrames(40)		
	end
	
	--UI:ResetChoiceLoc()
	partner_ground.IsInteracting = false
	GROUND:CharEndAnim(partner_ground)
	GROUND:CharEndAnim(hero_ground)
	
end



function guild_heros_room.DemoThankYou()
	UI:ResetSpeaker()
	UI:WaitShowDialogue("That's the end of the demo! Thank you so much for playing!")
	UI:WaitShowDialogue("I hope you enjoyed playing the Halcyon demo! More chapters to come in the future!")
	UI:WaitShowDialogue("Special thanks to Audino for all his help with the Origins engine.")
	UI:WaitShowDialogue("Without his help, Halcyon could not have been made!")
	UI:WaitShowDialogue("I'd also like to thank Trio- for helping with mission generation scripts and other scripting odds and ends.")
	UI:WaitShowDialogue("He saved me a lot of time and grief with all the help he provided.")
	UI:WaitShowDialogue("Please check the readme for the full list of credits!")
	UI:WaitShowDialogue("Everyone who helped out did a great job, and I appreciate all that they've done!")
	UI:WaitShowDialogue("If you have any feedback you would like to share, please do so in the relevant Halcyon discord channel!")
	UI:WaitShowDialogue("I'm interested to hear what people think about the game or if they have any suggestions or thoughts!")
	UI:WaitShowDialogue("If you're interested in contributing to Halcyon as well, please let Palika know!")
	UI:WaitShowDialogue("I would need sprite artists and musicians to help with custom assets now and then...")
	UI:WaitShowDialogue("So if that's up your alley and you're interested, please let me know!")
	UI:WaitShowDialogue("Anyways, you can keep playing Halcyon to complete the randomly generated missions if you feel like.")
	UI:WaitShowDialogue("Nothing can progress the game any further right now, as I need to develop more of the story.")
	UI:WaitShowDialogue("Thank you again for playing! Returning back to normal gameplay... now!")
	SV.Chapter4.DemoThankYou = true
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

