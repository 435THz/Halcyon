require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_heros_room_ch_1 = {}



function guild_heros_room_ch_1.SetupGround()
	if SV.Chapter1.TeamJoinedGuild then 
		local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
															RogueElements.Rect(168, 144, 24, 24),
															RogueElements.Loc(0, 8), 
															true, 
															"Event_Trigger_1")
		  groundObj:ReloadEvents()
		  GAME:GetCurrentGround():AddObject(groundObj)
	  end
	  GAME:FadeIn(20)
end

--Event Trigger 1 is the hero's bed. Event is to go to bed at the end of the chapter to trigger final cutscene.
function guild_heros_room_ch_1.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		UI:WaitShowDialogue("It's getting late...[pause=0] And I think we've looked around the guild enough...")
		UI:ChoiceMenuYesNo("Do you wanna hit the hay for tonight?")
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result then
			UI:WaitShowDialogue("Alright,[pause=10] let's call it a day then.")
			UI:WaitShowDialogue("Tomorrow's going to be a big day,[pause=10] so we need to get plenty of rest.")
			UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
			SOUND:FadeOutBGM()
			GAME:FadeOut(false, 60)
			GAME:WaitFrames(120)
			guild_heros_room_ch_1.Bedtalk()
		else
			UI:WaitShowDialogue("OK,[pause=10] we can look around a little more.")
			UI:WaitShowDialogue("But we shouldn't stay up much longer![pause=0] We want to be energized for tomorrow!")
		end
	else
		UI:WaitShowDialogue("It's not that late yet...[pause=0] Let's look around the guild and try to meet all of the other guild members!")
	end
end


function guild_heros_room_ch_1.Bedtalk()
	
	--Set nighttime, put duo in beds asleep
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													RogueElements.Rect(176, 56, 64, 64),
													RogueElements.Loc(0, 0), 
													false, 
													"Window")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddObject(groundObj)
	GROUND:Hide("Event_Trigger_1")
	GROUND:AddMapStatus(50)
	
	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Down)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Down)

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GeneralFunctions.CenterCamera({hero, partner})
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:CharSetAnim(partner, 'Laying', true)
	GAME:FadeIn(20)
	
	SOUND:PlayBGM("Goodnight.ogg", true)
	GAME:WaitFrames(60)
	UI:SetSpeaker(partner:GetDisplayName(), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("Hey,[pause=10] are you awake,[pause=10] " .. hero:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Today's been absolutely crazy,[pause=10] hasn't it?")
	UI:WaitShowDialogue("I've been wanting to join the guild for so long...")
	UI:WaitShowDialogue("Now that I'm here,[pause=10] I feel so happy...[pause=0] I'm having trouble falling asleep,[pause=10] haha.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("I was so nervous...[pause=0] But everyone here has been so kind and welcoming.")
	UI:WaitShowDialogue("...Well,[pause=10] almost everyone.[pause=0] But either way I feel so much more at ease now.")
	UI:WaitShowDialogue("Even the Guildmaster...[pause=0] He was so down to earth and nice,[pause=10] I was surprised.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("We're going to go on all sorts of adventures starting tomorrow...")
	UI:WaitShowDialogue("It's kind of scary but...[pause=0] I'm excited about it too!")
	UI:WaitShowDialogue("We'll learn and experience so much...[pause=0] And have a lot of fun too!")
	UI:WaitShowDialogue("And it's all because you decided to form this team with me,[pause=10] " .. hero:GetDisplayName() .. ".")
	UI:WaitShowDialogue("It really means a lot to me...")
	UI:WaitShowDialogue("So...[pause=0] Um...[pause=0] Thank you for joining the guild with me, " .. hero:GetDisplayName() .. "...")
	UI:WaitShowDialogue("Once we become great adventurers,[pause=10] I'm sure we'll be able to solve the mystery of your amnesia.[pause=0] I promise.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("We'd better try to get some sleep...[pause=0] We don't want to be exhausted in the morning.")
	UI:WaitShowDialogue("Let's give it our all tomorrow,[pause=10] OK?")
	UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	GROUND:CharSetAnim(partner, "EventSleep", true)
	SOUND:FadeOutBGM()
	GAME:WaitFrames(60)
	
	UI:SetSpeaker('', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	--man im excited but why do i feel so at ease and maybe a bit of deja vu? why am i a picklemanster?
	UI:WaitShowDialogue("(.........)")
	UI:WaitShowDialogue("(First I turned into a Pokémon,[pause=10] now I'm an apprentice at this guild...)")
	UI:WaitShowDialogue("(Everything is moving so fast...)")
	UI:WaitShowDialogue("(But...[pause=0] I can't help but feel thrilled about all this.)")
	UI:WaitShowDialogue("(Being friends with " .. partner:GetDisplayName() .. "...[pause=0] All the adventures we're gonna go on...)")
	UI:WaitShowDialogue("(Just thinking about it has me pumped!)")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("(But...[pause=0] I think that's what puzzles me the most.)")
	UI:WaitShowDialogue("(Shouldn't I be feeling scared instead?[pause=0] Why do I feel so at ease?)")
	UI:WaitShowDialogue("(I turned into a Pokémon without any memories and was lying unconscious near a strange tablet in a forest...)")
	UI:WaitShowDialogue("(So shouldn't I be a nervous wreck?)")
	GAME:WaitFrames(60)
	
	UI:WaitShowDialogue("(Even more troubling...)")
	UI:WaitShowDialogue("(What is this feeling of déjà vu?)")
	GAME:WaitFrames(60)
	
	UI:WaitShowDialogue("(.........)")
	UI:WaitShowDialogue("(I guess there isn't any point in trying to get myself psyched out about my situation.)")
	UI:WaitShowDialogue("(It's probably for the best I'm enjoying this.)")
	UI:WaitShowDialogue("(I should just go along with things for now and enjoy guild life with " .. partner:GetDisplayName() .. "...)")
	UI:WaitShowDialogue("(I'm sure " .. partner:GetDisplayName() .. " and I will get to the bottom of this eventually...)")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("(...[pause=0]Eventually...)")--doesn't really care if he finds out or not since hero can just enjoy life as a pokemon regardless of solving the mystery
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(180)
	GAME:FadeOut(false, 120)
	SV.ChapterProgression.Chapter = 2
	SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
	
end



function guild_heros_room_ch_1.RoomIntro()
--TASK:BranchCoroutine(guild_heros_room_ch_1.RoomIntro)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GROUND:Hide('Bedroom_Exit')--disable map transition object
	
	local noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 0, 200, Direction.Right},
		})

	GAME:MoveCamera(248, 168, 1, false)
	GROUND:TeleportTo(partner, -32, 188, Direction.Right)
	GROUND:TeleportTo(hero, -32, 212, Direction.Right)

	GAME:FadeIn(20)

	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												  GROUND:MoveToPosition(partner, 172, 188, false, 1) 
												  GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) 
												  end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
												  GROUND:MoveToPosition(hero, 172, 212, false, 1)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
												  end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 200, 200, false, 1) 
											      GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
												  end)
												
	TASK:JoinCoroutines({coro1, coro2, coro3})
	

	
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("These will be your quarters while you train here at the guild.")
	UI:WaitShowDialogue("There are some furnishings here already.[pause=0] You may make use of them as you will.")
	GAME:WaitFrames(20)


	--thanks phileas!
	GeneralFunctions.Hop(partner, "Idle")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, 4, 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Thank you so much " .. noctowl:GetDisplayName() .. "![pause=0] This room is amazing!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetAnim(partner, "None", true)
	local bed1 = MRKR("Hero_Bed")
	local bed2 = MRKR("Partner_Bed")
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed1.Position.X, bed1.Position.Y, false, 1)
											GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--this bed is comfy
	GeneralFunctions.Hop(partner)
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("These are some nice beds![pause=0] " .. hero:GetDisplayName() .. ",[pause=10] come sit on one of these!")
	
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, bed1.Position.X, bed1.Position.Y, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed2.Position.X, bed2.Position.Y, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(For a pile of straws,[pause=10] this bed is actually quite comfy!)", "Normal")
	
	
	--is this what's it's like to want to wag your tail?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I may have lost my memory and turned into a Pokémon,[pause=10] but...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(After meeting " .. partner:GetDisplayName() .. " and joining this guild...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...I can't help but feel excited.)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(I've transformed into a Pokémon...[pause=0] And yet I'm happy!)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(I can't really describe it,[pause=10] but I feel right at home!)", "Inspired")
	
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("Haha,[pause=10] told you,[pause=10] didn't I?")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GROUND:CharSetEmote(hero, 4, 0)
	
	GAME:WaitFrames(60)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	--GROUND:CharSetEmote(noctowl, 4, 0)
	UI:WaitShowDialogue("I am glad that you like the room.")
	--GROUND:CharSetEmote(noctowl, -1, 0)
	
	
	--why not go meet your compatriots?
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetEmote(hero, -1, 0)
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharTurnToCharAnimated(hero, noctowl, 4)
	
	GAME:WaitFrames(12)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Your training starts tomorrow.[pause=0] Make sure to get plenty of rest.")
	UI:WaitShowDialogue("Our daily routine starts bright and early.[pause=0] Don't be late!")
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("...Hmm...[pause=0] But it isn't quite that late in the night quite yet,[pause=10] is it?.")
	UI:WaitShowDialogue("I suggest you use this time to explore the guild and meet some of your fellow guild members.")
	GAME:WaitFrames(20)
	
	--we should go meet our guildmembers
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("That sounds like a great idea![pause=0] We'll get to it after we're settled in!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Very good,[pause=10] I will leave you to it then.[pause=0] I am off to assist the Guildmaster in updating our records.")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 0, 200, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:GetCurrentGround():RemoveTempChar(noctowl)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	
	--wow, can you believe how amazing this all is? welp, let's go explore!
	--we can hit the hay when we've felt we looked around enough
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Can you believe this " .. hero:GetDisplayName() .. "?[pause=0] We're really going to be adventurers!")
	UI:WaitShowDialogue("This feels surreal to me.[pause=0] I never thought this would ever happen![pause=0] It's like a dream!")
	
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(Being here in this guild is the least surreal thing to happen to me today...)", "Worried")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, "Idle", true)
	GeneralFunctions.HeroDialogue(hero, "(Still...[pause=0] It's fantastic that we managed to join up with the guild.)", "Happy")
	GeneralFunctions.HeroDialogue(hero, "(I'm pretty excited about it![pause=0] I think I'm going to have a lot of fun adventuring with " .. partner:GetDisplayName() .. "!)", "Happy")
	
	
	--let's go meet our guildmates!!
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("C'mon![pause=0] Let's go meet some of our guildmates![pause=0] We'll come back later when it's time to sleep.")
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()
	
	GAME:MoveCamera(0, 0, 60, true)
	GAME:WaitFrames(40)
	
	SOUND:PlayFanfare("Fanfare/Note")
	
	--adventurer's tip (how to save the game)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Adventurer's Tip")
	UI:WaitShowDialogue("The game will automatically save your progress every step you make in a dungeon.")
	UI:WaitShowDialogue("You can manually make a record of your progress by climbing into bed.")
	UI:WaitShowDialogue("You can also save your progress by pressing {0} and selecting Save.")
	UI:SetCenter(false)

	GAME:CutsceneMode(false)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	GROUND:Unhide("Bedroom_Exit")
	SV.Chapter1.TeamJoinedGuild = true
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

											
end



