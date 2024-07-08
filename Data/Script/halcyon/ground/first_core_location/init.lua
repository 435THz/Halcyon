--[[
    init.lua
    Created: 02/05/2023 11:29:10
    Description: Autogenerated script file for the map first_core_location.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.first_core_location.first_core_location_ch_3'

-- Package name
local first_core_location = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---first_core_location.Init
--Engine callback function
function first_core_location.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_first_core_location<<=')
	
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

---first_core_location.Enter
--Engine callback function
function first_core_location.Enter(map)
	first_core_location.PlotScripting()
end

---first_core_location.Exit
--Engine callback function
function first_core_location.Exit(map)


end

---first_core_location.Update
--Engine callback function
function first_core_location.Update(map)


end

---first_core_location.GameSave
--Engine callback function
function first_core_location.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

---first_core_location.GameLoad
--Engine callback function
function first_core_location.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	first_core_location.PlotScripting()
end


function first_core_location.PlotScripting()
	if SV.ChapterProgression.Chapter == 3 and not SV.Chapter3.RootSceneTransition then 
		first_core_location_ch_3.RootPreviewScene()
	elseif SV.ChapterProgression.Chapter == 3 and SV.Chapter3.RootSceneTransition then 
		first_core_location_ch_3.RootDeactivationScene()
	else
		GAME:FadeIn(20)
	end
end
-------------------------------
-- Entities Callbacks
-------------------------------
function first_core_location.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end


return first_core_location

