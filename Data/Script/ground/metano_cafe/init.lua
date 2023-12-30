--[[
    init.lua
    Created: 02/07/2021 21:52:45
    Description: Autogenerated script file for the map metano_cafe.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.metano_cafe.metano_cafe_ch_3'
require 'ground.metano_cafe.metano_cafe_ch_4'
require 'menu/ferment_menu'
require 'menu.single_deal_menu'
-- Package name
local metano_cafe = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_cafe.Init
--Engine callback function
function metano_cafe.Init(map, time)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_cafe <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies(true)
	PartnerEssentials.InitializePartnerSpawn()
	
	--Remove nicknames from characters if the nickname mod is enabled.
	if CONFIG.UseNicknames then
		CH('Cafe_Owner').Data.Nickname = CharacterEssentials.GetCharacterName('Shuckle')
	else 
		CH('Cafe_Owner').Data.Nickname = 'Shuckle'
	end
end

---metano_cafe.Enter
--Engine callback function
function metano_cafe.Enter(map, time)
	metano_cafe.PlotScripting()
end

---metano_cafe.Update
--Engine callback function
function metano_cafe.Update(map, time)
	

end

function metano_cafe.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_cafe.PlotScripting()
end

function metano_cafe.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_cafe.PlotScripting()
	if SV.ChapterProgression.Chapter == 3 then
		metano_cafe_ch_3.SetupGround()
	elseif SV.ChapterProgression.Chapter == 4 then
		metano_cafe_ch_4.SetupGround()
	else 
		GAME:FadeIn(20)
	end 
end

-------------------------------
-- Map Transition
-------------------------------

function metano_cafe.Cafe_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  if SV.metano_town.Song ~= "Spinda's Cafe.ogg" then SOUND:FadeOutBGM(20) end--map transition may result in a music change depending on song Falo is playing
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Cafe_Entrance_Marker", SV.metano_town.Song == "Spinda's Cafe.ogg")
  SV.partner.Spawn = 'Cafe_Entrance_Marker_Partner'
end



-------------------------------
-- Entities Callbacks
-------------------------------

--lists fermented drinks, their effects, and the recipes for each
function metano_cafe.Cafe_Sign_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	print("Cafe sign action")
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	UI:ResetSpeaker(false)
	local state = 0
	UI:SetCenter(true)
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)		
    GeneralFunctions.TurnTowardsLocation(hero, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
    GeneralFunctions.TurnTowardsLocation(partner, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)

	local shuckle_name = CharacterEssentials.GetCharacterName("Shuckle")
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Intro'], shuckle_name))
	
	local item1
	local item2
	
	while state > -1 do
		local choices = {STRINGS:Format(MapStrings['Cafe_Option_Domi']),
						STRINGS:Format(MapStrings['Cafe_Option_Cider']), 
						STRINGS:Format(MapStrings['Cafe_Option_Bomb']), 
						STRINGS:FormatKey('MENU_EXIT')}
						
		--Endurance Tonic is added in Chapter 4.
		--todo: better system for this?
		if SV.ChapterProgression.Chapter >= 4 then 
			table.insert(choices, 4, STRINGS:Format(MapStrings['Cafe_Option_Endurance']))
		end
				
				
		UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Cafe_Sign_Which_Drinks']), choices, 1, #choices)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result == 1 then
			item1 = RogueEssence.Dungeon.InvItem("berry_oran")--oran berry 
			item2 = RogueEssence.Dungeon.InvItem("ammo_stick")--stick
			item2.Amount = 5
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		elseif result == 2 then
			item1 = RogueEssence.Dungeon.InvItem("food_apple")--Apple 
			item2 = RogueEssence.Dungeon.InvItem("berry_oran")--oran berry
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		elseif result == 3 then 
			item1 = RogueEssence.Dungeon.InvItem("berry_cheri")--cheri berry
			item2 = RogueEssence.Dungeon.InvItem("seed_blast")--blast seed 
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Bomb_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Bomb_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		elseif result == 4 and #choices > 4 then 
			item1 = RogueEssence.Dungeon.InvItem("seed_reviver")
			item2 = RogueEssence.Dungeon.InvItem("berry_chesto")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Endurance_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Endurance_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		else
			state = -1
		end
	end

	UI:SetCenter(false)
	partner.IsInteracting = false
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
end


--[[
Drink ideas:
Frosty Float:
- ingredients: aspear berries, oran berries
- grants aurora veil to the party, even if it's not hailing

Banana Smoothie:
- Party full HP recovery + all stats EVs up by 1
- Tropius provides bananas to guild members as a rare reward for a job well done 


Endure Tonic:
- Gives drinker endure status for some time where they cannot be KO'd.
- Costs a reviver seed and something else.
]]--

function metano_cafe.Cafe_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	print("Cafe action")
	
	local state = 0
	local repeated = false
	
	--list of ~100 items, a random one is taken for new day to be sold as the cafe's special.
	local specials_catalog = 
	{
		{"food_apple_big", 30},
		{"food_apple_huge", 20},
		{"food_apple_perfect", 3},
		{"food_apple_golden", 1},
		
		{"food_banana", 10},
		{"food_banana_big", 2},
		{"food_banana_golden", 1},
		
		{"berry_lum", 15},
		{"berry_sitrus", 5},
		
		{"berry_tanga", 3},
		{"berry_colbur", 3},
		{"berry_haban", 3},
		{"berry_wacan", 3},
		{"berry_chople", 3},
		{"berry_occa", 3},
		{"berry_coba", 3},
		{"berry_kasib", 3},
		{"berry_rindo", 3},
		{"berry_shuca", 3},
		{"berry_yache", 3},
		{"berry_chilan", 3},
		{"berry_kebia", 3},
		{"berry_payapa", 3},
		{"berry_charti", 3},
		{"berry_babiri", 3},
		{"berry_passho", 3},
		{"berry_roseli", 3},
		
		{"berry_jaboca", 3},
		{"berry_rowap", 3},
		{"berry_apicot", 3},
		{"berry_liechi", 3},
		{"berry_ganlon", 3},
		{"berry_salac", 3},
		{"berry_petaya", 3},
		{"berry_starf", 3},
		{"berry_micle", 3},
		{"berry_enigma", 3},
		
				
		{"gummi_blue", 1}, --Blue Gummi
		{"gummi_black", 1}, --Black Gummi
		{"gummi_clear", 1}, --Clear Gummi
		{"gummi_grass", 1}, --Grass Gummi
		{"gummi_green", 1}, --Green Gummi
		{"gummi_brown", 1}, --Brown Gummi
		{"gummi_orange", 1}, --Orange Gummi
		{"gummi_gold", 1}, --Gold Gummi
		{"gummi_pink", 1}, --Pink Gummi
		{"gummi_purple", 1}, --Purple Gummi
		{"gummi_red", 1}, --Red Gummi
		{"gummi_royal", 1}, --Royal Gummi
		{"gummi_silver", 1}, --Silver Gummi
		{"gummi_white", 1}, --White Gummi
		{"gummi_yellow", 1}, --Yellow Gummi
		{"gummi_sky", 1}, --Sky Gummi
		{"gummi_gray", 1}, --Gray Gummi
		{"gummi_magenta", 1},	--Magenta Gummi
		{"gummi_wonder", 1}, --Wonder Gummi
		
		{"seed_plain", 20},
		{"seed_reviver", 10},
		{"seed_joy", 1},
		{"seed_doom", 3},

		{"boost_nectar", 1},
		{"boost_protein", 1},
		{"boost_iron", 1},
		{"boost_calcium", 1},
		{"boost_zinc", 1},
		{"boost_carbos", 1},
		{"boost_hp_up", 1},
		
		{"herb_mental", 5},
		{"herb_power", 5},
		{"herb_white", 5}
	}
	
	-- special is -1 if nothing has been selected as the daily special. It should be set back to -1 when a new day happens
	--but more ideally it should just be reinitialized when a new day happens. I just need to figure out how to do that properly
	if SV.metano_cafe.CafeSpecial == "" then 
		SV.metano_cafe.CafeSpecial =  GeneralFunctions.WeightedRandom(specials_catalog)
	end
	
	local special = RogueEssence.Dungeon.InvItem(SV.metano_cafe.CafeSpecial)
	local specialName = special:GetDisplayName()
	local specialPrice = special:GetSellValue()
	local owner = CH('Cafe_Owner')
	UI:SetSpeaker(owner)
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	owner.IsInteracting = true
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(owner, 'None', true)
			
	GROUND:CharTurnToChar(hero, owner)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, owner, 4) end)


	--He has a new type of drink he can serve
	if SV.metano_cafe.NewDrinkUnlocked then
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_New_Drink_1']))
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_New_Drink_2']))
		SV.metano_cafe.NewDrinkUnlocked = false
		GAME:WaitFrames(20)
	end 
	
	--he has a fermented item to give you
	if SV.metano_cafe.FermentedItem ~= "" and SV.metano_cafe.ItemFinishedFermenting then
		local juiceEntry = RogueEssence.Data.DataManager.Instance:GetItem(SV.metano_cafe.FermentedItem)
		local juice = RogueEssence.Dungeon.InvItem(SV.metano_cafe.FermentedItem, false, juiceEntry.MaxStack)
		UI:SetSpeakerEmotion('Normal')
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Give_Item_1'], juice:GetDisplayName()))
		if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
			UI:SetSpeakerEmotion('Worried')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full'], CharacterEssentials.GetCharacterName('Kangaskhan')))
			state = -1 --don't go to normal dialogue if he cant give you the fermented item.
		else
			--he retreats into his shell and pulls it out.
			GAME:WaitFrames(20)
			SOUND:PlayBattleSE('DUN_Equip')
			GROUND:CharSetAction(owner, RogueEssence.Ground.PoseGroundAction(owner.Position, owner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Special0")))
			GAME:WaitFrames(60)
			SOUND:PlayBattleSE('DUN_Worry_Seed')
			GROUND:CharSetAction(owner, RogueEssence.Ground.PoseGroundAction(owner.Position, owner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Special2")))
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Give_Item_2'], juice:GetDisplayName()))
			GROUND:CharSetAnim(owner, "None", true)
		
			--gives it to the player.
			GAME:GivePlayerItem(juice.ID, juiceEntry.MaxStack)
			SV.metano_cafe.FermentedItem = ""
			SV.metano_cafe.ItemFinishedFermenting = false
			SOUND:PlayBattleSE("DUN_Drink")
			UI:ResetSpeaker()
			UI:SetCenter(true)
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Item_Received'], juice:GetDisplayName(), owner:GetDisplayName()))
			UI:SetCenter(false)
		end			
	end
	

	--Normal Cafe Shop script
	while state > -1 do
		UI:SetSpeaker(owner)
		UI:SetSpeakerEmotion("Normal")
		local msg = STRINGS:Format(MapStrings['Cafe_Intro'])
		if repeated then 
			msg = STRINGS:Format(MapStrings['Cafe_Intro_Return'])
		end
		local cafe_choices = {STRINGS:Format(MapStrings['Cafe_Option_Ferment']), STRINGS:Format(MapStrings['Cafe_Option_Special']),
							  STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
		UI:BeginChoiceMenu(msg, cafe_choices, 1, 4)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then --drinks
			--he's already brewing something
			if SV.metano_cafe.FermentedItem ~= "" then
				local ferment_item = RogueEssence.Dungeon.InvItem(SV.metano_cafe.FermentedItem)
				local ferment_item_entry = RogueEssence.Data.DataManager.Instance:GetItem(SV.metano_cafe.FermentedItem)
				if ferment_item_entry.MaxStack > 1 then ferment_item.Amount = ferment_item_entry.MaxStack end--for multi-use items, like the apple cider
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Already_Fermenting'], ferment_item:GetDisplayName()))
			else		
				UI:SetSpeakerEmotion("Normal")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Ferment_Prompt']))
				
				local CreateFermentMenu = CreateFermentMenu()
				local items = {
					{ 
						item_to_ferment = "cafe_domi_blend",
						servings = 1,
						recipe_list = {{"berry_oran", 3}, {"ammo_stick", 5}},
						description_key = "Cafe_Sign_Domi_1",
					},
					{
						item_to_ferment = "cafe_apple_cider",
						servings = 4,
						recipe_list = {{"berry_oran", 1}, {"food_apple", 3}},
						description_key = "Cafe_Sign_Cider_1"
					},
					{
						item_to_ferment = "cafe_cheri_bomb",
						servings = 1,
						recipe_list = {{"berry_cheri", 1}, {"seed_blast", 1}},
						description_key = "Cafe_Sign_Bomb_1"
					},
	
				}
				if SV.ChapterProgression.Chapter >= 4 then 
					local endurance_tonic = {
						item_to_ferment = "cafe_endurance_tonic",
						servings = 1,
						recipe_list = {{"seed_reviver", 1}, {"berry_chesto", 1}},
						description_key = "Cafe_Sign_Endurance_1"
					}
					table.insert(items, 4, endurance_tonic)
				end
	
				local menu = CreateFermentMenu:new(items, MapStrings)
				UI:SetCustomMenu(menu.menu)
				UI:WaitForChoice()
	
				if (menu.item_list_index > -1) then
					local menu_item = items[menu.item_list_index + 1]
					local ferment_item = RogueEssence.Dungeon.InvItem(menu_item.item_to_ferment, false, menu_item.servings)
					UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Cafe_Confirm_Ferment_Choice'], ferment_item:GetDisplayName()), true)
					UI:WaitForChoice()
					local confirm = UI:ChoiceResult()
					if confirm then
						SV.metano_cafe.FermentedItem = menu_item.item_to_ferment
						metano_cafe.RemoveItems(menu_item.recipe_list)
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_1']))
						--puts the items in his shell
						SOUND:PlayBattleSE('DUN_Equip')
						GROUND:CharSetAction(owner, RogueEssence.Ground.PoseGroundAction(owner.Position, owner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Special0")))
						GAME:WaitFrames(60)
						GROUND:CharSetDrawEffect(owner, DrawEffect.Trembling)
						SOUND:PlayBattleSE('DUN_Drink')
						GAME:WaitFrames(60)
						SOUND:PlayBattleSE('DUN_Fake_Tears')
						GAME:WaitFrames(60)
						SOUND:PlayBattleSE('DUN_Food')
						GAME:WaitFrames(60)
						SOUND:PlayBattleSE('DUN_Worry_Seed')
						GROUND:CharEndDrawEffect(owner, DrawEffect.Trembling)
						GROUND:CharWaitAnim(owner, "Special1")
						GROUND:CharSetAnim(owner, "None", true)
						UI:SetSpeakerEmotion("Inspired")
						UI:WaitShowTimedDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_2']), 60)
						GAME:WaitFrames(20)
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_3'], ferment_item:GetDisplayName()))
					end
				end
			end
		elseif result == 2 then --today's special
			if SV.metano_cafe.BoughtSpecial then 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bought_Special']))	
			else 					
				--UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Cafe_Daily_Special'], specialName, specialPrice)) --deprecated
				local SingleItemDealMenu = SingleItemDealMenu()
				local menu = SingleItemDealMenu:new("Café Special", special, specialPrice)
				UI:SetCustomMenu(menu.menu)
				UI:WaitForChoice()
				if menu.result then
					if specialPrice > GAME:GetPlayerMoney() then --Menu coding prevents this from being hit (can't try to buy if no money), but keep this here in case.
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_No_Money']))
						UI:SetSpeakerEmotion('Normal')
					elseif GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full'], CharacterEssentials.GetCharacterName('Kangaskhan')))
						UI:SetSpeakerEmotion('Normal')
					else
						SV.metano_cafe.BoughtSpecial = true
						GAME:RemoveFromPlayerMoney(specialPrice)
						GAME:GivePlayerItem(special.ID, 1)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Special_Complete'], specialName))
						UI:SetSpeakerEmotion("Normal")
					end
				end 
			end
		elseif result == 3 then --cafe info
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_2']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_3']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_4']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_5']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_6']))
		else--exit
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Goodbye']))
			UI:SetSpeakerEmotion("Normal")
			state = -1
		end
				
				
		
	
	
	
	--elseif state == 1 then 	 shop menu for smoothies	
		
		
	end

	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	owner.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(owner)	
	
	
end




--used to check what items you have. Returns true or false.
--item list is a list of pairs that contain an item ID and the corresponding amount needed.
function metano_cafe.CheckForItems(itemList)
	local bag_count = GAME:GetPlayerBagCount()
	local item_count = #itemList--how many unique items are needed for the recipe?
	local stack_count
	local recipe_item
	local item
	local item_entry
	local togo 
	
	--no items, no way this could return true
	if bag_count == 0 then return false end
	
	for i=1, item_count, 1 do
		recipe_item = itemList[i][1]
		togo = itemList[i][2]
		for j=0, bag_count-1, 1 do
			item = GAME:GetPlayerBagItem(j)
			item_entry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
			if item_entry.MaxStack > 1 then stack_count = item.Amount else stack_count = 1 end
			if item.ID == recipe_item then
				togo = togo - stack_count --subtract from the needed items by the stack count. This can go negative, which is fine.
			end
		end
		
		if togo > 0 then return false end --Break early and return a false if we couldn't meet the item requirements for a particular recipe item.
		
	end
	
	--to get to this point, we must have passed item counts for all needed items.
	return true

	

end

--used to remove items needed for a drink.
--item list is a list of pairs that contain an item ID and the corresponding amount needed.
function metano_cafe.RemoveItems(itemList)
	local bag_count
	local item_count = #itemList--how many unique items are needed for the recipe?
	local stack_count
	local recipe_item
	local item
	local item_entry
	local togo

	--the item bag indexes at 0.
	for i=1, item_count, 1 do
		recipe_item = itemList[i][1]	
		togo = itemList[i][2]
		bag_count = GAME:GetPlayerBagCount()--update bag count as we go
		for j=bag_count-1 , 0, -1 do
			item = GAME:GetPlayerBagItem(j)
			item_entry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
			if item_entry.MaxStack > 1 then stack_count = item.Amount else stack_count = 1 end
			if item.ID == recipe_item then
				if item_entry.MaxStack <= 1 then 
					GAME:TakePlayerBagItem(j, true)
				else
					if item.Amount > togo then--check if the stackable item needs to be deleted, or just subtracted from.
						--remove from the player's bag item stack but not fully.
						item.Amount = stack_count - togo
					else
						--print(item.Amount)
						--print(j)
						GAME:TakePlayerBagItem(j, true)
					end
				end
				
				togo = togo - stack_count --subtract from the needed items by the stack count. This can go below 0 when stackables are involved.
						
				--break early for an item if this particular item has been cleared.
				if togo <= 0 then break end
			end
		end
	end

end




function metano_cafe.Breloom_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Breloom_Action(...,...)"), chara, activator))
end

function metano_cafe.Girafarig_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Girafarig_Action(...,...)"), chara, activator))
end

function metano_cafe.Mareep_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), chara, activator))
end

function metano_cafe.Cranidos_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), chara, activator))
end

function metano_cafe.Linoone_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Linoone_Action(...,...)"), chara, activator))
end

function metano_cafe.Cleffa_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cleffa_Action(...,...)"), chara, activator))
end

function metano_cafe.Aggron_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Aggron_Action(...,...)"), chara, activator))
end


function metano_cafe.Gulpin_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gulpin_Action(...,...)"), chara, activator))
end

function metano_cafe.Lickitung_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_cafe_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Lickitung_Action(...,...)"), chara, activator))
end






function metano_cafe.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--your allies will wait for you in the cafe if you have any.
function metano_cafe.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GeneralFunctions.GroundInteract(activator, chara)
end

function metano_cafe.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GeneralFunctions.GroundInteract(activator, chara)
end



return metano_cafe

