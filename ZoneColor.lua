local _, GuildFrame = ...

local purpleDark = "842196"
local purpleLight = "9482ca"
local pink = "e1649b"

local easternKingdoms = ""
local kalimdor = ""

local redYellowLight1 = "ab221c"
local redYellowLight2 = "ae491f"
local redYellowLight3 = "b16121"
local redYellowLight4 = "b88a29"
local redYellowLight5 = "bca42d"
local redYellowLight6 = "bfb330"

local redYellowDark1 = "9a0705"
local redYellowDark2 = "ad1a09"
local redYellowDark3 = "872700"
local redYellowDark4 = "c4410b"
local redYellowDark5 = "eaa50d"
local redYellowDark6 = "ad9700"

local blueGreenLight1 = "005c8d"
local blueGreenLight2 = "006596"
local blueGreenLight3 = "167482"
local blueGreenLight4 = "267c6b"
local blueGreenLight5 = "358448"
local blueGreenLight6 = "428d2f"

local blueGreenDark1 = "003599"
local blueGreenDark2 = "003575"
local blueGreenDark3 = "015e5e"
local blueGreenDark4 = "03692c"
local blueGreenDark5 = "0b6e12"
local blueGreenDark6 = "0c6100"

GuildFrame.zoneColor = {
    ["Tirisfal Glades"] = redYellowLight1,
    ["Western Plaguelands"] = redYellowLight1,
    ["Eastern Plaguelands"] = redYellowDark1,
    ["Ghostlands"] = redYellowDark1,
    ["Eversong Woods"] = redYellowDark1,

    ["Silverpine Forest"] = redYellowLight2,
    ["Alterac Mountains"] = redYellowLight2,
    ["Hillsbrad Foothills"] = redYellowLight2,
    ["The Hinterlands"] = redYellowDark2,
    ["Arathi Highlands"] = redYellowDark2,

    ["Wetlands"] = redYellowLight3,
    ["Loch Modan"] = redYellowDark3,
    ["Dun Morogh"] = redYellowDark3,

    ["Searing Gorge"] = redYellowLight4,
    ["Blackrock Mountain"] = redYellowDark4,
    ["Burning Steppes"] = redYellowDark4,
    ["Badlands"] = redYellowDark4,

    ["Elwynn Forest"] = redYellowLight5,
    ["Westfall"] = redYellowLight5,
    ["Duskwood"] = redYellowLight5,
    ["Redridge Mountains"] = redYellowDark5,
    ["Deadwind Pass"] = redYellowDark5,

    ["Stranglethorn Vale"] = redYellowLight6,
    ["Swamp of Sorrows"] = redYellowDark6,
    ["Blasted Lands"] = redYellowDark6,

    ["Teldrassil"] = blueGreenLight1,
    ["Azuremyst Isle"] = blueGreenLight1,
    ["Bloodmyst Isle"] = blueGreenLight1,
    ["Darkshore"] = blueGreenLight1,
    ["Moonglade"] =blueGreenDark1,
    ["Winterspring"] = blueGreenDark1,

    ["Felwood"] = blueGreenLight2,
    ["Ashenvale"] = blueGreenLight2,
    ["Azshara"] = blueGreenDark2,

    ["Stonetalon Mountains"] = blueGreenLight3,
    ["The Barrens"] = blueGreenDark3,
    ["Durotar"] = blueGreenDark3,

    ["Desolace"] = blueGreenLight4,
    ["Mulgore"] = blueGreenDark4,
    ["Dustwallow Marsh"] = blueGreenDark4,

    ["Feralas"] = blueGreenLight5,
    ["Thousand Needles"] = blueGreenDark5,

    ["Silithus"] = blueGreenLight6,
    ["Un'Goro Crater"] = blueGreenLight6,
    ["Tanaris"] = blueGreenDark6,

    ["Ragefire Chasm"] = purpleLight,
    ["Wailing Caverns"] = purpleLight,
    ["The Deadmines"] = purpleLight,
    ["Shadowfang Keep"] = purpleLight,
    ["Blackfathom Deeps"] = purpleLight,
    ["The Stockade"] = purpleLight,
    ["Gnomeregan"] = purpleLight,
    ["Razorfen Kraul"] = purpleLight,
    ["Scarlet Monastery"] = purpleLight,
    ["Razorfen Downs"] = purpleLight,
    ["Uldaman"] = purpleLight,
    ["Zul'Farrak"] = purpleLight,
    ["Maraudon"] = purpleLight,
    ["The Temple of Atal'Hakkar"] = purpleLight,
    ["Blackrock Depths"] = purpleLight,
    ["Blackrock Spire"] = purpleLight,
    ["Dire Maul"] = purpleLight,
    ["Stratholme"] = purpleLight,
    ["Scholomance"] = purpleLight,
    ["Onyxia's Lair"] = purpleDark,
    ["Zul'Gurub"] = purpleDark,
    ["Molten Core"] = purpleDark,
    ["Blackwing Lair"] = purpleDark,
    ["Ruins of Ahn'Qiraj"] = purpleDark,
    ["Ahn'Qiraj"] = purpleDark,
    ["Naxxramas"] = purpleDark,

    -- TBC Zones
    ["Hellfire Peninsula"] = "eb8559",
    ["Zangarmarsh"] = "29bab5",
    ["Terokkar Forest"] = "2bad41",
    ["Nagrand"] = "95ad2b",
    ["Blade's Edge Mountains"] = "ad842b",
    ["Netherstorm"] = "943ab0",
    ["Shadowmoon Valley"] = "00c932",

    -- TBC Instances
    ["Hellfire Ramparts"] = purpleLight,
    ["The Blood Furnace"] = purpleLight,
    ["The Shattered Halls"] = purpleLight,
    ["The Slave Pens"] = purpleLight,
    ["The Underbog"] = purpleLight,
    ["The Steamvault"] = purpleLight,
    ["Mana-Tombs"] = purpleLight,
    ["Auchenai Crypts"] = purpleLight,
    ["Sethekk Halls"] = purpleLight,
    ["Shadow Labyrinth"] = purpleLight,
    ["Old Hillsbrad Foothills"] = purpleLight,
    ["The Black Morass"] = purpleLight,
    ["The Botanica"] = purpleLight,
    ["The Mechanar"] = purpleLight,
    ["The Arcatraz"] = purpleLight,

    ["Karazhan"] = purpleDark,
    ["Magtheridon's Lair"] = purpleDark,
    ["Gruul's Lair"] = purpleDark,
    ["Serpentshrine Cavern"] = purpleDark,
    ["Tempest Keep"] = purpleDark,

    -- Cities
    ["Stormwind City"] = pink,
    ["Ironforge"] = pink,
    ["Darnassus"] = pink,
    ["The Exodar"] = pink,
    ["Shattrath City"] = pink,
    ["Orgrimmar"] = pink,
    ["Thunderbluff"] = pink,
    ["Undercity"] = pink,
    ["Silvermoon"] = pink,

    -- Cities
    ["Alterac Valley"] = "d14747",
    ["Warsong Gulch"] = "d14747",
    ["Arathi Basin"] = "d14747",
    ["Eye of the Storm"] = "d14747",
}