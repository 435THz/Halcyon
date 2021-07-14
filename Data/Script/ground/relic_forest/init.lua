--[[
    init.lua
    Created: 06/24/2021 22:23:31
    Description: Autogenerated script file for the map relic_forest.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

-- Package name
local relic_forest = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---relic_forest.Init
--Engine callback function
function relic_forest.Init(map)

  DEBUG.EnableDbgCoro()
  print('=>> Init_relic_forest <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()


end

---relic_forest.Enter
--Engine callback function
function relic_forest.Enter(map)
	--relic_forest.PartnerFindsHeroCutscene()  

  if SV.ChapterProgression.Chapter == 1 and not SV.Chapter1.PlayedIntroCutscene then --Opening Cutscene on a fresh save
	relic_forest.Intro_Cutscene()
  elseif SV.ChapterProgression.Chapter == 1 and SV.Chapter1.PartnerCompletedForest and not SV.Chapter1.PartnerMetHero then --our duo meet
	relic_forest.PartnerFindsHeroCutscene()  
  else
    GAME:FadeIn(20) 
  end
end

---relic_forest.Exit
--Engine callback function
function relic_forest.Exit(map)


end

---relic_forest.Update
--Engine callback function
function relic_forest.Update(map)


end

-------------------------------
--Cutscene functions
-------------------------------

function relic_forest.Intro_Cutscene()
	--First cutscene
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	
	
	--initialize some save data
	_DATA.Save.ActiveTeam:SetRank(0)
	_DATA.Save.ActiveTeam.Money = 0
	_DATA.Save.ActiveTeam.Bank = 0
	
	--remove any team members that may exist by default for some reason
	local party_count = _DATA.Save.ActiveTeam.Players.Count
	for ii = 1, party_count, 1 do
		_DATA.Save.ActiveTeam.Players:RemoveAt(0)
	end

	local assembly_count = GAME:GetPlayerAssemblyCount()
	for i = 1, assembly_count, 1 do
	   _DATA.Save.ActiveTeam.Assembly.RemoveAt(i-1)--not sure if this permanently deletes or not...
	end 
	
	
  	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_001']), -1)  
  	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_002']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_003']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_004']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_005']), -1) 

	--Hero data
	--This will be replaced by a personality quiz when I get around to it.
	local msg = STRINGS:Format(MapStrings['Test_Hero'])
	local hero_choices = {'Treecko', 'Cyndaquil', 'Turtwig', 'Squirtle'}
	UI:BeginChoiceMenu(msg, hero_choices, 1, 4)
	UI:WaitForChoice()	
	local result = UI:ChoiceResult()

	
	local gender = 0
	local gender_choices = {'Boy', 'Girl'}
	msg = STRINGS:Format(MapStrings['Gender_Prompt_Hero'])
	UI:BeginChoiceMenu(msg, gender_choices, 1, 2)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	else 
		gender = Gender.Female
	end
		
	local mon_ID = 0
	local egg_move = 0
	if result == 1 then 
		mon_id = RogueEssence.Dungeon.MonsterID(252, 0, 0, gender)
		egg_move = 225--dragonbreath
	elseif result == 2 then
		mon_id = RogueEssence.Dungeon.MonsterID(155, 0, 0, gender)
		egg_move = 24--double kick
	elseif result == 3 then
		mon_id = RogueEssence.Dungeon.MonsterID(387, 0, 0, gender)
		egg_move = 328--sand tomb
	else
		mon_id = RogueEssence.Dungeon.MonsterID(7, 0, 0, gender)
		egg_move = 196--icy wind
	end
	
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, -1, 0))--dunno what the -1 and 0 are exactly...
	
	GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move)
	GAME:SetTeamLeaderIndex(0)
	

	--Partner data
	msg = STRINGS:Format(MapStrings['Test_Partner'])
	local partner_choices = {'Chikorita', 'Piplup', 'Riolu', 'Torchic'}
	UI:BeginChoiceMenu(msg, partner_choices, 1, 4)
	UI:WaitForChoice()
	result = UI:ChoiceResult()
	
	gender = 0
	msg = STRINGS:Format(MapStrings['Gender_Prompt_Partner'])
	UI:BeginChoiceMenu(msg, gender_choices, 1, 2)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	else 
		gender = Gender.Female
	end
		

	mon_ID = 0
	egg_move = 0
	if result == 1 then 
		mon_id = RogueEssence.Dungeon.MonsterID(152, 0, 0, gender)
		egg_move = 246--ancient power
	elseif result == 2 then
		mon_id = RogueEssence.Dungeon.MonsterID(393, 0, 0, gender)
		egg_move = 196--icy wind
	elseif result == 3 then
		mon_id = RogueEssence.Dungeon.MonsterID(447, 0, 0, gender)
		egg_move = 418--Bullet punch
	else
		mon_id = RogueEssence.Dungeon.MonsterID(255, 0, 0, gender)
		egg_move = 67--low kick
	end
  	
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, -1, 0))--dunno what the -1 and 0 are exactly...
	
	GAME:LearnSkill(GAME:GetPlayerPartyMember(1), egg_move)

    _DATA.Save:UpdateTeamProfile(true)
    _DATA.Save.ActiveTeam.Leader.IsFounder = true
  
    UI:NameMenu(STRINGS:Format(MapStrings['Partner_Name_Prompt']), "")
	UI:WaitForChoice()
	result = UI:ChoiceResult()
	
	local partner = GAME:GetPlayerPartyMember(1)
	GAME:SetCharacterNickname(partner, result)
	_DATA.Save.ActiveTeam.Name = result --set team name to partner's name temporarily
	COMMON.RespawnAllies()
	
	GAME:WaitFrames(180)
  
  
  	local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	--todo: show a screen for Chapter 1:
	
	
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_001']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_002']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_003']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_004']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_005']), -1)
	
	GAME:WaitFrames(60)
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Opening_Cutscene_006']))
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 120)
	
	SV.Chapter1.PlayedIntroCutscene = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
	
	
	
end


function relic_forest.PartnerFindsHeroCutscene()
--[color=#FFFF00]Riolu[color]
--[color=#00FFFF]Erleuchtet[color]
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(300, 536, 1, false)
	GROUND:TeleportTo(partner, 292, 616, Direction.Up)
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(20)
	
	--walk into frame from the bottom 
	GeneralFunctions.MoveCharAndCamera(partner, 292, 528, 1)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Up)
	GAME:WaitFrames(10)
	
	--celebrate that you made it through 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I've been at it for a while...[pause=0] Is this the deepest section of the forest?")
	--todo: do a little hop
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Does that mean I made it through my first mystery dungeon?")
	
	SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	--todo: repeat this emotion while joyous
	GROUND:CharSetEmote(partner, 4, 3)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Yes![pause=0] I did it![pause=0] I made it through a mystery dungeon!")
	UI:WaitShowDialogue("I hope I won't be so afraid of joining the guild now!")
	
	--that was too easy (the real shit relicanth is warning you about is in a later part of the game, but is in the forest)
	GAME:WaitFrames(30)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Still,[pause=10] that wasn't as bad as I thought it would be...")
	UI:WaitShowDialogue("Was [color=#00FFFF]Erleuchtet[color] wrong about how dangerous this place was?")
	
	--look around a bit 
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Up)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I should take a look around while I'm here.")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Maybe there's some sort of treasure or something!")

	--huh? something's over there?
	GeneralFunctions.MoveCharAndCamera(partner, 292, 408, 1)
	GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.UpLeft)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, 2, 1)
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Huh?[pause=0] What's that over there?")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 360, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	
	--"Waah! Someone has collapsed on the sand!" 
	SOUND:PlayBattleSE('EVT_Emote_Startled')
	GROUND:CharSetAnim(partner, 'Hurt', true)
	GROUND:CharSetEmote(partner, 8, 1)
	--todo: do a little hop
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)
	
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Ahhh![pause=0] Someone's passed out in the grass!")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 272, 4, true)
	GeneralFunctions.MoveCharAndCamera(partner, 268, 272, 4, true)
	
	--todo: a little hop
	UI:WaitShowDialogue("H-hey![pause=0] What happened!?[pause=0] Are you alright!?")
	GAME:WaitFrames(80)
	
	UI:WaitShowDialogue("Oh no,[pause=10] c'mon,[pause=10] wake up!")
	GROUND:MoveInDirection(partner, Direction.Left, 4)
	--todo: move in and out twice, moving backwards where applicable
	
	--wakeup
	--todo: shake before getting up
	GAME:WaitFrames(60)
	UI:SetSpeaker(hero)
	GeneralFunctions.HeroDialogue(hero, "(...)", "Pain")
	GROUND:CharSetAnim(hero, 'Wake', false)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	--todo: walk backwards
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(40)
	GROUND:MoveInDirection(partner,Direction.Right, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	
	GeneralFunctions.LookAround(hero, 4, 4, true, true, false, Direction.Right)
	GAME:WaitFrames(40)
	
	--partner is relieved you arent dead
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Phew![pause=0] You weren't waking up.[pause=0] You had me scared for a moment there!")
		
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Anyway,[pause=10] I'm glad to see you're alright.[pause=0] My name's " .. partner:GetDisplayName() ..".")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("How did you end up here anyway?[pause=0] Nobody is supposed to be out here.")
	
	--amnesia
	local hero_species = DataManager.Instance.GetMonster(hero.CurrentForm.Species):GetColoredName()
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Huh?[pause=0] You don't know how you got here?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's worrisome...[pause=0] I wonder how a " .. hero_species .. " ended up conked out here.")
	
	--hero realizes they are a pokemon, pinches themselves to see if they are dreaming
	GROUND:CharSetEmote(hero, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(hero, 4, 4, false, false, false, Direction.Right)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, 8, 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(W-what!?[pause=0] I am a " .. hero_species .. "!)", "Surprised")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(This must just be a dream![pause=0] I just need to wake up!)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, 8, 1)
	SOUND:PlayBattleSE("DUN_Bounced")--pinch sfx
	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(Yowch!)", "Pain")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I'm still here!?[pause=0] I'm not dreaming!)", "Surprised")
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, 5, 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(But how did this happen?[pause=0] I only remember vague things that don't make any sense...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--human? oh god no
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(partner, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Huh?[pause=0] You say you're actually a human?")
	GAME:WaitFrames(20)
	--todo: a little hop
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Is this some kind of joke?[pause=0] Humans are just a legend.")
	UI:WaitShowDialogue("You're very clearly a " ..  hero_species .. ".")

	
	GROUND:CharSetEmote(hero, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero, 4, true)
	
	local zone = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You really believe you were a human,[pause=10] huh...")
	GAME:WaitFrames(20)
	
	
	--todo: have partner emote in some way while this is going on to show that they're stressed out the whole time.
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, 5, 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Is it really that hard to beleive I was a human?)", "Sad")
	GAME:WaitFrames(60)
	GeneralFunctions.HeroDialogue(hero, "(What am I going to do?[pause=0] I don't know anything about anything right now...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " doesn't believe me...[pause=0] Would anyone else?)", "Worried")

	--partner realizes you're scared and lost
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, 2, 1)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("(Hmm...[pause=0] They look really worried...[pause=0] Maybe they're telling the truth after all?)")
	UI:WaitShowDialogue("(There's no real reason to lie about this sort of thing,[pause=10] is there?)")
	GAME:WaitFrames(40)
	
	--ok i believe you kinda 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hey...[pause=0] I've thought about what you said more...")
	UI:WaitShowDialogue("I don't think you're lying,[pause=10] you seem pretty genuine.")
	UI:WaitShowDialogue("Someone wouldn't just lay unconscious in a mystery dungeon claiming humanity and amnesia for a prank.")
	UI:WaitShowDialogue("OK.[pause=0] Though I'm not sure if I one-hundred percent believe your story...")
	UI:WaitShowDialogue("I do believe that you're being truthful at least.[pause=0] Something weird certainly happened to you.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	--UI:WaitShowDialogue("(It's pretty unlikely this Pokémon was actually a human,[pause=10] right? But if they were...)")
	--UI:WaitShowDialogue("(Well,[pause=10] [color=#00FFFF]Erleuchtet[color] was wrong about " .. zone:GetColoredName() .. "...[pause=0] He could be wrong about humans too...)")

	--name yourself	
	--GAME:WaitFrames(20)
	--SOUND:PlayBattleSE('EVT_Emote_Sweating')
	--GROUND:CharSetEmote(partner, 5, 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("But...[pause=0] Are you sure you can't remember anything at all?[pause=0] A name perhaps?")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...I don't think I even remember something as simple as that...)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I guess I can just pick something that I'd like to be called,[pause=10] at least...)", "Normal")
	GAME:WaitFrames(20)
	UI:NameMenu("What will your name be?", "")
	UI:WaitForChoice()
	result = UI:ChoiceResult()
	GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), result)

	--partner makes an excuse as to why they were acting odd. the truth is they're scared of the omen
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I see. So " .. hero:GetDisplayName() .. " is your name.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I'm sorry for being so skeptical before.[pause=0] It's just hard to believe that a human could turn into a Pokémon.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Even if you're not a human,[pause=10] you seem to truly think you're one and that's good enough for me.")
	
	
	
	--will you come with me back to metano town?
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Left)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's getting late though...")
	--GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I think you should come with me to the town where I live.")
	UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon for some reason...")
	UI:WaitShowDialogue("It wouldn't be right to leave you all alone after what you've told me.")
	UI:BeginChoiceMenu("So,[pause=10] what do you say?[pause=0] Will you come back with me to the town?", {"Go with them", "Refuse"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()	
	--if you say no, loop a dialogue until you say yes
	while result == 2 do 
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'Hurt', true)
		SOUND:PlayBattleSE('EVT_Emote_Startled')
		GROUND:CharSetEmote(partner, 8, 1)
		--todo: do a little hop
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'None', true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("W-what!?")
		SOUND:PlayBattleSE('EVT_Emote_Sweating')
		GROUND:CharSetEmote(partner, 5, 1)
		GAME:WaitFrames(40)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(hero:GetDisplayName() .. "...")
		UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon...")
		UI:WaitShowDialogue("Where else would you go?[pause=0] What else would you do?")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I can't in good conscience leave you out here...")
		UI:BeginChoiceMenu("So please...[pause=0] Will you come back with me?", {"Go with them", "Refuse"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()	
	end
	
	--player agrees
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I don't have many options here...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " seems kind enough though.[pause=0] Staying with them seems like a good idea.)", "Normal")
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--hooray we'll have to go thru the dungeon though
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Great![pause=0] I think you'll love Metano Town.")
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	UI:WaitShowDialogue("We'll have to trek back through the mystery dungeon to get there though.")
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I managed to get here by myself,[pause=10] so as long as we work together it'll be easy to get back through it!")

	--lets look around before leaving
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Before we leave,[pause=10] let's look around a bit.")
	UI:WaitShowDialogue("I'm curious if there's anything interesting here in the depths of this forest...")
	UI:WaitShowDialogue("Maybe something nearby can clue us in on what happened to you.")
	
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Up)
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(20)
	
	--spot the obelisk, approach it
	UI:WaitShowDialogue("Oh![pause=0] There's a stone obelisk over there!")
	
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 293, 218, false, 1))
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 270, 236, false, 1)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	TASK:JoinCoroutines({coro1})
	
	UI:WaitShowDialogue("There's some sort of writing inscribed here...")
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(partner, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I don't think I've ever seen this script before...[pause=0] I can't make head or tails of it!")
	
	--touch the tablet
	GROUND:MoveToPosition(partner, 293, 210, false, 1)	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Hmm...")
	GAME:WaitFrames(20)
	GROUND:CharPoseAnim(partner, 'Pose')
	GAME:WaitFrames(40)
	--todo: center the text
	UI:WaitShowMonologue(partner:GetDisplayName() .. " touched the ancient stone tablet.")
	GAME:WaitFrames(60)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(partner, 5, 1)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	--todo: walk backwards
	GROUND:MoveToPosition(partner, 293, 218, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	
	--ask hero to try
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's definitely some ancient tablet...")
	UI:WaitShowDialogue("But there doesn't seem to be anything special about it to me besides its age.")
	UI:WaitShowDialogue("Why don't you take a look at it,[pause=10] " .. hero:GetDisplayName() .. "?")
	UI:WaitShowDialogue("It's a long shot,[pause=10] but maybe you can figure something out.")
	
	--partner moves out of way, hero tries looking and touching
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(hero, 293, 218, false, 1))
	GROUND:MoveToPosition(partner, 317, 218, false, 1)	
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	--sense a vague connection with the tablet
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Hmm...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I don't recognize these letters either...[pause=0] I wonder what it means though?)", "Worried")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 293, 210, false, 1)	
	GROUND:CharPoseAnim(hero, 'Pose')
	GAME:WaitFrames(20)
	UI:WaitShowMonologue(hero:GetDisplayName() .. " touched the ancient stone tablet.")
	GROUND:CharSetEmote(hero, 2, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Nothing seems out of the ordinary here,[pause=10] but...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(I feel some sort of vague connection with this tablet.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But why?[pause=0] Nothing about it appears extraordinary...)", "Worried")
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:MoveToPosition(hero, 293, 218, false, 1)	
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GeneralFunctions.HeroSpeak(hero, 60)

	--couldnt really learn anything meaningful from touching the tablet.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("When you touched the obelisk,[pause=10] you felt some sort of odd connection to it?")
	GAME:WaitFrames(20)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's strange...[pause=0] But if you can't read it either,[pause=10] we really don't know if that feeling means anything.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's something to keep in mind I suppose.[pause=0] Too bad we couldn't learn anything else...")
	
	--nothing else is nearby. Let's leave.
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("There doesn't seem to be anything else that interesting around here.")
	UI:WaitShowDialogue("I think it's time we headed towards town.")
	UI:WaitShowDialogue("If we stick together we should be able to make it through the mystery dungeon in one piece.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Alright![pause=0] Let's get a move on!")
	
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(hero, 293, 298, false, 1))
	local coro2 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 317, 298, false, 1))
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1, coro2})	

	SV.Chapter1.PartnerMetHero = true
	GAME:CutsceneMode(false)
	--todo: enter the dungeon and related stuff
	GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker")
end




function relic_forest.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return relic_forest

