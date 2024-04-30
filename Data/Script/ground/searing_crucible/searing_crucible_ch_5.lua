require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

searing_crucible_ch_5 = {}


--TASK:BranchCoroutine(function() searing_crucible_ch_5.FirstPreBossScene() end)
function searing_crucible_ch_5.FirstPreBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 184), Direction.Right, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(328, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(184, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 328), Direction.Left, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 184), Direction.Left, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(184, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(328, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 328), Direction.Right, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	
	GROUND:Hide('Slugma_Boy_1')
	GROUND:Hide('Slugma_Boy_2')
	GROUND:Hide('Slugma_Boy_3')
	GROUND:Hide('Slugma_Boy_4')
	GROUND:Hide('Slugma_Girl_1')
	GROUND:Hide('Slugma_Girl_2')
	GROUND:Hide('Slugma_Girl_3')
	GROUND:Hide('Slugma_Girl_4')
	
	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	GROUND:Hide('Magcargo')
	
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 240, 472, Direction.Up)
	GROUND:TeleportTo(partner, 272, 472, Direction.Up)
	GROUND:TeleportTo(growlithe, 240, 504, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 272, 504, Direction.Up)
	GAME:MoveCamera(264, 336, 1, false)
		
	GAME:CutsceneMode(true)
	GAME:WaitFrames(60)

	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', false)
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GeneralFunctions.EightWayMove(hero, 244, 312, false, 1)
											      end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 268, 312, false, 1)
											      end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
												  GeneralFunctions.EightWayMoveRS(growlithe, 240, 344, false, 1)
												  GROUND:EntTurn(growlithe, Direction.Up)
											      end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												  GeneralFunctions.EightWayMoveRS(zigzagoon, 272, 344, false, 1)
												  GROUND:EntTurn(zigzagoon, Direction.Up)
											      end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Left) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("We've made it pretty deep...")
	UI:WaitShowDialogue("Is this the deepest section of the tunnel?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I would think so,[pause=10] with how hot it's gotten.")
	UI:SetSpeakerEmotion("Pain")
	GROUND:CharSetEmote(zigzagoon, "sweating", 1)
	UI:WaitShowDialogue("Urf,[pause=10] I don't know how much more of this heat I can take...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ruff...[pause=0] It's starting to get to me too.[pause=0] I feel like I could melt!")
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Same here...[pause=0] But we don't have much further to go!")
	UI:WaitShowDialogue("Let's get through here quickly so we can get out of this heat and to the next camp.")
	GAME:WaitFrames(10)
	--they're interrupted by the ground shaking, and the lava flowing (magcargo doesn't have influence over these lava flows)
	--having the lava show up first also makes magcargo believe you're the one causing them (you showed up and it acted up)

	--takes about 20f to react to slugma materialization. each frame of materialization is 3 frames

	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 114, false, 1) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveInDirection(growlithe, Direction.Up, 110, false, 1) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 106, false, 1) end)	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y - 72, 72, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	local continueScene = true
	SOUND:StopBGM()
    SOUND:LoopSE("Light Earthquake")
	UI:SetSpeakerEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() while continueScene do
												GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
												GAME:WaitFrames(30)
											end
											end)
	coro2 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_Surprised')
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)
											UI:WaitShowDialogue("Waaah![pause=0] Wh-what!?[pause=0] Tremors!?")
											continueScene = false
											end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(hero, Direction.Up, 6, false, 1) --move the last little bit to get to the spot before reacting
											GROUND:CharSetEmote(hero, "shock", 1) 
											end)
	coro4 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(growlithe, Direction.Up, 10, false, 1) --move the last little bit to get to the spot before reacting
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(zigzagoon, Direction.Up, 14, false, 1) --move the last little bit to get to the spot before reacting
											GeneralFunctions.Recoil(growlithe, "Hurt", 10, 10, false, false)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	    

	--Lava starts spawning 80 frames in.
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
											GAME:WaitFrames(30)
											searing_crucible_ch_5.SpawnLava() end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)	--20
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)--28
											GAME:WaitFrames(10)--38
											GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)--50
											GAME:WaitFrames(10)--60
											GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)--68
											GAME:WaitFrames(10)--78
											GROUND:CharAnimateTurnTo(partner,Direction.Right, 4)--90
											GAME:WaitFrames(10)--100
											--SOUND:PlayBattleSE('EVT_Emote_Shock')
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)									
											GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 2)
											GROUND:MoveInDirection(partner, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)	--20
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)--28
											GAME:WaitFrames(10)--38
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4)--50
											GAME:WaitFrames(10)--60
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)--68
											GAME:WaitFrames(10)--78
											GROUND:CharAnimateTurnTo(hero,Direction.Left, 4)--94
											GAME:WaitFrames(10)--94
											GROUND:CharSetEmote(hero, "exclaim", 1)
											GAME:WaitFrames(38)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 2)
											GROUND:MoveInDirection(hero, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)	--26
											GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)--34
											GAME:WaitFrames(10)--44
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)--52
											GAME:WaitFrames(10)--62
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)--74
											GAME:WaitFrames(10)--84
											GROUND:CharAnimateTurnTo(growlithe,Direction.UpLeft, 4)--92
											GAME:WaitFrames(10)--102
											GROUND:CharSetEmote(growlithe, "shock", 1)
											GAME:WaitFrames(36)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 2)
											GROUND:MoveInDirection(growlithe, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)	--22
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)--30
											GAME:WaitFrames(10)--40
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)--52
											GAME:WaitFrames(10)--62
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)--74
											GAME:WaitFrames(10)--84
											GROUND:CharAnimateTurnTo(zigzagoon,Direction.UpRight, 4)--96
											GAME:WaitFrames(10)--106
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											GAME:WaitFrames(32)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 2)
											GROUND:MoveInDirection(zigzagoon, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											end)											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
-- GROUND:AnimateInDirection(zigzagoon, "Walk", zigzagoon.Direction, Direction.Down, 8, 1, 1)
											
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function()	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)										
											end)	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:WaitShowDialogue("W-woah![pause=0] That was close![pause=0] Is everyone OK!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("We're fine,[pause=10] ruff![pause=0] But...")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What are we gonna do now?[pause=0] The lava's in our way!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("The lava is volatile in this place,[pause=10] right?[pause=0]\nIt shifts around and moves all over the place!")
	UI:WaitShowDialogue("If we wait,[pause=10] the lava flow might change and clear the way forward.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I just hope it doesn't take long,[pause=10] this heat is unbearable!")

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I guess we have no choice.[pause=0] We'll have to wait and hope the lava goes away.")
	
	
	--You arrived and then the lava shifted. You must be the cause! You and all the other outlanders that have been passing through!
	GAME:WaitFrames(60)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("...Outlanders...[pause=0] Is this your doing?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Down)
	GAME:WaitFrames(10)
	
	GROUND:EntTurn(partner, Direction.DownLeft)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Huh?[pause=0] Did you guys hear that?")
	GAME:WaitFrames(10)
		
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)										
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ruff?[pause=0] No,[pause=10] I didn't hear anything.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I didn't hear anything either.")
	GAME:WaitFrames(40)
	
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("The instability...[pause=0] Outlanders...[pause=0] It must be your doing!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) 
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GeneralFunctions.EmoteAndPause(hero, "Notice", false) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", false) 
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(28) 
											GeneralFunctions.EmoteAndPause(zigzagoon, "Exclaim", false) 
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function()	GeneralFunctions.LookAround(partner, 2, 4, false, true, true, Direction.Right)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.UpLeft)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GeneralFunctions.LookAround(growlithe, 2, 4, false, false, false, Direction.DownLeft)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GeneralFunctions.LookAround(zigzagoon, 2, 4, false, false, true, Direction.Down)									
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Wh-what!?[pause=0] Who said that?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("You trepass on our land and cause turmoil,[pause=10] yet have the gall to question who we are!?")
	UI:WaitShowDialogue("Fine![pause=0] So be it![pause=0] We shall show you who we are!")
	GAME:WaitFrames(20)
	

    local materializeAnimLeft = RogueEssence.Content.AnimData("Slugma_Materialize", 3)
    local materializeAnimRight = RogueEssence.Content.AnimData("Slugma_Materialize", 3)
    local leftFlip = 1
    local rightFlip = 0
    local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')

    materializeAnimLeft.AnimFlip =  LUA_ENGINE:LuaCast(leftFlip, fliptype)
    materializeAnimRight.AnimFlip =  LUA_ENGINE:LuaCast(rightFlip, fliptype)
    
    local slugma_anim_left_1 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_1 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_2 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_2 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_3 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_3 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_4 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_4 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    

    --A13. Threat.ogg
    SOUND:PlayBGM('Rising Fear.ogg', true)

	--4 sets of spawning
    coro1 = TASK:BranchCoroutine(function()	SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_1:SetupEmitted(RogueElements.Loc(slugma_boy_1.Position.X + 8, slugma_boy_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_1:SetupEmitted(RogueElements.Loc(slugma_girl_1.Position.X + 8, slugma_girl_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_1, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_1, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_1')
											GROUND:Unhide('Slugma_Girl_1')
											GAME:WaitFrames(20)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_1, Direction.DownRight)
											GROUND:EntTurn(slugma_girl_1, Direction.DownLeft)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_1, Direction.Down)
											GROUND:EntTurn(slugma_girl_1, Direction.Down)
											GROUND:CharSetAnim(slugma_boy_1, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_1, "Idle", true)
											end)

    coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_2:SetupEmitted(RogueElements.Loc(slugma_girl_2.Position.X + 8, slugma_girl_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_2:SetupEmitted(RogueElements.Loc(slugma_boy_2.Position.X + 8, slugma_boy_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_2, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_2, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_2')
											GROUND:Unhide('Slugma_Girl_2')
											GAME:WaitFrames(20)
											GROUND:CharSetAnim(slugma_boy_2, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_2, "Idle", true)
											end)
	
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(160)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_3:SetupEmitted(RogueElements.Loc(slugma_boy_3.Position.X + 8, slugma_boy_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_3:SetupEmitted(RogueElements.Loc(slugma_girl_3.Position.X + 8, slugma_girl_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_3, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_3, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_3')
											GROUND:Unhide('Slugma_Girl_3')
											GAME:WaitFrames(20)
											GROUND:CharSetAnim(slugma_boy_3, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_3, "Idle", true)
											end)
											
	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(240)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_4:SetupEmitted(RogueElements.Loc(slugma_girl_4.Position.X + 8, slugma_girl_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_4:SetupEmitted(RogueElements.Loc(slugma_boy_4.Position.X + 8, slugma_boy_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_4, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_4, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_4')
											GROUND:Unhide('Slugma_Girl_4')
											GAME:WaitFrames(20)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_4, Direction.UpLeft)
											GROUND:EntTurn(slugma_girl_4, Direction.UpRight)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_4, Direction.Up)
											GROUND:EntTurn(slugma_girl_4, Direction.Up)
											GROUND:CharSetAnim(slugma_boy_4, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_4, "Idle", true)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)	
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) 
											--SOUND:PlayBattleSE('EVT_Emote_Shock')
											GROUND:CharSetEmote(partner, "shock", 1)
											GAME:WaitFrames(60)
											--GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GAME:WaitFrames(50)
											GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Right)
											end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(42)	
												GROUND:CharSetEmote(hero, "exclaim", 1)
												GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) 
												GAME:WaitFrames(60)
												GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GAME:WaitFrames(10)
												--GROUND:CharSetEmote(hero, "notice", 1)
												GAME:WaitFrames(46)
												GeneralFunctions.LookAround(hero, 4, 4, true, false, false, Direction.Left)
												end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(46)	
												GROUND:CharSetEmote(growlithe, "shock", 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GAME:WaitFrames(60)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												GAME:WaitFrames(10)
												--GROUND:CharSetEmote(growlithe, "exclaim", 1)
												GAME:WaitFrames(50)
												GeneralFunctions.LookAround(growlithe, 4, 4, true, false, false, Direction.Left)
												end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(48)	
												GROUND:CharSetEmote(zigzagoon, "shock", 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) 
												GAME:WaitFrames(60)
												--GROUND:CharSetEmote(zigzagoon, "exclaim", 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
												GAME:WaitFrames(50)
												GeneralFunctions.LookAround(zigzagoon, 4, 4, true, false, false, Direction.Right)
												end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Waaah![pause=0] Where did these guys come from!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Th-they're "  .. _DATA:GetMonster('slugma'):GetColoredName() .. "![pause=0] Their bodies are made up of hot magma!")
	UI:WaitShowDialogue("They must have been in the lava coursing underneath this pit!")
	GAME:WaitFrames(10)
	
	
	--TODO: slow the movement speed down of the slugmas here if possible.
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(slugma_boy_1, Direction.Down, 16, false, 1) GROUND:CharSetAnim(slugma_boy_1, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveInDirection(slugma_girl_1, Direction.Down, 16, false, 1) GROUND:CharSetAnim(slugma_girl_1, "Idle", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:MoveInDirection(slugma_girl_2, Direction.Right, 16, false, 1) GROUND:CharSetAnim(slugma_girl_2, "Idle", true) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveInDirection(slugma_boy_2, Direction.Left, 16, false, 1) GROUND:CharSetAnim(slugma_boy_2, "Idle", true) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:MoveInDirection(slugma_boy_3, Direction.Right, 16, false, 1) GROUND:CharSetAnim(slugma_boy_3, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:MoveInDirection(slugma_girl_3, Direction.Left, 16, false, 1) GROUND:CharSetAnim(slugma_girl_3, "Idle", true) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:MoveInDirection(slugma_girl_4, Direction.Up, 16, false, 1) GROUND:CharSetAnim(slugma_girl_4, "Idle", true) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) GROUND:MoveInDirection(slugma_boy_4, Direction.Up, 16, false, 1) GROUND:CharSetAnim(slugma_boy_4, "Idle", true) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	--GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(partner, "Walk", partner.Direction, 266, 246, 4, 1, 0) 
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:AnimateToPosition(growlithe, "Walk", growlithe.Direction, 246, 266, 1, 1, 0)  end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:AnimateToPosition(zigzagoon, "Walk", zigzagoon.Direction, 266, 266, 1, 1, 0) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:AnimateToPosition(hero, "Walk", hero.Direction, 246, 246, 1, 1, 0)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("They don't look friendly,[pause=10] ruff...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("H-hey![pause=0] We don't want to fight!")
	UI:WaitShowDialogue("We're just passing through here![pause=0] We don't mean to trespass or cause any trouble!")
	GAME:WaitFrames(20)
	
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("No trouble!?[pause=0] You lie to us as well!?")
	UI:WaitShowDialogue("All you outlanders coming through here,[pause=10] disrupting the balance of this place...")
	UI:WaitShowDialogue("It make my blood boil with rage![pause=0] That tears it!")
	GAME:WaitFrames(10)

	--magcargo spawns in via the heatran effect
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 30))
											GAME:WaitFrames(10)	
											SOUND:PlayBattleSE("_UNK_EVT_003")
											local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
											arriveAnim:SetupEmitted(RogueElements.Loc(magcargo.Position.X + 8, magcargo.Position.Y), 32, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(3)
											GROUND:Unhide('Magcargo')
											GAME:WaitFrames(37)		
											end)

	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(partner, "shock", 1)
											GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(hero, "exclaim", 1)
											GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(growlithe, "None", growlithe.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(growlithe, "shock", 1)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(zigzagoon, "None", zigzagoon.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
											
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, magcargo.CurrentForm.Species, magcargo.CurrentForm.Form, magcargo.CurrentForm.Skin, magcargo.CurrentForm.Gender)				
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("I am " .. magcargo:GetDisplayName() .. "![pause=0] Chieftain of the " .. _DATA:GetMonster('slugma'):GetColoredName() .. " clan!")
	UI:SetSpeaker(magcargo)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("No mercy for those who defile our home![pause=0] Prepare yourselves,[pause=10] outlanders!")
	
	--Setup for lavaflow variables will happen in the zone's enter segment.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)	
	SV.Chapter5.EncounteredBoss = true
	--enter fight
	GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
end

function searing_crucible_ch_5.SecondPreBossScene()
	--instead of having it play out like the first time, cut right to the chase of being surrounded again. sky does this a lot and,
	--while it is the lazy option, do you really want to see the same animation again? It'd be really contrived too at that part, or at least more so.
	--Magcargo says you continue to defile the lands and cause this crap. You truly are scum.
	--they try to speak up but get interrupted
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 200), Direction.Down, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 312), Direction.Up, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 200), Direction.Down, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 312), Direction.Up, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	

	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	

	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 246, 246, Direction.Up)
	GROUND:TeleportTo(partner, 266, 246, Direction.Up)
	GROUND:TeleportTo(growlithe, 246, 266, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 266, 266, Direction.Up)
	GAME:MoveCamera(264, 264, 1, false)
	GAME:CutsceneMode(true)
	
	--spawn in the lava without any animation or anything.
	searing_crucible_ch_5.SpawnLava(false)

	--do this during the fade out: we need the wait frames to desync them, but we dont want it to take extra time to "load in", so do this as part of the 60 frames we'd want to wait for the display.
	GROUND:CharSetAnim(slugma_boy_1, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_1, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_2, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_2, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_3, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_3, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_4, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_4, "Idle", true)
	GAME:WaitFrames(30)
		
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	
	GAME:WaitFrames(60)
	
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('Rising Fear.ogg', false)
	
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(magcargo)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("You return!?[pause=0] Why must you outlanders continue to bring unrest to our home!?")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("This is a misunderstanding![pause=0] We'd never do something to hurt your home!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Ruff![pause=0] That's right![pause=0] We only want to pass through here!")

	GAME:WaitFrames(20)	
	UI:SetSpeaker(magcargo)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Save your lies![pause=0] Outlanders are not to be trusted!")
	UI:WaitShowDialogue("Prepare for another scorching!")
	
	
	--Setup for lavaflow variables will happen in the zone's enter segment.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)	
	--enter fight
	GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
	
end

--TASK:BranchCoroutine(searing_crucible_ch_5.DefeatedBoss)
function searing_crucible_ch_5.DefeatedBoss()
	--magcargo is actually defeated, and offers his neck metaphorically to the stone, party explains that they didn't even want to fight
	--magcargo explains he thought the outlanders were causing all the issues the tunnel's been experiencing
	--after they disappear, partner should mention that he's glad hyko and almotz were there. Just him and the palyer wouldn't have been able to deal with all those enemies at once
	--this took so long to sort out, it's probably night by now! We have to hurry ahead!
	--commenting on his exit being as dramatic as his entrance (with sweatdrops)
	--magcargo realizes he endangered his tribe by attacking you without listening to what you had to say... he apologizes
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 200), Direction.Down, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 312), Direction.Up, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 200), Direction.Down, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 312), Direction.Up, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	

	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	
	GROUND:CharSetAnim(magcargo, "Charge", true)
	
	
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 244, 240, Direction.Up)
	GROUND:TeleportTo(partner, 268, 240, Direction.Up)
	GROUND:TeleportTo(growlithe, 240, 272, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 272, 272, Direction.Up)
	GAME:MoveCamera(264, 264, 1, false)
	GAME:CutsceneMode(true)
	
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(magcargo)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Gwooaaaaaaah!")
	GAME:WaitFrames(10)
	
	--setup flash emitter 
    local center = GAME:GetCameraCenter()
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
    emitter.HoldTime = 2
    emitter.FadeOutTime = 2
    emitter.StartColor = Color(0, 0, 0, 0)
    emitter.Layer = DrawLayer.Top
    emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(16)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(46)

	--todo: special magcargo animation
	--He collapses
	GROUND:CharEndAnim(magcargo)
	UI:WaitShowDialogue("Outlanders...[pause=0] Your strength...[pause=0] We are outmatched...")
	UI:WaitShowDialogue("You have bested our clan.[pause=0] Do what you will with us.")
	
	--The slugmas all bow as well now, in sync.
	
	
	--player's party look at each other and sweat
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.EmoteAndPausePrecise(hero, "Sweatdrop", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GeneralFunctions.EmoteAndPausePrecise(growlithe, "Sweatdrop", false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.EmoteAndPausePrecise(zigzagoon, "Sweatdrop", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
		
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("wtf are you talking about? we dont want to do anything to you guys")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yeah![pause=0] We only fought you because you attacked us.[pause=0] We just want to pass through here!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(magcargo)
	UI:WaitShowDialogue("...Mercy?[pause=0] You give us mercy in our moment of vulnerability?")

	--MAgcargo and the Slugmas rise
	
	UI:WaitShowDialogue("Outlanders...[pause=0] I do not know what to say...")
	UI:WaitShowDialogue("Your mercy speaks volumes.[pause=0] I see now you never had any ill will towards my clan.")
	--he bows again
	UI:WaitShowDialogue("We were wrong to attack you.[pause=0] On behalf of my clan,[pause=10] I offer my sincerest apologies.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPausePrecise(partner, "Sweating", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("There's no need for all this, we're all squared away now right?")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("But I have to ask...[pause=0] Why did you attack us in the first place?[pause=0] Did we do something wrong?")
	GAME:WaitFrames(20)
	
	--Magcargo rises back up
	UI:SetSpeaker(magcargo)
	UI:WaitShowDialogue("...Our clan has suffered great tragedy at the hands of outlanders in days gone past.")
	UI:WaitShowDialogue("Between the horrible fluctuations in the lava flow and all the other outlanders passing through here today,[pause=10] I thought this was a return to those times.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPausePrecise(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Huh?[pause=0] Fluctuations in the lava flow?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(magcargo)
	UI:WaitShowDialogue("The lava flow been fucked up lately...")
	UI:WaitShowDialogue("Things used to be stable, and pokemon of all types were just fine.")
	UI:WaitShowDialogue("Some regions of the tunnel have too little lava...[pause=0] Others are flooded.")
	UI:WaitShowDialogue("It's been awful for the Pokemon living in the tunnel.")
	UI:WaitShowDialogue("Some are getting overheated, while others, such as my clan, may go cold...")
	UI:WaitShowDialogue("It's just been terrible for all of us here in the tunnel.")
	UI:WaitShowDialogue("When the lava flow erupted as you outlanders passed through... I figured you may be the culprits of this.")
	UI:WaitShowDialogue("But given your mercy towards our clan, it is clear now you are not to blame for this. It was merely coincidence")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("So that's why you attacked us...")
	UI:WaitShowDialogue("But how could we have possibly caused the lava flow to change?")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPausePrecise(magcargo, "Sweatdrop", true)
	UI:SetSpeaker(magcargo)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("In hindsight...[pause=0] We did act rather rashly...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But please understand that our behavior was guided by mistrust rather than logic...")
	UI:WaitShowDialogue("All we can do now is allow you safe passage through the remainder of the cavern.")
	UI:WaitShowDialogue("I apologize again.")
	
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(magcargo, Direction.DownLeft, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(magcargo, Direction.DownRight, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(magcargo, Direction.Down, 4)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("We will be on our way now.[pause=0] Safe travels,[pause=10] outlanders.")
	GAME:WaitFrames(10)
	
	
	--Party looks around at them as the slugmas dematerialize. They're startled when Magcargo explodes to disappear
	local materializeAnimLeft = RogueEssence.Content.AnimData("Slugma_Materialize_Reverse", 3)
    local materializeAnimRight = RogueEssence.Content.AnimData("Slugma_Materialize_Reverse", 3)
    local leftFlip = 1
    local rightFlip = 0
    local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')

    materializeAnimLeft.AnimFlip =  LUA_ENGINE:LuaCast(leftFlip, fliptype)
    materializeAnimRight.AnimFlip =  LUA_ENGINE:LuaCast(rightFlip, fliptype)
    
    local slugma_anim_left_1 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_1 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_2 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_2 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_3 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_3 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_4 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_4 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    

	--4 sets of despawning
    coro1 = TASK:BranchCoroutine(function()	--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_4, Direction.UpLeft)
											GROUND:EntTurn(slugma_girl_4, Direction.UpRight)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_4, Direction.Left)
											GROUND:EntTurn(slugma_girl_4, Direction.Right)
											GAME:WaitFrames(16)											
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_4')
											GROUND:Hide('Slugma_Girl_4')
											slugma_anim_left_4:SetupEmitted(RogueElements.Loc(slugma_boy_4.Position.X + 8, slugma_boy_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_right_4:SetupEmitted(RogueElements.Loc(slugma_girl_4.Position.X + 8, slugma_girl_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_4, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_4, RogueEssence.Content.DrawLayer.Front)
											end)

    coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(100)
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_3')
											GROUND:Hide('Slugma_Girl_3')
											slugma_anim_right_3:SetupEmitted(RogueElements.Loc(slugma_boy_3.Position.X + 8, slugma_boy_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_3:SetupEmitted(RogueElements.Loc(slugma_girl_3.Position.X + 8, slugma_girl_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_3, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_3, RogueEssence.Content.DrawLayer.Front)
											end)
	
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(180)
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_2')
											GROUND:Hide('Slugma_Girl_2')
											slugma_anim_left_2:SetupEmitted(RogueElements.Loc(slugma_boy_2.Position.X + 8, slugma_boy_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_right_2:SetupEmitted(RogueElements.Loc(slugma_girl_2.Position.X + 8, slugma_girl_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_2, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_2, RogueEssence.Content.DrawLayer.Front)
											end)				
	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(240)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_1, Direction.DownRight)
											GROUND:EntTurn(slugma_girl_1, Direction.DownLeft)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_1, Direction.Right)
											GROUND:EntTurn(slugma_girl_1, Direction.Left)
											GAME:WaitFrames(16)		
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_1')
											GROUND:Hide('Slugma_Girl_1')
											slugma_anim_right_1:SetupEmitted(RogueElements.Loc(slugma_boy_1.Position.X + 8, slugma_boy_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_1:SetupEmitted(RogueElements.Loc(slugma_girl_1.Position.X + 8, slugma_girl_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_1, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_1, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(80)--Let the final animation coroutine finish before joining
											end)
	
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(50)	
											      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) 
												  GAME:WaitFrames(60)
												  GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
												  GAME:WaitFrames(120)
												  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												  end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)	
												  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
												  GAME:WaitFrames(60)
												  GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												  GAME:WaitFrames(120)
												  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
												  end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)	
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4) 
												  GAME:WaitFrames(60)
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												  GAME:WaitFrames(120)
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												  end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(56)	
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4) 
												  GAME:WaitFrames(60)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
												  GAME:WaitFrames(120)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												  end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	GAME:WaitFrames(10)
	
	--magcargo explodes to leave
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 30))
											GAME:WaitFrames(10)	
											SOUND:PlayBattleSE("_UNK_EVT_003")
											local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
											arriveAnim:SetupEmitted(RogueElements.Loc(magcargo.Position.X + 8, magcargo.Position.Y), 32, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(3)
											GROUND:Hide('Magcargo')
											end)

	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(hero, "shock", 1)
											end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(growlithe, "None", growlithe.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(growlithe, "Hurt", 10, 10, false, false)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(zigzagoon, "None", zigzagoon.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(zigzagoon, "Hurt", 10, 10, false, false)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(70)
		
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.EmoteAndPausePrecise(hero, "Sweatdrop", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GeneralFunctions.EmoteAndPausePrecise(growlithe, "Sweatdrop", false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.EmoteAndPausePrecise(zigzagoon, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro4})

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Did he need to exit so dramatically...?")
	GAME:WaitFrames(40)
	
	--phew... im glad that's over
	--thank goodness we had you there growlithe and zigzagoon
	--makes me wonder though... if the tunnel wasn't always like this, what's changed?
	--dunno...
	--Oh crud, we gotta hurry to the next camp!
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("That was certainly something...[pause=0] I'm glad that's resolved now at least.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Yes it was... Thank goodness we had you here, " .. growlithe:GetDisplayName() .. " and " .. zigzagoon:GetDisplayName() .. ".")
	UI:WaitShowDialogue("I don't think we would have been able to make them come to their senses if it was just me and " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("Same! We woulda been in trouble if you guys werent here, ruff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("So the tunnel hasn't always been like how it is now, hmm...")
	UI:WaitShowDialogue("I wonder what's causing the issue then?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I don't know...")
	UI:WaitShowDialogue("But it explains why the lava was going crazy earlier...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPausePrecise(partner, "Exclaim", true)
	UI:WaitShowDialogue("Oh man it's gotta be late by now![pause=0] We should get moving!")
	GAME:WaitFrames(10)
	
	--they leave
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 114, false, 1) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveInDirection(growlithe, Direction.Up, 110, false, 1) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 106, false, 1) end)	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(50) 
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60)
											end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(90)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')	
end



function searing_crucible_ch_5.SpawnLava(playAnimation)
	--lava stuff. initialize it before using it all
	local leftFlip = 1
	local rightFlip = 0
	local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')
	--playAnimation = true to do the animation + sounds + shakes. false = to instantly set it up
	if playAnimation == nil then playAnimation = true end

	local lava_pool_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	local lava_pool_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	lava_pool_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_pool_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)	
	
	local lava_anim_small_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_anim_big_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)

	local lava_anim_small_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	lava_anim_big_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	
	
	if playAnimation then
		SOUND:LoopSE("Heavy Earthquake")
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 50))
		GAME:WaitFrames(50)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 140))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_left, RogueElements.Loc(5 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_right, RogueElements.Loc(15 * 24, 8 * 24)))
		GAME:WaitFrames(40)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(7 * 24, 8 * 24)))
		--right needs to be offset on x axis by -24
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(14 * 24 - 24, 8 * 24)))
		GAME:WaitFrames(40)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(9 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(12 * 24 - 24, 8 * 24)))
		GAME:WaitFrames(60)
		SOUND:FadeOutSE("Heavy Earthquake", 90)
		SOUND:FadeOutSE("Light Earthquake", 90)	
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 50))
		GAME:WaitFrames(50)

		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 40))
		GAME:WaitFrames(40)
	else
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_left, RogueElements.Loc(5 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_right, RogueElements.Loc(15 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(7 * 24, 8 * 24)))
		--right needs to be offset on x axis by -24
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(14 * 24 - 24, 8 * 24)))	
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(9 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(12 * 24 - 24, 8 * 24)))
	end
end

