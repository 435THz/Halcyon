--[[
    init.lua
    Created: 01/01/2022 02:00:40
    Description: Autogenerated script file for the map ledian_dojo.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.ledian_dojo.ledian_dojo_ch_2'


-- Package name
local ledian_dojo = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---ledian_dojo.Init
--Engine callback function
function ledian_dojo.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_ledian_dojo <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()

	GROUND:AddMapStatus(50)--darkness

end

---ledian_dojo.Enter
--Engine callback function
function ledian_dojo.Enter(map)

  ledian_dojo.PlotScripting()

end

---ledian_dojo.Exit
--Engine callback function
function ledian_dojo.Exit(map)


end

---ledian_dojo.Update
--Engine callback function
function ledian_dojo.Update(map)


end

---ledian_dojo.GameSave
--Engine callback function
function ledian_dojo.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

---ledian_dojo.GameLoad
--Engine callback function
function ledian_dojo.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	ledian_dojo.PlotScripting()
end

function ledian_dojo.PlotScripting()
	GAME:FadeIn(20)
end




--modified version of common's ShowDestinationMenu. Has no capability for grounds, and sets risk to None if the dungeon chosen is a tutorial level
function ledian_dojo.ShowMazeMenu(dungeon_entrances)
  --check for unlock of dungeons
  local open_dests = {}
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[dungeon_entrances[ii]]
	  local zone_name = zone_summary:GetColoredName()
      table.insert(open_dests, { Name=zone_name, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
	end
  end
  
  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  if #open_dests == 1 then
      --single dungeon entry
      UI:ResetSpeaker()
      SOUND:PlaySE("Menu/Skip")
	  UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
  elseif #open_dests > 1 then
    
    UI:ResetSpeaker()
    SOUND:PlaySE("Menu/Skip")
    UI:DestinationMenu(open_dests)
	UI:WaitForChoice()
	dest = UI:ChoiceResult()
  end
  
  if dest:IsValid() then
	local risk = RogueEssence.Data.GameProgress.DungeonStakes.Risk
	--set risk to none if chosen level is a tutorial level
	if dest.ID == 51 then risk = RogueEssence.Data.GameProgress.DungeonStakes.None end
    SOUND:PlayBGM("", true)
    GAME:FadeOut(false, 20)
	GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, risk, true, false)
  end
end
-------------------------------
-- Map Transition
-------------------------------

function ledian_dojo.Dojo_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Dojo_Entrance_Marker")
  SV.partner.Spawn = 'Dojo_Entrance_Marker_Partner'
end

function ledian_dojo.Dungeon_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:UnlockDungeon(51)--todo: move to a cutscene
  local dungeon_entrances = { 51 }
  ledian_dojo.ShowMazeMenu(dungeon_entrances)
	
end

-------------------------------
-- Entities Callbacks
-------------------------------

function ledian_dojo.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return ledian_dojo
