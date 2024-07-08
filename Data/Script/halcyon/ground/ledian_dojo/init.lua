--[[
    init.lua
    Created: 01/01/2022 02:00:40
    Description: Autogenerated script file for the map ledian_dojo.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.ledian_dojo.ledian_dojo_ch_2'
require 'halcyon.ground.ledian_dojo.ledian_dojo_ch_3'
require 'halcyon.ground.ledian_dojo.ledian_dojo_ch_4'


-- Package name
local ledian_dojo = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---ledian_dojo.Init
--Engine callback function
function ledian_dojo.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_ledian_dojo <<=')
	
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	GROUND:AddMapStatus("darkness")--darkness
	
	--Remove nicknames from characters if the nickname mod is enabled.
	if CONFIG.UseNicknames then
		CH('Sensei').Data.Nickname = CharacterEssentials.GetCharacterName('Ledian')
		CH('Gible').Data.Nickname = CharacterEssentials.GetCharacterName('Gible')
	else 
		CH('Sensei').Data.Nickname = 'Ledian'
		CH('Gible').Data.Nickname = 'Gible'
	end
end

---ledian_dojo.Enter
--Engine callback function
function ledian_dojo.Enter(map)

  ledian_dojo.PlotScripting()

end

---ledian_dojo.Exit
--Engine callback function
function ledian_dojo.Exit(map)


end

---ledian_dojo.Update
--Engine callback function
function ledian_dojo.Update(map)


end

---ledian_dojo.GameSave
--Engine callback function
function ledian_dojo.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

---ledian_dojo.GameLoad
--Engine callback function
function ledian_dojo.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	ledian_dojo.PlotScripting()
end

function ledian_dojo.PlotScripting()
	
	--Setup Ground first before checking what cutscene to run.
	if SV.ChapterProgression.Chapter == 2 then 
			ledian_dojo_ch_2.SetupGround()	
	elseif SV.ChapterProgression.Chapter == 3 then 
			ledian_dojo_ch_3.SetupGround()	
	elseif SV.ChapterProgression.Chapter == 4 then 
			ledian_dojo_ch_4.SetupGround()
	else
		--GAME:FadeIn(20)
	end

	--if a generic ending has been flagged, prioritize that
	if SV.Dojo.LessonCompletedGeneric or SV.Dojo.TrainingCompletedGeneric or SV.Dojo.TrialCompletedGeneric or SV.Dojo.LessonFailedGeneric or SV.Dojo.TrainingFailedGeneric or SV.Dojo.TrialFailedGeneric then
	
		
		if SV.Dojo.LessonCompletedGeneric then
			ledian_dojo.GenericLessonSuccess()
		elseif SV.Dojo.TrainingCompletedGeneric then
			ledian_dojo.GenericTrainingSuccess()
		elseif SV.Dojo.TrialCompletedGeneric then
			ledian_dojo.GenericTrialSuccess()
		elseif SV.Dojo.LessonFailedGeneric then
			ledian_dojo.GenericLessonFailure()
		elseif SV.Dojo.TrainingFailedGeneric then
			ledian_dojo.GenericTrainingFailure()
		elseif SV.Dojo.TrialFailedGeneric then
			ledian_dojo.GenericTrialFailure()
		else --this shouldn't happen
			GAME:FadeIn(20)
		end

	elseif SV.ChapterProgression.Chapter == 2 then
		if not SV.Chapter2.StartedTraining then--Cutscene for entering the dojo for the first time
			ledian_dojo_ch_2.PreTrainingCutscene()
		elseif not SV.Chapter2.FinishedTraining then--Cutscene for dying in first lesson/maze. cutscene function has logic for appropriate scene
			ledian_dojo_ch_2.FailedTrainingCutscene()
		elseif not SV.Chapter2.FinishedDojoCutscenes then--Cutscene for finishing first lesson/maze. cutscene function has logic for appropriate scene
			ledian_dojo_ch_2.PostTrainingCutscene()
		else 
			GAME:FadeIn(20)
		end
	else
		GAME:FadeIn(20)	
	end 
end

function ledian_dojo.Gible_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("ledian_dojo_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gible_Action(...,...)"), chara, activator))
end

function ledian_dojo.Azumarill_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("ledian_dojo_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Azumarill_Action(...,...)"), chara, activator))
end

function ledian_dojo.Sensei_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false
	local ledian = CH('Sensei')

	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
	local olddir = ledian.Direction
    ledian.IsInteracting = true
    partner.IsInteracting = true
    UI:SetSpeaker(ledian)
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)

	GROUND:CharTurnToChar(ledian, CH('PLAYER'))		
    GROUND:CharTurnToChar(hero, ledian)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, ledian, 4) end)
	
	--ledian mentions if new mazes are unlocked.
	if SV.Dojo.NewMazeUnlocked then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_New_Maze_1']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_New_Maze_2']))
		SV.Dojo.NewMazeUnlocked = false
		GAME:WaitFrames(20)
	end
	
	while state > -1 do
		local msg = STRINGS:Format(STRINGS.MapStrings['Dojo_Intro'])
		if repeated == true then
			msg = STRINGS:Format(STRINGS.MapStrings['Dojo_Intro_Return'])
		end
		local dojo_choices = {STRINGS:FormatKey("MENU_INFO"),
							  STRINGS:Format(STRINGS.MapStrings['Dojo_Facilities_Info']),
							  STRINGS:FormatKey("MENU_EXIT")}
		UI:BeginChoiceMenu(msg, dojo_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then 
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Info_001']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Info_002']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Info_003']))
		
		elseif result == 2 then 
			repeated = false
			while state > -1 do
				dojo_choices = {STRINGS:Format(STRINGS.MapStrings['Dojo_Menu_Training']),
									  STRINGS:Format(STRINGS.MapStrings['Dojo_Menu_Lesson']),
									  STRINGS:Format(STRINGS.MapStrings['Dojo_Menu_Trials']),
									  STRINGS:Format(STRINGS.MapStrings['Dojo_Menu_Back']),}
				msg = STRINGS:Format(STRINGS.MapStrings['Dojo_Info_Prompt'])
				if repeated == true then
					msg = STRINGS:Format(STRINGS.MapStrings['Dojo_Info_Prompt_Return'])
				end
				UI:BeginChoiceMenu(msg, dojo_choices, 1, 4)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				repeated = true
				if result == 1 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_001']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_002']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_003']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_004']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_005']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Training_Info_006']))
				elseif result == 2 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_001']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_002']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_003']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_004']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_005']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_006']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_007']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_008']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Lesson_Info_009']))
				elseif result == 3 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_001']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_002']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_003']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_004']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_005']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_006']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_007']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_008']))
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Trial_Info_009']))
				else 
					state = -1
				end
			end
			state = 0
				
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Dojo_Goodbye']))
			state = -1
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	GROUND:EntTurn(ledian, olddir)
	partner.IsInteracting = false
	ledian.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
end 

--modified version of common's ShowDestinationMenu. Has no capability for grounds, and sets risk to None if the dungeon chosen is a tutorial level
function ledian_dojo.ShowMazeMenu(dungeon_entrances)
  --check for unlock of dungeons
  local open_dests = {}
  local default_choice = 1
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
	    local zone_name = ""
	    if _DATA.Save:GetDungeonUnlock(dungeon_entrances[ii]) == RogueEssence.Data.GameProgress.UnlockState.Completed then
		  zone_name = zone_summary:GetColoredName()
		else
		  zone_name = "[color=#00FFFF]"..zone_summary.Name:ToLocal().."[color]"
		end

		table.insert(open_dests, { Name=zone_name, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
	end
  end
  
  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  if #open_dests == 1 then
      --single dungeon entry
      UI:ResetSpeaker()
      --SOUND:PlaySE("Menu/Skip")
	  UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
  elseif #open_dests > 1 then
    
    UI:ResetSpeaker()
    --SOUND:PlaySE("Menu/Skip")
    UI:DestinationMenu(open_dests, default_choice)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result ~= nil then 
		dest = open_dests[result].Dest
	end
  end
  
  if dest:IsValid() then
	local risk = RogueEssence.Data.GameProgress.DungeonStakes.Risk
	--set risk to none if chosen level is a lesson
	if dest.ID == 'beginner_lesson' then risk = RogueEssence.Data.GameProgress.DungeonStakes.None end
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
	GeneralFunctions.SendInvToStorage()--send money and items to the bank
	GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, risk, true, false)
  end
end
		
		
		
function ledian_dojo.GenericTrainingSuccess()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local ledian = CH('Sensei')
	--GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	
	--set their animations to none rather than using cutscene mode, as background NPCs need to continue to idle.
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharSetAnim(partner, "None", true)
	
	GROUND:TeleportTo(hero, 208, 200, Direction.Up)	
	GROUND:TeleportTo(partner, 184, 200, Direction.Up)
	GAME:MoveCamera(204, 184, 1, false)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(SV.Dojo.LastZone)
	GAME:FadeIn(40)
		
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(ledian, 'Exclaim', true)
	UI:SetSpeaker(ledian)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hoiyah![pause=0] You did it![pause=0] You successfully completed the " .. zone:GetColoredName() .."!")
	UI:SetSpeakerEmotion("Shouting")
	local coro1 = TASK:BranchCoroutine(function() ledian_dojo_ch_2.Hwacha(ledian) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharSetEmote(hero, "exclaim", 1) end)	
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GeneralFunctions.Recoil(partner) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)

	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But this is only the beginning of your journey!")
	UI:WaitShowDialogue("Hwacha![pause=0] There is still so much training for you ahead!")
	UI:WaitShowDialogue("Wahtah![pause=0] Be sure to keep giving it your all!")

	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()

	SV.Dojo.TrainingCompletedGeneric = false -- reset the flag

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--GAME:CutsceneMode(false)	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
end
		
function ledian_dojo.GenericLessonSuccess()
	--for now, all 3 generic finishes will be the same
	ledian_dojo.GenericTrainingSuccess()
	SV.Dojo.LessonCompletedGeneric = false -- reset the flag
end
	
function ledian_dojo.GenericTrialSuccess()
	--for now, all 3 generic finishes will be the same	
	ledian_dojo.GenericTrainingSuccess()
	SV.Dojo.TrialCompletedGeneric = false -- reset the flag

end
		
function ledian_dojo.GenericTrainingFailure()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local ledian = CH('Sensei')
	--GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	
	--set their animations to none rather than using cutscene mode, as background NPCs need to continue to idle.
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharSetAnim(partner, "None", true)
	
	GROUND:TeleportTo(hero, 208, 200, Direction.Up)	
	GROUND:TeleportTo(partner, 184, 200, Direction.Up)
	GAME:MoveCamera(204, 184, 1, false)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(SV.Dojo.LastZone)
	GAME:FadeIn(40)
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(ledian, 'Sweating', true)
	UI:SetSpeaker(ledian)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Oohcha...[pause=0] You failed to make it to the end...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(ledian)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hoiyah![pause=0] Worry not my students![pause=0] The journey to a stronger self is not an easy one.")
	UI:WaitShowDialogue("This is simply one of the hardships you will encounter on the path to success.")
	UI:WaitShowDialogue("Wahtah![pause=0] If you continue to seek victory,[pause=10] it cannot continue to hide!")
	UI:WaitShowDialogue("Gather your strength,[pause=10] and go give it your all again!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()

	SV.Dojo.TrainingFailedGeneric = false -- reset the flag

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--GAME:CutsceneMode(false)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	
end
		
function ledian_dojo.GenericLessonFailure()
	--for now, all 3 generic finishes will be the same
	ledian_dojo.GenericTrainingFailure()
	SV.Dojo.LessonFailedGeneric = false -- reset the flag
end
		
function ledian_dojo.GenericTrialFailure()
	--for now, all 3 generic finishes will be the same
	ledian_dojo.GenericTrainingFailure()
	SV.Dojo.TrialFailedGeneric = false -- reset the flag
end
-------------------------------
-- Map Transition
-------------------------------

function ledian_dojo.Dojo_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "Wigglytuff's Guild Remix.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Dojo_Entrance_Marker", SV.metano_town.Song == "Wigglytuff's Guild Remix.ogg")
  SV.partner.Spawn = 'Dojo_Entrance_Marker_Partner'
end

function ledian_dojo.Dungeon_Entrance_Touch(obj, activator)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine

	local dungeon_entrances = { }
	UI:ResetSpeaker()
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)	
	
	UI:BeginChoiceMenu("Which would you like to do?", {"Training", "Lesson", "Trial", "Cancel"}, 1, 4)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	
	--these need to be updated as more dojo dungeons are created.
	if result == 1 then
		--training mazes
		dungeon_entrances = {"normal_maze", "grass_maze", "fire_maze", "water_maze", "rock_maze", "flying_maze", "electric_maze", "bug_maze"}
	elseif result == 2 then
		--lessons
		dungeon_entrances = {"beginner_lesson"}
	elseif result == 3 then
		--trials
		dungeon_entrances = {}
		if #dungeon_entrances == 0 then 
			UI:WaitShowDialogue("There aren't any trials available to you now. Come back later!")
		end
	else
		--cancel
		partner.IsInteracting = false
		GROUND:CharEndAnim(partner)
		GROUND:CharEndAnim(hero)	
		return
	end
	--set the dungeons we can choose from based on whether we are choosing to do a lesson, a training maze, or a trial
	ledian_dojo.ShowMazeMenu(dungeon_entrances)
	
	GAME:WaitFrames(10)
	partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)	
end

-------------------------------
-- Entities Callbacks
-------------------------------

function ledian_dojo.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return ledian_dojo

