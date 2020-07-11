local addonName, GuildFrame = ...
GuildFrame = LibStub("AceAddon-3.0"):NewAddon(
    GuildFrame, addonName,
    "AceConsole-3.0",
    "AceEvent-3.0",
    "AceComm-3.0",
    "AceTimer-3.0",
    "AceSerializer-3.0"
)
_G.HHGuildFrame = GuildFrame
_G["BINDING_HEADER_HHGUILDFRAME_NAME"] = "HH Guild Frame"
_G["BINDING_NAME_HHGUILDFRAME_TOGGLE"] = "Toggle guild frame"
local BlizzGuildFrame = _G.GuildFrame

GuildFrame.version = GetAddOnMetadata(addonName, "Version")

local guildPlayersCache = {}
local guildDataCache = {}
local raidPlayersCache = {}
local altNoteWarning = {}

local function IsPlayerInGuild()
    return IsInGuild() and GetGuildInfo("player")
end

local defaults = {
    profile = {
        debugPrint = false,
        showZoneColors = true,
        ui = {
            showOffline = false,
            showMembers = true,
            showInitiates = true,
            showAlts = true,
            showSocial = true,
            hideNotInRaid = false,
            showAsMains = false,
            showInactive = true,
            inactiveDaysLimit = 30,
        },
    },
    realm = {},
}

local optionsTable = {
    type='group',
    name = "Held Hostile GuildFrame",
    desc = "An improved guild frame",
    args = {
        show = {
            type = "execute",
            name = "Show main UI",
            func = function() GuildFrame:Show() end,
            order = 1,
            width = "full",
        },
        options = {
            type='group',
            name = "Options",
            order = 2,
            args = {
                show = {
                    type = "toggle",
                    name = "Show zone colors",
                    get = function() return GuildFrame.db.profile.showZoneColors end,
                    set = function(_, v) GuildFrame.db.profile.showZoneColors = v end,
                    order = 1,
                    width = "full",
                },
            },
        },
        debug = {
            type='group',
            name = "Debug",
            order = 3,
            args = {
                debugPrint = {
                    type = "toggle",
                    name = "Enable debug messages",
                    desc = "...",
                    get = function() return GuildFrame.db.profile.debugPrint end,
                    set = function(_, v) GuildFrame.db.profile.debugPrint = v end,
                    order = 1,
                    width = "full",
                },
            },
        },
    }
}


local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
AceConfig:RegisterOptionsTable(addonName, optionsTable, { "hhgf" })
AceConfigDialog:AddToBlizOptions(addonName, "HH GuildFrame")


--[[========================================================
                        SETUP
========================================================]]--


function GuildFrame:OnInitialize()
    self:RegisterEvent("GUILD_ROSTER_UPDATE")
    self:RegisterEvent("RAID_ROSTER_UPDATE")

    self.db = LibStub("AceDB-3.0"):New("HHGuildFrameDB", defaults)
    self.ldb = LibStub("LibDataBroker-1.1"):NewDataObject("HHGuildFrame", {
        type = "data source",
        label = "Guild",
        text  = GuildFrame:LDBText(),
        OnTooltipShow = function(tooltip)
            GuildFrame:LDBShowTooltip(tooltip)
        end,
        OnClick = function(_, button)
            if (button == "LeftButton") then
                GuildFrame:Toggle()
            end
        end,
    })

    -- Return the details frame if we stole it
    BlizzGuildFrame:HookScript("OnShow", function()
        GuildFrame.UI:ReturnGuildMemberDetailFrame()
    end)
end


function GuildFrame:DPrint(...)
    if self.db.profile.debugPrint then
        self:Print(...)
    end
end


function GuildFrame:Show()
    GuildRoster()
    self.UI:Show()
    self:UpdateUI() -- Must be after Show
    self.guildUpdateTimer = self:ScheduleRepeatingTimer(function()
        GuildRoster()
    end, 11)
end


function GuildFrame:Toggle()
    if GuildFrame.UI.frame and GuildFrame.UI.frame:IsVisible() then
        GuildFrame.UI.frame:Hide()
    else
        GuildFrame:Show()
    end
end


function GuildFrame:UpdateUI()
    self:UpdateRaidCache()
    self.UI:Update(guildPlayersCache, guildDataCache, raidPlayersCache)
end


--[[========================================================
                        Events
========================================================]]--


function GuildFrame:GUILD_ROSTER_UPDATE() --( namespace, event, message, format )
    self:UpdateGuildCache()
    self:UpdateUI()
    self:LDBUpdate()
end


function GuildFrame:RAID_ROSTER_UPDATE()
    self:UpdateRaidCache()
    self:UpdateUI()
end


--[[========================================================
                        Data
========================================================]]--


function GuildFrame:GetGuildData()
    if guildDataCache and #guildDataCache > 0 then
        return guildDataCache
    else
        -- Trigger fetch new data
        GuildRoster()
        return {}
    end
end


function GuildFrame:GetUIDB()
    return self.db.profile.ui
end


function GuildFrame:GetMainName(note)
    if strfind(note, "Alt of .+") then
        local mainName = gsub(note, "Alt of ", "")
        return mainName
    end
    return nil
end


function GuildFrame:GetMainData(altData)
    if not self:IsAltRank(altData.rank) then
        return altData
    end

    if not altData.note or altData.note == "" then
        if not altNoteWarning[altData.name] then
            altNoteWarning[altData.name] = true
            self:Print("Warning: Could not find main for "..altData.name.." (Missing note)")
        end
        return altData
    end

    local main = self:GetMainName(altData.note)
    if main then
        if guildDataCache[main] then
            return guildDataCache[main]
        end
        if not altNoteWarning[altData.name] then
            altNoteWarning[altData.name] = true
            self:Print("Warning: Could not find main for "..altData.name.." ("..altData.note..")")
        end
        return altData
    end

    if not altNoteWarning[altData.name] then
        altNoteWarning[altData.name] = true
        self:Print("Warning: Could not find main for "..altData.name.." ("..altData.note..")")
    end
    return altData
end


function GuildFrame:GetMemberCount()
    self:UpdateGuildCache()
    local onlineMembers = 0
    local onlineInitiates = 0
    local onlineSocial = 0
    for _, data in pairs(guildDataCache) do
        if data.online then
            if self:IsMemberRank(data.rank) or self:IsMemberAlt(data) then
                onlineMembers = onlineMembers + 1
            elseif self:IsInitiateRank(data.rank) then
                onlineInitiates = onlineInitiates + 1
            else
                onlineSocial = onlineSocial + 1
            end
        end
    end
    return onlineMembers, onlineInitiates, onlineSocial
end


function GuildFrame:GetRaidMemberCount()
    if IsInRaid() then
        self:UpdateRaidCache()
        local raidMembers = 0
        for name in pairs(raidPlayersCache) do
            if guildDataCache[name] and guildDataCache[name].online then
                raidMembers = raidMembers + 1
            end
        end
        return raidMembers
    end
    return 0
end


function GuildFrame:UpdateGuildCache()
    if not IsPlayerInGuild() then
        self:DPrint("Not in guild")
        wipe(guildPlayersCache)
        wipe(guildDataCache)
    end

    local numTotalGuildMembers = GetNumGuildMembers();

    wipe(guildPlayersCache)
    for i = 1, numTotalGuildMembers do
        local nameRaw, rank, rankIndex, level, className, zone,
            note, officernote, online, status, class = GetGuildRosterInfo(i);

        if nameRaw then
            local name = strsplit("-", nameRaw)
            tinsert(guildPlayersCache, name)
            -- Dont create new tables
            if guildDataCache[name] then
                -- if i < 6 then self:DPrint("Update data cache for "..name) end
                guildDataCache[name].guildIndex = i
                guildDataCache[name].name = name
                guildDataCache[name].nameRaw = nameRaw
                guildDataCache[name].rank = rank
                guildDataCache[name].rankIndex = rankIndex
                guildDataCache[name].level = level
                guildDataCache[name].className = className
                guildDataCache[name].zone = zone or ""
                guildDataCache[name].note = note
                guildDataCache[name].officernote = officernote
                guildDataCache[name].online = online
                guildDataCache[name].status = status
                guildDataCache[name].class = class
                guildDataCache[name].isOnAlt = nil
                guildDataCache[name].isOnAltClass = nil
            else
                -- if i < 6 then self:DPrint("New data cache for "..name) end
                guildDataCache[name] = {
                    guildIndex = i,
                    name = name,
                    nameRaw = nameRaw,
                    rank = rank,
                    rankIndex = rankIndex,
                    level = level,
                    className = className,
                    zone = zone or "",
                    note = note,
                    officernote = officernote,
                    online = online,
                    status = status,
                    class = class
                }
            end
        else
            self:DPrint("GetGuildRosterInfo returned nil as first parameter")
            break
        end
    end

    -- self:DPrint("UpdateGuildCache", #guildPlayersCache, guildDataCache)
end


function GuildFrame:UpdateRaidCache()
    wipe(raidPlayersCache)
    if IsInRaid() then
        for i = 1, 40 do
            local name, _, _, _, class = GetRaidRosterInfo(i);
            if name then
                raidPlayersCache[name] = class
            end
        end
    end
end


function GuildFrame:ClearIsOnAlt()
    for _, data in pairs(guildDataCache) do
        if data.isOnAlt then
            data.isOnAlt = nil
            data.isOnAltClass = nil
            data.online = false
        end
    end
    self:UpdateUI()
end


--[[========================================================
                    Util
========================================================]]--


function GuildFrame:IsMemberRank(rank)
    return rank == "Member" or rank == "Officer" or rank == "Guild Master"
end


function GuildFrame:IsAltRank(rank)
    return rank == "Alt" or rank == "Officer alt"
end


function GuildFrame:IsInitiateRank(rank)
    return rank == "Initiate"
end


function GuildFrame:IsMemberAlt(data)
    if self:IsAltRank(data.rank) then
        local main = self:GetMainData(data)
        return self:IsMemberRank(main.rank)
    end
    return false
end


--[[========================================================
                    LibDataBroker
========================================================]]--


function GuildFrame:LDBShowTooltip(tooltip)
        --[[
    Display the tool tip for this LDB.
    Note: This returns
    --]]
    tooltip = tooltip or GameTooltip

    -- Show the LDB addon title in green
    tooltip:AddLine("Guild")

    tooltip:AddDoubleLine("Left click:", "|cffffffffOpen raid window|r")
    -- tooltip:AddDoubleLine("Right click:", "|cffffffffOpen options|r")

    -- local activeRolls = self:GetActiveRolls()
    -- if #activeRolls > 0 then
    --     tooltip:AddLine(" ")

    --     for _, roll in ipairs(activeRolls) do
    --         tooltip:AddDoubleLine(
    --             string.format("|c%s%s|r", RAID_CLASS_COLORS[roll.playerClass or "WARRIOR"].colorStr, roll.player),
    --             string.format("|cff888888%d  %d|r  |cffffffff%d|r", roll.roll, roll.penalty, roll.result)
    --         )
    --     end
    -- end
end


function GuildFrame:LDBUpdate()
    self.ldb.text = self:LDBText()
end


function GuildFrame:LDBText()
    local onlineMembers, onlineInitiates, onlineSocial = self:GetMemberCount()

    if onlineMembers == 0 then
        return "Not in a guild"
    end

    local text = onlineMembers + onlineInitiates

    if onlineSocial > 0 then
        text = text.." |cff888888(+"..onlineSocial..")|r"
    end

    return text
end