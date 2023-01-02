--[[
    init.lua
    Created: 02/06/2021 17:32:04
    Description: Autogenerated script file for the map testmap.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'mission_gen'

-- Package name
local testmap = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---testmap.Init
--Engine callback function
function testmap.Init(map, time)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  
  --local chara = CH('Teammate1')
	--AI:SetCharacterAI(chara, "ai.ground_partner", CH('PLAYER'), chara.Position)
   -- chara.CollisionDisabled = true
	
	--GROUND:AddMapStatus("darkness")

end

---testmap.Enter
--Engine callback function
function testmap.Enter(map, time)


end

---testmap.Update
--Engine callback function
function testmap.Update(map, time)


end




-------------------------------
-- Entities Callbacks
-------------------------------


function testmap.Make_Missions_Action(chara, activator)
	print("Running mission generation!")
	MISSION_GEN.ResetBoards()
	MISSION_GEN.GenerateBoard("Mission")
	MISSION_GEN.GenerateBoard("Outlaw")
	MISSION_GEN.SortMission()
	MISSION_GEN.SortOutlaw()
end

function testmap.See_Taken_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.TakenBoard[i].Client .. " Target: " .. SV.TakenBoard[i].Target ..
			" Zone: " .. SV.TakenBoard[i].Zone .. " Reward: " .. SV.TakenBoard[i].Reward .. " Floor: " .. SV.TakenBoard[i].Floor .. " Type: "
			.. SV.TakenBoard[i].Type .. " Completion: " .. SV.TakenBoard[i].Completion .. " Taken: " .. tostring(SV.TakenBoard[i].Taken) .. " Difficulty: " .. SV.TakenBoard[i].Difficulty)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Mission_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.MissionBoard[i].Client .. " Target: " .. SV.MissionBoard[i].Target ..
			" Zone: " .. SV.MissionBoard[i].Zone .. " Reward: " .. SV.MissionBoard[i].Reward .. " Floor: " .. SV.MissionBoard[i].Floor .. " Type: "
			.. SV.MissionBoard[i].Type .. " Completion: " .. SV.MissionBoard[i].Completion .. " Taken: " .. tostring(SV.MissionBoard[i].Taken) .. " Difficulty: " .. SV.MissionBoard[i].Difficulty)			
	end
	UI:SetAutoFinish(false)
end

function testmap.See_Outlaw_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.OutlawBoard[i].Client .. " Target: " .. SV.OutlawBoard[i].Target ..
			" Zone: " .. SV.OutlawBoard[i].Zone .. " Reward: " .. SV.OutlawBoard[i].Reward .. " Floor: " .. SV.OutlawBoard[i].Floor .. " Type: "
			.. SV.OutlawBoard[i].Type .. " Completion: " .. SV.OutlawBoard[i].Completion .. " Taken: " .. tostring(SV.OutlawBoard[i].Taken) .. " Difficulty: " .. SV.OutlawBoard[i].Difficulty)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Job_1_Menu_Action(chara, activator)
  local menu = JobMenu:new("mission", 1)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end

function testmap.See_Mission_Board_Action(chara, activator)
  local menu = BoardMenu:new("mission")
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end


function testmap.See_Outlaw_Board_Action(chara, activator)
  local menu = BoardMenu:new("outlaw")
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end


function testmap.See_Taken_Board_Action(chara, activator)
  local menu = BoardMenu:new("taken")
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end



function testmap.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end



return testmap

