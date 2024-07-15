--[[
    init.lua
    Created: 12/20/2023 21:11:27
    Description: Autogenerated script file for the map testmap_2.
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local testmap_2 = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = STRINGS.MapStrings['SomeStringName']


-------------------------------
-- Map Callbacks
-------------------------------
---testmap_2.Init(map)
--Engine callback function
function testmap_2.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  

end

---testmap_2.Enter(map)
--Engine callback function
function testmap_2.Enter(map)

  GAME:FadeIn(20)

end

---testmap_2.Exit(map)
--Engine callback function
function testmap_2.Exit(map)


end

---testmap_2.Update(map)
--Engine callback function
function testmap_2.Update(map)


end

---testmap_2.GameSave(map)
--Engine callback function
function testmap_2.GameSave(map)


end

---testmap_2.GameLoad(map)
--Engine callback function
function testmap_2.GameLoad(map)

  GAME:FadeIn(20)

end

-------------------------------
-- Entities Callbacks
-------------------------------


return testmap_2
