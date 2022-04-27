--[[
    init.lua
    Created: 03/21/2021 22:07:39
    Description: Autogenerated script file for the map metano_fire_home.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.metano_fire_home.metano_fire_home_ch_2'

-- Package name
local metano_fire_home = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_fire_home.Init
--Engine callback function
function metano_fire_home.Init(map, time)

	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_fire_home <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

---metano_fire_home.Enter
--Engine callback function
function metano_fire_home.Enter(map, time)

	metano_fire_home.PlotScripting()

end

---metano_fire_home.Exit
--Engine callback function
function metano_fire_home.Exit(map, time)


end

---metano_fire_home.Update
--Engine callback function
function metano_fire_home.Update(map, time)


end

function metano_fire_home.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_fire_home.PlotScripting()
end

function metano_fire_home.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function metano_fire_home.PlotScripting()
	if SV.ChapterProgression.Chapter == 2 then 
		metano_fire_home_ch_2.SetupGround()
	else
		GAME:FadeIn(20)
	end
end

-------------------------------
-- Map Transitions
-------------------------------

function metano_fire_home.Fire_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Fire_Home_Entrance_Marker")
  SV.partner.Spawn = 'Fire_Home_Entrance_Marker_Partner'
end



------------------
--NPCS 
----------------
function metano_fire_home.Camerupt_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_fire_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Camerupt_Action(...,...)"), chara, activator))
end

function metano_fire_home.Numel_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_fire_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Numel_Action(...,...)"), chara, activator))
end




function metano_fire_home.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))end

return metano_fire_home

