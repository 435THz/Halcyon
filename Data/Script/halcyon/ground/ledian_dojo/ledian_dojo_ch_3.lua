require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_3 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_3.SetupGround()
	GROUND:TeleportTo(CH('Gible'), 144, 160, Direction.DownRight)
	AI:SetCharacterAI(CH('Gible'), "halcyon.ai.ground_default", RogueElements.Loc(128, 144), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
end


function ledian_dojo_ch_3.Gible_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "The training mazes at the dojo are great for getting more fighting experience!")
	UI:WaitShowDialogue("Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " organized each of them carefully so her students could train optimally.")
	UI:WaitShowDialogue("As such,[pause=10] you can get stronger faster here than you can in regular mystery dungeons!")
	UI:WaitShowDialogue("I know I've gotten a lot stronger ever since I started training here with Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " and her mazes!")
	GeneralFunctions.EndConversation(chara)
end

	
