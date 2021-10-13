local _, GuildFrame = ...
local BlizzGuildFrame = _G.GuildFrame

local classColorDark = {
    DRUID = "ff803e05",
    HUNTER = "ff556938",
    MAGE = "ff206375",
    PALADIN = "ff804960",
    PRIEST = "ff808080",
    ROGUE = "ff807a34",
    SHAMAN = "ff003870",
    WARLOCK = "ff434375",
    WARRIOR = "ff634e37",
}



local function OnClick(self, button)
    if button == "LeftButton" then
        -- TODO: Show member info
    elseif button == "RightButton" then
        FriendsFrame_ShowDropdown(self.name, true)
    end
end

local function SetParent(self, parent)
    self.frame:SetParent(parent)
end

local function SetPoint(self, ...)
    self.frame:SetPoint(...)
end

local function SetWidth(self, ...)
    self.frame:SetWidth(...)
end

local function SetHeight(self, ...)
    self.frame:SetHeight(...)
end

local function Show(self, ...)
    self.frame:Show(...)
end

local function Hide(self, ...)
    self.frame:Hide(...)
end

local function Update(self, playerData, raidData)
    if playerData.online then
        local classColor = "ffaaaaaa" --n!!
        if playerData.class then
            classColor = RAID_CLASS_COLORS[playerData.class].colorStr
        end

        local name = playerData.name
        local altName = ""
        if raidData[name] then
            name = "|cfffa842f"..name.."|r"
        end
        if playerData.isOnAlt then
            altName = " |c"..classColorDark[playerData.isOnAltClass]..playerData.isOnAlt.."|r"
        end

        self.frame.name:SetText(name..altName)
        self.frame.class:SetText("|c"..classColor..playerData.className.."|r")
        self.frame.level:SetText(playerData.level)
        if GuildFrame.db.profile.showZoneColors then
            local zoneColor = GuildFrame.zoneColor[playerData.zone] or "b0b0b0"
            self.frame.zone:SetText("|cff"..zoneColor..playerData.zone.."|r")
        else
            self.frame.zone:SetText(playerData.zone)
        end
    else
        local offlineColor = "ff808080"
        local classColor = offlineColor
        if playerData.class then
            classColor = classColorDark[playerData.class]
        end

        self.frame.name:SetText("|c"..offlineColor..playerData.name.."|r")
        self.frame.class:SetText("|c"..classColor..playerData.className.."|r")
        self.frame.level:SetText("|c"..offlineColor..playerData.level.."|r")
        self.frame.zone:SetText("|c"..offlineColor..playerData.zone.."|r")

    end

    self.guildIndex = playerData.guildIndex
    self.name = playerData.name
    self.frame.rank:SetText(playerData.rank)
    if GuildFrame:IsAltRank(playerData.rank) then
        self.frame.main:SetText(GuildFrame:GetMainName(playerData.note) or "-")
    else
        self.frame.main:SetText("-")
    end
end

local ROW_COUNT = 0
function GuildFrame.UI.CreateGuildPlayerRow()
    ROW_COUNT = ROW_COUNT + 1
    local frameName = "HHGuildFrame_UI-GuildFrameRow-"..ROW_COUNT
    local self = {}

    self.Update = Update
    self.SetParent = SetParent
    self.SetPoint = SetPoint
    self.SetWidth = SetWidth
    self.SetHeight = SetHeight
    self.Show = Show
    self.Hide = Hide

    self.frame = CreateFrame("Button", frameName)
    local frame = self.frame
    frame:SetScript("OnClick", function(_, button) OnClick(self, button) end)
    frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    frame:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

    frame.name = frame:CreateFontString(frameName.."_Name", "ARTWORK", "GameFontNormalSmall")
    frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -4)
    frame.name:SetJustifyH("LEFT")
    frame.name:SetText("[Player name]")
    -- frame.name:SetTextColor(0.9, 0.9, 0.9)
    frame.name:SetHeight(12)
    frame.name:SetWidth(100)

    frame.class = frame:CreateFontString(frameName.."_Class", "ARTWORK", "GameFontNormalSmall")
    frame.class:SetPoint("LEFT", frame.name, "RIGHT", 6, 0)
    frame.class:SetJustifyH("LEFT")
    frame.class:SetText("[Class]")
    frame.class:SetHeight(12)
    frame.class:SetWidth(60)

    frame.level = frame:CreateFontString(frameName.."_Level", "ARTWORK", "GameFontNormalSmall")
    frame.level:SetPoint("LEFT", frame.class, "RIGHT", 6, 0)
    frame.level:SetJustifyH("CENTER")
    frame.level:SetText("00")
    frame.level:SetTextColor(0.9, 0.9, 0.9)
    frame.level:SetHeight(12)
    frame.level:SetWidth(20)

    frame.zone = frame:CreateFontString(frameName.."_Zone", "ARTWORK", "GameFontNormalSmall")
    frame.zone:SetPoint("LEFT", frame.level, "RIGHT", 6, 0)
    frame.zone:SetJustifyH("LEFT")
    frame.zone:SetText("[Zone]")
    frame.zone:SetTextColor(0.9, 0.9, 0.9)
    frame.zone:SetHeight(12)
    frame.zone:SetWidth(110)

    frame.rank = frame:CreateFontString(frameName.."_Rank", "ARTWORK", "GameFontNormalSmall")
    frame.rank:SetPoint("LEFT", frame.zone, "RIGHT", 6, 0)
    frame.rank:SetJustifyH("LEFT")
    frame.rank:SetText("[Rank]")
    frame.rank:SetTextColor(0.5, 0.5, 0.5)
    frame.rank:SetHeight(12)
    frame.rank:SetWidth(80)

    frame.main = frame:CreateFontString(frameName.."_Main", "ARTWORK", "GameFontNormalSmall")
    frame.main:SetPoint("LEFT", frame.rank, "RIGHT", 6, 0)
    frame.main:SetJustifyH("LEFT")
    frame.main:SetText("[Main]")
    frame.main:SetTextColor(0.5, 0.5, 0.5)
    frame.main:SetHeight(12)
    frame.main:SetWidth(60)

    return self
end
