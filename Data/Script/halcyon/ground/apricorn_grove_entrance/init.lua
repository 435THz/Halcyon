--[[
    init.lua
    Created: 07/13/2023 19:44:56
    Description: Autogenerated script file for the map apricorn_grove_entrance.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.apricorn_grove_entrance.apricorn_grove_entrance_ch_4'

-- Package name
local apricorn_grove_entrance = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---apricorn_grove_entrance.Init(map)
--Engine callback function
function apricorn_grove_entrance.Init(map)

	DEBUG.EnableDbgCoro()
	print('=>> Init_apricorn_grove_entrance <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies(true)
	COMMON.RespawnGuests()
	PartnerEssentials.InitializePartnerSpawn()

end

---apricorn_grove_entrance.Enter(map)
--Engine callback function
function apricorn_grove_entrance.Enter(map)

  apricorn_grove_entrance.PlotScripting()

end

---apricorn_grove_entrance.Exit(map)
--Engine callback function
function apricorn_grove_entrance.Exit(map)


end

---apricorn_grove_entrance.Update(map)
--Engine callback function
function apricorn_grove_entrance.Update(map)


end

---apricorn_grove_entrance.GameSave(map)
--Engine callback function
function apricorn_grove_entrance.GameSave(map)

	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))

end

---apricorn_grove_entrance.GameLoad(map)
--Engine callback function
function apricorn_grove_entrance.GameLoad(map)

	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	apricorn_grove_entrance.PlotScripting()

end


function apricorn_grove_entrance.PlotScripting()
	if SV.ChapterProgression.Chapter == 4 then 
		if not SV.Chapter4.EnteredGrove then--first time
			apricorn_grove_entrance_ch_4.FirstAttemptCutscene()
		elseif not SV.Chapter4.FinishedGrove and not SV.Chapter4.ReachedGlade and not SV.ApricornGrove.InDungeon then 
			apricorn_grove_entrance_ch_4.SubsequentAttemptCutscene()--failed; hasn't made it to the end yet
		elseif not SV.Chapter4.FinishedGrove and SV.Chapter4.ReachedGlade and not SV.ApricornGrove.InDungeon then  
			apricorn_grove_entrance_ch_4.FailedNoFullTeamReattempt()--failed; made it to the end, but couldn't get the apricorn
		elseif SV.ApricornGrove.InDungeon and not SV.Chapter4.BacktrackedOutGroveYet then
			apricorn_grove_entrance_ch_4.FirstComeOutFront()--Came out the front from the dungeon for the first time
		elseif SV.ApricornGrove.InDungeon and SV.Chapter4.BacktrackedOutGroveYet then
			apricorn_grove_entrance.ComeOutFront()--generic come out front from dungeon
		else
			GAME:FadeIn(20)--this should never happen in actual gameplay, but useful for debug warping here
		end
	else
		if SV.ApricornGrove.InDungeon then
			apricorn_grove_entrance.ComeOutFront()
		else 
			GAME:FadeIn(20)
		end
	end
end

--Generic come out front cutscene
function apricorn_grove_entrance.ComeOutFront() 
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local guest1 = CH('Guest1')
	local guest2 = CH('Guest2')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 40, Direction.Down)
	GROUND:TeleportTo(partner, 172, 40, Direction.Down)
	
	--Check if we have a guest. If we do, overwrite team2 or team3 accordingly based on party size so they take that slot in the cutscene.
	if guest1 ~= nil then
		if GAME:GetPlayerPartyCount() == 2 then 
			team2 = guest1 
		else
			team3 = guest1
		end
	end 
	
	
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 16, Direction.Down)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 16, Direction.Down)
	end
	
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) 
											      GAME:WaitFrames(20)
												  GeneralFunctions.LookAround(partner, 3 , 4, true, true, false, Direction.Right) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 140, 200, false, 1) 
												  GAME:WaitFrames(20)
												  GeneralFunctions.LookAround(hero, 3 , 4, true, false, false, Direction.Left) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
												  GAME:WaitFrames(2)
												  GROUND:MoveToPosition(team2, 156, 176, false, 1) 
												  GAME:WaitFrames(28)
												  GeneralFunctions.LookAround(team2, 3 , 4, true, false, false, Direction.Down) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
												  GAME:WaitFrames(6)
												  GROUND:MoveToPosition(team3, 188, 176, false, 1) 
												  GAME:WaitFrames(32)
												  GeneralFunctions.LookAround(team3, 3 , 4, true, false, false, Direction.DownLeft) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function()	GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] Looks like we're back at the entrance.") 
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] what should we do?")
	UI:BeginChoiceMenu("Should we head back into the dungeon,[pause=10] or should we call it a day and head back to the guild?", {"Go back in", "Head home"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	if result == 1 then
		UI:WaitShowDialogue("OK,[pause=10] we'll head back into the dungeon then.")
		UI:WaitShowDialogue("Let's go,[pause=10] " .. hero:GetDisplayName() .. "!")
		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
		TASK:JoinCoroutines({coro1, coro2})
		
		GAME:WaitFrames(10)
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
												GROUND:MoveToPosition(hero, 140, 32, false, 1) end)	
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												GROUND:MoveToPosition(partner, 172, 32, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
												GROUND:CharAnimateTurnTo(team2, Direction.Up, 4)
												GROUND:MoveToPosition(team2, 156, 8, false, 1) end end)
		coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
												GROUND:CharAnimateTurnTo(team3, Direction.Up, 4)
												GROUND:MoveToPosition(team3, 188, 8, false, 1) end end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
		GAME:CutsceneMode(false)
		GAME:WaitFrames(20)
		GAME:ContinueDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else 
		UI:WaitShowDialogue("OK,[pause=10] we'll call it a day and head back to the guild then.")
		UI:WaitShowDialogue("C'mon.[pause=0] Let's head home!")
		GAME:WaitFrames(40)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)	
		SV.ApricornGrove.InDungeon = false
		GAME:CutsceneMode(false)
		GAME:WaitFrames(90)

		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 

		--Go to second floor if mission was done, else, dinner room
		if SV.TemporaryFlags.MissionCompleted then
			GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Escaped, "master_zone", -1, 22, 0, true, true)
		else
			GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Escaped, "master_zone", -1, 6, 0, true, true)
		end		
		
	end
end

-------------------------------
-- Entities Callbacks
-------------------------------
function apricorn_grove_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

function apricorn_grove_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function apricorn_grove_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end
 
return apricorn_grove_entrance

