--[[
    init.lua
    Created: 06/28/2021 23:00:22--i've been copy and pasting this data so this timestamp is a couple days off lul, same for the bedroom areas
    Description: Autogenerated script file for the map guild_third_floor_lobby.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'AudinoAssembly'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_1'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_2'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_3'


-- Package name
local guild_third_floor_lobby = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_third_floor_lobby.Init
--Engine callback function
function guild_third_floor_lobby.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_third_floor_lobby<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


	if not SV.ChapterProgression.UnlockedAssembly then--hide audino at her assembly if it isn't unlocked yet
		GROUND:Hide('Assembly')
		GROUND:Hide('Assembly_Owner')
	end


end

---guild_third_floor_lobby.Enter
--Engine callback function
function guild_third_floor_lobby.Enter(map)
	guild_third_floor_lobby.PlotScripting()
end

---guild_third_floor_lobby.Exit
--Engine callback function
function guild_third_floor_lobby.Exit(map)


end

---guild_third_floor_lobby.Update
--Engine callback function
function guild_third_floor_lobby.Update(map)


end


function guild_third_floor_lobby.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_third_floor_lobby.PlotScripting()
end

function guild_third_floor_lobby.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_third_floor_lobby.PlotScripting()
	--if generic morning address is flagged, prioritize that.
	if SV.TemporaryFlags.MorningAddress then 
		guild_third_floor_lobby.MorningAddress(true)
	else
	--plot scripting	
		if SV.ChapterProgression.Chapter == 1 then
			if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then 
				guild_third_floor_lobby_ch_1.GoToGuildmasterRoom()
			else
				guild_third_floor_lobby_ch_1.SetupGround()
			end
		elseif SV.ChapterProgression.Chapter == 2 then
			if not SV.Chapter2.FirstMorningMeetingDone then
				guild_third_floor_lobby_ch_2.FirstMorningMeeting()
			elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then 
				guild_third_floor_lobby_ch_2.BeforeFirstDinner()
			else
				guild_third_floor_lobby_ch_2.SetupGround()
			end
		elseif SV.ChapterProgression.Chapter == 3 then
			if not SV.Chapter3.FinishedOutlawIntro then
				guild_third_floor_lobby_ch_3.FirstMorningAddress()
			else 
				guild_third_floor_lobby_ch_3.SetupGround()
			end
		else
			GAME:FadeIn(20)
		end
	end
end

--potentially calls relevant scripts after a generic morning address was given. This would be stuff like
--Anything that happens after a completely generic opening should be called from here. If it wasn't completely generic, it won't be called from here.
--noctowl giving the day's mission or a comment from the partner.
function guild_third_floor_lobby.PostAddressScripting()
	if SV.ChapterProgression.Chapter == 2 then
		if SV.Chapter2.FinishedFirstDay and not SV.Chapter2.FinishedCameruptRequestScene then
			guild_third_floor_lobby_ch_2.PostSecondMorningAddress()--Noctowl will show you to the board for your first job.
		elseif SV.Chapter2.EnteredRiver then 
			guild_third_floor_lobby_ch_2.FailedRiver()--partner mentions that you need to go return to Illuminant Riverbed to rescue numel
		end
	elseif SV.ChapterProgression.Chapter == 3 then 
		if SV.Chapter3.EncounteredBoss then 
			guild_third_floor_lobby_ch_3.FailedCavernAfterBoss()--You made it to Team Style but haven't beaten them yet. Partner is mad about them. 
		elseif SV.TemporaryFlags.LastDungeonEntered ~= 57 then 
			guild_third_floor_lobby_ch_3.NotEnteredCavern() --Latest dungeon attempt was not the cavern and you haven't seen Team Style yet.
		else
			guild_third_floor_lobby_ch_3.FailedCavernBeforeBoss()--Your last dungeon was the cavern but you've not made it to Team Style yet.
		end	
	else --if there's nothing special to do, just give back control.
		GeneralFunctions.PanCamera()
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(CH('Teammate1'))
		AI:SetCharacterAI(CH('Teammate1'), "ai.ground_partner", CH('PLAYER'), CH('Teammate1').Position)
	end
end


function guild_third_floor_lobby.MorningAddress(generic)
	
	if generic == nil then generic = false end 

	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, 
		  breloom, mareep, cranidos = guild_third_floor_lobby.SetupMorningAddress()

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!")
	GAME:WaitFrames(20)
	
	--HURRAH!
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)	
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	
	GROUND:CharPoseAnim(growlithe, "Pose")
	GROUND:CharPoseAnim(zigzagoon, "Pose")
	GROUND:CharPoseAnim(breloom, "Pose")
	GROUND:CharPoseAnim(girafarig, "Pose")
	GROUND:CharPoseAnim(cranidos, "Pose")
	GROUND:CharPoseAnim(mareep, "Pose")
	GROUND:CharPoseAnim(audino, "Pose")
	GROUND:CharPoseAnim(snubbull, "Pose")	
	GROUND:CharPoseAnim(partner, "Pose")	
	GROUND:CharPoseAnim(hero, "Pose")	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)	
	GROUND:CharSetEmote(partner, "", 0)

	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	
	--everyone leaves
	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby.ApprenticeLeave(growlithe) end)
	local coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6) 
											guild_third_floor_lobby.ApprenticeLeaveBottom(zigzagoon) end)
	local coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby.ApprenticeLeave(mareep) end)
	local coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby.ApprenticeLeaveBottom(cranidos) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby.ApprenticeLeaveFast(snubbull) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby.ApprenticeLeaveBottomFast(audino) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby.ApprenticeLeaveFast(breloom) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby.ApprenticeLeaveBottomFast(girafarig) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
													GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1) end)
	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
												   GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
												   GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
												   GAME:GetCurrentGround():RemoveTempChar(tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})


	if generic then 
		--call post address scripting to see if anything additional is needed if address is generic 
		print("generic address.")
		SV.TemporaryFlags.MorningAddress = false
		guild_third_floor_lobby.PostAddressScripting()
		--[[the commented out functionality below was moved to the scripts that post address scripting calls		
		GeneralFunctions.PanCamera()
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)	]]--
	end

	
end 

function guild_third_floor_lobby.SetupMorningAddress()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--create characters
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos = 
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 'Tropius'},
			{'Noctowl', 'Noctowl'},
			{'Audino', 'Audino'},
			{'Snubbull', 'Snubbull'},
			{'Growlithe', 'Growlithe'},
			{'Zigzagoon', 'Zigzagoon'},
			{'Girafarig', 'Girafarig'},
			{'Breloom', 'Breloom'},
			{'Mareep', 'Mareep'},
			{'Cranidos', 'Cranidos'}})
	
	GeneralFunctions.CenterCamera({snubbull, tropius})
	GROUND:TeleportTo(partner, MRKR("Partner").X, MRKR("Partner").Y, MRKR("Partner").Direction)
	GROUND:TeleportTo(hero, MRKR("Hero").X, MRKR("Hero").Y, MRKR("Hero").Direction)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	return tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos
end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby.ApprenticeLeave(chara)
	GeneralFunctions.EightWayMove(chara, 544, 280, false, 1)
	GeneralFunctions.EightWayMove(chara, 628, 200, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby.ApprenticeLeaveBottom(chara)
	GeneralFunctions.EightWayMove(chara, 552, 312, false, 1)
	GeneralFunctions.EightWayMove(chara, 648, 208, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)
end

--used for having apprentices leave towards the stairs - shorter to end cutscene faster
function guild_third_floor_lobby.ApprenticeLeaveFast(chara)
	GeneralFunctions.EightWayMove(chara, 552, 280, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end

--used for having apprentices leave towards the stairs - shorter to end cutscene faster
function guild_third_floor_lobby.ApprenticeLeaveBottomFast(chara)
	GeneralFunctions.EightWayMove(chara, 552, 312, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end



---------------------------------
-- Event Object
-- This is a temporary object created by a script used for temporary objects events that only happen
-- that only exist when certain story flag conditions are met.
---------------------------------
function guild_third_floor_lobby.Event_Object_1_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_third_floor_lobby_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Object_1_Action(...,...)"), obj, activator))
end




---------------------------
-- Map Objects 
---------------------------
function guild_third_floor_lobby.Board_Action(chara, activator)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("(There are a number of internal guild postings here...)")
	UI:WaitShowDialogue("(...But you're not really sure what to make of them yet.)")
	UI:SetCenter(false)
end




-------------------------------
-- Entities Callbacks
-------------------------------
function guild_third_floor_lobby.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guild_third_floor_lobby.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_third_floor_lobby_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Noctowl_Action(...,...)"), chara, activator))
end

function guild_third_floor_lobby.Test_Action(chara, activator)
	SV.Chapter1.MetSnubbull = true
	SV.Chapter1.MetZigzagoon = true
	SV.Chapter1.MetCranidosMareep = true
	SV.Chapter1.MetBreloomGirafarig = true
	SV.Chapter1.MetAudino = false
	SV.Chapter1.TeamJoinedGuild = true

	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("All guildmates now considered met.")
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 1\n\nAnother Beginning\n", 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 120, 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:WaitShowDialogue("poop " .. STRINGS:LocalKeyString(9))

end

function guild_third_floor_lobby.Assembly_Action(obj, activator)
	AudinoAssembly.Assembly(CH('Assembly_Owner'))
end

---------------------------
-- Map Transitions
---------------------------
function guild_third_floor_lobby.Right_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_bedroom_hallway", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Left_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_dining_room", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Bottom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_storage_hallway", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Door_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_guildmasters_room", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Stairs_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_second_floor", 'Guild_Second_Floor_Upwards_Stairs_Marker')
  SV.partner.Spawn = 'Guild_Second_Floor_Upwards_Stairs_Marker_Partner'
end




return guild_third_floor_lobby

