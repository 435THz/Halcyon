require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_2 = {}

function metano_town_ch_2.SetupGround()

	if SV.Chapter2.FirstMorningMeetingDone and not SV.Chapter2.FinishedTraining then
		--these objects prevent the player from going into the rest of the town too soon, as they must go to the dojo first and complete training
		local stoneBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(896, 880, 16, 40),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_1")
		
		local bridgeBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(464, 1184, 16, 64),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_2")

		local marketBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(968, 1000, 16, 240),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_3")
		stoneBlock:ReloadEvents()
		bridgeBlock:ReloadEvents()
		marketBlock:ReloadEvents()

		GAME:GetCurrentGround():AddObject(stoneBlock)
		GAME:GetCurrentGround():AddObject(bridgeBlock)
		GAME:GetCurrentGround():AddObject(marketBlock)
		
		GAME:FadeIn(20)
	end
end

function metano_town_ch_2.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's the way to the market.[pause=0] I don't think Ledian Dojo is that way.")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I know I said I'd show you the town today,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")

end

function metano_town_ch_2.Event_Trigger_2_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's the way towards the housing area.[pause=0] I don't think Ledian Dojo is that way.")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I know I said I'd show you the town today,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")
end

function metano_town_ch_2.Event_Trigger_3_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] that must be the ladder to the dojo right over there!")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue("Let's head on in![pause=0] We'll have time after our training to take a look around town!")

end



--Growlithe himself is behind the desk, so there's an obj on the desk that we interact with to actually talk with him
function metano_town_ch_2.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	GROUND:CharTurnToChar(growlithe, CH('PLAYER'))
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("What's that,[pause=10] ruff?[pause=0] You're looking for Ledian Dojo?")
	GROUND:EntTurn(growlithe, Direction.DownRight)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(928, 1120, 180, false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:WaitShowDialogue("It's through the ladder by the river over there!")
	GAME:WaitFrames(20)
	GROUND:EntTurn(growlithe, Direction.Right)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('Teammate1'), growlithe, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('PLAYER'), growlithe, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(0, 0, 180, true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Just cross the bridge,[pause=10] then head east,[pause=10] ruff!")
	GROUND:EntTurn(growlithe, Direction.Right)
end