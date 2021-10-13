local _, GuildFrame = ...

local function white(str)
    return "|cffffffff"..str.."|r"
end

local function gray(str)
    return "|cffa0a0a0"..str.."|r"
end

local details = {}
local function Update(self)
    -- TODO: Add variant looking at all members (not only online)
    --   GetMemberCount needs to be adapted.
    -- local dbUI = GuildFrame:GetUIDB()
    local onlineMembers, onlineInitiates, onlineSocial = GuildFrame:GetMemberCount()

    wipe(details)
    if onlineMembers > 0 then
        local label = "Member"
        if onlineMembers > 1 then
            label = "Members"
        end
        tinsert(details, onlineMembers.." "..label)
    end

    if onlineInitiates > 0 then
        local label = "Initiate"
        if onlineInitiates > 1 then
            label = "Initiates"
        end
        tinsert(details, onlineInitiates.." "..label)
    end

    if onlineSocial > 0 then
        tinsert(details, onlineSocial.." ".."Social")
    end

    local total = onlineMembers + onlineInitiates + onlineSocial
    local detailsText = strjoin(", ", unpack(details))
    local text = "Online:  "..white(total).."  "..gray("("..detailsText..")")
    self.text:SetText(text)

    local playersInRaid = GuildFrame:GetRaidMemberCount()
    if playersInRaid > 0 then
        text ="|cfffa842fIn raid:|r "..white(playersInRaid)
        if total > playersInRaid then
            text = text.."  Outside: "..white(total-playersInRaid)
        end
        self.textRaid:SetText(text)
        self.textRaid:Show()
    end
end


function GuildFrame.UI.CreateGuildInfo()
    local frameName = "HHGuildFrame_UI-GuildFrame-Info"

    local frame = CreateFrame("Frame", frameName, nil, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
    frame:SetHeight(20)
    frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    frame:SetBackdropColor(0.2,0.3,0.2,1)

    frame.Update = Update

    frame.text = frame:CreateFontString(frameName.."_Text", "ARTWORK", "GameFontNormalSmall")
    frame.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetText("Online:  "..white(40).."  "..gray("(34 Members, 5 Initiates, 1 Social)"))

    frame.textRaid = frame:CreateFontString(frameName.."_Text", "ARTWORK", "GameFontNormalSmall")
    frame.textRaid:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    frame.textRaid:SetJustifyH("RIGHT")
    frame.textRaid:SetText("|cfffa842fIn raid:|r "..white(10).." Outside of raid: "..white("3"))
    frame.textRaid:Hide()

    return frame
end
