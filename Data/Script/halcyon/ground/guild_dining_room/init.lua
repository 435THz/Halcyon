--[[
    init.lua
    Created: 06/28/2021 23:45:55
    Description: Autogenerated script file for the map guild_dining_room.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.guild_dining_room.guild_dining_room_ch_1'


-- Package name
local guild_dining_room = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---guild_dining_room.Init
--Engine callback function
function guild_dining_room.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_dining_room<<=')
	
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

---guild_dining_room.Enter
--Engine callback function
function guild_dining_room.Enter(map)
	guild_dining_room.PlotScripting()
end

---guild_dining_room.Exit
--Engine callback function
function guild_dining_room.Exit(map)


end

---guild_dining_room.Update
--Engine callback function
function guild_dining_room.Update(map)


end

function guild_dining_room.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_dining_room.PlotScripting()
end

function guild_dining_room.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_dining_room.PlotScripting()
	--if dinnertime flag is set, play a generic dinnertime cutscene and override any other plotscripting logic
	if SV.TemporaryFlags.Dinnertime then
		guild_dining_room.Dinnertime(true)
	else
		--plot scripting
		if SV.ChapterProgression.Chapter == 1 then
			guild_dining_room_ch_1.SetupGround()
		else
			GAME:FadeIn(20)
		end
	end
end

-------------------------------
-- Entities Callbacks
-------------------------------
function guild_dining_room.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guild_dining_room.Snubbull_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_dining_room_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Snubbull_Action(...,...)"), chara, activator))
end





----------------------------
--
----------------------------
function guild_dining_room.Dinnertime(generic)
	if generic == nil then generic = true end
	
	GAME:CutsceneMode(false)
	SOUND:StopBGM()--cut the music if it hasn't been already, music should have been faded out by whatever leads into these scene though
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tropius, noctowl, mareep, cranidos, girafarig, breloom, audino, snubbull, growlithe, zigzagoon =
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 'Tropius'},
			{'Noctowl', 'Noctowl'},
			{'Mareep', 'Mareep'},
			{'Cranidos', 'Cranidos'},
			{'Girafarig', 'Girafarig'}, 
			{'Breloom', 'Breloom'},
			{'Audino', 'Audino'},
			{'Snubbull', 'Snubbull'},
			{'Growlithe', 'Growlithe'},
			{'Zigzagoon', 'Zigzagoon'}
		})
	

	AI:DisableCharacterAI(partner)

	local nightWindow1 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													RogueElements.Rect(104, 56, 64, 64),
													RogueElements.Loc(0, 0), 
													false, 
													"Window_Dinner_1")	
	
	local nightWindow2 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													RogueElements.Rect(248, 56, 64, 64),
													RogueElements.Loc(0, 0), 
													false, 
													"Window_Dinner_2")
													
	nightWindow1:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(nightWindow1)
	nightWindow2:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(nightWindow2)
													

	GROUND:CharSetAnim(hero, "Eat", true)
	GROUND:CharSetAnim(partner, "Eat", true)
	GROUND:CharSetAnim(tropius, "Eat", true)
	GROUND:CharSetAnim(noctowl, "Eat", true)
	GROUND:CharSetAnim(cranidos, "Eat", true)
	GROUND:CharSetAnim(mareep, "Eat", true)
	GROUND:CharSetAnim(girafarig, "Eat", true)
	GROUND:CharSetAnim(breloom, "Eat", true)
	GROUND:CharSetAnim(audino, "Eat", true)
	GROUND:CharSetAnim(snubbull, "Eat", true)
	GROUND:CharSetAnim(growlithe, "Eat", true)
	GROUND:CharSetAnim(zigzagoon, "Eat", true)
	
	GROUND:CharSetEmote(hero, "eating", 0)
	GROUND:CharSetEmote(partner, "eating", 0)
	GROUND:CharSetEmote(tropius, "eating", 0)
	GROUND:CharSetEmote(noctowl, "eating", 0)
	GROUND:CharSetEmote(cranidos, "eating", 0)
	GROUND:CharSetEmote(mareep, "eating", 0)
	GROUND:CharSetEmote(girafarig, "eating", 0)
	GROUND:CharSetEmote(breloom, "eating", 0)
	GROUND:CharSetEmote(audino, "eating", 0)
	GROUND:CharSetEmote(snubbull, "eating", 0)
	GROUND:CharSetEmote(growlithe, "eating", 0)
	GROUND:CharSetEmote(zigzagoon, "eating", 0)
	
	
	GROUND:Unhide('Food_Hero')
	GROUND:Unhide('Food_Partner')
	GROUND:Unhide('Food_Tropius')
	GROUND:Unhide('Food_Mareep')
	GROUND:Unhide('Food_Noctowl')
	GROUND:Unhide('Food_Cranidos')
	GROUND:Unhide('Food_Breloom')
	GROUND:Unhide('Food_Girafarig')
	GROUND:Unhide('Food_Snubbull')
	GROUND:Unhide('Food_Audino')
	GROUND:Unhide('Food_Growlithe')
	GROUND:Unhide('Food_Zigzagoon')
	GROUND:Unhide('Food_Big')
	
	--disable collision, then teleport them to their markers as they won't be pushed out anymore
	hero.CollisionDisabled = true
	partner.CollisionDisabled = true
	tropius.CollisionDisabled = true
	noctowl.CollisionDisabled = true
	growlithe.CollisionDisabled = true
	zigzagoon.CollisionDisabled = true
	mareep.CollisionDisabled = true
	cranidos.CollisionDisabled = true
	breloom.CollisionDisabled = true
	girafarig.CollisionDisabled = true
	audino.CollisionDisabled = true
	snubbull.CollisionDisabled = true
	
	GROUND:TeleportTo(hero, MRKR('Hero').Position.X, MRKR('Hero').Position.Y, MRKR('Hero').Direction)
	GROUND:TeleportTo(partner, MRKR('Partner').Position.X, MRKR('Partner').Position.Y, MRKR('Partner').Direction)
	GROUND:TeleportTo(tropius, MRKR('Tropius').Position.X, MRKR('Tropius').Position.Y, MRKR('Tropius').Direction)
	GROUND:TeleportTo(noctowl, MRKR('Noctowl').Position.X, MRKR('Noctowl').Position.Y, MRKR('Noctowl').Direction)
	GROUND:TeleportTo(growlithe, MRKR('Growlithe').Position.X, MRKR('Growlithe').Position.Y, MRKR('Growlithe').Direction)
	GROUND:TeleportTo(zigzagoon, MRKR('Zigzagoon').Position.X, MRKR('Zigzagoon').Position.Y, MRKR('Zigzagoon').Direction)
	GROUND:TeleportTo(mareep, MRKR('Mareep').Position.X, MRKR('Mareep').Position.Y, MRKR('Mareep').Direction)
	GROUND:TeleportTo(cranidos, MRKR('Cranidos').Position.X, MRKR('Cranidos').Position.Y, MRKR('Cranidos').Direction)
	GROUND:TeleportTo(breloom, MRKR('Breloom').Position.X, MRKR('Breloom').Position.Y, MRKR('Breloom').Direction)
	GROUND:TeleportTo(girafarig, MRKR('Girafarig').Position.X, MRKR('Girafarig').Position.Y, MRKR('Girafarig').Direction)
	GROUND:TeleportTo(audino, MRKR('Audino').Position.X, MRKR('Audino').Position.Y, MRKR('Audino').Direction)
	GROUND:TeleportTo(snubbull, MRKR('Snubbull').Position.X, MRKR('Snubbull').Position.Y, MRKR('Snubbull').Direction)

	--during second half of chapter 3 and all of chapter 4, girafarig and breloom are absent
	--This is kind of a hacky way of doing this, but it works
	--todo? Handle this better instead of a hardcode here
	if SV.ChapterProgression.Chapter == 4 or (SV.ChapterProgression.Chapter == 3 and SV.Chapter3.DefeatedBoss) then
		GROUND:TeleportTo(breloom, 640, 280, Direction.Up)
		GROUND:TeleportTo(girafarig, 640, 312, Direction.Up)
		GROUND:Hide("Food_Breloom")
		GROUND:Hide("Food_Girafarig")
	end

	GAME:MoveCamera(288, 156, 1, false)
	
	if generic then 
		local stopEating = false 
		UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
		GAME:WaitFrames(60)--don't load in too fast. give it a second to transition properly.
		SOUND:LoopSE('Dinner Eating')
		local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(208, 156, 184, false)
													  GAME:WaitFrames(120)
													  stopEating = true end)
		local coro3 = TASK:BranchCoroutine(function() while not stopEating do 
														UI:WaitShowTimedDialogue("Crunch-munch! Om-nom-nom! Chomp-chomp!\nCrunch-munch! Om-nom-nom! Chomp-chomp!", 6)
													  end
													  SOUND:FadeOutSE('Dinner Eating', 120)
													  GAME:FadeOut(false, 120)  end)
		
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		--wait a bit before going to bedtime scene
		GAME:WaitFrames(40)
		GAME:CutsceneMode(false)
		SV.TemporaryFlags.Dinnertime = false --clear flag
		SV.partner.Spawn = 'Default'
		GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
	
	end 
 
end 
								







---------------------------
-- Map Transitions
---------------------------
function guild_dining_room.Right_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_third_floor_lobby", "Guild_Third_Floor_Lobby_Left_Marker")
  SV.partner.Spawn = 'Guild_Third_Floor_Lobby_Left_Marker_Partner'
end

return guild_dining_room