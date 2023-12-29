--[[
    init.lua
    Created: 12/23/2023 13:26:42
    Description: Autogenerated script file for the map searing_tunnel_entrance.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'

-- Package name
local searing_tunnel_entrance = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---searing_tunnel_entrance.Init(map)
--Engine callback function
function searing_tunnel_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_searing_tunnel_entrance <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

end

---searing_tunnel_entrance.Enter(map)
--Engine callback function
function searing_tunnel_entrance.Enter(map)

  apricorn_glade.PlotScripting()

end

---searing_tunnel_entrance.Exit(map)
--Engine callback function
function searing_tunnel_entrance.Exit(map)


end

---searing_tunnel_entrance.Update(map)
--Engine callback function
function searing_tunnel_entrance.Update(map)


end

---searing_tunnel_entrance.GameSave(map)
--Engine callback function
function searing_tunnel_entrance.GameSave(map)

	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))

end

---searing_tunnel_entrance.GameLoad(map)
--Engine callback function
function searing_tunnel_entrance.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	searing_tunnel_entrance.PlotScripting()
end

function searing_tunnel_entrance.PlotScripting()
  GAME:FadeIn(20)
end 


-------------------------------
-- Entities Callbacks
-------------------------------
function searing_tunnel_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

function searing_tunnel_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function searing_tunnel_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return searing_tunnel_entrance

