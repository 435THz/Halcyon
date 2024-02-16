--[[
    init.lua
    Created: 12/13/2023 17:56:20
    Description: Autogenerated script file for the map searing_tunnel_midpoint.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'

-- Package name
local searing_tunnel_midpoint = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---searing_tunnel_midpoint.Init(map)
--Engine callback function
function searing_tunnel_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_searing_tunnel_midpoint <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies(true)
  GROUND:AddMapStatus("steam")
  PartnerEssentials.InitializePartnerSpawn()

end

---searing_tunnel_midpoint.Enter(map)
--Engine callback function
function searing_tunnel_midpoint.Enter(map)

  apricorn_glade.PlotScripting()

end

---searing_tunnel_midpoint.Exit(map)
--Engine callback function
function searing_tunnel_midpoint.Exit(map)


end

---searing_tunnel_midpoint.Update(map)
--Engine callback function
function searing_tunnel_midpoint.Update(map)


end

---searing_tunnel_midpoint.GameSave(map)
--Engine callback function
function searing_tunnel_midpoint.GameSave(map)

	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))

end

---searing_tunnel_midpoint.GameLoad(map)
--Engine callback function
function searing_tunnel_midpoint.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	searing_tunnel_midpoint.PlotScripting()
end

function searing_tunnel_midpoint.PlotScripting()
  GAME:FadeIn(20)
end 


-------------------------------
-- Entities Callbacks
-------------------------------
function searing_tunnel_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

function searing_tunnel_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function searing_tunnel_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return searing_tunnel_midpoint
