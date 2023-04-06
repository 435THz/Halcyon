require 'common'
require 'GeneralFunctions'

--Halcyon Custom work:
--Code in this folder is used to generate, display, and handle randomized missions
--and all that goes with that (rewards, rankups, etc)


--A job is saved as a list of variables, where each variable represents an attribute of the job, such as reward, client, destination floor, etc.
--There are 3 sets of lua lists then. One for the missions taken, one for the missions on the job board, and one for the missions on the outlaw board.
--Each of those lists can only have up to 8 jobs.

--List of mission attributes:
--Client (the pokemon in need of escort, rescue, or the person asking for an outlaw capture). Given as species string
--Target (Pokemon in need of rescue, or the one to escort to, or the mon to be arrested). Given as species string
--Escort Species - should be given as a blank if this is not an escort mission.
--Zone (dungeon)
--Segment (part of the dungeon) - this is typically the default segment
--Floor 
--Reward - given as item name's string. If money, should be given as "Money" and the amount will be based off the difficulty.
--Mission Type - outlaw, escort, or rescue
--Completion status - Incomplete or Complete. When a reward is handed out at the end of the day, any missions that are completed should be removed from the taken board.
--Taken - Was the mission on the board taken? This is also used to suspend missions that were taken off the board
--Difficulty - Letter rank that are hardcoded to represent certain number amounts
--Flavor - Flavor text for the mission, should be a string in strings.resx that can potentially be filled in by blanks.


--Hardcoded number values. Adjust those sorts of things here.
--Difficulty's point ranks
MISSION_GEN = {}

MISSION_GEN.DIFFICULTY = {}
MISSION_GEN.DIFFICULTY[""] = 0
MISSION_GEN.DIFFICULTY["F"] = 0
MISSION_GEN.DIFFICULTY["E"] = 10
MISSION_GEN.DIFFICULTY["D"] = 15
MISSION_GEN.DIFFICULTY["C"] = 20
MISSION_GEN.DIFFICULTY["B"] = 30
MISSION_GEN.DIFFICULTY["A"] = 50
MISSION_GEN.DIFFICULTY["S"] = 70

--dungeon's assigned difficulty
MISSION_GEN.DUNGEON_DIFFICULTY = {}
MISSION_GEN.DUNGEON_DIFFICULTY[""] = "F"--just in case lul
MISSION_GEN.DUNGEON_DIFFICULTY["relic_forest"] = "E"--missions shouldn't be given for relic forest 
MISSION_GEN.DUNGEON_DIFFICULTY["illuminant_riverbed"] = "D"
MISSION_GEN.DUNGEON_DIFFICULTY["crooked_cavern"] = "C"


--order of difficulties. 
MISSION_GEN.DIFF_TO_ORDER = {}
MISSION_GEN.DIFF_TO_ORDER[""] = 1
MISSION_GEN.DIFF_TO_ORDER["F"] = 2
MISSION_GEN.DIFF_TO_ORDER["E"] = 3
MISSION_GEN.DIFF_TO_ORDER["D"] = 4
MISSION_GEN.DIFF_TO_ORDER["C"] = 5
MISSION_GEN.DIFF_TO_ORDER["B"] = 6
MISSION_GEN.DIFF_TO_ORDER["A"] = 7
MISSION_GEN.DIFF_TO_ORDER["S"] = 8

--use this to get back from above.
MISSION_GEN.ORDER_TO_DIFF = {"", "F", "E", "D", "C", "B", "A", "S"}

--mapping of difficulty to reward amounts for money
MISSION_GEN.DIFF_TO_MONEY = {}
MISSION_GEN.DIFF_TO_MONEY[""] = 0
MISSION_GEN.DIFF_TO_MONEY["F"] = 0
MISSION_GEN.DIFF_TO_MONEY["E"] = 100
MISSION_GEN.DIFF_TO_MONEY["D"] = 150
MISSION_GEN.DIFF_TO_MONEY["C"] = 200
MISSION_GEN.DIFF_TO_MONEY["B"] = 250
MISSION_GEN.DIFF_TO_MONEY["A"] = 300
MISSION_GEN.DIFF_TO_MONEY["S"] = 350

MISSION_GEN.COMPLETE = 1
MISSION_GEN.INCOMPLETE = 0

MISSION_GEN.EXPECTED_LEVEL = {}
MISSION_GEN.EXPECTED_LEVEL["illuminant_riverbed"] = 8
MISSION_GEN.EXPECTED_LEVEL["crooked_cavern"] = 10


MISSION_GEN.TITLES =  {
	RESCUE_SELF = {
		"MISSION_TITLE_RESCUE_SELF_001",
		"MISSION_TITLE_RESCUE_SELF_002",
		"MISSION_TITLE_RESCUE_SELF_003",
		"MISSION_TITLE_RESCUE_SELF_004",
		"MISSION_TITLE_RESCUE_SELF_005",
		"MISSION_TITLE_RESCUE_SELF_006",
		"MISSION_TITLE_RESCUE_SELF_007",
		"MISSION_TITLE_RESCUE_SELF_008",
		"MISSION_TITLE_RESCUE_SELF_009",
		"MISSION_TITLE_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_TITLE_RESCUE_FRIEND_001",
		"MISSION_TITLE_RESCUE_FRIEND_002",
		"MISSION_TITLE_RESCUE_FRIEND_003",
		"MISSION_TITLE_RESCUE_FRIEND_004",
		"MISSION_TITLE_RESCUE_FRIEND_005",
		"MISSION_TITLE_RESCUE_FRIEND_006",
		"MISSION_TITLE_RESCUE_FRIEND_007",
		"MISSION_TITLE_RESCUE_FRIEND_008",
		"MISSION_TITLE_RESCUE_FRIEND_009",
		"MISSION_TITLE_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_TITLE_ESCORT_001",
		"MISSION_TITLE_ESCORT_002",
		"MISSION_TITLE_ESCORT_003",
		"MISSION_TITLE_ESCORT_004",
		"MISSION_TITLE_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_TITLE_EXPLORATION_001",
		"MISSION_TITLE_EXPLORATION_002",
		"MISSION_TITLE_EXPLORATION_003",
		"MISSION_TITLE_EXPLORATION_004",
		"MISSION_TITLE_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_TITLE_DELIVERY_001",
		"MISSION_TITLE_DELIVERY_002",
		"MISSION_TITLE_DELIVERY_003",
		"MISSION_TITLE_DELIVERY_004",
		"MISSION_TITLE_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_TITLE_LOST_ITEM_001",
		"MISSION_TITLE_LOST_ITEM_002",
		"MISSION_TITLE_LOST_ITEM_003",
		"MISSION_TITLE_LOST_ITEM_004",
		"MISSION_TITLE_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_TITLE_OUTLAW_001",
		"MISSION_TITLE_OUTLAW_002",
		"MISSION_TITLE_OUTLAW_003",
		"MISSION_TITLE_OUTLAW_004",
		"MISSION_TITLE_OUTLAW_005",
		"MISSION_TITLE_OUTLAW_006",
		"MISSION_TITLE_OUTLAW_007",
		"MISSION_TITLE_OUTLAW_008",
		"MISSION_TITLE_OUTLAW_009",
		"MISSION_TITLE_OUTLAW_010",
	},
	OUTLAW_ITEM = {
		"MISSION_TITLE_OUTLAW_ITEM_001",
		"MISSION_TITLE_OUTLAW_ITEM_002",
		"MISSION_TITLE_OUTLAW_ITEM_003",
		"MISSION_TITLE_OUTLAW_ITEM_004",
		"MISSION_TITLE_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_TITLE_OUTLAW_FLEE_001",
		"MISSION_TITLE_OUTLAW_FLEE_002",
		"MISSION_TITLE_OUTLAW_FLEE_003",
		"MISSION_TITLE_OUTLAW_FLEE_004",
		"MISSION_TITLE_OUTLAW_FLEE_005"
	}
}

MISSION_GEN.FLAVOR_TOP =  {
	RESCUE_SELF = {
		"MISSION_BODY_TOP_RESCUE_SELF_001",
		"MISSION_BODY_TOP_RESCUE_SELF_002",
		"MISSION_BODY_TOP_RESCUE_SELF_003",
		"MISSION_BODY_TOP_RESCUE_SELF_004",
		"MISSION_BODY_TOP_RESCUE_SELF_005",
		"MISSION_BODY_TOP_RESCUE_SELF_006",
		"MISSION_BODY_TOP_RESCUE_SELF_007",
		"MISSION_BODY_TOP_RESCUE_SELF_008",
		"MISSION_BODY_TOP_RESCUE_SELF_009",
		"MISSION_BODY_TOP_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_BODY_TOP_RESCUE_FRIEND_001",
		"MISSION_BODY_TOP_RESCUE_FRIEND_002",
		"MISSION_BODY_TOP_RESCUE_FRIEND_003",
		"MISSION_BODY_TOP_RESCUE_FRIEND_004",
		"MISSION_BODY_TOP_RESCUE_FRIEND_005",
		"MISSION_BODY_TOP_RESCUE_FRIEND_006",
		"MISSION_BODY_TOP_RESCUE_FRIEND_007",
		"MISSION_BODY_TOP_RESCUE_FRIEND_008",
		"MISSION_BODY_TOP_RESCUE_FRIEND_009",
		"MISSION_BODY_TOP_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_BODY_TOP_ESCORT_001",
		"MISSION_BODY_TOP_ESCORT_002",
		"MISSION_BODY_TOP_ESCORT_003",
		"MISSION_BODY_TOP_ESCORT_004",
		"MISSION_BODY_TOP_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_BODY_TOP_EXPLORATION_001",
		"MISSION_BODY_TOP_EXPLORATION_002",
		"MISSION_BODY_TOP_EXPLORATION_003",
		"MISSION_BODY_TOP_EXPLORATION_004",
		"MISSION_BODY_TOP_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_BODY_TOP_DELIVERY_001",
		"MISSION_BODY_TOP_DELIVERY_002",
		"MISSION_BODY_TOP_DELIVERY_003",
		"MISSION_BODY_TOP_DELIVERY_004",
		"MISSION_BODY_TOP_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_BODY_TOP_LOST_ITEM_001",
		"MISSION_BODY_TOP_LOST_ITEM_002",
		"MISSION_BODY_TOP_LOST_ITEM_003",
		"MISSION_BODY_TOP_LOST_ITEM_004",
		"MISSION_BODY_TOP_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_BODY_TOP_OUTLAW_001",
		"MISSION_BODY_TOP_OUTLAW_002",
		"MISSION_BODY_TOP_OUTLAW_003",
		"MISSION_BODY_TOP_OUTLAW_004",
		"MISSION_BODY_TOP_OUTLAW_005",
		"MISSION_BODY_TOP_OUTLAW_006",
		"MISSION_BODY_TOP_OUTLAW_007",
		"MISSION_BODY_TOP_OUTLAW_008",
		"MISSION_BODY_TOP_OUTLAW_009",
		"MISSION_BODY_TOP_OUTLAW_010"
	},
	OUTLAW_ITEM = {
		"MISSION_BODY_TOP_OUTLAW_ITEM_001",
		"MISSION_BODY_TOP_OUTLAW_ITEM_002",
		"MISSION_BODY_TOP_OUTLAW_ITEM_003",
		"MISSION_BODY_TOP_OUTLAW_ITEM_004",
		"MISSION_BODY_TOP_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_BODY_TOP_OUTLAW_FLEE_001",
		"MISSION_BODY_TOP_OUTLAW_FLEE_002",
		"MISSION_BODY_TOP_OUTLAW_FLEE_003",
		"MISSION_BODY_TOP_OUTLAW_FLEE_004",
		"MISSION_BODY_TOP_OUTLAW_FLEE_005"
	}
}

MISSION_GEN.FLAVOR_BOTTOM =  {
	RESCUE_SELF = {
		"MISSION_BODY_BOTTOM_RESCUE_SELF_001",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_002",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_003",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_004",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_005",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_006",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_007",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_008",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_009",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_001",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_002",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_003",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_004",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_005",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_006",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_007",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_008",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_009",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_BODY_BOTTOM_ESCORT_001",
		"MISSION_BODY_BOTTOM_ESCORT_002",
		"MISSION_BODY_BOTTOM_ESCORT_003",
		"MISSION_BODY_BOTTOM_ESCORT_004",
		"MISSION_BODY_BOTTOM_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_BODY_BOTTOM_EXPLORATION_001",
		"MISSION_BODY_BOTTOM_EXPLORATION_002",
		"MISSION_BODY_BOTTOM_EXPLORATION_003",
		"MISSION_BODY_BOTTOM_EXPLORATION_004",
		"MISSION_BODY_BOTTOM_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_BODY_BOTTOM_DELIVERY_001",
		"MISSION_BODY_BOTTOM_DELIVERY_002",
		"MISSION_BODY_BOTTOM_DELIVERY_003",
		"MISSION_BODY_BOTTOM_DELIVERY_004",
		"MISSION_BODY_BOTTOM_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_BODY_BOTTOM_LOST_ITEM_001",
		"MISSION_BODY_BOTTOM_LOST_ITEM_002",
		"MISSION_BODY_BOTTOM_LOST_ITEM_003",
		"MISSION_BODY_BOTTOM_LOST_ITEM_004",
		"MISSION_BODY_BOTTOM_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_BODY_BOTTOM_OUTLAW_001",
		"MISSION_BODY_BOTTOM_OUTLAW_002",
		"MISSION_BODY_BOTTOM_OUTLAW_003",
		"MISSION_BODY_BOTTOM_OUTLAW_004",
		"MISSION_BODY_BOTTOM_OUTLAW_005"
	},
	OUTLAW_ITEM = {
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_001",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_002",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_003",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_004",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_001",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_002",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_003",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_004",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_005"
	}
}
--master pokemon list
--This is a list of all Released Pokemon, minus ones who are in the same evolutionary family as a named character in the game,
--starters, legendaries, and a few other "special" mons (unown for example)
MISSION_GEN.MASTER_POKEMON_LIST = 
{"abra","absol","aerodactyl","aipom","alakazam","alcremie","altaria","amaura","anorith","appletun","applin","arbok","archen","ariados","armaldo","aron","arrokuda","aurorus","axew",
"baltoy","banette","barboach","bastiodon","beedrill","beldum","bellsprout","bibarel","bidoof","blissey","bonsly","bounsweet","bronzong","bronzor","buneary","burmy",
"carnivine","carvanha","cascoon","castform","chandelure","chansey","chatot","cherrim","cherubi","chimecho","chinchou","chingling","clamperl","claydol","clobbopus","cloyster","combee","corphish","corsola","corviknight","cradily","cramorant","crawdaunt","croagunk","crobat","cubchoo","cursola","cutiefly",
"deerling","deino","delibird","dewgong","diglett","ditto","donphan","dragonair","dragonite","drampa","drapion","dratini","drifblim","drifloon","drowzee","dugtrio","dunsparce","duosion","dusclops","dusknoir","duskull","dustox",
"ekans","electabuzz","electivire","electrode","elekid","emolga","espurr","exeggcute","exeggutor","exploud",
"fearow","feebas","finneon","flabebe","floette","florges","flygon","fomantis","forretress","froslass",
"gallade","galvantula","gardevoir","gastly","gastrodon","gengar","geodude","glalie","gligar","gliscor","golbat","goldeen","golduck","golem","golisopod","golurk","goomy","gorebyss","gothita","gothitelle","gothorita","gourgeist","graveler","grimer","grumpig","gyarados",
"happiny","hariyama","hatenna","hatterene","hattrem","haunter","helioptile","heracross","hippopotas","hippowdon","hitmonchan","hitmonlee","hitmontop","honedge","hoppip","horsea","houndoom","houndour","huntail","hypno",
"illumise","indeedee",
"jangmo_o","joltik","jumpluff","jynx",
"kabuto","kabutops","kadabra","kakuna","kingdra","kingler","kirlia","koffing","krabby","kricketot","kricketune",
"lampent","lanturn","lapras","larvitar","leavanny","lileep","lillipup","litwick","lopunny","loudred","lumineon","lunatone","luvdisc",
"magby","magcargo","magikarp","magmar","magmortar","magnemite","magneton","magnezone","makuhita","mamoswine","mandibuzz","mankey","mantine","mantyke","maractus","mareanie","masquerain","meowstic","metagross","metang","mienfoo","mightyena","milotic","miltank","mime_jr","minccino","minior","minun","misdreavus","mismagius","morgrem","mothim","mr_mime","muk",
"natu","nincada","ninjask","noibat","noivern","nosepass","nuzleaf",
"octillery","omanyte","omastar","onix",
"pachirisu","paras","parasect","phantump","pidgeot","pidgeotto","pidgey","pidove","piloswine","pineco","pinsir","plusle","politoed","poliwag","poliwhirl","poliwrath","ponyta","poochyena","porygon","porygon_z","porygon2","primeape","probopass","psyduck","pumpkaboo","pupitar","purrloin","purugly",
"qwilfish",
"ralts","rapidash","raticate","rattata","remoraid","rhydon","rhyhorn","rhyperior","ribombee","roggenrola",
"sableye","salandit","salazzle","sandshrew","sandslash","sandygast","sawsbuck","scizor","scrafty","scyther","seadra","seaking","seedot","seel","sewaddle","sharpedo","shedinja","shellder","shellos","shieldon","shiftry","shuppet","sinistea","skarmory","skiploom","skorupi","skuntank","slaking","slakoth","slugma","smeargle","smoochum","snorunt","snover","solrock","spearow","spinarak","spiritomb","spoink","stantler","staraptor","staravia","starly","starmie","staryu","steelix","steenee","stoutland","sudowoodo","surskit","swablu","swellow","swinub","swirlix","swoobat",
"taillow","tangela","tangrowth","tauros","teddiursa","tentacool","tentacruel","thievul","togedemaru","togekiss","togepi","togetic","torkoal","toxicroak","trapinch","trubbish","tsareena","tympole","tyranitar","tyrogue",
"ursaring",
"vanillish","vanillite","venomoth","venonat","vespiquen","vibrava","victreebel","vigoroth","volbeat","voltorb",
"wailmer","wailord","weedle","weepinbell","weezing","whimsicott","whiscash","whismur","wobbuffet","woobat","wooloo","wormadam","wynaut",
"xatu",
"yanma","yanmega",
"zubat"}

MISSION_GEN.POKEMON = {
	--weak mons for easy missions
	TIER_LOW = 
	{"abra","amaura","anorith","applin","archen","aron","arrokuda","axew",
	"baltoy","barboach","beldum","bellsprout","bidoof","bonsly","bounsweet","bronzor","buneary","burmy",
	"carvanha","cascoon","cherubi","chinchou","chingling","clamperl","clobbopus","combee","corphish","croagunk","cubchoo","cutiefly",
	"deerling","deino","diglett","dratini","drifloon","drowzee","duskull",
	"ekans","elekid","espurr","exeggcute",
	"feebas","finneon","flabebe","fomantis",
	"gastly","geodude","goldeen","goomy","gothita","grimer",
	"happiny","hatenna","helioptile","hippopotas","honedge","hoppip","horsea","houndour",

	"jangmo_o","joltik",
	"kabuto","kakuna","koffing","krabby","kricketot",
	"larvitar","lileep","lillipup","litwick","luvdisc",
	"magby","magikarp","magnemite","makuhita","mankey","mantyke","mareanie","mienfoo","mime_jr","minccino",
	"natu","nincada","noibat","nosepass",
	"omanyte","onix",
	"paras","phantump","pidgey","pidove","pineco","poliwag","ponyta","poochyena","porygon","psyduck","pumpkaboo","purrloin",

	"ralts","rattata","remoraid","rhyhorn","roggenrola",
	"salandit","sandshrew","sandygast","seedot","seel","sewaddle","shellder","shellos","shieldon","shuppet","sinistea","skorupi","slakoth","slugma","smoochum","snorunt","snover","spearow","spinarak","spoink","starly","staryu","surskit","swablu","swinub","swirlix",
	"taillow","teddiursa","tentacool","togepi","trapinch","trubbish","tympole","tyrogue",

	"vanillite","venonat","voltorb",
	"wailmer","weedle","whismur","woobat","wooloo","wynaut",


	"zubat"},

	--middling mons for medium missions
	TIER_MID = 
	{"aipom","arbok","ariados",
	"beedrill","bibarel",
	"carnivine","castform","chansey","chatot","cherrim","chimecho","corsola","cramorant",
	"delibird","ditto","dragonair","dunsparce","duosion","dustox",
	"electabuzz","emolga",
	"floette",
	"gligar","golbat","gothorita","graveler",
	"hattrem","haunter",
	"illumise","indeedee",
	"jynx",
	"kadabra","kirlia","kricketune",
	"lampent","loudred","lunatone",
	"magmar","magneton","maractus","masquerain","metang","mightyena","miltank","minior","minun","misdreavus","morgrem","mothim","mr_mime",
	"ninjask","nuzleaf",

	"pachirisu","parasect","pidgeotto","piloswine","plusle","poliwhirl","porygon2","pupitar",
	"qwilfish",
	"raticate","ribombee",
	"sableye","scyther","seadra","shedinja","skiploom","smeargle","solrock","stantler","staravia","steenee","sudowoodo",
	"tangela","thievul","togedemaru","togetic","torkoal",

	"vanillish","venomoth","vespiquen","vibrava","vigoroth","volbeat",
	"weepinbell","wobbuffet","wormadam",

	"yanma"
	},

	--strong pokemon for difficult missions
	TIER_HIGH = 
	{"absol","aerodactyl","alakazam","alcremie","altaria","appletun","armaldo","aurorus",
	"banette","bastiodon","blissey","bronzong",
	"chandelure","claydol","cloyster","corviknight","cradily","crawdaunt","crobat","cursola",
	"dewgong","donphan","dragonite","drampa","drapion","drifblim","dugtrio","dusclops","dusknoir",
	"electivire","exeggutor","exploud",
	"fearow","florges","flygon","forretress","froslass",
	"gallade","galvantula","gardevoir","gastrodon","gengar","glalie","gliscor","golduck","golem","golisopod","gorebyss","gothitelle","gourgeist","grumpig","gyarados",
	"hariyama","hatterene","heracross","hippowdon","hitmonchan","hitmonlee","hitmontop","houndoom","huntail","hypno",

	"jumpluff",
	"kabutops","kingdra","kingler",
	"lanturn","lapras","leavanny","lopunny","lumineon",
	"magcargo","magmortar","magnezone","mamoswine","mandibuzz","mantine","meowstic","metagross","milotic","mismagius","muk",
	"noivern",
	"octillery","omastar",
	"pidgeot","pinsir","politoed","poliwrath","porygon_z","primeape","probopass","purugly",

	"rapidash","rhydon","rhyperior",
	"salazzle","sandslash","sawsbuck","scizor","scrafty","seaking","sharpedo","shiftry","skarmory","skuntank","slaking","spiritomb","staraptor","starmie","steelix","stoutland","swellow","swoobat",
	"tangrowth","tauros","tentacruel","togekiss","toxicroak","tsareena","tyranitar",
	"ursaring",
	"victreebel",
	"wailord","weezing","whimsicott","whiscash",
	"xatu",
	"yanmega",
	}
}

--weighting of possible client/target pokemon based on difficulty of mission
MISSION_GEN.DIFF_POKEMON = {
	E = {
		{"TIER_LOW", 10},
		{"TIER_MID", 0},
		{"TIER_HIGH", 0}
		},
	D = {
		{"TIER_LOW", 9},
		{"TIER_MID", 1},
		{"TIER_HIGH", 0}
		},
	C = {
		{"TIER_LOW", 8},
		{"TIER_MID", 2},
		{"TIER_HIGH", 0}
		},
	B = {
		{"TIER_LOW", 7},
		{"TIER_MID", 3},
		{"TIER_HIGH", 0}
		},
	A = {
		{"TIER_LOW", 5},
		{"TIER_MID", 5},
		{"TIER_HIGH", 0}
		},
	S = {
		{"TIER_LOW", 2},
		{"TIER_MID", 7},
		{"TIER_HIGH", 1}
		}
}

--weighting of each loot table based on difficulty of mission

MISSION_GEN.DIFF_REWARDS = {
	E = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 0},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	D = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 2},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	C = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 3},
		{"HELD_HIGH", 0},
		{"TM_LOW", 2},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	B = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 4},
		{"HELD_HIGH", 0},
		{"TM_LOW", 3},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	A = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 2},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	S = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 2},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		}
}



--Weighted list of rewards to choose from for missions
--todo: balance the weightings
MISSION_GEN.REWARDS = {
	--Reward tables of high and low tier loot separated by category (TM, ammo, held items, etc)
	--different mission difficulties have different chances to roll each table
	AMMO_LOW = {
		{"ammo_geo_pebble", 5},
		{"ammo_gravelerock", 5},
		{"ammo_iron_thorn", 5},
		{"ammo_stick", 5},
		{"ammo_silver_spike", 5}
	},
	
	AMMO_HIGH = {
		{"ammo_rare_fossil", 5},
		{"ammo_corsola_twig", 5},
		{"ammo_cacnea_spike", 5},
		{"ammo_golden_spike", 5}
	},
	--Rare chance for gummis
	FOOD_LOW = {
		{"food_apple", 15},
		{"food_apple_big", 9},
		{"food_banana", 9},
		{"food_chestnut", 6},
		{"gummi_blue", 1},
		{"gummi_black", 1},
		{"gummi_clear", 1}, 
		{"gummi_grass", 1},
		{"green_gummi", 1},
		{"gummi_brown", 1},
		{"gummi_orange", 1},
		{"gummi_gold", 1},
		{"gummi_pink", 1},
		{"gummi_purple", 1},
		{"gummi_red", 1},
		{"gummi_royal", 1},
		{"gummi_silver", 1},
		{"gummi_white", 1},
		{"gummi_yellow", 1},
		{"gummi_sky", 1},
		{"gummi_gray", 1},
		{"gummi_magenta", 1}
	},
	--Better chance for gummis over low tier, small chance for vitamins
	FOOD_HIGH = {
		{"food_apple_big", 15},
		{"food_apple_huge", 9},
		{"food_apple_perfect", 6},
		{"food_banana_big", 9},
		{"gummi_blue", 1},
		{"gummi_black", 1},
		{"gummi_clear", 1}, 
		{"gummi_grass", 1},
		{"green_gummi", 1},
		{"gummi_brown", 1},
		{"gummi_orange", 1},
		{"gummi_gold", 1},
		{"gummi_pink", 1},
		{"gummi_purple", 1},
		{"gummi_red", 1},
		{"gummi_royal", 1},
		{"gummi_silver", 1},
		{"gummi_white", 1},
		{"gummi_yellow", 1},
		{"gummi_sky", 1},
		{"gummi_gray", 1},
		{"gummi_magenta", 1},
		{"boost_calcium", 1},
		{"boost_protein", 1},
		{"boost_hp_up", 1},
		{"boost_zinc", 1},
		{"boost_carbos", 1},
		{"boost_iron", 1},
		{"boost_nectar", 1}
		
	},
	--includes seeds and berries
	SEED_LOW = {
		{'seed_blast', 5},
		{'seed_reviver', 5},
		{'seed_sleep', 5},
		{'seed_warp', 5},
		{'berry_oran', 5},
		{'berry_leppa', 5},
		{'berry_sitrus', 5},
		{'berry_pecha', 5},
		{'berry_cheri', 5},
		{'berry_rawst', 5},
		{'berry_aspear', 5},
		{'berry_chesto', 5},
		{'berry_persim', 5},
		{'berry_lum', 5}
	},
	
	--includes seeds and berries
	SEED_HIGH = {
		{'seed_reviver', 5},
		{'seed_pure', 5},
		{'seed_joy', 5},
		{'berry_sitrus', 5},
		{'berry_lum', 5}
	}, 
	
	HELD_LOW = {
		{'held_power_band', 5},
		{'held_special_band', 5},
		{'held_defense_scarf', 5},
		{'held_zinc_band', 5},
		
		{'held_pecha_scarf', 5},
		{'held_cheri_scarf', 5},
		{'held_rawst_scarf', 5},
		{'held_aspear_scarf', 5},
		{'held_insomniascope', 5},
		{'held_persim_band', 5},
		
		{'held_warp_scarf', 5}
	},
	
	HELD_HIGH = {
		{'held_friend_bow', 5},
		{'held_mobile_scarf', 5},
		{'held_cover_band', 5},
		{'held_scope_lens', 5},
		{'held_trap_scarf', 5},
		{'held_reunion_cape', 5},
		{'held_pierce_band', 5},
		{'held_heal_ribbon', 5},
		{'held_goggle_specs', 5},
		{'held_x_ray_specs', 5},
		{'held_twist_band', 5}
	},
	
	TM_LOW = {
		{'tm_snatch', 5},
		{'tm_sunny_day', 5},
		{'tm_rain_dance', 5},
		{'tm_sandstorm', 5},
		{'tm_hail', 5},
		{'tm_taunt', 5},
		
		{'tm_safeguard', 5},
		{'tm_light_screen', 5},
		{'tm_dream_eater', 5},
		{'tm_nature_power', 5},
		{'tm_swagger', 5},
		{'tm_captivate', 5},
		{'tm_fling', 5},
		{'tm_payback', 5},
		{'tm_reflect', 5},
		{'tm_rock_polish', 5},
		{'tm_pluck', 5},
		{'tm_psych_up', 5},
		{'tm_secret_power', 5},

		{'tm_return', 5},
		{'tm_frustration', 5},
		{'tm_torment', 5},
		{'tm_endure', 5},
		{'tm_echoed_voice', 5},
		{'tm_gyro_ball', 5},
		{'tm_recycle', 5},
		{'tm_false_swipe', 5},
		{'tm_defog', 5},
		{'tm_telekinesis', 5},
		{'tm_double_team', 5},
		{'tm_thunder_wave', 5},
		{'tm_attract', 5},
		{'tm_smack_down', 5},
		{'tm_snarl', 5},
		{'tm_flame_charge', 5},

		{'tm_protect', 5},
		{'tm_round', 5},
		{'tm_rest', 5},
		{'tm_thief', 5},
		{'tm_cut', 5},
		{'tm_whirlpool', 5},
		{'tm_infestation', 5},
		{'tm_roar', 5},
		{'tm_flash', 5},
		{'tm_embargo', 5},
		{'tm_struggle_bug', 5},
		{'tm_quash', 5}},
		
	TM_MID = {

		{'tm_explosion', 5},
		{'tm_will_o_wisp', 5},
		{'tm_facade', 5},
		{'tm_water_pulse', 5},
		{'tm_shock_wave', 5},
		{'tm_brick_break', 5},
		{'tm_calm_mind', 5},
		{'tm_charge_beam', 5},
		{'tm_retaliate', 5},
		{'tm_roost', 5},
		{'tm_acrobatics', 5},
		{'tm_bulk_up', 5},


		{'tm_shadow_claw', 5},

		{'tm_steel_wing', 5},
		{'tm_snarl', 5},
		{'tm_bulldoze', 5},
		{'tm_substitute', 5},
		{'tm_brine', 5},
		{'tm_venoshock', 5},
		{'tm_u_turn', 5},
		{'tm_aerial_ace', 5},
		{'tm_hone_claws', 5},
		{'tm_rock_smash', 5},

		{'tm_hidden_power', 5},
		{'tm_rock_tomb', 5},
		{'tm_strength', 5},
		{'tm_grass_knot', 5},
		{'tm_power_up_punch', 5},
		{'tm_work_up', 5},
		{'tm_incinerate', 5},
		{'tm_bullet_seed', 5},
		{'tm_low_sweep', 5},
		{'tm_volt_switch', 5},
		{'tm_avalanche', 5},
		{'tm_dragon_tail', 5},
		{'tm_silver_wind', 5},
		{'tm_frost_breath', 5},
		{'tm_sky_drop', 5}},
	TM_HIGH = {
		{'tm_earthquake', 5},
		{'tm_hyper_beam', 5},
		{'tm_overheat', 5},
		{'tm_blizzard', 5},
		{'tm_swords_dance', 5},
		{'tm_surf', 5},
		{'tm_dark_pulse', 5},
		{'tm_psychic', 5},
		{'tm_thunder', 5},
		{'tm_shadow_ball', 5},
		{'tm_ice_beam', 5},
		{'tm_giga_impact', 5},
		{'tm_fire_blast', 5},
		{'tm_dazzling_gleam', 5},
		{'tm_flash_cannon', 5},
		{'tm_stone_edge', 5},
		{'tm_sludge_bomb', 5},
		{'tm_focus_blast', 5},

		{'tm_x_scissor', 5},
		{'tm_wild_charge', 5},
		{'tm_focus_punch', 5},
		{'tm_psyshock', 5},
		{'tm_rock_slide', 5},
		{'tm_thunderbolt', 5},
		{'tm_flamethrower', 5},
		{'tm_energy_ball', 5},
		{'tm_scald', 5},
		{'tm_waterfall', 5},
		{'tm_rock_climb', 5},

		{'tm_giga_drain', 5},
		{'tm_dive', 5},
		{'tm_poison_jab', 5},
	
		{'tm_iron_tail', 5},
	
		{'tm_dig', 5},
		{'tm_fly', 5},
		{'tm_dragon_claw', 5},
		{'tm_dragon_pulse', 5},
		{'tm_sludge_wave', 5},
		{'tm_drain_punch', 5}},
	--additional, special, unique rewards. todo
	SPECIAL = {}
}

MISSION_GEN.SPECIAL_RESCUE_RIVAL = "RIVAL"
MISSION_GEN.SPECIAL_RESCUE_CHILD = "CHILD"
MISSION_GEN.SPECIAL_RESCUE_LOVER = "LOVER"
MISSION_GEN.SPECIAL_RESCUE_FRIEND = "FRIEND"


MISSION_GEN.SPECIAL_RESCUE_OPTIONS = {
	MISSION_GEN.SPECIAL_RESCUE_RIVAL,
	MISSION_GEN.SPECIAL_RESCUE_CHILD,
	MISSION_GEN.SPECIAL_RESCUE_LOVER,
	MISSION_GEN.SPECIAL_RESCUE_FRIEND
}

--Order matters for these! First is the client, second is the target
--Titles are random from a small list. Each pair has a unique body text however included in the data below.
MISSION_GEN.SPECIAL_LOVER_PAIRS = {
	TIER_LOW = {
		{'volbeat', Gender.Male, 'illumise', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_001"},
		{'minun', Gender.Male, 'plusle', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_002"},
		{'mareep', Gender.Female, 'wooloo', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_003"},
		{'luvdisc', Gender.Female, 'luvdisc', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_004"}	
	},
	TIER_MID = {
		{'miltank', Gender.Female, 'tauros', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_005"},
		{'venomoth', Gender.Male, 'butterfree', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_006"},
		{'liepard', Gender.Female, 'persian', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_007"},
		{'dustox', Gender.Male, 'beautifly', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_008"},
		{'glalie', Gender.Male, 'froslass', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_009"},
		{'ribombee', Gender.Female, 'masquerain', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_010"},
		{'maractus', Gender.Female, 'cacturne', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_011"},---my prickly love!
		{'lanturn', Gender.Male, 'lumineon', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_012"}
	},
	TIER_HIGH = {
		{'tyranitar', Gender.Male, 'altaria', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_013"},--reference to an old idea i had
		{'gyarados', Gender.Male, 'milotic', Gender.Female, "MISSION_BODY_SPECIAL_LOVER_014"},
		{'gardevoir', Gender.Female, 'gallade', Gender.Male, "MISSION_BODY_SPECIAL_LOVER_015"}
	}

}

MISSION_GEN.SPECIAL_CHILD_PAIRS = {
	TIER_LOW = {
		{'clefable', 'cleffa'},
		{'wigglytuff', 'igglybuff'},
		{'togekiss', 'togepi'},
		{'roserade', 'budew'},
		{'chimecho', 'chingling'},
		{'sudowoodo', 'bonsly'},
		{'mr_mime', 'mime_jr'},
		{'raticate', 'rattata'},--hes still not so good at gnawing!
		{'leavanny', 'sewaddle'}
	},
	TIER_MID = {
		{'appletun', 'applin'},
		{'aggron', 'aron'},--probably munched too much metal!
		{'jynx', 'smoochum'},
		{'electivire', 'elekid'},
		{'magmortar', 'magby'},
		{'tsareena', 'bounsweet'},
		{'hatterene', 'hatenna'},
		{'gothitelle', 'gothita'},
		{'dugtrio', 'diglett'}
	},	
	TIER_HIGH = {
		{'tyranitar', 'larvitar'},
		{'salamence', 'bagon'},
		{'dragonite', 'dratini'},
		{'noivern', 'noibat'}
	}
	
	
	
	
}

MISSION_GEN.SPECIAL_FRIENDS_PAIRS = {
	TIER_LOW = {
		{'cherubi', 'applin'},--We both get mistaken for fruit! What if someone ate him!?
		{'mantyke', 'remoraid'},--My best friend is missing! I'll never be able to evolve without him!
		{'magikarp', 'feebas'},--feebas is the only one who understands what it's like to be dogshit!
		{'poliwag', 'lotad'},--frog and his lilypad. I have no lilypad now, save him!
		{'teddiursa', 'combee'}, --Without Combee, I have no honey! Please find them!
		{'woobat', 'zubat'},--we both use ultrasonic waves to see!
		{'trubbish', 'grimer'},--we both love eating garbage!
		{'shroomish', 'paras'},--we both love to spread spores!
		{'chansey', 'togepi'},--cares for togepi because its an egg
		{'salandit', 'combee'}--they relate in being useless
	},
	TIER_MID = {
		{'lunatone', 'solrock'},
		{'emolga', 'pachirisu'},
		{'spinda', 'hypno'}, --Hypno went missing; only he can help stop my dizziness
		{'cramorant', 'pelipper'},
		{'magnemite', 'nosepass'},--We're both sensitive to magnetism!
		{'venomoth', 'lampent'}
	},
	TIER_HIGH = {
		{'lilligant', 'kricketune'},--I can't dance without Kricketune's music!
		{'wigglytuff', 'exploud'}, --we love making loud, silly noises together!
		{'beedrill', 'florges'},--without my flower, i have no meaning!
		{'dunsparce', 'dugtrio'},--we both love to burrow!
		{'whimsicott', 'jumpluff'}
	}
}

MISSION_GEN.SPECIAL_RIVAL_PAIRS = {
	TIER_LOW = {
		{'koffing', 'stunky'},--they compete to see whose odor is stronger
		{'krabby', 'corphish'},--compare claw strength
		{'shuppet', 'duskull'},--we like to see who can pull better pranks!
		{'pidgey', 'spearow'},--we compete at flying!
		{'kabuto', 'omanyte'}, --we've been rivals since our ancestors' time!
		{'joltik', 'spinarak'},--We like to see who can spin the better web!
		{'tyrogue', 'makuhita'},--my punching bag training partner!
		{'lillipup', 'poochyena'}

},
	
	TIER_MID = {
		{'vigoroth', 'primeape'},--full of energy!
		{'sawsbuck', 'stantler'},--butt antlers!
		{'jangmo_o', 'axew'},
		{'mareanie', 'corsola'}

	},
	
	TIER_HIGH = {
		{'heracross', 'pinsir'},
		{'slowking', 'slowbro'},--slowbro may not be as smart as me, but we're still great friends!
		{'magmortar', 'electivire'}, --we need to settle who is stronger!
		{'cradily', 'armaldo'}, --we've been rivals since our ancestors' time!
		{'bastiodon', 'rampardos'}, --we've been rivals since our ancestors' time!
		{'archeops', 'aerodactyl'}, --we've been rivals since our ancestors' time!
		{'swellow', 'staraptor'},--brave birds!

	}
}



MISSION_GEN.SPECIAL_OUTLAW = {

}


MISSION_GEN.LOST_ITEMS = {
	"mission_lost_scarf"
}

MISSION_GEN.STOLEN_ITEMS = {
	"mission_stolen_scarf"
}

MISSION_GEN.DELIVERABLE_ITEMS = {
	"berry_oran",
	"berry_leppa",
}

--"order" of dungeons
MISSION_GEN.DUNGEON_ORDER = {}
MISSION_GEN.DUNGEON_ORDER[""] = 99999--empty missions should get shoved towards the end 
MISSION_GEN.DUNGEON_ORDER["relic_forest"] = 1
MISSION_GEN.DUNGEON_ORDER["illuminant_riverbed"] = 2
MISSION_GEN.DUNGEON_ORDER["crooked_cavern"] = 3



--Do the stairs go up or down? Blank string if up, B if down
MISSION_GEN.STAIR_TYPE = {}
MISSION_GEN.STAIR_TYPE[""] = ""
MISSION_GEN.STAIR_TYPE["relic_forest"] = ""
MISSION_GEN.STAIR_TYPE["illuminant_riverbed"] = ""
MISSION_GEN.STAIR_TYPE["crooked_cavern"] = "B"




function MISSION_GEN.WeightedRandom (weights)
    local summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
    end
    if summ == 0 then return end
    -- local value = math.random (summ) -- for integer weights only
    local rand = summ*math.random ()
    summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
        if rand <= summ then
            return value[1]--, weight
        end
    end
end


function MISSION_GEN.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



function MISSION_GEN.ResetBoards()
--jobs on the mission board.
SV.MissionBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	}

}

--Jobs on the outlaw board.
SV.OutlawBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = nil,
		TargetGender = nil,
		BonusReward = ""
	}
}

end

--Generate a board. Board_type should be given as "Mission" or "Outlaw".
--Job/Outlaw Boards should be cleared before being regenerated.
function MISSION_GEN.GenerateBoard(board_type)
	local jobs_to_make = math.random(5, 8)--Todo: jobs generated is based on your rank or how many dungeons you've done.
	local assigned_combos = {}--floor/dungeon combinations that already have had missions genned for it. Need to consider already genned missions and missions on taken board.
	

	-- All seen Pokemon in the pokedex
	--local seen_pokemon = {}

	--for entry in luanet.each(_DATA.Save.Dex) do
	--	if entry.Value == RogueEssence.Data.GameProgress.UnlockState.Discovered then
	--		table.insert(seen_pokemon, entry.Key)
	--	end
	--end

	--print( seen_pokemon[ math.random( #seen_pokemon ) ] )
	


	--default to mission.
	local mission_type = "Mission"
	if board_type == "Outlaw" then mission_type = "Outlaw" end
	
	--todo: figures out dungeons based on what you've completed, minus certain ones like dojo dungeons and relic forest.
	local dungeon_list = {"illuminant_riverbed", "crooked_cavern"}
	
	--generate jobs
	for i = 1, jobs_to_make, 1 do 
		--choose a dungeon, client, target, item, etc
		local dungeon = dungeon_list[math.random(1, #dungeon_list)]
		local client = ""
		local item = ""
		local special = ""

		--generate the objective. 10% chance of escort vs rescue.
		local objective 
		if mission_type == "Outlaw" then 
			local roll = math.random(1, 10)
			if roll <= 5 then
				objective = COMMON.MISSION_TYPE_OUTLAW
			elseif roll <= 8 then 
				objective = COMMON.MISSION_TYPE_OUTLAW_ITEM
			elseif roll <= 9 then 
				objective = COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE
			else
				objective = COMMON.MISSION_TYPE_OUTLAW_FLEE
			end
		else
			local roll = math.random(1, 10)
			if roll <= 1 then 
				--if there's already an escort mission generated for this dungeon, don't gen another one and just make it a rescue.
				objective = COMMON.MISSION_TYPE_ESCORT 
				--only check from 1 to i-1 to save time.
				for j = 1, i-1, 1 do 
					if SV.MissionBoard[j].Zone == dungeon and SV.MissionBoard[j].Type == COMMON.MISSION_TYPE_ESCORT then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end 
				end 
				
				for j = 1, 8, 1 do
					if SV.TakenBoard[j].Zone == dungeon and SV.TakenBoard[j].Type == COMMON.MISSION_TYPE_ESCORT then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end
				end
			elseif roll <= 2 then
				-- TODO - Apply the same logic from escort missions to exploration
				objective = COMMON.MISSION_TYPE_EXPLORATION
			elseif roll <= 4 then
				objective = COMMON.MISSION_TYPE_DELIVERY
			elseif roll <= 6 then
				objective = COMMON.MISSION_TYPE_LOST_ITEM
			else
				objective = COMMON.MISSION_TYPE_RESCUE
			end
		end

		if objective == COMMON.MISSION_TYPE_DELIVERY then
			item = MISSION_GEN.DELIVERABLE_ITEMS[math.random(1, #MISSION_GEN.DELIVERABLE_ITEMS)]
		elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
			item = MISSION_GEN.STOLEN_ITEMS[math.random(1, #MISSION_GEN.STOLEN_ITEMS)]
		elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
			item = MISSION_GEN.LOST_ITEMS[math.random(1, #MISSION_GEN.LOST_ITEMS)]
		end


		local difficulty = MISSION_GEN.DUNGEON_DIFFICULTY[dungeon]
		local offset = 0
		--up the difficulty by 1 if its an outlaw or escort mission.
		local difficult_objectives = { COMMON.MISSION_TYPE_ESCORT, COMMON.MISSION_TYPE_OUTLAW, COMMON.MISSION_TYPE_OUTLAW_FLEE, COMMON.MISSION_TYPE_OUTLAW_ITEM }
		if GeneralFunctions.TableContains(difficult_objectives, objective) then
			offset = 1
		--up the difficulty by 2 if its an outlaw monster house
		elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			offset = 2
		end
		difficulty = MISSION_GEN.ORDER_TO_DIFF[MISSION_GEN.DIFF_TO_ORDER[difficulty]+offset]
		
		
		
		--Generate a tier, then the client
		local tier = MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_POKEMON[difficulty])
		local client_candidates = MISSION_GEN.POKEMON[tier]
		client = client_candidates[math.random(1, #client_candidates)]
		print(tier)
		
		--50% chance that the client and target are the same. Target is the escort if its an escort mission.
		--It is possible for this to roll the same target as the client again, which is fine.
		--Always give a target if objective is escort or a outlaw stole an item.
		--Target should always be client for 
		local target = client
		if math.random(1, 2) == 1 or objective == COMMON.MISSION_TYPE_ESCORT or objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
			local target_candidates = MISSION_GEN.POKEMON[tier]
			target = target_candidates[math.random(1, #target_candidates)]	
			--print(target_candidates[1]) --to give an idea of what tier we rolled
		end
		
		--if its a generic outlaw mission, or a monster house / fleeing outlaw, Zhayn is the client. Normal mons only ask you to go after their stolen items.
		if objective == COMMON.MISSION_TYPE_OUTLAW or objective == COMMON.MISSION_TYPE_OUTLAW_FLEE or objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			client = "zhayn"
		end
		
		--if it's a delivery, exploration, or lost item, target and client should match.
		if objective == COMMON.MISSION_TYPE_EXPLORATION or objective == COMMON.MISSION_TYPE_DELIVERY or objective == COMMON.MISSION_TYPE_LOST_ITEM then
			target = client
		end
		
		
		--Roll for genders. Use base form because it PROBABLY won't ever matter.
		local client_gender
		
		if client == "zhayn" then--Zhayn is a special exception
			client_gender = Gender.Male
		else
			client_gender = _DATA:GetMonster(client).Forms[0]:RollGender(_ZONE.CurrentGround.Rand)
		end 
		
		local target_gender = _DATA:GetMonster(target).Forms[0]:RollGender(_ZONE.CurrentGround.Rand)


		-- TODO handle special cases 
		--[[
		if objective == COMMON.MISSION_TYPE_RESCUE and math.random(1, 10) == 1 then
			special = MISSION_GEN.SPECIAL_RESCUE_OPTIONS[math.random(1, #MISSION_GEN.SPECIAL_RESCUE_OPTIONS)]
			if special == MISSION_GEN.SPECIAL_RESCUE_LOVER then

			elseif special == MISSION_GEN.SPECIAL_RESCUE_CHILD then

			elseif special == MISSION_GEN.SPECIAL_RESCUE_RIVAL then

			elseif special == MISSION_GEN.SPECIAL_RESCUE_FRIEND then
			end
		end
		]]--
		
		
		--generate reward with hardcoded list of weighted rewards
		local reward = "money"
		--1/4 chance you get money instead of an item
		
		if math.random(1, 4) > 1 then 
			reward = MISSION_GEN.WeightedRandom(MISSION_GEN.REWARDS[MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_REWARDS[difficulty])])
		end
		
		--1/3 chance you get a bonus reward. Bonus reward is always an item, never money 
		local bonus_reward = ""
		
		if math.random(1,3) == 1 then 
			bonus_reward = MISSION_GEN.WeightedRandom(MISSION_GEN.REWARDS[MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_REWARDS[difficulty])])
		end 
		
		--get the zone, and max floors (counted floors of relevant segments)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon)
		
		


		--Choose a random title that's appropriate.
		local title = "Default title."
		local title_candidates = {}
		
		if special ~= "" then -- get special title
			print("and i oop")
		else 
			if objective == COMMON.MISSION_TYPE_RESCUE and client ~= target then
				title_candidates = MISSION_GEN.TITLES["RESCUE_FRIEND"]
			elseif objective == COMMON.MISSION_TYPE_RESCUE and client == target then
				title_candidates = MISSION_GEN.TITLES["RESCUE_SELF"]
			elseif objective == COMMON.MISSION_TYPE_ESCORT then
				title_candidates = MISSION_GEN.TITLES["ESCORT"]
			elseif objective == COMMON.MISSION_TYPE_EXPLORATION then
				title_candidates = MISSION_GEN.TITLES["EXPLORATION"]
			elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
				title_candidates = MISSION_GEN.TITLES["LOST_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_DELIVERY then
				title_candidates = MISSION_GEN.TITLES["DELIVERY"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW then
				title_candidates = MISSION_GEN.TITLES["OUTLAW"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_MONSTER_HOUSE"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_FLEE then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_FLEE"]			
			end
			title = RogueEssence.StringKey(title_candidates[math.random(1, #title_candidates)]):ToLocal()
			
			--string substitutions, if needed.
			if string.find(title, "%[target%]") then
				title = string.gsub(title, "%[target%]", _DATA:GetMonster(target):GetColoredName())
			end 
			
			if string.find(title, "%[dungeon%]") then
				title = string.gsub(title, "%[dungeon%]", _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon):GetColoredName())
			end 
			
			if string.find(title, "%[item%]") then
				title = string.gsub(title, "%[item%]",  _DATA:GetItem(item):GetColoredName())
			end
		end 
		
		
		
		--Flavor text generation
		local flavor = "Default flavor text.\nHow did you see this? Tell Palika, please!"
		local flavor_top_candidates = {}
		local flavor_bottom_candidates = {}
		
		if special ~= "" then -- get special title
		
		else 
			if objective == COMMON.MISSION_TYPE_RESCUE and client ~= target then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["RESCUE_FRIEND"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["RESCUE_FRIEND"]
			elseif objective == COMMON.MISSION_TYPE_RESCUE and client == target then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["RESCUE_SELF"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["RESCUE_SELF"]
			elseif objective == COMMON.MISSION_TYPE_ESCORT then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["ESCORT"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["ESCORT"]
			elseif objective == COMMON.MISSION_TYPE_EXPLORATION then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["EXPLORATION"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["EXPLORATION"]
			elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["LOST_ITEM"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["LOST_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_DELIVERY then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["DELIVERY"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["DELIVERY"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_ITEM"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_MONSTER_HOUSE"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_MONSTER_HOUSE"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_FLEE then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_FLEE"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_FLEE"]
			end
			flavor = RogueEssence.StringKey(flavor_top_candidates[math.random(1, #flavor_top_candidates)]):ToLocal() .. '\n' .. RogueEssence.StringKey(flavor_bottom_candidates[math.random(1, #flavor_bottom_candidates)]):ToLocal()
		
			--string substitutions, if needed.
			if string.find(flavor, "%[target%]") then
				flavor = string.gsub(flavor, "%[target%]", _DATA:GetMonster(target):GetColoredName())
			end
			
			if string.find(flavor, "%[dungeon%]") then
				flavor = string.gsub(flavor, "%[dungeon%]", _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon):GetColoredName())
			end
						
			if string.find(flavor, "%[item%]") then
				flavor = string.gsub(flavor, "%[item%]",  _DATA:GetItem(item):GetColoredName())
			end
			
		end 



		
		--mission floor should be in last 45% of the dungeon
		--don't pick a floor that's already been chosen for another mission in a dungeon
		
		
		local used_floors = {}
		for j = 1, 8, 1 do 
			if SV.OutlawBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.OutlawBoard[j].Floor)
			end
			if SV.MissionBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.MissionBoard[j].Floor)
			end
			if SV.TakenBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.TakenBoard[j].Floor)
			end
		end
				
		local mission_floor = math.random(math.floor(zone.CountedFloors * .55), zone.CountedFloors)
		
		--don't generate this particular job slot if this floor's already been taken.
		--a bit of a lazy approach, perhaps upgrade in future?
		if not MISSION_GEN.has_value(used_floors, mission_floor) then 
			if mission_type == "Outlaw" then
				SV.OutlawBoard[i].Client = client
				SV.OutlawBoard[i].Target = target
				SV.OutlawBoard[i].Flavor = flavor
				SV.OutlawBoard[i].Title = title
				SV.OutlawBoard[i].Zone = dungeon
				SV.OutlawBoard[i].Segment = segment
				SV.OutlawBoard[i].Reward = reward
				SV.OutlawBoard[i].Floor = mission_floor
				SV.OutlawBoard[i].Type = objective
				SV.OutlawBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.OutlawBoard[i].Taken = false
				SV.OutlawBoard[i].Difficulty = difficulty
				SV.OutlawBoard[i].Item = item
				SV.OutlawBoard[i].Special = special
				SV.OutlawBoard[i].ClientGender = client_gender
				SV.OutlawBoard[i].TargetGender = target_gender
				SV.OutlawBoard[i].BonusReward = bonus_reward
			else 
				SV.MissionBoard[i].Client = client
				SV.MissionBoard[i].Target = target
				SV.MissionBoard[i].Flavor = flavor
				SV.MissionBoard[i].Title = title
				SV.MissionBoard[i].Zone = dungeon
				SV.MissionBoard[i].Segment = segment
				SV.MissionBoard[i].Reward = reward
				SV.MissionBoard[i].Floor = mission_floor
				SV.MissionBoard[i].Type = objective
				SV.MissionBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.MissionBoard[i].Taken = false
				SV.MissionBoard[i].Difficulty = difficulty
				SV.MissionBoard[i].Item = item
				SV.MissionBoard[i].Special = special		
				SV.MissionBoard[i].ClientGender = client_gender
				SV.MissionBoard[i].TargetGender = target_gender
				SV.MissionBoard[i].BonusReward = bonus_reward
			end
		end
			
	end
	
end

function MISSION_GEN.JobSortFunction(j1, j2)
	--if they're the same dungeon, then check floors. Otherwise, dungeon order takes presidence. 
	if MISSION_GEN.DUNGEON_ORDER[j1.Zone] == MISSION_GEN.DUNGEON_ORDER[j2.Zone] then
		return j1.Floor < j2.Floor 
	else 
		return MISSION_GEN.DUNGEON_ORDER[j1.Zone] < MISSION_GEN.DUNGEON_ORDER[j2.Zone]
	end
end


function MISSION_GEN.SortTaken()
	table.sort(SV.TakenBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortMission()
	table.sort(SV.MissionBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortOutlaw()
	table.sort(SV.OutlawBoard, MISSION_GEN.JobSortFunction)
end



JobMenu = Class('JobMenu')

--jobs is a job board 
--job type should be taken, mission, or outlaw
--job number should be 1-8
function JobMenu:initialize(job_type, job_number, parent_board_menu)
  assert(self, "JobMenu:initialize(): Error, self is nil!")
  self.menu = RogueEssence.Menu.ScriptableMenu(32, 32, 256, 176, function(input) self:Update(input) end)
  --self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(jobs[i], RogueElements.Loc(16, 8 + 14 * (i-1))))
    
  local job 
  
  self.job_number = job_number
  
  self.job_type = job_type
  
  self.parent_board_menu = parent_board_menu
  
  --get relevant board
  local job
  if job_type == 'taken' then
		job = SV.TakenBoard[job_number]
  elseif job_type == 'outlaw' then
  	job = SV.OutlawBoard[job_number]
  else --default to mission board
  	job = SV.MissionBoard[job_number]
  end
  
  self.taken = job.Taken
  
  self.flavor = job.Flavor
  --Zhayn is the only non-species name that'll show up here. So he is hardcoded in as an exception here.
  --TODO: Unhardcode this by adding in a check if string is not empty and if its not a species name, then add the color coding around it for  proper names.
  self.client = ""
  if job.Client == 'zhayn' then 
	self.client = '[color=#00FFFF]Zhayn[color]' 
  elseif job.Client ~= "" then 
	self.client = _DATA:GetMonster(job.Client):GetColoredName() 
  end
  print(self.client)

  self.target = ""
  if job.Target ~= '' then self.target = _DATA:GetMonster(job.Target):GetColoredName() end
  
	self.item = ""
	if job.Item ~= '' then self.item = _DATA:GetItem(job.Item):GetColoredName() end
  
  self.objective = ""
  self.type = job.Type
  self.taken_count = MISSION_GEN.GetTakenCount()
  
  if self.type == COMMON.MISSION_TYPE_RESCUE then
		self.objective = "Rescue " .. self.target .. "."
  elseif self.type == COMMON.MISSION_TYPE_ESCORT then
    self.objective = "Escort " .. self.client .. " to " .. self.target .. "."
	elseif self.type == COMMON.MISSION_TYPE_EXPLORATION then
		self.objective = "Explore with " .. self.client .. "."
  elseif self.type == COMMON.MISSION_TYPE_OUTLAW or self.type == COMMON.MISSION_TYPE_OUTLAW_FLEE or self.type == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then 
		self.objective = "Arrest " .. self.target .. "."
	elseif self.type == COMMON.MISSION_TYPE_LOST_ITEM then 
		self.objective = "Find " .. self.item .. " for " .. self.client .. "."
	elseif self.type == COMMON.MISSION_TYPE_DELIVERY then 
		self.objective = "Deliver " .. self.item .. " to " .. self.client .. "."
  elseif self.type == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
		self.objective = "Reclaim " .. self.item .. " from " .. self.target .. "."
  end
  
  
  self.zone = ""
  if job.Zone ~= "" then self.zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(job.Zone):GetColoredName() end
  
  self.floor = ""
  if job.Floor ~= -1 then self.floor = MISSION_GEN.STAIR_TYPE[job.Zone] .. '[color=#00FFFF]' .. tostring(job.Floor) .. "[color]F" end
  
  self.difficulty = ""
  if job.Difficulty ~= "" then self.difficulty = "[color=#FFC663]" .. job.Difficulty .. "[color]   (" .. tostring(MISSION_GEN.DIFFICULTY[job.Difficulty]) .. ")" end 
  
  
  
  
  self.reward = ""
  if job.Reward ~= '' then
	--special case for money
	if job.Reward == "money" then
		self.reward = '[color=#00FFFF]' .. MISSION_GEN.DIFF_TO_MONEY[job.Difficulty] .. '[color]' .. STRINGS:Format("\\uE024")
	else 
		self.reward = RogueEssence.Dungeon.InvItem(job.Reward, false, RogueEssence.Data.DataManager.Instance:GetItem(job.Reward).MaxStack):GetDisplayName()
    end
  end
  
  --add in the ??? for a bonus reward if one exists
  if job.BonusReward ~= "" then
	self.reward = self.reward .. ' + ?'
  end
  
  
	self:DrawJob()
  

end

function JobMenu:DrawJob()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2))

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Job Summary", RogueElements.Loc(16, 8)))
  
  --Accepted element 
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, self.menu.Bounds.Height - 24), self.menu.Bounds.Width - 8 * 2))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Accepted: " .. self.taken_count .. "/8", RogueElements.Loc(96, self.menu.Bounds.Height - 20)))


  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.flavor, RogueElements.Loc(16, 24)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Client:", RogueElements.Loc(16, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Objective:", RogueElements.Loc(16, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Place:", RogueElements.Loc(16, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Difficulty:", RogueElements.Loc(16, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Reward:", RogueElements.Loc(16, 110))) 

  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.client, RogueElements.Loc(68, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.objective, RogueElements.Loc(68, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.zone .. " " .. self.floor, RogueElements.Loc(68, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.difficulty, RogueElements.Loc(68, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.reward, RogueElements.Loc(68, 110)))
end 



--for use with submenu
function JobMenu:DeleteJob()
	SV.TakenBoard[self.job_number] = {
										Client = "",
										Target = "",
										Flavor = "",
										Title = "",
										Zone = "",
										Segment = -1,
										Floor = -1,
										Reward = "",
										Type = -1,
										Completion = -1,
										Taken = false,
										Difficulty = "",
										Item = "",
										Special = "",
										ClientGender = nil,
										TargetGender = nil,
										BonusReward = ""
									}
	
	MISSION_GEN.SortTaken()
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
		
		--redraw selection board with potentially changed information
		if self.parent_board_menu.parent_selection_menu ~= nil then 
			self.parent_board_menu.parent_selection_menu.menu.MenuElements:Clear()
			self.parent_board_menu.parent_selection_menu:DrawMenu()
		end
	end
	_MENU:RemoveMenu()
end

--for use with submenu
--flips taken status of self, and also updates the appropriate SV var's taken value
function JobMenu:FlipTakenStatus()
	self.taken = not self.taken
	if self.job_type == 'taken' then
		SV.TakenBoard[self.job_number].Taken = self.taken
	elseif self.job_type == 'outlaw' then
		SV.OutlawBoard[self.job_number].Taken = self.taken
	else 
		SV.MissionBoard[self.job_number].Taken = self.taken
	end
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
	end
end 

--for use with submenu
--adds the current job to the taken board, then sorts it. Then close the menu
function JobMenu:AddJobToTaken()
	--this should already be true if we get to this point, but just in case, check if the last job slot is empty
	if SV.TakenBoard[8].Client == "" then
		if self.job_type == 'outlaw' then
			SV.TakenBoard[8] = SV.OutlawBoard[self.job_number]
		elseif self.job_type == 'mission' then
			SV.TakenBoard[8] = SV.MissionBoard[self.job_number]
		end 
		MISSION_GEN.SortTaken()
	end
	
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
		
		--redraw selection board with potentially changed information
		if self.parent_board_menu.parent_selection_menu ~= nil then 
			self.parent_board_menu.parent_selection_menu.menu.MenuElements:Clear()
			self.parent_board_menu.parent_selection_menu:DrawMenu()
		end
	end
	

	_MENU:RemoveMenu()
end

function JobMenu:OpenSubMenu()
	if self.job_type ~= 'taken' and self.taken then 
		--This is a job from the board that was already taken!
	else 
		--create prompt menu
		local choices = {}
		print(self.job_type .. " taken: " .. tostring(self.taken))
		if self.job_type == 'taken' then
			local choice_str = "Take Job"
			if self.taken then
				choice_str = 'Suspend'
			end
			choices = {	{choice_str, true, function() self:FlipTakenStatus() _MENU:RemoveMenu() _MENU:RemoveMenu() end},
						{"Delete", true, function() self:DeleteJob() _MENU:RemoveMenu() end},
						{"Cancel", true, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end} }
			
		else --outlaw/mission boards
			--we already made a check above to see if this is a job board and not taken 
			--only selectable if there's room on the taken board for the job and we haven't already taken this mission
			choices = {{"Take Job", SV.TakenBoard[8].Client == "" and not self.taken, function() self:FlipTakenStatus() 
																								 self:AddJobToTaken() _MENU:RemoveMenu() end },
					   {"Cancel", true, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end} }
		end 
	
		submenu = RogueEssence.Menu.ScriptableSingleStripMenu(232, 138, 24, choices, 1, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end) 
		_MENU:AddMenu(submenu, true)
		
	end
end

function JobMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then  
	if self.job_type ~= 'taken' and self.taken then 
		--This is a job from the board that was already taken! Play a cancel noise.
		_GAME:SE("Menu/Cancel")
	else 
		--This job has not yet been taken.  This block will never be hit because the submenu will automatically open.
	end
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else

  end
end 



BoardMenu = Class('BoardMenu')

--board type should be taken, mission, or outlaw 
function BoardMenu:initialize(board_type, parent_selection_menu)
  assert(self, "BoardMenu:initialize(): Error, self is nil!")
    
  self.menu = RogueEssence.Menu.ScriptableMenu(32, 32, 256, 176, function(input) self:Update(input) end)
  self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
  
  self.board_type = board_type
  
  --For refreshing the parent selection menu
  self.parent_selection_menu = parent_selection_menu
  
  if self.board_type == 'taken' then
	self.jobs = SV.TakenBoard
  elseif self.board_type == 'outlaw' then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end

  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
  
  self.current_item = 0
  self.cursor.Loc = RogueElements.Loc(9, 24)
  self.page = 1--1 or 2
  self.taken_count = MISSION_GEN.GetTakenCount()
  self.total_pages = math.ceil(self.total_items / 4)


  self:DrawBoard()

end

--refresh information from results of job menu
function BoardMenu:RefreshSelf()
  print("Debug: Refreshing self!")
  if self.board_type == 'taken' then
	self.jobs = SV.TakenBoard
  elseif self.board_type == 'outlaw' then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end
  
  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
 
  --in the event of deleting the last item on the board, move the cursor to accomodate.
  if self:GetSelectedJobIndex() > self.total_items then 
	print("On refresh self, needed to adjust current item!")
	self.current_item = (self.total_items % 4) - 1
	
	--move cursor to reflect new current item location
	self.cursor:ResetTimeOffset()
    self.cursor.Loc = RogueElements.Loc(9, 24 + 26 * self.current_item)
  end
  
  self.total_pages = math.ceil(self.total_items / 4)

  --go to page 1 if we now only have 1 page
  if self.page == 2 and self.total_pages == 1 then
	self.page = 1
  end

  --refresh taken count
  self.taken_count = MISSION_GEN.GetTakenCount()
  
  --if there are no more missions and we're on the taken screen, close the menu.  
  if SV.TakenBoard[1].Client == "" and self.board_type == 'taken' then 
	  _MENU:RemoveMenu()
  end
end 


--NOTE: Board is hardcoded to have 4 items a page, and only to have up to 8 total items to display.
--If you want to edit this, you'll probably have to change most instances of the number 4 here and some references to page. Sorry!
function BoardMenu:DrawBoard()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2))

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Notice Board", RogueElements.Loc(16, 8)))
  
  --page element
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("(" .. tostring(self.page) .. "/" .. tostring(self.total_pages) .. ")", RogueElements.Loc(self.menu.Bounds.Width - 35, 8)))

	
  --Accepted element 
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, self.menu.Bounds.Height - 24), self.menu.Bounds.Width - 8 * 2))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Accepted: " .. tostring(self.taken_count) .. "/8", RogueElements.Loc(96, self.menu.Bounds.Height - 20)))


  self.menu.MenuElements:Add(self.cursor)
  
  --populate 4 self.jobs on a page
  for i = (4 * self.page) - 3, 4 * self.page, 1 do 
	--stop populating self.jobs if we hit a job that's empty
    if self.jobs[i].Client == "" then break end 
	
	
	local title = self.jobs[i].Title
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(self.jobs[i].Zone):GetColoredName()
    local floor =  MISSION_GEN.STAIR_TYPE[self.jobs[i].Zone] ..'[color=#00FFFF]' .. tostring(self.jobs[i].Floor) .. "[color]F"
    local difficulty = "[color=#FFC663]" .. self.jobs[i].Difficulty .. "[color]" 
	
	local icon = ""
	if self.board_type == 'taken' then
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10F")--open letter
		else
			icon = STRINGS:Format("\\uE10E")--closed letter
		end
	else 
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10E")--closed letter
		else
			icon = STRINGS:Format("\\uE110")--paper
		end
	end
	
	local location = zone .. " " .. floor .. " " .. difficulty
	
	--color everything red if job is taken and this is a job board
	if self.jobs[i].Taken and self.board_type ~= 'taken' then
		location = string.gsub(location, '%[color=#00FFFF]', '')
		location = string.gsub(location, '%[color=#FFC663]', '')
		location = string.gsub(location, '%[color]', '')
		title = "[color=#FF0000]" .. title .. "[color]"
		location = "[color=#FF0000]" .. location .. "[color]"
	end
	
	--modulo the iterator so that if we're on the 2nd page it goes to the right spot
	
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(icon, RogueElements.Loc(21, 23 + 26 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(title, RogueElements.Loc(33, 23 + 26 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(location, RogueElements.Loc(33, 35 + 26 * ((i-1) % 4))))


  end
end 


function BoardMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	--open the selected job menu
	_GAME:SE("Menu/Confirm")
	local job_menu = JobMenu:new(self.board_type, self:GetSelectedJobIndex(), self)
	_MENU:AddMenu(job_menu.menu, false)
	job_menu:OpenSubMenu()
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % 4
	  
	  --if we try to move the cursor to an empty slot on a down press, then move it to the space for the first job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = 0
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item - 1) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item - 1) % 4
	  
	  --if we try to move the cursor to an empty slot on an up press, then move it to the space for the last job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = (self.total_items % 4) - 1
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item + 1 ) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
	elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, {Dir8.Left, Dir8.Right})) then
	  --go to other menu if there are more options on the 2nd menu
	  if self.total_pages > 1 then 
	    --change the page
	    if self.page == 1 then self.page = 2 else self.page = 1 end
		moved = true
		
	  --if we try to move the cursor to an empty slot on a side press, then move it to the space for the last job on the page.
	    if self:GetSelectedJobIndex() > self.total_items then 
			local new_current = (self.total_items % 4) - 1
			self.current_item = new_current
		end
		
		
		self.menu.MenuElements:Clear()
		self:DrawBoard()
	  end
    end
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(9, 24 + 26 * self.current_item)
    end
  end
end 

--gets current job index based on the current item and the page. if self.page is 2, and current item is 0, returned answer should be 5.
function BoardMenu:GetSelectedJobIndex()
	return self.current_item + (4 * (self.page - 1) + 1)
	
end








------------------------
-- Board Selection Menu
------------------------
BoardSelectionMenu = Class('BoardSelectionMenu')

--Used to choose between viewing the board, your job list, or to cancel
function BoardSelectionMenu:initialize(board_type)
  assert(self, "BoardSelectionMenu:initialize(): Error, self is nil!")
  
  --I'm bad at this. Need different menu sizes depending on the board 
  if board_type == "outlaw" then
	self.menu = RogueEssence.Menu.ScriptableMenu(24, 22, 128, 60, function(input) self:Update(input) end)
  else
  	self.menu = RogueEssence.Menu.ScriptableMenu(24, 22, 119, 60, function(input) self:Update(input) end)

  end 
  self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
  self.board_type = board_type
  
  self.current_item = 0
  self.cursor.Loc = RogueElements.Loc(9, 8)
  
  self:DrawMenu()

end

--refreshes information and draws to the menu. This is important in case there's a change to the taken board
function BoardSelectionMenu:DrawMenu()
  
  --color this red if there's no jobs and mark there's no jobs to view.
  self.board_populated = true
  local board_name = ""
  if self.board_type == "outlaw" then
	if SV.OutlawBoard[1].Client == '' then 
		board_name = "[color=#FF0000]Outlaw Notice Board[color]"
		self.board_populated = false
	else
		board_name = "Outlaw Notice Board" 
	end
  else
	if SV.MissionBoard[1].Client == '' then 
		board_name = "[color=#FF0000]Job Bulletin Board[color]"
		self.board_populated = false
	else
		board_name = "Job Bulletin Board" 
	end	
  end
  
  --color this red if there's no jobs, mark there's no jobs taken
  self.job_list = "Job List"
  self.taken_populated = true 
  if SV.TakenBoard[1].Client == "" then
	self.job_list = "[color=#FF0000]Job List[color]"
	self.taken_populated = false 
  end
  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(board_name, RogueElements.Loc(21, 8)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.job_list, RogueElements.Loc(21, 22)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Exit", RogueElements.Loc(21, 36)))

  self.menu.MenuElements:Add(self.cursor)
end 


function BoardSelectionMenu:Update(input)

 if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	if self.current_item == 0 then --open relevant job menu 
		if self.board_populated then 
			_GAME:SE("Menu/Confirm")
			local board_menu = BoardMenu:new(self.board_type, self)
			_MENU:AddMenu(board_menu.menu, false)
		else
			_GAME:SE("Menu/Cancel")
		end
	elseif self.current_item == 1 then--open taken missions
		if self.taken_populated then
			_GAME:SE("Menu/Confirm")
			local board_menu = BoardMenu:new("taken", self)
			_MENU:AddMenu(board_menu.menu, false)
		else
		    _GAME:SE("Menu/Cancel")
		end
	else 
		_GAME:SE("Menu/Cancel")
		_MENU:RemoveMenu()
	end 
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % 3
	  
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item - 1) % 3
	end
	
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(9, 8 + 14 * self.current_item)
    end
  end
end 

--How many missions are taken? Probably shoulda just had a variable that kept track, but oh well...
function MISSION_GEN.GetTakenCount()
	local count = 0
	for i = 1, 8, 1 do
		if SV.TakenBoard[i].Client == "" then 
			break 
		else
			count = count + 1 
		end 
	end 
	return count
end