--[[
    init.lua
    Created: 02/06/2021 17:32:04
    Description: Autogenerated script file for the map testmap.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.mission_gen'



-- Package name
local testmap = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---testmap.Init
--Engine callback function
function testmap.Init(map, time)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


end

---testmap.Enter
--Engine callback function
function testmap.Enter(map, time)
	SV.ChapterProgression.Chapter = 4
	--Mark all dungeons as completed as well just so we can actually make jobs for them
	local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
	for ii = 0, dungeon_keys.Count-1 ,1 do
		_DATA.Save:CompleteDungeon(dungeon_keys[ii])
	end
end

---testmap.Update
--Engine callback function
function testmap.Update(map, time)


end




-------------------------------
-- Entities Callbacks
-------------------------------

function testmap.EnterCavern_Action(chara, activator)
GAME:EnterDungeon("crooked_cavern", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterRiver_Action(chara, activator)
GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterGrove_Action(chara, activator)
GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterSteppe_Action(chara, activator)
GAME:EnterDungeon("vast_steppe", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterTunnel_Action(chara, activator)
GAME:EnterDungeon("searing_tunnel", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterMountain_Action(chara, activator)
GAME:EnterDungeon("mount_windswept", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function testmap.Make_Missions_Action(chara, activator)
	print("Running mission generation!")  
	MISSION_GEN.ResetBoards()
	MISSION_GEN.RemoveMissionBackReference()
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_MISSION)
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_OUTLAW)
	MISSION_GEN.SortMission()
	MISSION_GEN.SortOutlaw()
end

function testmap.See_Taken_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.TakenBoard[i].Client .. " Target: " .. SV.TakenBoard[i].Target ..
			" Zone: " .. SV.TakenBoard[i].Zone .. " Reward: " .. SV.TakenBoard[i].Reward .. " Floor: " .. SV.TakenBoard[i].Floor .. " Type: "
			.. SV.TakenBoard[i].Type .. " Completion: " .. SV.TakenBoard[i].Completion .. " Taken: " .. tostring(SV.TakenBoard[i].Taken) .. " Difficulty: " .. SV.TakenBoard[i].Difficulty .. " Item: " .. SV.TakenBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Mission_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.MissionBoard[i].Client .. " Target: " .. SV.MissionBoard[i].Target ..
			" Zone: " .. SV.MissionBoard[i].Zone .. " Reward: " .. SV.MissionBoard[i].Reward .. " Floor: " .. SV.MissionBoard[i].Floor .. " Type: "
			.. SV.MissionBoard[i].Type .. " Completion: " .. SV.MissionBoard[i].Completion .. " Taken: " .. tostring(SV.MissionBoard[i].Taken) .. " Difficulty: " .. SV.MissionBoard[i].Difficulty .. " Item: " .. SV.MissionBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end

function testmap.See_Outlaw_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.OutlawBoard[i].Client .. " Target: " .. SV.OutlawBoard[i].Target ..
			" Zone: " .. SV.OutlawBoard[i].Zone .. " Reward: " .. SV.OutlawBoard[i].Reward .. " Floor: " .. SV.OutlawBoard[i].Floor .. " Type: "
			.. SV.OutlawBoard[i].Type .. " Completion: " .. SV.OutlawBoard[i].Completion .. " Taken: " .. tostring(SV.OutlawBoard[i].Taken) .. " Difficulty: " .. SV.OutlawBoard[i].Difficulty ..  " Item: " .. SV.OutlawBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Job_1_Menu_Action(chara, activator)
  local menu = JobMenu:new(COMMON.MISSION_BOARD_MISSION, 1)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end

function testmap.See_Mission_Board_Action(chara, activator)
	  local menu = BoardSelectionMenu:new(COMMON.MISSION_BOARD_MISSION)
	  UI:SetCustomMenu(menu.menu)
	  UI:WaitForChoice()
end


function testmap.See_Outlaw_Board_Action(chara, activator)
	  local menu = BoardSelectionMenu:new(COMMON.MISSION_BOARD_OUTLAW)
	  UI:SetCustomMenu(menu.menu)
	  UI:WaitForChoice()
end


function testmap.See_Taken_Board_Action(chara, activator)
  local menu = BoardMenu:new("taken")
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end



function testmap.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end


function testmap.CompleteTakens_Action()
	if SV.TakenBoard[1].Client ~= '' then
		for i =1, 8, 1 do 
			if SV.TakenBoard[i].Client ~= '' then
				SV.TakenBoard[i].Completion = MISSION_GEN.COMPLETE
			else 
				break
			end 
		end 
	end 
	SV.TemporaryFlags.MissionCompleted = true
	SV.TemporaryFlags.Dinnertime = true
	UI:WaitShowDialogue("Taken missions completed!")
end 

--skip to having entered the guild but not talking to anyone yet
function testmap.Chapter1_2_Action(chara, activator)
	SV.ChapterProgression.Chapter = 1
	
	GAME:UnlockDungeon('relic_forest')
	_DATA.Save.ActiveTeam:SetRank("normal")
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = false,--talked to snubbull?
		MetZigzagoon = false,
		MetCranidosMareep = false,
		MetBreloomGirafarig = false,
		MetAudino = false,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 1 before talking to guild mates!")

end


--skip to having just started chapter 2
function testmap.Chapter2_1_Action(chara, activator)
	SV.ChapterProgression.Chapter = 2
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	_DATA.Save.ActiveTeam:SetRank("normal")
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 2 before doing anything!")

end

function testmap.Chapter2_2_Action(chara, activator)
	SV.ChapterProgression.Chapter = 2
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	GAME:UnlockDungeon('beginner_lesson')
	GAME:UnlockDungeon('normal_maze')
	_DATA.Save.ActiveTeam:SetRank("normal")
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	SV.Chapter2 = 
	{
		FirstMorningMeetingDone = true,--completed the first morning cutscene with the guild?
		StartedTraining = true,--started the training at ledian dojo?
		SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
		FinishedTraining = true,--finished the preliminary training at ledian dojo?
		FinishedDojoCutscenes = true,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
		FinishedMarketIntro = true,--partner showed the hero the market?
		FinishedNumelTantrum = true,--watched numel's tantrum?
		FinishedFirstDay = true,--finished first day of chapter 2?
		FinishedCameruptRequestScene = true,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
		
		EnteredRiver = false,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
		FinishedRiver = false,--player and partner have finished the dungeon and made it to Numel?
		
		TropiusGaveReviver = false,--did tropius give the free one off reviver seed?
		WooperIntro = true--talked to the wooper siblings? if not play their little cutscene
	}
	
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 2 day 2!")
	
	

end


function testmap.Chapter3_1_Action(chara, activator)
	SV.ChapterProgression.Chapter = 3
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	GAME:UnlockDungeon('crooked_cavern')
	GAME:UnlockDungeon('beginner_lesson')
	GAME:UnlockDungeon('normal_maze')
	GAME:UnlockDungeon('fire_maze')
	GAME:UnlockDungeon('water_maze')
	GAME:UnlockDungeon('grass_maze')
	SV.ChapterProgression.CurrentStoryDungeon = 'crooked_cavern'
	_DATA.Save.ActiveTeam:SetRank("normal")
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	SV.Chapter2 = 
	{
		FirstMorningMeetingDone = true,--completed the first morning cutscene with the guild?
		StartedTraining = true,--started the training at ledian dojo?
		SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
		FinishedTraining = true,--finished the preliminary training at ledian dojo?
		FinishedDojoCutscenes = true,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
		FinishedMarketIntro = true,--partner showed the hero the market?
		FinishedNumelTantrum = true,--watched numel's tantrum?
		FinishedFirstDay = true,--finished first day of chapter 2?
		FinishedCameruptRequestScene = true,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
		
		EnteredRiver = true,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
		FinishedRiver = true,--player and partner have finished the dungeon and made it to Numel?
		
		TropiusGaveReviver = true,--did tropius give the free one off reviver seed?
		WooperIntro = true--talked to the wooper siblings? if not play their little cutscene
	}
		
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 3 day 1!")

end


function testmap.Chapter3_2_Action(chara, activator)
	SV.ChapterProgression.Chapter = 3
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	GAME:UnlockDungeon('crooked_cavern')
	GAME:UnlockDungeon('beginner_lesson')
	GAME:UnlockDungeon('normal_maze')
	GAME:UnlockDungeon('fire_maze')
	GAME:UnlockDungeon('water_maze')
	GAME:UnlockDungeon('grass_maze')
	SV.ChapterProgression.CurrentStoryDungeon = ''
	_DATA.Save.ActiveTeam:SetRank("normal")

	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	SV.Chapter2 = 
	{
		FirstMorningMeetingDone = true,--completed the first morning cutscene with the guild?
		StartedTraining = true,--started the training at ledian dojo?
		SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
		FinishedTraining = true,--finished the preliminary training at ledian dojo?
		FinishedDojoCutscenes = true,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
		FinishedMarketIntro = true,--partner showed the hero the market?
		FinishedNumelTantrum = true,--watched numel's tantrum?
		FinishedFirstDay = true,--finished first day of chapter 2?
		FinishedCameruptRequestScene = true,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
		
		EnteredRiver = true,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
		FinishedRiver = true,--player and partner have finished the dungeon and made it to Numel?
		
		TropiusGaveReviver = true,--did tropius give the free one off reviver seed?
		WooperIntro = true--talked to the wooper siblings? if not play their little cutscene
	}
		
	SV.Chapter3 = 
	{
		ShowedTitleCard = true,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
		FinishedOutlawIntro = true,--did shuca and ganlon teach you about outlaws?
		MetTeamStyle = true,--did you meet team style?
		FinishedCafeCutscene = true,--did partner point out the cafe's open?
		EnteredCavern = true,--did duo enter the dungeon?
		FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
		EncounteredBoss = true,--did duo find team style in the dungeon yet?
		LostToBoss = false,--did duo die to boss?
		EscapedBoss = false,--due team use an escape orb to escape boss?
		DefeatedBoss = true, --did duo defeat team style?
		RootSceneTransition = true, --Used to remember where in the root scene we are after transitioning away to show the root 
		FinishedRootScene = true, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not
		FinishedMerchantIntro = false, --Did merchant intro cutscene?
		--DemoThankYou = false,--Showed demo thank you? Not needed for future versions.

		TropiusGaveWand = true,--did tropius give some wands to help the duo?
		BreloomGirafarigConvo = true, --talked to breloom/girafarig about their expedition?
		PostBossSpokeToCranidos = false -- Talked to cranidos in town after beating boss? Used to flag the partner to mention not being able to impress cranidos.
	}
	
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 3 day 2!")

end


function testmap.Chapter4_1_Action(chara, activator)
	SV.ChapterProgression.Chapter = 4
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	GAME:UnlockDungeon('crooked_cavern')
	GAME:UnlockDungeon('beginner_lesson')
	GAME:UnlockDungeon('normal_maze')
	GAME:UnlockDungeon('fire_maze')
	GAME:UnlockDungeon('water_maze')
	GAME:UnlockDungeon('grass_maze')
	GAME:UnlockDungeon('apricorn_grove')
	GAME:UnlockDungeon('flying_maze')
	GAME:UnlockDungeon('rock_maze')
	SV.ChapterProgression.CurrentStoryDungeon = 'apricorn_grove'
	_DATA.Save.ActiveTeam:SetRank("bronze")
	SV.ChapterProgression.UnlockedAssembly = true
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	SV.Chapter2 = 
	{
		FirstMorningMeetingDone = true,--completed the first morning cutscene with the guild?
		StartedTraining = true,--started the training at ledian dojo?
		SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
		FinishedTraining = true,--finished the preliminary training at ledian dojo?
		FinishedDojoCutscenes = true,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
		FinishedMarketIntro = true,--partner showed the hero the market?
		FinishedNumelTantrum = true,--watched numel's tantrum?
		FinishedFirstDay = true,--finished first day of chapter 2?
		FinishedCameruptRequestScene = true,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
		
		EnteredRiver = true,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
		FinishedRiver = true,--player and partner have finished the dungeon and made it to Numel?
		
		TropiusGaveReviver = true,--did tropius give the free one off reviver seed?
		WooperIntro = true--talked to the wooper siblings? if not play their little cutscene
	}
		
	SV.Chapter3 = 
	{
		ShowedTitleCard = true,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
		FinishedOutlawIntro = true,--did shuca and ganlon teach you about outlaws?
		MetTeamStyle = true,--did you meet team style?
		FinishedCafeCutscene = true,--did partner point out the cafe's open?
		EnteredCavern = true,--did duo enter the dungeon?
		FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
		EncounteredBoss = true,--did duo find team style in the dungeon yet?
		LostToBoss = false,--did duo die to boss?
		EscapedBoss = false,--due team use an escape orb to escape boss?
		DefeatedBoss = true, --did duo defeat team style?
		RootSceneTransition = true, --Used to remember where in the root scene we are after transitioning away to show the root 
		FinishedRootScene = true, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not
		FinishedMerchantIntro = true, --Did merchant intro cutscene?
		--DemoThankYou = false,--Showed demo thank you? Not needed for future versions.

		TropiusGaveWand = true,--did tropius give some wands to help the duo?
		BreloomGirafarigConvo = true, --talked to breloom/girafarig about their expedition?
		PostBossSpokeToCranidos = true -- Talked to cranidos in town after beating boss? Used to flag the partner to mention not being able to impress cranidos.
	}
	
	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 4 day 1!")

end

function testmap.Chapter4_2_Action(chara, activator)
	SV.ChapterProgression.Chapter = 4
	
	GAME:UnlockDungeon('relic_forest')
	GAME:UnlockDungeon('illuminant_riverbed')
	GAME:UnlockDungeon('crooked_cavern')
	GAME:UnlockDungeon('beginner_lesson')
	GAME:UnlockDungeon('normal_maze')
	GAME:UnlockDungeon('fire_maze')
	GAME:UnlockDungeon('water_maze')
	GAME:UnlockDungeon('grass_maze')
	GAME:UnlockDungeon('apricorn_grove')
	GAME:UnlockDungeon('flying_maze')
	GAME:UnlockDungeon('rock_maze')
	SV.ChapterProgression.CurrentStoryDungeon = ''
	_DATA.Save.ActiveTeam:SetRank("bronze")
	SV.ChapterProgression.UnlockedAssembly = true
	
	SV.Chapter1 = 
	{
		PlayedIntroCutscene = true,
		PartnerEnteredForest = true,--Did partner go into the forest yet?
		PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
		PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
		TeamCompletedForest = true, --completed backtrack to town?
		TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

		--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
		MetSnubbull = true,--talked to snubbull?
		MetZigzagoon = true,
		MetCranidosMareep = true,
		MetBreloomGirafarig = true,
		MetAudino = true,
		
		--partner dialogue flag on second floor
		PartnerSecondFloorDialogue = 0,
		TutorialProgression = 10
	}
	
	SV.Chapter2 = 
	{
		FirstMorningMeetingDone = true,--completed the first morning cutscene with the guild?
		StartedTraining = true,--started the training at ledian dojo?
		SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
		FinishedTraining = true,--finished the preliminary training at ledian dojo?
		FinishedDojoCutscenes = true,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
		FinishedMarketIntro = true,--partner showed the hero the market?
		FinishedNumelTantrum = true,--watched numel's tantrum?
		FinishedFirstDay = true,--finished first day of chapter 2?
		FinishedCameruptRequestScene = true,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
		
		EnteredRiver = true,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
		FinishedRiver = true,--player and partner have finished the dungeon and made it to Numel?
		
		TropiusGaveReviver = true,--did tropius give the free one off reviver seed?
		WooperIntro = true--talked to the wooper siblings? if not play their little cutscene
	}
		
	SV.Chapter3 = 
	{
		ShowedTitleCard = true,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
		FinishedOutlawIntro = true,--did shuca and ganlon teach you about outlaws?
		MetTeamStyle = true,--did you meet team style?
		FinishedCafeCutscene = true,--did partner point out the cafe's open?
		EnteredCavern = true,--did duo enter the dungeon?
		FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
		EncounteredBoss = true,--did duo find team style in the dungeon yet?
		LostToBoss = false,--did duo die to boss?
		EscapedBoss = false,--due team use an escape orb to escape boss?
		DefeatedBoss = true, --did duo defeat team style?
		RootSceneTransition = true, --Used to remember where in the root scene we are after transitioning away to show the root 
		FinishedRootScene = true, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not
		FinishedMerchantIntro = true, --Did merchant intro cutscene?
		--DemoThankYou = false,--Showed demo thank you? Not needed for future versions.

		TropiusGaveWand = true,--did tropius give some wands to help the duo?
		BreloomGirafarigConvo = true, --talked to breloom/girafarig about their expedition?
		PostBossSpokeToCranidos = true -- Talked to cranidos in town after beating boss? Used to flag the partner to mention not being able to impress cranidos.
	}
	
	SV.Chapter4 = 
	{
		ShowedTitleCard = true,--Did the generic wakeup for the first day? Need a variable for this due to chapter 4 title card.
		FinishedFirstAddress = true,--Did you get the address regarding your mission for the chapter and the expedition?
		FinishedAssemblyIntro = true,--did audino teach you about her assembly?
		FinishedSignpostCutscene = true,--Did audino show you her signpost for the assembly by the cafe?
		EnteredGrove = true,--has player set foot at all into the grove yet?
		BacktrackedOutGroveYet = true,--has player ever backtracked out the entrance of the grove yet? if not, give them a cutscene explaining what just happened
		ReachedGlade = true, --has player reached the glade yet?
		FinishedGrove = true,--has player finished the grove for good?
		FinishedBedtimeCutscene = true,--has player watched the bedtime cutscene? this is the last cutscene of this chapter
		
		TropiusGaveAdvice = true,--did you speak with Tropius day one?
		SpokeToRelicanthDayOne = true,--did you speak with relicanth day one?
		HeardRelicanthStory = false,--did you hear with relicanth's story? (TO BE USED ONCE STORY IS CREATED)
		MedichamMachampArgument = false,--did you see machamp and medicham arguing over their mailbox?
		CranidosBlush = false,--did Cranidos accidentally spill the beans on being a softy towards mareep?
		WoopersMedititeConvo = false,--did you see woopers and meditite talk to each other?
		DemoThankYou = false--Showed demo thank you?

	}

	UI:ResetSpeaker()
	UI:WaitShowDialogue("Chapter progression set: Chapter 4 day 2!")

end











function testmap.Get_Released_Mons_Action()
	--mons is a list of all species index strings
	--local mons = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:GetOrderedKeys(false)
	--for i = 1, 906, 1 do
	--	if _DATA:GetMonster(mons[i]).Released then
	--		print(mons[i]) 
	--	 end
	--end
	
	--mons is a list of all species index strings
	local mons = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:GetOrderedKeys(false)
	for i = 1, 2000, 1 do
		if _DATA:GetItem(mons[i]).ItemData.UsageType == _DATA:GetItem("tm_acrobatics").ItemData.UsageType then
			print(mons[i]) 
		 end
	end
end

--[[
potential sfx:
EVT_EP_Aegis_Cave_Marker_Glow
EVT_EP_Palkia_Transport
_UNK_EVT_106
_UNK_EVT_079 (TIME GEAR TAKE DOWN)

]]--
function testmap.Test_Core_Deactivation_Action(chara, activator)
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	
	GAME:MoveCamera(688, 936, 1, false)
	
	local root = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Anima_Root", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(600, 864, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 0), --offset
												 true, 
												 "Anima_Root")--object entity name	
												 
	root:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(root)
	
	local core = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Anima_Core", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(600, 865, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, -1), --offset
												 true, 
												 "Anima_Core")--object entity name	
				
	core:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(core)
	
	--setup darkness
	--It'll fade in for 200 frames, last 0 frames, and fade out in 0 frames. It'll transition to the darkness map status though at 200 frames.
	local overlay = RogueEssence.Content.FiniteOverlayEmitter()
    overlay.TotalTime = 0;
	overlay.FadeIn = 200;
	overlay.FadeOut = 0;
	overlay.Layer = DrawLayer.Top;
	overlay.Anim = RogueEssence.Content.BGAnimData("White", 0)
	overlay.Color = Color(0, 0, 0, 76/255)
	
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root', 10, 0, 15, Direction.Down)
	GROUND:ObjectSetDefaultAnim(core, 'Anima_Core', 10, 0, 31, Direction.Down)

	SOUND:LoopBattleSE('_UNK_EVT_106')
	GROUND:ObjectWaitAnimFrame(core, 0)
	GROUND:ObjectWaitAnimFrame(core, 25)
	print("shart")
	SOUND:FadeOutBattleSE('_UNK_EVT_106', 60)
	GROUND:ObjectWaitAnimFrame(core, 0)
	print("Shart")
	
	SOUND:PlayBattleSE('EVT_EP_Nightmare_Break')
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(core, 10, 0, 11, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 11, 11, Direction.Down)
	
	GROUND:ObjectWaitAnimFrame(core, 11)
	GAME:WaitFrames(40)
	
	--move core slowly down after deactivating
	for i = 1, 10, 1 do
		GROUND:MoveObjectToPosition(core, core.Position.X, core.Position.Y + 1, 1)
		GAME:WaitFrames(8)
	end
	
	GROUND:ObjectWaitAnimFrame(root, 0)
	
	GROUND:PlayVFX(overlay, CH('PLAYER').Position.X, CH('PLAYER').Position.Y)
	SOUND:PlayBattleSE("_UNK_EVT_079")
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(root, 40, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 5, 5, Direction.Down)
	
	GAME:WaitFrames(200)
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(180)
	GAME:GetCurrentGround():RemoveTempObject(root)
	GAME:GetCurrentGround():RemoveTempObject(core)
	GAME:MoveCamera(0, 0, 1, true)
	GAME:CutsceneMode(false)
	SOUND:PlayBGM('Deep Dark Crater.ogg', true)
	GROUND:RemoveMapStatus("darkness")
	GAME:GetCurrentGround():RemoveTempObject(groundObj)
end
	
	
											 

return testmap

