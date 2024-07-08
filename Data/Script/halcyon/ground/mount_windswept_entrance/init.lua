--[[
    init.lua
    Created: 01/03/2024 12:34:54
    Description: Autogenerated script file for the map mount_windswept_entrance.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.mount_windswept_entrance.mount_windswept_entrance_ch_5'

-- Package name
local mount_windswept_entrance = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---mount_windswept_entrance.Init(map)
--Engine callback function
function mount_windswept_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_mount_windswept_entrance <<=')
  
  COMMON.RespawnAllies()
  GROUND:AddMapStatus("blowing_wind")
  PartnerEssentials.InitializePartnerSpawn()

end

---mount_windswept_entrance.Enter(map)
--Engine callback function
function mount_windswept_entrance.Enter(map)

  mount_windswept_entrance.PlotScripting()

end

---mount_windswept_entrance.Exit(map)
--Engine callback function
function mount_windswept_entrance.Exit(map)


end

---mount_windswept_entrance.Update(map)
--Engine callback function
function mount_windswept_entrance.Update(map)


end

---mount_windswept_entrance.GameSave(map)
--Engine callback function
function mount_windswept_entrance.GameSave(map)

	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))

end

---mount_windswept_entrance.GameLoad(map)
--Engine callback function
function mount_windswept_entrance.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	mount_windswept_entrance.PlotScripting()
end

function mount_windswept_entrance.PlotScripting()
  GAME:FadeIn(20)
end 


-------------------------------
-- Entities Callbacks
-------------------------------
function mount_windswept_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

function mount_windswept_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function mount_windswept_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return mount_windswept_entrance

