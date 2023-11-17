--[[
    init.lua
    Created: 11/11/2023 19:41:41
    Description: Autogenerated script file for the map bug_maze.
]]--
-- Commonly included lua functions and data
require 'common'
require 'GeneralFunctions'

local bug_maze = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function bug_maze.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_bug_maze")
end

function bug_maze.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function bug_maze.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_bug_maze (Bug Maze) result "..tostring(result).." segment "..tostring(segmentID))

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
	
	
	--flag bug_maze as last dojo zone
	SV.Dojo.LastZone = "bug_maze"

	
	--Failed to clear
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		SV.Dojo.TrainingFailedGeneric = true
	else--Cleared
		SV.Dojo.TrainingCompletedGeneric = true
	end
	
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)

end
	

return bug_maze
