--[[
    init.lua
    Created: 01/23/2021 11:46:06
    Description: Autogenerated script file for the map guild_first_floor.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'

-- Package name
local guild_first_floor = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_first_floor.Enter
--Engine callback function
function guild_first_floor.Enter(map)
	DEBUG.EnableDbgCoro()
	print('Enter_guild_first_floor')
	GAME:FadeIn(20)
	--GAME:MoveCamera(0,0,60, true)
	UI:ResetSpeaker()
end

---guild_first_floor.Update
--Engine callback function
function guild_first_floor.Update(map, time)


end

---guild_first_floor.Init
--Engine callback function
function guild_first_floor.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_first_floor <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


end

-------------------------------
-- Entities Callbacks
-------------------------------

function guild_first_floor.test_Action(obj, activator)
	GAME:FadeIn(20)
end

function guild_first_floor.Main_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Guild_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function guild_first_floor.Stairs_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function guild_first_floor.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end


return guild_first_floor

