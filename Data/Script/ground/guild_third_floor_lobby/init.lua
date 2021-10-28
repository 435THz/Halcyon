--[[
    init.lua
    Created: 06/28/2021 23:00:22--i've been copy and pasting this data so this timestamp is a couple days off lul, same for the bedroom areas
    Description: Autogenerated script file for the map guild_third_floor_lobby.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'AudinoAssembly'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_1'

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

end

---guild_third_floor_lobby.Enter
--Engine callback function
function guild_third_floor_lobby.Enter(map)
	if not SV.ChapterProgression.UnlockedAssembly then--hide audino at her assembly if it isn't unlocked yet
		GROUND:Hide('Assembly')
	end

	if SV.ChapterProgression.Chapter == 1 then
		if SV.Chapter1.TeamCompletedForest then 
			guild_third_floor_lobby_ch_1.GoToGuildmasterRoom()
		elseif SV.Chapter1.TeamJoinedGuild then

		else
			GAME:FadeIn(20)
		end
	else
		GAME:FadeIn(20)
	end

end

---guild_third_floor_lobby.Exit
--Engine callback function
function guild_third_floor_lobby.Exit(map)


end

---guild_third_floor_lobby.Update
--Engine callback function
function guild_third_floor_lobby.Update(map)


end

-------------------------------
-- Entities Callbacks
-------------------------------
function guild_third_floor_lobby.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guild_third_floor_lobby.Test_Action(chara, activator)
	SV.Chapter1.MetSnubbull = true
	SV.Chapter1.MetZigzagoon = true
	SV.Chapter1.MetCranidosMareep = true
	SV.Chapter1.MetBreloomGirafarig = true
	SV.Chapter1.MetAudino = true
	SV.Chapter1.TeamJoinedGuild = true
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("All guildmates now considered met.")
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 1\n\noh god im sharting\n", 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Dusknoir", 120, 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
end

function guild_third_floor_lobby.Noctowl_Action(chara, activator)
	print("im sharting")
end

function guild_third_floor_lobby.Assembly_Action(obj, activator)
	AudinoAssembly.Assembly(CH('Assembly'))
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

