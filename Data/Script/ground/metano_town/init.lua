require 'common'
require 'GeneralFunctions'
require 'PartnerEssentials'
require 'ground.metano_town.metano_town_ch_1'
require 'ground.metano_town.metano_town_ch_2'
require 'ground.metano_town.metano_town_ch_3'


local MapStrings = {}

local metano_town = {}


function metano_town.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_town <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	GROUND:AddMapStatus("cloudy")
	
		
	--if SV.metano_town.AggronGuided then--Hide Aggron if he's been guided to the Dojo
	--	GROUND:Hide('Aggron')
	--end
	
	--local chara = CH('Aggron')
	--metano_town.CreateWalkArea(chara, 1264, 560, 32, 32)
	--chara = CH('Delcatty')
	--metano_town.CreateWalkArea(chara, 1122, 888, 32, 32)
	



end



function metano_town.Enter(map)
	DEBUG.EnableDbgCoro()
	print('Enter_metano_town')
	metano_town.PlotScripting()
end

function metano_town.Update(map, time)

end

function metano_town.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_town.PlotScripting()
end

function metano_town.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end



function metano_town.PlotScripting()
	--plot scripting
	if SV.ChapterProgression.Chapter == 1 then 
		if not SV.Chapter1.PartnerCompletedForest then
			metano_town_ch_1.PartnerLongingCutscene()
		elseif SV.Chapter1.TeamCompletedForest then
			metano_town_ch_1.EnterGuild()
		end
	elseif SV.ChapterProgression.Chapter == 2 then
		metano_town_ch_2.SetupGround()
		if SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedMarketIntro then 
			metano_town_ch_2.MarketIntro()
		end
	elseif SV.ChapterProgression.Chapter == 3 then 
		metano_town_ch_3.SetupGround()
		if SV.Chapter3.FinishedOutlawIntro and not SV.Chapter3.MetTeamStyle then 
			metano_town_ch_3.MeetTeamStyle()
		end	
	else
		GAME:FadeIn(20)
	end
end


--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------
function metano_town.CreateWalkArea(chara, x, y, w, h)


  --Set the area to wander in
  AI:SetCharacterAI(chara,                                      --[[Entity that will use the AI]]--
                    "ai.ground_default",                         --[[Class path to the AI class to use]]--
                    RogueElements.Loc(x, y), --[[Top left corner pos of the allowed idle wander area]]--
                    RogueElements.Loc(w, h), --[[Width and Height of the allowed idle wander area]]--
                    1,                                         --[[Wandering speed]]--
                    16,                                          --[[Min move distance for a single wander]]--
                    32,                                          --[[Max move distance for a single wander]]--
                    40,                                         --[[Min delay between idle actions]]--
                    180)                                        --[[Max delay between idle actions]]--
end







----------------------
-- Map Transitions
----------------------

--Main_Entrance_Marker is the default entrance marker for a map, every map
--has that marker, but it's kinda arbitrary which one I choose to be the "main" one.
--Other markers may need to be specified if a map has more than once entrance point.

function metano_town.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries["illuminant_riverbed"] 
  UI:ResetSpeaker()
  UI:ChoiceMenuYesNo("Would you like to enter " .. zone:GetColoredName() .. "?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  if yesnoResult then 
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end

function metano_town.East_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GeneralFunctions.StartPartnerConversation("Where should we go,[pause=10] " .. CH('PLAYER'):GetDisplayName() .. "?", "Normal", false)
  GAME:WaitFrames(20)
  local dungeons = {"relic_forest", "illuminant_riverbed", "crooked_cavern"}--this needs to be updated when more dungeons come out.
  local grounds = {}
  metano_town.ShowDestinationMenu(dungeons, grounds)
  GeneralFunctions.EndConversation(CH('Teammate1'))
end

function metano_town.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Guild_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  SOUND:FadeOutBGM(20)--map transition will result in a music change
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_first_floor", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Cafe_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  SOUND:FadeOutBGM(20)--map transition will result in a music change
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cafe", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Fire_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_fire_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Rock_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_rock_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Water_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_water_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Grass_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_grass_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Electric_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_electric_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Normal_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_normal_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Cave_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cave", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Dojo_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  SOUND:FadeOutBGM(20)--map transition will result in a music change
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("ledian_dojo", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Post_Office_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("post_office", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Inn_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_inn", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end




-----------------------
-- Partner scripting
-----------------------

function metano_town.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--locales mark the zone of the town we're in for partner dialogue
function metano_town.Cafe_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Cafe'
end

function metano_town.Exploration_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Exploration'
end

function metano_town.Cave_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Cave'
end

function metano_town.South_Houses_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'South Houses'
end

function metano_town.North_Houses_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'North Houses'
end

function metano_town.Merchants_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Merchants'
end

function metano_town.Guild_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Guild'
end

function metano_town.Market_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Market'
end

function metano_town.Well_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Well'
end

function metano_town.Post_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Post'
end

function metano_town.Dojo_Locale_Touch(chara, activator)
	DEBUG.EnableDbgCoro()
	SV.metano_town.Locale = 'Dojo'
end


-----------------------
-- Helper Functions
-----------------------
--Reimplemented, modified version of common's showdestination menu. 
function metano_town.ShowDestinationMenu(dungeon_entrances,ground_entrances)
  
  --Story dungeons and their corresponding "entrance ground" used for story cutscenes during the relevant chapter.
  --Illuminant Riverbed and Relic Forest 1 are story dungeons not accessed via this menu and thus the flag doesn't track them.
  local dungeon_entrance_mapping = {}
  dungeon_entrance_mapping["illuminant_riverbed"] = 38 --Illuminant Riverbed, but this shouldn't ever be used.
  dungeon_entrance_mapping["crooked_cavern"] = 41--Crooked Cavern
  
  --check for unlock of dungeons
  local open_dests = {}
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[dungeon_entrances[ii]]
	  local zone_name = zone_summary:GetColoredName()
      table.insert(open_dests, { Name=zone_name, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
	end
  end
  
  --check for unlock of grounds
  for ii = 1,#ground_entrances,1 do
    if ground_entrances[ii].Flag then
	  local ground_id = ground_entrances[ii].Zone
	  local zone = _DATA:GetZone(ground_id)
	  local ground = _DATA:GetGround(zone.GroundMaps[ground_entrances[ii].ID])
	  local ground_name = ground:GetColoredName()
      table.insert(open_dests, { Name=ground_name, Dest=RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_entrances[ii].ID, ground_entrances[ii].Entry) })
	end
  end
  
  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  if #open_dests == 1 then
    if open_dests[1].Dest.StructID.Segment < 0 then
	  --single ground entry
      UI:ResetSpeaker()
      
	  UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_ENTER_GROUND", open_dests[1].Name))
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
	else
	  --single dungeon entry
      UI:ResetSpeaker()
      SOUND:PlaySE("Menu/Skip")
	  UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
	end
  elseif #open_dests > 1 then
    
    UI:ResetSpeaker()
    SOUND:PlaySE("Menu/Skip")
    UI:DestinationMenu(open_dests)
	UI:WaitForChoice()
	dest = UI:ChoiceResult()
  end
  
  if dest:IsValid() then
	--confirm the choice
	UI:ResetSpeaker()
	UI:SetCenter(true)
	local dest_name = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[dest.ID]:GetColoredName()
	UI:ChoiceMenuYesNo(dest_name .. " is the destination.\nIs that correct?")
	UI:WaitForChoice()
	local confirm = UI:ChoiceResult()
	UI:SetCenter(false)
	if confirm then
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)
		if dest.StructID.Segment > -1 then
		  if SV.ChapterProgression.CurrentStoryDungeon == dest.ID then --go to the ground outside instead as it's the current story dungeon.
			GAME:WaitFrames(120)--wait a bit before going to the ground
			GAME:EnterZone("master_zone", -1, dungeon_entrance_mapping[dest.ID], 0)
		  else
			GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
		  end
		else
		  GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
		end
	end
  end
end


-----------------------
-- Shop/Useful NPCs
-----------------------

function metano_town.GenerateGreenKecleonStock()
	--generate random stock of items for green kec. Items generated are based on story progression (better items will crop up later in the story)
	--Start with predefined list of weighted items, then generate a stock of several items from those lists
	--Stocks are separated based on category (food, medicine, hold item, etc).
	--Kec stock isn't totally random, it pulls a gauranteed number from each stock  (i.e. always 1 hold item a day, but which it is is random)
	
	local stock = {}
	
	
	--TODO: Add more types of stock progressions later on 
	--Basic Stock, early game
	
	--total weight = 100
	local food_stock = {
		{"apple", 82}, --Apple
		{"blue_gummi", 1}, --Blue Gummi
		{"black_gummi", 1}, --Black Gummi
		{"clear_gummi", 1}, --Clear Gummi
		{"grass_gummi", 1}, --Grass Gummi
		{"green_gummi", 1}, --Green Gummi
		{"brown_gummi", 1}, --Brown Gummi
		{"orange_gummi", 1}, --Orange Gummi
		{"gold_gummi", 1}, --Gold Gummi
		{"pink_gummi", 1}, --Pink Gummi
		{"purple_gummi", 1}, --Purple Gummi
		{"red_gummi", 1}, --Red Gummi
		{"royal_gummi", 1}, --Royal Gummi
		{"silver_gummi", 1}, --Silver Gummi
		{"white_gummi", 1}, --White Gummi
		{"yellow_gummi", 1}, --Yellow Gummi
		{"sky_gummi", 1}, --Sky Gummi
		{"gray_gummi", 1}, --Gray Gummi
		{"magenta_gummi", 1}	--Magenta Gummi
	}
	
	--total weight = 120
	local medicine_stock = {
		{"reviver_seed", 10},--Reviver seed 
		{"warp_seed", 5}, --Warp Seed 
		{"sleep_seed", 5}, --Sleep seed 
		{"vile_seed", 2}, --Vile seed 
		{"blast_seed", 8}, --Blast seed
		
		{"leppa_berry", 25}, --Leppa berry 

		
		{"oran_berry", 32}, --Oran berry
		{"lum_berry", 2}, --Lum berry 
		{"cheri_berry", 6}, -- Cheri berry 
		{"chesto_berry", 4}, -- Chesto berry 
		{"pecha_berry", 8}, -- Pecha berry 
		{"aspear_berry", 3}, -- Aspear berry 
		{"rawst_berry", 4}, -- Rawst berry 
		{"persim_berry", 6} -- Persim berry 
	}
	
	
	local ammo_stock = 
	{
		{"ammo_geo_pebble", 50}, --Geo pebble 
		{"ammo_stick", 50},--stick 
		{"ammo_iron_thorn", 50}--iron thorn 
	}
	
	
	local held_stock = {
		{"power_band", 10}, -- power band 
		{"special_band", 10}, --special band 
		{"defense_scarf", 10}, --defense scarf 
		{"zinc_band", 10}, --Zinc band 
		
		{"pecha_scarf", 10}, --Pecha Scarf
		{"cheri_scarf", 10}, --Cheri scarf 
		{"rawst_scarf", 10}, --Rawst scarf 
		{"aspear_scarf", 10}, --Aspear Scarf 
		{"insomniascope", 10}, --Insomnia scope
		{"persim_band", 10}, --Persim Band
		
		{"reunion_cape", 2} --Reunion cape 
		
	}
	
	table.insert(stock, GeneralFunctions.WeightedRandom(held_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(ammo_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(food_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(medicine_stock))

	--set stock to randomized assortment and flag that the stock was refreshed for the day
	SV.DailyFlags.GreenKecleonStockedRefreshed = true
	SV.DailyFlags.GreenKecleonStock = stock
	
end

function metano_town.GeneratePurpleKecleonStock()
	--generate random stock of items for green kec. Items generated are based on story progression (better items will crop up later in the story)
	--Start with predefined list of weighted items, then generate a stock of several items from those lists
	--Stocks are separated based on category (food, medicine, hold item, etc).
	--Kec stock isn't totally random, it pulls a gauranteed number from each stock  (i.e. always 1 hold item a day, but which it is is random)
	
	local stock = {}
	
	
	--TODO: Add more types of stock progressions later on 
	--Basic Stock, early game
	
	--total weight = 
	--mostly meh TMs for early game 
	local tm_stock = {
		{"tm_secret_power", 10},--secret power 
		{"tm_embargo", 10},--embargo 
		{"tm_echoed_voice", 10},--echoed voice
		{"tm_protect", 5},--protect 
		{"tm_roar", 10},--roar 
		{"tm_swagger", 10},--swagger 
		{"tm_facade", 10}, --facade 
		{"tm_payback", 10}, --payback 
		{"tm_dig", 2}, --dig 
		{"tm_safeguard", 10},--safeguard 
		{"tm_venoshock", 5}, --venoshock
		{"tm_work_up", 5},--workup
		{"tm_thunder_wave", 5}, --thunder wave 
		{"tm_return", 5},--return
		{"tm_pluck", 5},--pluck 
		{"tm_frustration", 5},--frustration
		{"tm_thief", 10},--thief 
		{"tm_water_pulse", 2},--water pulse
		{"tm_shock_wave", 2},--shock wave 
		{"tm_incinerate", 2},--incinerate 
		{"tm_rock_tomb", 4},--rock tomb 
		{"tm_attract", 10},--attract
		{"tm_hidden_power", 8},--hidden power 
		{"tm_taunt", 10},--taunt 
		{"tm_grass_knot", 4},--grass knot 
		{"tm_brick_break", 2},--brick break 
		{"tm_rest", 5},--rest 
	}
	
	--total weight = 
	local wand_stock = {
		{"wand_path", 10},--path wand 
		{"wand_pounce", 10},--pounce wand 
		{"wand_whirlwind", 10},--whirlwind wand 
		{"wand_switcher", 10},--switcher wand 
		{"wand_lure", 10},--lure wand 
		{"wand_slow", 10},--slow wand 
		{"wand_fear", 10},--fear wand 
		{"wand_topsy_turvy", 5},--topsy turvy wand 
		{"wand_warp", 5},--warp wand 
		{"wand_purge", 5},--purge wand 
		{"wand_lob", 10} --lob wand 
	}
	
	
	local orb_stock = 
	{
		{"escape_orb", 50},--escape orb 
		{"cleanse_orb", 10},--cleanse orb 
		
		{"petrify_orb", 10},--petrify orb 
		{"slumber_orb", 10},--slumber orb 
		{"totter_orb", 10},--totter orb 
		{"scanner_orb", 10},--scanner orb
		{"luminous_orb", 10},--luminous orb
		{"spurn_orb", 10},--spurn orb 
		{"foe_hold_orb", 10},--foe hold orb 
		{"foe_seal_orb", 10},--foe seal orb 
		{"rollcall_orb", 15},--rollcall orb 
		{"trawl_orb", 5}, --trawl orb 
		{"all_aim_orb", 10},--all aim orb
		{"invert_orb", 5}, --invert orb 
		{"fill_in_orb", 5} --fill in orb
	}
	
	
	table.insert(stock, GeneralFunctions.WeightedRandom(tm_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(orb_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(wand_stock))
	table.insert(stock, GeneralFunctions.WeightedRandom(wand_stock))


	--set stock to randomized assortment and flag that the stock was refreshed for the day
	SV.DailyFlags.PurpleKecleonStockedRefreshed = true
	SV.DailyFlags.PurpleKecleonStock = stock	
end

function metano_town.Shop_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
    
  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }
  
  --generate stock if it hasn't been for the day 
  if not SV.DailyFlags.GreenKecleonStockedRefreshed then 
	metano_town.GenerateGreenKecleonStock()
  end
  
  --populate the catalog of items to buy using the generated stock. Item and hidden (amount of items in the stack typically) are grabbed from the item's predefined values in the item editor
  for ii = 1, #SV.DailyFlags.GreenKecleonStock, 1 do
  	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(SV.DailyFlags.GreenKecleonStock[ii])
	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.GreenKecleonStock[ii], false, itemEntry.MaxStack)

	--item price is 5 times the sell value. 
	local item_data = { Item = item, Price = item:GetSellValue() * 5 }
	table.insert(catalog, item_data)
  end

  
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Shop_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)
		
  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Shop_Intro'])
			if repeated then
				msg = STRINGS:Format(MapStrings['Shop_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Shop_Option_Buy']), STRINGS:Format(MapStrings['Shop_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if #catalog > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_Empty']))
				end
			elseif result == 2 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Sell'], STRINGS:LocalKeyString(26)))
					state = 3
				else
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Bag_Empty']))
					UI:SetSpeakerEmotion("Normal")
				end
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_005']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ShopMenu(catalog)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Bag_Full']))
					UI:SetSpeakerEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + catalog[cart[ii]].Price
			end
			local msg
			if total > GAME:GetPlayerMoney() then
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_No_Money']))
				UI:SetSpeakerEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = catalog[cart[1]].Item:GetDisplayName()
					msg = STRINGS:Format(MapStrings['Shop_Buy_One'], total, name)
				else
					msg = STRINGS:Format(MapStrings['Shop_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				if result then
					GAME:RemoveFromPlayerMoney(total)
					for ii = 1, #cart, 1 do
						local item = catalog[cart[ii]].Item
						GAME:GivePlayerItem(item.ID, item.Amount)
					end
					for ii = #cart, 1, -1 do
						table.remove(catalog, cart[ii])
						table.remove(SV.DailyFlags.GreenKecleonStock, cart[ii])
					end
					
					cart = {}
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		elseif state == 3 then
			UI:SellMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if #result > 0 then
				cart = result
				state = 4
			else
				state = 0
			end
		elseif state == 4 then
			local total = 0
			for ii = 1, #cart, 1 do
				local item
				if cart[ii].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[ii].Slot)
				end
				total = total + item:GetSellValue()
			end
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(MapStrings['Shop_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(MapStrings['Shop_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			
			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:AddToPlayerMoney(total)
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Sell_Complete']))
				state = 0
			else
				state = 3
			end
		end
	end
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end





function metano_town.TM_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
    
  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }
  
  --generate stock if it hasn't been for the day 
  if not SV.DailyFlags.PurpleKecleonStockedRefreshed then 
	metano_town.GeneratePurpleKecleonStock()
  end
  
  --populate the catalog of items to buy using the generated stock. Item and hidden (amount of items in the stack typically) are grabbed from the item's predefined values in the item editor
  for ii = 1, #SV.DailyFlags.PurpleKecleonStock, 1 do
  	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(SV.DailyFlags.PurpleKecleonStock[ii])
	local item = RogueEssence.Dungeon.InvItem(SV.DailyFlags.PurpleKecleonStock[ii], false, math.min(4, itemEntry.MaxStack))--only give 4 wands.

	--item price is 5 times the sell value. 
	local item_data = { Item = item, Price = item:GetSellValue() * 5 }
	table.insert(catalog, item_data)
  end

  
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('TM_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)
		
  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['TM_Shop_Intro'])
			if repeated then
				msg = STRINGS:Format(MapStrings['TM_Shop_Intro_Return'])
			end
			local TM_Shop_choices = {STRINGS:Format(MapStrings['TM_Shop_Option_Buy']), STRINGS:Format(MapStrings['TM_Shop_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, TM_Shop_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if #catalog > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Buy'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Buy_Empty']))
				end
			elseif result == 2 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Sell'], STRINGS:LocalKeyString(26)))
					state = 3
				else
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Bag_Empty']))
					UI:SetSpeakerEmotion("Normal")
				end
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Info_005']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ShopMenu(catalog)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Bag_Full']))
					UI:SetSpeakerEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + catalog[cart[ii]].Price
			end
			local msg
			if total > GAME:GetPlayerMoney() then
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Buy_No_Money']))
				UI:SetSpeakerEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = catalog[cart[1]].Item:GetDisplayName()
					msg = STRINGS:Format(MapStrings['TM_Shop_Buy_One'], total, name)
				else
					msg = STRINGS:Format(MapStrings['TM_Shop_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				if result then
					GAME:RemoveFromPlayerMoney(total)
					for ii = 1, #cart, 1 do
						local item = catalog[cart[ii]].Item
						GAME:GivePlayerItem(item.ID, item.Amount)
					end
					for ii = #cart, 1, -1 do
						table.remove(catalog, cart[ii])
						table.remove(SV.DailyFlags.PurpleKecleonStock, cart[ii])
					end
					
					cart = {}
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		elseif state == 3 then
			UI:SellMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if #result > 0 then
				cart = result
				state = 4
			else
				state = 0
			end
		elseif state == 4 then
			local total = 0
			for ii = 1, #cart, 1 do
				local item
				if cart[ii].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[ii].Slot)
				end
				total = total + item:GetSellValue()
			end
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(MapStrings['TM_Shop_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(MapStrings['TM_Shop_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			
			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:AddToPlayerMoney(total)
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['TM_Shop_Sell_Complete']))
				state = 0
			else
				state = 3
			end
		end
	end
	
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end















function metano_town.Musician_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('Musician')
  UI:SetSpeaker(chara)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Music_Intro']))
  UI:ShowMusicMenu({'MAIN_001'})
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result ~= nil then
	SV.base_town.Song = result--To do: rename this for specifically metano town map
	GROUND:CharSetAnim(chara, 'Wiggle', true)
  end
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Music_End']))
end









function metano_town.Storage_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local chara = CH('Storage_Owner')
	chara.IsInteracting = true
	partner.IsInteracting = true
	UI:SetSpeaker(chara)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(chara, 'None', true)
			
	GROUND:CharTurnToChar(hero, chara)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:SetSpeakerEmotion('Happy')
	
	local state = 0
	local repeated = false
	
	while state > -1 do
		local has_items = GAME:GetPlayerBagCount() > 0
		local has_storage = GAME:GetPlayerStorageCount() > 0
		
		local item_count = GAME:GetPlayerBagCount()
		
		local storage_choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items},
		{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}
		
		local msg = STRINGS:Format(MapStrings['Storage_Intro'])
		if repeated then 
			msg = STRINGS:Format(MapStrings['Storage_Intro_Return']) 
			UI:SetSpeakerEmotion('Normal')			
		end
		
		UI:BeginChoiceMenu(msg, storage_choices, 1, 4)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()	
		UI:SetSpeakerEmotion('Normal')

		
		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Store'], STRINGS:LocalKeyString(26)))
			UI:StorageMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then 
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Stored_Items']))
			end
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Withdraw'], STRINGS:LocalKeyString(26)))
			UI:WithdrawMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then 
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Withdrew_Items']))
			end 
		elseif result == 3 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_2']))
			UI:SetSpeakerEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_3']))
			UI:SetSpeakerEmotion('Normal')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_4']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_5']))
		else 
			UI:SetSpeakerEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Goodbye']))
			state = -1
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end 












function metano_town.Bank_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local chara = CH('Bank_Owner')
    chara.IsInteracting = true
    partner.IsInteracting = true
    UI:SetSpeaker(chara)
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
    GROUND:CharSetAnim(chara, 'None', true)
		
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	
	local state = 0
	local repeated = false
	
	while state > -1 do
		
		local player_money = GAME:GetPlayerMoney()
		local bank_choices = { { STRINGS:FormatKey('MENU_STORAGE_MONEY'), true},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}
		
		local msg = STRINGS:Format(MapStrings['Bank_Intro'], GAME:GetPlayerMoneyBank())
		if repeated then msg = STRINGS:Format(MapStrings['Bank_Intro_Return']) end
		
		UI:BeginChoiceMenu(msg, bank_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()	
		
		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Interact']))
			UI:BankMenu()
			UI:WaitForChoice()
			local difference = math.abs(player_money - GAME:GetPlayerMoney())
			if player_money > GAME:GetPlayerMoney() then --deposited money
				UI:SetSpeakerEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Stored_Money'], difference))
			elseif player_money < GAME:GetPlayerMoney() then --Withdrew money
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Withdrew_Money'], difference))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Canceled']))
			end
			UI:SetSpeakerEmotion('Normal')
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_2']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_3']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_4']))
		else 
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Goodbye']))
			state = -1
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end 


function metano_town.Red_Merchant_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false

	
	--todo: remove some nice items, add to green merchant... they should have a few exclusive items
	
	--items the merchants can potentially sell. should be about 2/3 chance for common junk, 1/3 to get something more interesting.
	local merchant_catalog = 
	{
		"machine_recall_box", "machine_recall_box", "machine_recall_box", --link box 
		--"machine_assembly_box", "machine_assembly_box", "machine_assembly_box", --assembly box (disabled in demo)
		"machine_storage_box", "machine_storage_box", "machine_storage_box", --storage box
		"ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", --stick
		"ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", --cacnea spike
		"ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", --corsola twig
		"ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", --iron thorn
		"ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike",  --silver spike 
		"ammo_golden_thorn", "ammo_golden_thorn", "ammo_golden_thorn",   --golden thorn 
		"ammo_rare_fossil",  --rare fossil
		"ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", --geo pebble
		"ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock",   --gravelerock
		"apricorn_perfect", --perfect apricorn
		"wand_path", "wand_path", "wand_path", "wand_path", "wand_path",--path wand 
		"wand_pounce", "wand_pounce", "wand_pounce", "wand_pounce", "wand_pounce",--pounce wand 
		"wand_whirlwind", "wand_whirlwind", "wand_whirlwind", "wand_whirlwind", "wand_whirlwind", --whirlwind wand
		"wand_switcher", "wand_switcher", "wand_switcher", "wand_switcher", "wand_switcher", --switcher wand
		"wand_surround", "wand_surround", "wand_surround", "wand_surround", "wand_surround", --surround wand
		"wand_lure", "wand_lure", "wand_lure", "wand_lure", "wand_lure",--lure wand 
		"wand_slow", "wand_slow", "wand_slow", "wand_slow", "wand_slow", --slow wand 
		"wand_stayaway", "wand_stayaway", "wand_stayaway", "wand_stayaway", "wand_stayaway", --stayaway wand 
		"wand_fear", "wand_fear", "wand_fear", "wand_fear", "wand_fear", --fear wand 
		"wand_totter", "wand_totter", "wand_totter", "wand_totter", "wand_totter",--totter wand
		"wand_infatuation", "wand_infatuation", "wand_infatuation", "wand_infatuation", "wand_infatuation",--infatuation wand 
		"wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", --topsy turvy wand 
		"wand_warp", "wand_warp", "wand_warp", "wand_warp", "wand_warp", --warp wand 
		"wand_purge", "wand_purge", "wand_purge", "wand_purge", "wand_purge", --purge wand
		"wand_lob", "wand_lob", "wand_lob", "wand_lob", "wand_lob", --lob wand
		--rest of items are non "junk", put one of each since they should be rare to get a specific item, but there's so many different ones it isn't rare to find non junk
		"held_silver_powder", "held_black_glasses", "held_dragon_scale", "held_magnet", "held_pink_bow", "held_black_belt", "held_charcoal", "held_sharp_beak", "held_spell_tag", "held_miracle_seed", "held_soft_sand", "held_never_melt_ice", "held_silk_scarf", "held_poison_barb", "held_twisted_spoon", "held_hard_stone", "held_metal_coat", "held_mystic_water", --type boosting items
		"evo_harmony_scarf", "evo_everstone", "evo_fire_stone", "evo_thunder_stone", "evo_water_stone", "evo_leaf_stone", "evo_moon_stone", "evo_sun_stone", "evo_magmarizer", "evo_electirizer", "evo_reaper_cloth", "evo_cracked_pot", "evo_chipped_pot", "evo_shiny_stone", "evo_dusk_stone", "evo_dawn_stone", "evo_link_cable", "evo_up_grade", "evo_dubious_disc", "evo_razor_fang", "evo_razor_claw", "370", "evo_protector", "evo_oval_stone", "evo_prism_scale", "evo_kings_rock", "evo_deep_sea_tooth", "evo_deep_sea_scale", "evo_sun_ribbon", "evo_lunar_ribbon",--evolution items, maybe disable if game is not complete?
		"machine_ability_capsule" --ability capsule
	}
	
	if SV.DailyFlags.RedMerchantItem == "" then 
		SV.DailyFlags.RedMerchantItem = math.random(1, #merchant_catalog)
	end
	
	local chara = CH('Red_Merchant')
	
	local item = RogueEssence.Dungeon.InvItem(merchant_catalog[SV.DailyFlags.RedMerchantItem])
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.Amount = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue()

	local merchant_choices = {STRINGS:Format(MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	
	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the green merchant
		local angry = SV.DailyFlags.GreenMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.RedMerchantBought
		
		UI:SetSpeakerEmotion('Normal')
		local msg = STRINGS:Format(MapStrings['Red_Merchant_Intro'])
		
		
		if repeated then
			if happy then 
				msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Return_Happy'])
				UI:SetSpeakerEmotion('Normal')
			elseif angry then 
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Return'])
			end
		elseif happy then
			UI:SetSpeakerEmotion('Happy')
			msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Happy'])
		elseif angry then 
			UI:SetSpeakerEmotion('Determined')
			msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Angry'])
		end
		
		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then 
			if happy then 
				UI:SetSpeakerEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_No_Stock']))
			elseif angry then 
				UI:SetSpeakerEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Refuse_Service']))
			else
				UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Red_Merchant_Daily_Item'], itemName, itemPrice))
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result then
					if itemPrice > GAME:GetPlayerMoney() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Bag_Full']))
					else
						SV.DailyFlags.RedMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Joyous")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Purchase_Made'], itemName))
					end
				end
			end				
		elseif result == 2 then 
			if angry then 
				UI:SetSpeakerEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Angry']))
			elseif happy then 
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_2']))
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_3']))
				UI:SetSpeakerEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_5']))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_1']))
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_2']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_3']))
				UI:SetSpeakerEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_5']))
			end 
		else
			if angry then
				UI:SetSpeakerEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye_Angry']))
			elseif happy then
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye']))
			end
			state = -1
		end 
	end

	GROUND:EntTurn(chara, olddir)
	
	
end



function metano_town.Green_Merchant_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false

	
	--code and strings say "angry" but this merchant actually gets sad when you buy from the other one. too lazy to update naming to reflect that, as code is copied from other merchant 
	--items the merchants can potentially sell. should be about 2/3 chance for common junk, 1/3 to get something more interesting.
	local merchant_catalog = 
	{
		"machine_recall_box", "machine_recall_box", "machine_recall_box", --link box 
		--"machine_assembly_box", "machine_assembly_box", "machine_assembly_box", --assembly box (disable in demo)
		"machine_storage_box", "machine_storage_box", "machine_storage_box", --storage box
		"ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", "ammo_stick", --stick
		"ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", "ammo_cacnea_spike", --cacnea spike
		"ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", "ammo_corsola_twig", --corsola twig
		"ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", "ammo_iron_thorn", --iron thorn
		"ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike", "ammo_silver_spike",  --silver spike 
		"ammo_golden_thorn", "ammo_golden_thorn", "ammo_golden_thorn",   --golden thorn 
		"ammo_rare_fossil",  --rare fossil
		"ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", "ammo_geo_pebble", --geo pebble
		"ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock", "ammo_gravelerock",   --gravelerock
		"apricorn_perfect", --perfect apricorn
		"wand_path", "wand_path", "wand_path", "wand_path", "wand_path",--path wand 
		"wand_pounce", "wand_pounce", "wand_pounce", "wand_pounce", "wand_pounce",--pounce wand 
		"wand_whirlwind", "wand_whirlwind", "wand_whirlwind", "wand_whirlwind", "wand_whirlwind", --whirlwind wand
		"wand_switcher", "wand_switcher", "wand_switcher", "wand_switcher", "wand_switcher", --switcher wand
		"wand_surround", "wand_surround", "wand_surround", "wand_surround", "wand_surround", --surround wand
		"wand_lure", "wand_lure", "wand_lure", "wand_lure", "wand_lure",--lure wand 
		"wand_slow", "wand_slow", "wand_slow", "wand_slow", "wand_slow", --slow wand 
		"wand_stayaway", "wand_stayaway", "wand_stayaway", "wand_stayaway", "wand_stayaway", --stayaway wand 
		"wand_fear", "wand_fear", "wand_fear", "wand_fear", "wand_fear", --fear wand 
		"wand_totter", "wand_totter", "wand_totter", "wand_totter", "wand_totter",--totter wand
		"wand_infatuation", "wand_infatuation", "wand_infatuation", "wand_infatuation", "wand_infatuation",--infatuation wand 
		"wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", "wand_topsy_turvy", --topsy turvy wand 
		"wand_warp", "wand_warp", "wand_warp", "wand_warp", "wand_warp", --warp wand 
		"wand_purge", "wand_purge", "wand_purge", "wand_purge", "wand_purge", --purge wand
		"wand_lob", "wand_lob", "wand_lob", "wand_lob", "wand_lob", --lob wand
		--rest of items are non "junk", put one of each since they should be rare to get a specific item, but there's so many different ones it isn't rare to find non junk
		"power_band", "power_band", "power_band", "special_band", "special_band", "special_band", "defense_scarf", "defense_scarf", "defense_scarf", "zinc_band", "zinc_band", "zinc_band", --power band, def scarf, etc
		"held_friend_bow", "held_pierce_band", "held_mobile_scarf", "held_pass_scarf", "held_warp_scarf", "held_trap_scarf", "held_grip_claw", "held_binding_band", "held_twist_band", "held_metronome", "held_shed_shell", "held_shell_bell", "held_scope_lens", "held_wide_lens", "held_heal_ribbon", --some assorted bands and scarfs
		"held_sticky_barb", "held_choice_band", "held_choice_specs", "held_choice_scarf", "held_assault_vest", "held_life_orb", "held_toxic_orb", "held_flame_orb", "held_iron_ball", "held_ring_target", "held_black_sludge", "held_x_ray_specs", "reunion_cape", "held_cover_band", "held_big_root", "held_expert_belt", --assorted hold items
		"machine_ability_capsule" --ability capsule
	}
	
	if SV.DailyFlags.GreenMerchantItem == "" then 
		SV.DailyFlags.GreenMerchantItem = math.random(1, #merchant_catalog)
	end
	
	local chara = CH('Green_Merchant')
	
	local item = RogueEssence.Dungeon.InvItem(merchant_catalog[SV.DailyFlags.GreenMerchantItem])
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.Amount = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue()
	local merchant_choices = {STRINGS:Format(MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	
	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the red merchant
		local angry = SV.DailyFlags.RedMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.GreenMerchantBought
		
		UI:SetSpeakerEmotion('Normal')
		local msg = STRINGS:Format(MapStrings['Green_Merchant_Intro'])
		
		
		if repeated then
			if happy then 
				msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Return_Happy'])
				--UI:SetSpeakerEmotion('Happy')
			elseif angry then 
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Return'])
			end
		elseif happy then
			UI:SetSpeakerEmotion('Happy')
			msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Happy'])
		elseif angry then 
			UI:SetSpeakerEmotion('Teary-Eyed')
			msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Angry'])
		end
		
		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then 
			if happy then 
				UI:SetSpeakerEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_No_Stock']))
			elseif angry then 
				UI:SetSpeakerEmotion('Crying')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Refuse_Service']))
			else
				UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Green_Merchant_Daily_Item'], itemName, itemPrice))
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result then
					if itemPrice > GAME:GetPlayerMoney() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Bag_Full']))
					else
						SV.DailyFlags.GreenMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Purchase_Made'], itemName))
					end
				end
			end				
		elseif result == 2 then 
			if angry then 
				UI:SetSpeakerEmotion('Crying')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Angry']))
			elseif happy then 
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_2']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_3']))
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_5']))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_2']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_3']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_4']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_5']))
			end 
		else
			if angry then
				UI:SetSpeakerEmotion('Teary-Eyed')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye_Angry']))
			elseif happy then
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye']))
			end
			state = -1
		end 
	end

	GROUND:EntTurn(chara, olddir)
	
	
	
	
	
	
end





function metano_town.Swap_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  --silk/dust/gem/globes
  local catalog = { 
	{ Item="xcl_element_bug_gem", ReqItem={"xcl_element_bug_silk","xcl_element_bug_dust"}},
	{ Item="xcl_element_bug_globe", ReqItem={"xcl_element_bug_silk", "xcl_element_bug_dust", "xcl_element_bug_gem"}},
	{ Item="xcl_element_dark_gem", ReqItem={"xcl_element_dark_silk","xcl_element_dark_dust"}},
	{ Item="xcl_element_dark_globe", ReqItem={"xcl_element_dark_silk", "xcl_element_dark_dust", "xcl_element_dark_gem"}},
	{ Item="xcl_element_dragon_gem", ReqItem={"xcl_element_dragon_silk","xcl_element_dragon_dust"}},
	{ Item="xcl_element_dragon_globe", ReqItem={"xcl_element_dragon_silk", "xcl_element_dragon_dust", "xcl_element_dragon_gem"}},
	{ Item="xcl_element_electric_gem", ReqItem={"xcl_element_electric_silk","xcl_element_electric_dust"}},
	{ Item="xcl_element_electric_globe", ReqItem={"xcl_element_electric_silk", "xcl_element_electric_dust", "xcl_element_electric_gem"}},
	{ Item="xcl_element_fairy_gem", ReqItem={"xcl_element_fairy_silk","xcl_element_fairy_dust"}},
	{ Item="xcl_element_fairy_globe", ReqItem={"xcl_element_fairy_silk", "xcl_element_fairy_dust", "xcl_element_fairy_gem"}},
	{ Item="xcl_element_fighting_gem", ReqItem={"xcl_element_fighting_silk","xcl_element_fighting_dust"}},
	{ Item="xcl_element_fighting_globe", ReqItem={"xcl_element_fighting_silk", "xcl_element_fighting_dust", "xcl_element_fighting_gem"}},
	{ Item="xcl_element_fire_gem", ReqItem={"xcl_element_fire_silk","xcl_element_fire_dust"}},
	{ Item="xcl_element_fire_globe", ReqItem={"xcl_element_fire_silk", "xcl_element_fire_dust", "xcl_element_fire_gem"}},
	{ Item="xcl_element_flying_gem", ReqItem={"xcl_element_flying_silk","xcl_element_flying_dust"}},
	{ Item="xcl_element_flying_globe", ReqItem={"xcl_element_flying_silk", "xcl_element_flying_dust", "xcl_element_flying_gem"}},
	{ Item="xcl_element_ghost_gem", ReqItem={"xcl_element_ghost_silk","xcl_element_ghost_dust"}},
	{ Item="xcl_element_ghost_globe", ReqItem={"xcl_element_ghost_silk", "xcl_element_ghost_dust", "xcl_element_ghost_gem"}},
	{ Item="xcl_element_grass_gem", ReqItem={"xcl_element_grass_silk","xcl_element_grass_dust"}},
	{ Item="xcl_element_grass_globe", ReqItem={"xcl_element_grass_silk", "xcl_element_grass_dust", "xcl_element_grass_gem"}},
	{ Item="xcl_element_ground_gem", ReqItem={"xcl_element_ground_silk","xcl_element_ground_dust"}},
	{ Item="xcl_element_ground_globe", ReqItem={"xcl_element_ground_silk", "xcl_element_ground_dust", "xcl_element_ground_gem"}},
	{ Item="xcl_element_ice_gem", ReqItem={"xcl_element_ice_silk","xcl_element_ice_dust"}},
	{ Item="xcl_element_ice_globe", ReqItem={"xcl_element_ice_silk", "xcl_element_ice_dust", "xcl_element_ice_gem"}},
	{ Item="xcl_element_normal_gem", ReqItem={"xcl_element_normal_silk","xcl_element_normal_dust"}},
	{ Item="xcl_element_normal_globe", ReqItem={"xcl_element_normal_silk", "xcl_element_normal_dust", "xcl_element_normal_gem"}},
	{ Item="xcl_element_poison_gem", ReqItem={"xcl_element_poison_silk","xcl_element_poison_dust"}},
	{ Item="xcl_element_poison_globe", ReqItem={"xcl_element_poison_silk", "xcl_element_poison_dust", "xcl_element_poison_gem"}},
	{ Item="xcl_element_psychic_gem", ReqItem={"xcl_element_psychic_silk","xcl_element_psychic_dust"}},
	{ Item="xcl_element_psychic_globe", ReqItem={"xcl_element_psychic_silk", "xcl_element_psychic_dust", "xcl_element_psychic_gem"}},
	{ Item="xcl_element_rock_gem", ReqItem={"xcl_element_rock_silk","xcl_element_rock_dust"}},
	{ Item="xcl_element_rock_globe", ReqItem={"xcl_element_rock_silk", "xcl_element_rock_dust", "xcl_element_rock_gem"}},
	{ Item="xcl_element_steel_gem", ReqItem={"xcl_element_steel_silk","xcl_element_steel_dust"}},
	{ Item="xcl_element_steel_globe", ReqItem={"xcl_element_steel_silk", "xcl_element_steel_dust", "xcl_element_steel_gem"}},
	{ Item="xcl_element_water_gem", ReqItem={"xcl_element_water_silk","xcl_element_water_dust"}},
	{ Item="xcl_element_water_globe", ReqItem={"xcl_element_water_silk", "xcl_element_water_dust", "xcl_element_water_gem"}}
}
  
  local state = 0
  local repeated = false
  local cart = {} --catalog element chosen to trade for
  local tribute = {} --item IDs chosen to trade in
  
  --normal trades
  for ii = 1, #COMMON_GEN.TRADES, 1 do
	local base_data = COMMON_GEN.TRADES[ii]
	table.insert(catalog, base_data)
  end
  
  --random trades
  for ii = 1, #SV.base_trades, 1 do
	local base_data = SV.base_trades[ii]
	table.insert(catalog, base_data)
  end
  
  local Prices = { 1000, 5000, 20000, 50000, 100000 }
  local player = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Swap_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(player, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)
		
  GROUND:CharTurnToChar(player, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Swap_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Swap_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Swap_Option_Swap']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Choose']))
				state = 1
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_003']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			--only show the items that can be swapped for, checking inv, held, and storage
			--allow trade from storage, and find a way around multi-select for storage.
			UI:SwapMenu(catalog, Prices)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local free_slots = 0
			tribute = {}
			for ii = 1, #trade.ReqItem, 1 do
				if trade.ReqItem[ii] == "" then
					free_slots = free_slots + 1
				else
					table.insert(tribute, trade.ReqItem[ii])
				end
			end
			
			if free_slots > 0 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Give_Choose'], receive_item:GetDisplayName()))
				--tribute simply aggregates all items period
				--this means that choosing multiple of one item will be impossible
				--must choose all DIFFERENT specific items
				UI:TributeMenu(free_slots)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if #result > 0 then
					for ii = 1, #result, 1 do
						table.insert(tribute, result[ii])
					end
					state = 3
				else
					state = 0
				end
			else
				state = 3
			end
		elseif state == 3 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local give_items = {}
			for ii = 1, #tribute, 1 do
				local give_item = RogueEssence.Dungeon.InvItem(tribute[ii])
				table.insert(give_items, give_item:GetDisplayName())
			end
			
			local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(trade.Item)
			local total = Prices[itemEntry.Rarity]
			
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Confirm_001'], STRINGS:CreateList(give_items), receive_item:GetDisplayName()))
			UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Swap_Confirm_002'], total), false)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if result then
				for ii = #tribute, 1, -1 do
					local item_slot = GAME:FindPlayerItem(tribute[ii], true, true)
					if not item_slot:IsValid() then
						--it is a certainty that there is an item in storage, due to previous checks
						GAME:TakePlayerStorageItem(tribute[ii])
					elseif item_slot.IsEquipped then
						GAME:TakePlayerEquippedItem(item_slot.Slot)
					else
						GAME:TakePlayerBagItem(item_slot.Slot)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:RemoveFromPlayerMoney(total)
				
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Complete_001']))
				UI:SetSpeakerEmotion("Stunned")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Complete_002']))
				UI:SetSpeakerEmotion("Normal")
				
				UI:ResetSpeaker()
				SOUND:PlayFanfare("Fanfare/Treasure")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Give'], player:GetDisplayName(), receive_item:GetDisplayName()))
				
				--local bag_count = GAME:GetPlayerBagCount()
				--local bag_cap = GAME:GetPlayerBagLimit()
				--if bag_count < bag_cap then
				--	GAME:GivePlayerItem(trade.Item, 1)
				--else--TODO: load universal strings alongside local strings
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Item_Give_Storage'], receive_item:GetDisplayName()))
				GAME:GivePlayerStorageItem(trade.Item, 1)
				--end
				
				UI:SetSpeaker(chara)
				tribute = {}
				cart = {}
				state = 0
			else
				state = 1
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(player)
	GROUND:CharEndAnim(chara)
end

function metano_town.Tutor_Sequence(member, moveEntry)
	--Does the animation + flash whenever slowpoke helps you remember/forget a move
	local chara = CH('Tutor_Owner')
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "Strike", false)
	GAME:WaitFrames(15)
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
	emitter.HoldTime = 4
	emitter.FadeOutTime = 2
	emitter.StartColor = Color(0, 0, 0, 0)
	emitter.Layer = DrawLayer.Top
	emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
	GROUND:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "None", true)
	GAME:WaitFrames(30)
end

function metano_town.Tutor_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local price = 0
  local state = 0
  local repeated = false
  local member = nil
  local move = ""
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Tutor_Owner')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)
		
  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Tutor_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Tutor_Intro_Return'])
			end
			
			local tutor_choices = {RogueEssence.StringKey("MENU_RECALL_SKILL"):ToLocal(),
			RogueEssence.StringKey("MENU_FORGET_SKILL"):ToLocal(),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, tutor_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if price > GAME:GetPlayerMoney() then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_No_Money']))
				else
					state = 1
				end
			elseif result == 2 then
				state = 4
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_003']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				state = 2
				member = GAME:GetPlayerPartyMember(result)
			else
				state = 0
			end
		elseif state == 2 then
			if not GAME:CanRelearn(member) then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Cant_Remember']))
				state = 1
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_What'], member.BaseName))
				UI:RelearnMenu(member)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result > -1 then
					move = result
					state = 3
				else
					state = 1
				end
			end
		elseif state == 3 then
			local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
			if GAME:CanLearn(member) then
				--SOUND:PlayBattleSE("DUN_Money") price was removed so no money sound
				GAME:RemoveFromPlayerMoney(price)
				GAME:LearnSkill(member, move)
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Begin']))
				metano_town.Tutor_Sequence()	
				SOUND:PlayBattleSE("DUN_Learn_Move")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Success'], member.BaseName, moveEntry.Name:ToLocal()))				state = 0
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Replace']))
				local result = UI:LearnMenu(member, move)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result > -1 and result < 4 then
					--SOUND:PlayBattleSE("DUN_Money") price was removed so no money sound
					GAME:RemoveFromPlayerMoney(price)
					GAME:SetCharacterSkill(member, move, result)
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Begin']))
					metano_town.Tutor_Sequence()	
					SOUND:PlayBattleSE("DUN_Learn_Move")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Success'], member.BaseName, moveEntry.Name:ToLocal()))					state = 0
				else
					state = 2
				end
			end
		elseif state == 4 then
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				member = GAME:GetPlayerPartyMember(result)
				if not GAME:CanForget(member) then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Cant_Forget']))
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_What'], member.BaseName))
					state = 5
				end
			else
				state = 0
			end
		elseif state == 5 then
			local result = UI:ForgetMenu(member)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Begin']))
				metano_town.Tutor_Sequence()
				move = GAME:GetCharacterSkill(member, result)
				local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
				GAME:ForgetSkill(member, result)
				SOUND:PlayBattleSE("DUN_Learn_Move")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Success'], member.BaseName, moveEntry.Name:ToLocal()))
				state = 0
			else
				state = 4
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end



function metano_town.Appraisal_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local state = 0
  local repeated = false
  local cart = {}
  local price = 150
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local chara = CH('Appraisal')
  chara.IsInteracting = true
  partner.IsInteracting = true
  UI:SetSpeaker(chara)
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  GROUND:CharSetAnim(chara, 'None', true)
		
  GROUND:CharTurnToChar(hero, chara)
  local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
  UI:SetSpeaker(chara)
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Appraisal_Intro'], STRINGS:FormatKey("MONEY_AMOUNT", price))
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Appraisal_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Appraisal_Option_Open']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				if bag_count > 0 then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Choose'], "A"))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Bag_Empty']))
				end
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_004'], STRINGS:FormatKey("MONEY_AMOUNT", price)))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:AppraiseMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if #result > 0 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local total = #cart * price
			
			if total > GAME:GetPlayerMoney() then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_No_Money']))
				state = 1
			else
				local msg
				if #cart == 1 then
					local item
					if cart[1].IsEquipped then
						item = GAME:GetPlayerEquippedItem(cart[1].Slot)
					else
						item = GAME:GetPlayerBagItem(cart[1].Slot)
					end
					msg = STRINGS:Format(MapStrings['Appraisal_Choose_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), item:GetDisplayName())
				else
					msg = STRINGS:Format(MapStrings['Appraisal_Choose_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				local treasure = {}
				if result then
					for ii = #cart, 1, -1 do
						local box = nil
						local stack = 0
						if cart[ii].IsEquipped then
							box = GAME:GetPlayerEquippedItem(cart[ii].Slot)
							GAME:TakePlayerEquippedItem(cart[ii].Slot)
						else
							box = GAME:GetPlayerBagItem(cart[ii].Slot)
							GAME:TakePlayerBagItem(cart[ii].Slot)
						end
						
						local itemEntry = _DATA:GetItem(box.HiddenValue)
						local treasure_choice = { Box = box, Item = RogueEssence.Dungeon.InvItem(box.HiddenValue,false,itemEntry.MaxStack)}
						table.insert(treasure, treasure_choice)
						
						-- note high rarity items
						if itemEntry.Rarity > 0 then
							SV.unlocked_trades[box.HiddenValue] = true
						end
					end
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(total)
					cart = {}
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Start']))
					
					GROUND:MoveInDirection(chara, Direction.Up, 18, false, 2)
					GROUND:Hide("Appraisal_Owner")
					GAME:WaitFrames(10)
					local shake = RogueEssence.Content.ScreenMover(0, 8, 30)
					GROUND:MoveScreen(shake)
					SOUND:PlayBattleSE("DUN_Explosion")
					GAME:WaitFrames(60)
					GROUND:Unhide("Appraisal_Owner")
					GROUND:MoveInDirection(chara, Direction.Down, 18, false, 2)
					
					SOUND:PlayFanfare("Fanfare/Treasure")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_End']))
					UI:SpoilsMenu(treasure)
					UI:WaitForChoice()
					
					for ii = 1, #treasure, 1 do
						local item = treasure[ii].Item
						
						GAME:GivePlayerItem(item.ID, item.Amount, false, item.HiddenValue)
					end
					
					state = 0
				else
					state = 1
				end
			end
		end
	end
	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	chara.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(chara)
end





---------------------------------
-- Event Trigger
-- These are temporary objects created by a script used to trigger events that only happen
-- at certain plot progressions, typically a cutscene of sorts for a particular chapter.

-- The same event trigger won't be used for two different purposes within the same chapter.
-- if Event Trigger 1 is used to block a specific exit, it won't ever be used for another purpose within that same chapter.
---------------------------------
function metano_town.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_2_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_2_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_3_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_3_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_4_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_4_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_5_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_5_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_6_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_6_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_7_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_7_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_8_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_8_Touch(...,...)"), obj, activator))
end

function metano_town.Event_Trigger_9_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_9_Touch(...,...)"), obj, activator))
end

--------------------
-- Town NPCs
--------------------

--[[
Generic town NPCs to be handled on a per chapter basis, as what they say and do will change between chapters.
The list of non-shop NPCs that live in the town are:

Floatzel (Tweed)
Quagsire
Wooper Boy (Dee)
Wooper Girl (Dun)

???
Manetric
Electrike

Machamp
Medicham
Meditite

Camerupt (Single Mother)
Numel

Vileplume
Bellossom
Gloom
Oddish

???
???
???

Sunflora (Cave Hermit)

Azumarill (Loaf) lives in a tent

Mawile (Bria) lives in a tent

Lickitung ( Urgil  , cafe goer)
Gulpin ( Boosmu  , cafe goer)
???
???
???

]]--

function metano_town.Luxray_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Luxray_Action(...,...)"), obj, activator))
end

function metano_town.Electrike_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Electrike_Action(...,...)"), obj, activator))
end

function metano_town.Manectric_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Manectric_Action(...,...)"), obj, activator))
end

function metano_town.Bellossom_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Bellossom_Action(...,...)"), obj, activator))
end

function metano_town.Vileplume_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Vileplume_Action(...,...)"), obj, activator))
end

function metano_town.Gloom_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gloom_Action(...,...)"), obj, activator))
end

function metano_town.Oddish_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Oddish_Action(...,...)"), obj, activator))
end

function metano_town.Numel_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Numel_Action(...,...)"), obj, activator))
end

function metano_town.Camerupt_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Camerupt_Action(...,...)"), obj, activator))
end

function metano_town.Machamp_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Machamp_Action(...,...)"), obj, activator))
end

function metano_town.Meditite_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Meditite_Action(...,...)"), obj, activator))
end

function metano_town.Medicham_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Medicham_Action(...,...)"), obj, activator))
end

function metano_town.Furret_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Furret_Action(...,...)"), obj, activator))
end

function metano_town.Linoone_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Linoone_Action(...,...)"), obj, activator))
end

function metano_town.Sentret_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Sentret_Action(...,...)"), obj, activator))
end

function metano_town.Wooper_Girl_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Girl_Action(...,...)"), obj, activator))
end

function metano_town.Wooper_Boy_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Wooper_Boy_Action(...,...)"), obj, activator))
end

function metano_town.Floatzel_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Floatzel_Action(...,...)"), obj, activator))
end

function metano_town.Quagsire_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Quagsire_Action(...,...)"), obj, activator))
end

function metano_town.Nidorina_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidorina_Action(...,...)"), obj, activator))
end

function metano_town.Nidoran_Male_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoran_Male_Action(...,...)"), obj, activator))
end

function metano_town.Nidoking_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoking_Action(...,...)"), obj, activator))
end

function metano_town.Nidoqueen_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Nidoqueen_Action(...,...)"), obj, activator))
end

function metano_town.Mawile_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mawile_Action(...,...)"), obj, activator))
end

function metano_town.Azumarill_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Azumarill_Action(...,...)"), obj, activator))
end



function metano_town.Gulpin_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gulpin_Action(...,...)"), obj, activator))
end

function metano_town.Lickitung_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Lickitung_Action(...,...)"), obj, activator))
end


function metano_town.Roselia_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Roselia_Action(...,...)"), obj, activator))
end

function metano_town.Spinda_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Spinda_Action(...,...)"), obj, activator))
end

function metano_town.Ludicolo_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Ludicolo_Action(...,...)"), obj, activator))
end

function metano_town.Jigglypuff_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Jigglypuff_Action(...,...)"), obj, activator))
end

function metano_town.Marill_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Marill_Action(...,...)"), obj, activator))
end

function metano_town.Spheal_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Spheal_Action(...,...)"), obj, activator))
end




function metano_town.Mareep_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), obj, activator))
end

function metano_town.Cranidos_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), obj, activator))
end


function metano_town.Growlithe_Desk_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Growlithe_Desk_Action(...,...)"), obj, activator))
end






------------------------------
--Signposts, other objects
------------------------------


function metano_town.Guild_Bridge_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Guild_Bridge_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end


function metano_town.Crossroads_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Crossroads_1']))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Crossroads_2']))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Crossroads_3']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end

function metano_town.Dojo_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Dojo_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end

function metano_town.To_Dungeons_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_To_Dungeons_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end

function metano_town.Wishing_Well_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_Wishing_Well_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end

function metano_town.To_Spring_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sign_To_Spring_1']))
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end

function metano_town.Postboard_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:SetCenter(true)  
  UI:WaitShowDialogue("There's nothing here right now.\nCome back again another time!")
  UI:SetAutoFinish(false)
  UI:SetCenter(false)
end
--Change this to a little cutscene like how chimecho comes out to see you? Whoever ends up running the assmebly should come out to see you
function metano_town.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  COMMON.ShowTeamAssemblyMenu(COMMON.RespawnAllies)
end

function metano_town.Well_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Would you like to throw a " .. STRINGS:Format("\\uE024") .. " in?")
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result then 
	  local money = GAME:GetPlayerMoney()
	  if money < 1 then 
		UI:WaitShowDialogue("You don't have any money!")
	  else 
		GAME:RemoveFromPlayerMoney(1)
		SOUND:PlayBattleSE("_UNK_DUN_Water_Drop")
		UI:WaitShowDialogue("You threw a " .. STRINGS:Format("\\uE024") .. " into the well!\nMay good luck come your way!")
	  end
   end 
   UI:SetCenter(false)
end   
   
return metano_town
