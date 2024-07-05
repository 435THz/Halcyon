--[[
    init.lua
    Created: 03/21/2021 22:07:39
    Description: Autogenerated script file for the map metano_water_home.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.metano_water_home.metano_water_home_ch_2'
require 'halcyon.ground.metano_water_home.metano_water_home_ch_3'
require 'halcyon.ground.metano_water_home.metano_water_home_ch_4'

-- Package name
local metano_water_home = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_water_home.Init
--Engine callback function
function metano_water_home.Init(map, time)

	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_water_home <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	
	if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
      SOUND:PlayBGM(SV.metano_town.Song, true)
    end
end

---metano_water_home.Enter
--Engine callback function
function metano_water_home.Enter(map, time)

	metano_water_home.PlotScripting()

end

---metano_water_home.Exit
--Engine callback function
function metano_water_home.Exit(map, time)


end

---metano_water_home.Update
--Engine callback function
function metano_water_home.Update(map, time)


end

function metano_water_home.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_water_home.PlotScripting()
end

function metano_water_home.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function metano_water_home.PlotScripting()
	if SV.ChapterProgression.Chapter == 2 then 
		metano_water_home_ch_2.SetupGround()
	elseif SV.ChapterProgression.Chapter == 3 then 
		metano_water_home_ch_3.SetupGround()		
	elseif SV.ChapterProgression.Chapter == 4 then 
		metano_water_home_ch_4.SetupGround()
	else
		GAME:FadeIn(20)
	end
end

-------------------------------
-- Map Transitions
-------------------------------

function metano_water_home.Water_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Water_Home_Entrance_Marker", true)
  SV.partner.Spawn = 'Water_Home_Entrance_Marker_Partner'
end



------------------
--NPCS 
----------------
function metano_water_home.Quagsire_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_water_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Quagsire_Action(...,...)"), chara, activator))
end

function metano_water_home.Floatzel_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_water_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Floatzel_Action(...,...)"), chara, activator))
end

function metano_water_home.Wooper_Girl_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_water_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Girl_Action(...,...)"), chara, activator))
end

function metano_water_home.Wooper_Boy_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_water_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Boy_Action(...,...)"), chara, activator))
end


function metano_water_home.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))end

return metano_water_home

