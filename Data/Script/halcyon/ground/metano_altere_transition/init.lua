--[[
    init.lua
    Created: 06/17/2021 20:55:40
    Description: Autogenerated script file for the map metano_altere_transition.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.metano_altere_transition.metano_altere_transition_ch_1'
require 'halcyon.ground.metano_altere_transition.metano_altere_transition_ch_2'

-- Package name
local metano_altere_transition = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---metano_altere_transition.Init
--Engine callback function
function metano_altere_transition.Init(map)


  
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
  GROUND:AddMapStatus("clouds_overhead")
  if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
    SOUND:PlayBGM(SV.metano_town.Song, true)
  end
end

---metano_altere_transition.Enter
--Engine callback function
function metano_altere_transition.Enter(map)
	metano_altere_transition.PlotScripting()
end

---metano_altere_transition.Exit
--Engine callback function
function metano_altere_transition.Exit(map)


end

---metano_altere_transition.Update
--Engine callback function
function metano_altere_transition.Update(map)


end


function metano_altere_transition.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_altere_transition.PlotScripting()
end

function metano_altere_transition.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_altere_transition.PlotScripting()
  --plot scripting
  if SV.ChapterProgression.Chapter == 1 then
	metano_altere_transition_ch_1.HeartToHeartCutscene()
  elseif SV.ChapterProgression.Chapter == 2 then
	metano_altere_transition_ch_2.SetupGround()
  else
	GAME:FadeIn(20)
  end
end
---------------------------
-- Map Transitions 
---------------------------

function metano_altere_transition.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Metano_South_Entrance_Marker", true)
  SV.partner.Spawn = 'Metano_South_Entrance_Marker_Partner'
end

function metano_altere_transition.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "File Select.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker", SV.metano_town.Song == 'File Select.ogg')
  SV.partner.Spawn = 'Default'
end


-------------------------------
-- Entities Callbacks
-------------------------------

function metano_altere_transition.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return metano_altere_transition
