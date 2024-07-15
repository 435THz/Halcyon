--[[
    init.lua
    Created: 06/12/2023 20:58:54
    Description: Autogenerated script file for the map flying_maze.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'halcyon.GeneralFunctions'

local flying_maze = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function flying_maze.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_flying_maze")
end

function flying_maze.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function flying_maze.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_flying_maze (Water Maze) result "..tostring(result).." segment "..tostring(segmentID))

	GAME:SetRescueAllowed(false)
	
	--[[Different dungeon result typeS (cleared, died, etc)
	       public enum ResultType
        {
            Unknown = -1,
            Downed,
            Failed,
            Cleared,
            Escaped,
            TimedOut,
            GaveUp,
            Rescue
        }
		]]--
	
	
	--flag flying_zone as last dojo zone
	SV.Dojo.LastZone = "flying_maze"

	
	--Failed to clear
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		SV.Dojo.TrainingFailedGeneric = true
	else--Cleared
		SV.Dojo.TrainingCompletedGeneric = true
	end
	
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)

end
	

return flying_maze