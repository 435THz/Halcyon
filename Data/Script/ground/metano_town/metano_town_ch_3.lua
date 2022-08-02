require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_3 = {}

function metano_town_ch_3.SetupGround()
	--objects/npcs that aren't for use in chapter 3 
	GROUND:Hide('Red_Merchant')
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	GROUND:Hide('Assembly')
		
	--let the cutscene handle the fade in if it hasnt played yet		
	if SV.Chapter3.MetTeamStyle then 
		GAME:FadeIn(20)
	end

end

function metano_town_ch_3.MeetTeamStyle()	
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[57] 
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
		{"Luxio", 464, 1208, Direction.Right},
		{"Glameow", 432, 1224, Direction.Right},
		{"Cacnea", 432, 1192, Direction.Right}})
		
	GAME:MoveCamera(648, 1232, 1, false)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 624, 1064, Direction.Down)
	GROUND:TeleportTo(partner, 656, 1064, Direction.Down)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 656, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 624, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)	

	TASK:JoinCoroutines({coro1, coro2})	

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] I guess we have to go catch this " .. CharacterEssentials.GetCharacterName("Sandile") .. " guy.")
	UI:WaitShowDialogue("To be honest,[pause=10] I think " .. CharacterEssentials.GetCharacterName("Cranidos") .. " chose this mission because he thinks we can't do it...")
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I would be lying if I said I wasn't scared...")
	UI:WaitShowDialogue("Especially with all those bandits hiding out in " .. zone:GetColoredName() .. "...")
	UI:WaitShowDialogue("It seems like it could go really badly...")
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, 1, 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("But...[pause=0] With you,[pause=10] I feel so confident![pause=0] I don't need to feel so afraid!")
	UI:WaitShowDialogue("We're going to catch this outlaw![pause=0] And we're gonna prove that bully " .. CharacterEssentials.GetCharacterName("Cranidos") .. " wrong!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoAnimation(hero, "Nod")
	GeneralFunctions.DoAnimation(hero, "Nod")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Yeah![pause=0] That's the spirit!")	
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, -1, 0)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowTimedDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. "![pause=30] Let's head to the market to prepare for-", 40)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	
	SOUND:FadeOutBGM(120)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Well well well![pause=30] What do we have here?", 40) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GeneralFunctions.EmoteAndPause(partner, "Notice", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM('Team Skull.ogg', true)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 640, 1208, false, 1) 
											GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(glameow, 592, 1224, false, 1) 
											GAME:WaitFrames(20)
											GROUND:MoveToPosition(glameow, 616, 1200, false, 1) 
											GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(cacnea, 656, 1192, false, 1) 
											GROUND:MoveToPosition(cacnea, 664, 1200, false, 1) 
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) 
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(partner, luxio, 4, Direction.Up) end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4) 
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(hero, luxio, 4, Direction.Up) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, glameow.CurrentForm.Species, glameow.CurrentForm.Form, glameow.CurrentForm.Skin, glameow.CurrentForm.Gender)
	UI:WaitShowDialogue("Looks to me like the newest guild losers,[pause=10] " .. luxio:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Sure looks that way,[pause=10] " .. glameow:GetDisplayName() .. ".[pause=0] Seems like they only let chumps in these days.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cacnea.CurrentForm.Species, cacnea.CurrentForm.Form, cacnea.CurrentForm.Skin, cacnea.CurrentForm.Gender)
	UI:WaitShowDialogue("Huhuh,[pause=10] yeah boss.[pause=0] We got a couple of champs right here,[pause=10] huhuh.")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, cacnea, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharTurnToCharAnimated(glameow, cacnea, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(cacnea:GetDisplayName() .. ',[pause=10] did you just call them "champs"?')
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Duh...[pause=0] Yeah,[pause=10] champs,[pause=10] just like you said,[pause=10] boss.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.Complain(luxio, true)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue('Chumps,[pause=10] not champs,[pause=10] you moron!')	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("Um...[pause=0] Who are you guys exactly?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(luxio, -1, 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(glameow, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(cacnea, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Oh?[pause=0] You haven't heard of us?")
	UI:WaitShowDialogue("You really are a bunch of know-nothing nobodies.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("That's a real shame.[pause=0] Anybody who doesn't know about us must lead such sad lives.")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Should we tell 'em who we are,[pause=10] boss?")	

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(glameow, luxio, 4)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion('Special1')
	UI:WaitShowDialogue(cacnea:GetDisplayName() .. ",[pause=10] I don't know if we can let such lowly peons know something like that.")	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("No,[pause=10] no.[pause=0] I think we can grace them,[pause=10] this one time.")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("We're Team [color=#FFA5FF]Style[color]![pause=0] Everything we do,[pause=10] we do with style!") end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Special1")
	UI:WaitShowDialogue("We're an adventuring team with fame and fortune in our sights!")
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("What!?[pause=10] You're all an adventuring team!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("That's right,[pause=10] loser.[pause=0] And soon everyone's gonna know the name Team [color=#FFA5FF]Style[color]!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But adventuring isn't about money or being famous!")
	UI:WaitShowDialogue("It's about making discoveries and helping Pokémon in need![pause=0] Every adventurer knows that!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yuck.[pause=0] You sound like that wash-up " .. CharacterEssentials.GetCharacterName("Tropius") .. ".[pause=0] He's so self-righteous it disgusts me!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("That has-been told us the same thing when he turned us away.[pause=0] He simply couldn't see our greatness!")
	UI:WaitShowDialogue("That blind fool wouldn't even notice if we stole the fruit off his neck!")

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	GROUND:CharSetEmote(hero, 3, 1)
	GeneralFunctions.Complain(partner)
	UI:WaitShowDialogue("How can you say such rude things about the Guildmaster!?[pause=0] It's no wonder he turned you all away!")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Oh,[pause=10] we kept it cordial our entire time with him...")
	UI:WaitShowDialogue("Even still,[pause=10] he wouldn't allow us into that stupid guild of his.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("And for some reason...[pause=0] That wash-up let you two in the guild.[pause=0] What's so special about you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowTimedDialogue("Um...[pause=30] I don't really-", 40)
	
	GAME:WaitFrames(20)
	GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	GROUND:CharSetEmote(luxio, 7, 0)
	UI:WaitShowDialogue("Well!?[pause=0] What makes you losers better than us,[pause=10] huh!?[pause=0] Huh!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Shouting")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("I don't know!![pause=30] OK!?[pause=30] I don't know!", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(luxio, "Exclaim", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharSetEmote(hero, 3, 1) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(25) GeneralFunctions.EmoteAndPause(glameow, "Notice", false) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(luxio, "Walk", Direction.Down, Direction.Up, 8, 1, 1) 
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I don't know why he chose to let us apprentice at the guild...")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Determined")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("But it doesn't matter why " .. CharacterEssentials.GetCharacterName("Tropius") .. " took us in!")
	UI:WaitShowDialogue("All that matters is that me and " .. hero:GetDisplayName() .. " are in the guild and we're learning to become adventurers!")
	UI:WaitShowDialogue("It's not hard to see why he didn't want you guys in the guild!")
	
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Shock", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Tch![pause=0] That's big talk for a newbie team![pause=0] What kind of adventures have you even gone on?")
											UI:WaitShowDialogue("Probably none![pause=0] I bet all you've done so far is scrub the floors!")	end)
	TASK:JoinCoroutines({coro1, coro2})

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("That's not true![pause=0] We've already rescued someone who got lost in a mystery dungeon!")
	UI:WaitShowDialogue("And right now we're getting ready to capture our first outlaw!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Oh?[pause=0] Is that so?")
	
	
	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Psst...[pause=0] Whisper whisper...")
	
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Psst...[pause=0] Murmur murmur...")	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Psst...[pause=0] Mumble mumble...")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What are they talking about?[pause=0] I can't make out what they're saying...")
	
	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) GAME:WaitFrames(8) GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})	
	
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Well,[pause=10] it seems like you may be real adventurers actually.[pause=0] Perhaps we got the wrong impression of you.")
	UI:WaitShowDialogue("You might just be a team worthy of our respect after all.")
	
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4)
	UI:WaitShowDialogue("Let's roll out of here, you two.[pause=0] We've got...[pause=30] adventuring work to attend to.")
	
	GAME:WaitFrames(20)
	
	--cacnea will later forget that this was just a temporary lie and think he's supposed to be nice to you still.
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Right, 4) 
											GROUND:MoveInDirection(luxio, Direction.Right, 200, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(luxio) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveInDirection(glameow, Direction.Down, 16, false, 1) 
											GROUND:CharTurnToChar(partner, glameow)
											GROUND:CharTurnToChar(hero, glameow)
											UI:SetSpeaker(glameow)
											UI:WaitShowTimedDialogue("We'll be keeping an eye on you,[pause=10] darlings.[pause=30] I hope you keep an eye out for us as well.", 60)
											GAME:WaitFrames(20)
											GROUND:MoveInDirection(glameow, Direction.Right, 200, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(glameow) end)
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(300)
											GROUND:MoveInDirection(cacnea, Direction.Down, 16, false, 1) 
											GROUND:CharTurnToChar(partner, cacnea)
											GROUND:CharTurnToChar(hero, cacnea)
											UI:SetSpeaker(cacnea)
											UI:SetSpeakerEmotion("Happy")
											UI:WaitShowTimedDialogue("Duh...[pause=30] If the boss say your team's alright,[pause=10] then you're alright with me too,[pause=10] huhuh.", 60)
											GAME:WaitFrames(20)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1) 
											SOUND:FadeOutBGM(120)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(cacnea) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(240) 
											GeneralFunctions.FaceMovingCharacter(partner, glameow, 4, Direction.UpRight) 
											GAME:WaitFrames(50)
											GROUND:CharTurnToCharAnimated(partner, cacnea, 4)
											GAME:WaitFrames(200)
											GeneralFunctions.FaceMovingCharacter(partner, cacnea, 4, Direction.UpRight)  end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(240) 
											GeneralFunctions.FaceMovingCharacter(hero, glameow, 4, Direction.UpRight) 
											GAME:WaitFrames(50)
											GeneralFunctions.FaceMovingCharacter(hero, cacnea, 4, Direction.UpRight)  end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] that was certainly strange...[pause=0] I wonder what their deal was?")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Between this Team [color=#FFA5FF]Style[color] and " .. CharacterEssentials.GetCharacterName("Cranidos") .. ",[pause=10] I've certainly had my fill of bullies for the day...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(We sure have been dealing with a lot of rude Pokémon today.[pause=0] All adventure team members,[pause=10] too...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Even if most of them seem to be nice,[pause=10] I guess not all adventurers are kind Pokémon...)", "Worried")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That Team [color=#FFA5FF]Style[color] though...[pause=0] They sure had a change of attitude just now,[pause=10] don't you think?")
	UI:WaitShowDialogue("The way they started whispering to each other was pretty strange...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(They were acting hostile the entire time until the end there...[pause=0] What could have caused the sudden change?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(What exactly were they whispering about,[pause=10] anyway?)", "Worried")
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM('Treasure Town.ogg', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("There isn't much point in dwelling on them though.[pause=0] Let's just hope that change in attitude sticks for them.")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("For now,[pause=10] let's forget about them.[pause=0] We have a mission to get to after all!")
	UI:WaitShowDialogue("Let's head into town and get ready.[pause=0] Once you're ready,[pause=10] we should leave town to the east,[pause=10] like " .. CharacterEssentials.GetCharacterName("Mareep") .. " said to.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()
	SV.Chapter3.MetTeamStyle = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)

	
end 	