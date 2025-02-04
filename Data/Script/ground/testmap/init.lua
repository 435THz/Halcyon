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
	SV.ChapterProgression.Chapter = 4
	--Mark all dungeons as completed as well just so we can actually make jobs for them
	local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
	for ii = 0, dungeon_keys.Count-1 ,1 do
		_DATA.Save:CompleteDungeon(dungeon_keys[ii])
	end
end

---testmap.Update
--Engine callback function
function testmap.Update(map, time)


end




-------------------------------
-- Entities Callbacks
-------------------------------

function testmap.EnterCavern_Action(chara, activator)
GAME:EnterDungeon("crooked_cavern", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterRiver_Action(chara, activator)
GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.EnterGrove_Action(chara, activator)
GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function testmap.Make_Missions_Action(chara, activator)
	print("Running mission generation!")  
	MISSION_GEN.ResetBoards()
	MISSION_GEN.RemoveMissionBackReference()
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_MISSION)
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_OUTLAW)
	MISSION_GEN.SortMission()
	MISSION_GEN.SortOutlaw()
end

function testmap.See_Taken_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.TakenBoard[i].Client .. " Target: " .. SV.TakenBoard[i].Target ..
			" Zone: " .. SV.TakenBoard[i].Zone .. " Reward: " .. SV.TakenBoard[i].Reward .. " Floor: " .. SV.TakenBoard[i].Floor .. " Type: "
			.. SV.TakenBoard[i].Type .. " Completion: " .. SV.TakenBoard[i].Completion .. " Taken: " .. tostring(SV.TakenBoard[i].Taken) .. " Difficulty: " .. SV.TakenBoard[i].Difficulty .. " Item: " .. SV.TakenBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Mission_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.MissionBoard[i].Client .. " Target: " .. SV.MissionBoard[i].Target ..
			" Zone: " .. SV.MissionBoard[i].Zone .. " Reward: " .. SV.MissionBoard[i].Reward .. " Floor: " .. SV.MissionBoard[i].Floor .. " Type: "
			.. SV.MissionBoard[i].Type .. " Completion: " .. SV.MissionBoard[i].Completion .. " Taken: " .. tostring(SV.MissionBoard[i].Taken) .. " Difficulty: " .. SV.MissionBoard[i].Difficulty .. " Item: " .. SV.MissionBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end

function testmap.See_Outlaw_Action(chara, activator)
	UI:ResetSpeaker()
	UI:SetAutoFinish(true)
	for i = 1, 8, 1 do
		UI:WaitShowDialogue("Job " .. tostring(i) .. ": Client: " .. SV.OutlawBoard[i].Client .. " Target: " .. SV.OutlawBoard[i].Target ..
			" Zone: " .. SV.OutlawBoard[i].Zone .. " Reward: " .. SV.OutlawBoard[i].Reward .. " Floor: " .. SV.OutlawBoard[i].Floor .. " Type: "
			.. SV.OutlawBoard[i].Type .. " Completion: " .. SV.OutlawBoard[i].Completion .. " Taken: " .. tostring(SV.OutlawBoard[i].Taken) .. " Difficulty: " .. SV.OutlawBoard[i].Difficulty ..  " Item: " .. SV.OutlawBoard[i].Item)			
	end
	UI:SetAutoFinish(false)
end


function testmap.See_Job_1_Menu_Action(chara, activator)
  local menu = JobMenu:new(COMMON.MISSION_BOARD_MISSION, 1)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
end

function testmap.See_Mission_Board_Action(chara, activator)
	  local menu = BoardSelectionMenu:new(COMMON.MISSION_BOARD_MISSION)
	  UI:SetCustomMenu(menu.menu)
	  UI:WaitForChoice()
end


function testmap.See_Outlaw_Board_Action(chara, activator)
	  local menu = BoardSelectionMenu:new(COMMON.MISSION_BOARD_OUTLAW)
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


function testmap.CompleteTakens_Action()
	if SV.TakenBoard[1].Client ~= '' then
		for i =1, 8, 1 do 
			if SV.TakenBoard[i].Client ~= '' then
				SV.TakenBoard[i].Completion = MISSION_GEN.COMPLETE
			else 
				break
			end 
		end 
	end 
	SV.TemporaryFlags.MissionCompleted = true
	SV.TemporaryFlags.Dinnertime = true
	UI:WaitShowDialogue("Taken missions completed!")
end 

function testmap.Get_Released_Mons_Action()
	--mons is a list of all species index strings
	--local mons = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:GetOrderedKeys(false)
	--for i = 1, 906, 1 do
	--	if _DATA:GetMonster(mons[i]).Released then
	--		print(mons[i]) 
	--	 end
	--end
	
	--mons is a list of all species index strings
	local mons = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:GetOrderedKeys(false)
	for i = 1, 2000, 1 do
		if _DATA:GetItem(mons[i]).ItemData.UsageType == _DATA:GetItem("tm_acrobatics").ItemData.UsageType then
			print(mons[i]) 
		 end
	end
end

--[[
potential sfx:
EVT_EP_Aegis_Cave_Marker_Glow
EVT_EP_Palkia_Transport
_UNK_EVT_106
_UNK_EVT_079 (TIME GEAR TAKE DOWN)

]]--
function testmap.Test_Core_Deactivation_Action(chara, activator)
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	
	GAME:MoveCamera(688, 936, 1, false)
	
	local root = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Anima_Root", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(600, 864, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 0), --offset
												 true, 
												 "Anima_Root")--object entity name	
												 
	root:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(root)
	
	local core = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Anima_Core", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(600, 865, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, -1), --offset
												 true, 
												 "Anima_Core")--object entity name	
				
	core:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(core)
	
	--setup darkness
	--It'll fade in for 200 frames, last 0 frames, and fade out in 0 frames. It'll transition to the darkness map status though at 200 frames.
	local overlay = RogueEssence.Content.FiniteOverlayEmitter()
    overlay.TotalTime = 0;
	overlay.FadeIn = 200;
	overlay.FadeOut = 0;
	overlay.Layer = DrawLayer.Top;
	overlay.Anim = RogueEssence.Content.BGAnimData("White", 0)
	overlay.Color = Color(0, 0, 0, 76/255)
	
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root', 10, 0, 15, Direction.Down)
	GROUND:ObjectSetDefaultAnim(core, 'Anima_Core', 10, 0, 31, Direction.Down)

	SOUND:LoopBattleSE('_UNK_EVT_106')
	GROUND:ObjectWaitAnimFrame(core, 0)
	GROUND:ObjectWaitAnimFrame(core, 25)
	print("shart")
	SOUND:FadeOutBattleSE('_UNK_EVT_106', 60)
	GROUND:ObjectWaitAnimFrame(core, 0)
	print("Shart")
	
	SOUND:PlayBattleSE('EVT_EP_Nightmare_Break')
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(core, 10, 0, 11, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 11, 11, Direction.Down)
	
	GROUND:ObjectWaitAnimFrame(core, 11)
	GAME:WaitFrames(40)
	
	--move core slowly down after deactivating
	for i = 1, 10, 1 do
		GROUND:MoveObjectToPosition(core, core.Position.X, core.Position.Y + 1, 1)
		GAME:WaitFrames(8)
	end
	
	GROUND:ObjectWaitAnimFrame(root, 0)
	
	GROUND:PlayVFX(overlay, CH('PLAYER').Position.X, CH('PLAYER').Position.Y)
	SOUND:PlayBattleSE("_UNK_EVT_079")
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(root, 40, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 5, 5, Direction.Down)
	
	GAME:WaitFrames(200)
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(180)
	GAME:GetCurrentGround():RemoveTempObject(root)
	GAME:GetCurrentGround():RemoveTempObject(core)
	GAME:MoveCamera(0, 0, 1, true)
	GAME:CutsceneMode(false)
	SOUND:PlayBGM('Deep Dark Crater.ogg', true)
	GROUND:RemoveMapStatus("darkness")
	GAME:GetCurrentGround():RemoveTempObject(groundObj)
end
	
	
	
												 
												 

return testmap

