local _, GuildFrame = ...

GuildFrame.UI = {}
local UI_CREATED = false


local function FrameOnDragStart(self, arg1)
    if arg1 == "LeftButton" then
        self:StartMoving()
    end
end


local function FrameOnDragStop(self)
    self:StopMovingOrSizing()
end


function GuildFrame.UI:Update(guildPlayers, guildData, raidData)
    if not UI_CREATED or not self.frame:IsVisible() then
        return
    end
    self.frame.guildMenu:Update()
    self.frame.guildInfo:Update()
    self.frame.guildFrame:Update(guildPlayers, guildData, raidData)
end


function GuildFrame.UI:Create()
    if UI_CREATED then return end
    UI_CREATED = true

    local frameName = "HHGuildFrame_UI"

    local frame = CreateFrame("Frame", frameName)
    frame:SetParent(UIParent)
    frame:SetPoint("CENTER")
    frame:SetHeight(568)
    frame:SetWidth(540)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton", "RightButton")
    frame:SetScript("OnMouseDown", FrameOnDragStart)
    frame:SetScript("OnMouseUp", FrameOnDragStop)
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    frame:SetBackdropColor(0.45,0.45,0.45,1)
    frame:Hide()
    tinsert(UISpecialFrames, frameName)	-- allow ESC close

    frame.CloseButton = CreateFrame("Button", frameName.."-CloseButton", frame, "UIPanelCloseButton")
    frame.CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

    frame.titleFrame = CreateFrame("Frame")
    frame.titleFrame:ClearAllPoints()
    frame.titleFrame:SetParent(frame)
    frame.titleFrame:SetPoint("TOPLEFT", frame, 10, -7)
    frame.titleFrame:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -30, -25)

    frame.titleFrame.text = frame.titleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    frame.titleFrame.text:SetAllPoints(frame.titleFrame)
    frame.titleFrame.text:SetJustifyH("CENTER")
    frame.titleFrame.text:SetText("Guild")

    frame.titleFrame.version = frame.titleFrame:CreateFontString(nil, "ARTWORK")
    frame.titleFrame.version:SetPoint("BOTTOMRIGHT", frame.titleFrame, "BOTTOMRIGHT", -5, 1)
    frame.titleFrame.version:SetTextColor(1, 1, 1, 0.5)
    frame.titleFrame.version:SetSize(150, 10)
    frame.titleFrame.version:SetFont(_G["SystemFont_Tiny"]:GetFont(), 10)
    frame.titleFrame.version:SetJustifyH("RIGHT")
    frame.titleFrame.version:SetJustifyV("BOTTOM")
    frame.titleFrame.version:SetText("v"..GuildFrame.version)

    frame.guildMenu = GuildFrame.UI.CreateGuildMenu()
    frame.guildMenu:ClearAllPoints()
    frame.guildMenu:SetParent(frame)
    frame.guildMenu:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -28)
    frame.guildMenu:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -10, -48)

    frame.guildInfo = GuildFrame.UI.CreateGuildInfo()
    frame.guildInfo:ClearAllPoints()
    frame.guildInfo:SetParent(frame)
    frame.guildInfo:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
    frame.guildInfo:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)

    frame.guildFrame = GuildFrame.UI.CreateGuildFrame()
    frame.guildFrame:ClearAllPoints()
    frame.guildFrame:SetParent(frame)
    frame.guildFrame:SetPoint("BOTTOMLEFT", frame.guildInfo, "TOPLEFT", 0, 5)

    self.frame = frame

    return frame
end


function GuildFrame.UI:Show()
    self:Create()
    self.frame:Show()
end

