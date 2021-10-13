local _, GuildFrame = ...
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

local function FilterOffline()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showOffline = not dbUI.showOffline
    SetGuildRosterShowOffline(dbUI.showOffline)
    GuildFrame:UpdateUI()
end


local function FilterNotInRaid()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.hideNotInRaid = not dbUI.hideNotInRaid
    GuildFrame:UpdateUI()
end


local function FilterInactive()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showInactive = not dbUI.showInactive
    GuildFrame:UpdateUI()
end


local function FilterShowAsMain()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showAsMains = not dbUI.showAsMains
    if dbUI.showAsMains == false then
        GuildRoster()
        GuildFrame:ClearIsOnAlt()
    end
    GuildFrame:UpdateUI()
end


local function RoleFilterTitle()
    local dbUI = GuildFrame:GetUIDB()
    local count = 0
    if dbUI.showMembers then
        count = count + 1
    end
    if dbUI.showInitiates then
        count = count + 1
    end
    if dbUI.showSocial then
        count = count + 1
    end
    if dbUI.showAlts then
        count = count + 1
    end

    if count == 4 then
        return "Roles: All"
    end
    return "Roles: "..count.."/4"
end


local function Update(self)
    local dbUI = GuildFrame:GetUIDB()
    self.raid:SetChecked(dbUI.hideNotInRaid)
    self.mains:SetChecked(dbUI.showAsMains)
    self.offline:SetChecked(dbUI.showOffline)
    self.inactive:SetChecked(dbUI.showInactive)
    RoleFilterTitle()
end


local function RoleFilterDropDownSelect(_, arg1)
    local dbUI = GuildFrame:GetUIDB()
    dbUI[arg1] = not dbUI[arg1]
    LibDD:UIDropDownMenu_SetText(GuildFrame.UI.frame.guildMenu.roleFilter, RoleFilterTitle())
    GuildFrame:UpdateUI()
end


local function RoleFilterDropDownMenu()
    local info = LibDD:UIDropDownMenu_CreateInfo()
    local dbUI = GuildFrame:GetUIDB()
    info.func = RoleFilterDropDownSelect
    info.keepShownOnClick = true
    info.isNotRadio = true

    info.text = "Member"
    info.arg1 = "showMembers"
    info.checked = dbUI[info.arg1]
    LibDD:UIDropDownMenu_AddButton(info)

    info.text = "Initiate"
    info.arg1 = "showInitiates"
    info.checked = dbUI[info.arg1]
    LibDD:UIDropDownMenu_AddButton(info)

    info.text = "Social"
    info.arg1 = "showSocial"
    info.checked = dbUI[info.arg1]
    LibDD:UIDropDownMenu_AddButton(info)

    info.text = "Alt"
    info.arg1 = "showAlts"
    info.checked = dbUI[info.arg1]
    LibDD:UIDropDownMenu_AddButton(info)
end


function GuildFrame.UI.CreateGuildMenu()
    local frameName = "HHGuildFrame_UI-GuildFrame-Menu"

    local frame = CreateFrame("Frame", frameName)
    frame:ClearAllPoints()
    frame:SetHeight(28)
    frame.Update = Update

    frame.offline = CreateFrame("CheckButton", frameName.."_Offline", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.offline:SetHeight(24)
    frame.offline:SetWidth(24)
    frame.offline:SetHitRectInsets(0, -50, 0, 0)
    frame.offline:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame.offline:SetScript("OnClick", FilterOffline)
    frame.offline.text = frame.offline:CreateFontString(frameName.."_OfflineText", "ARTWORK", "GameFontNormalSmall")
    frame.offline.text:SetPoint("LEFT", frame.offline, "RIGHT", 0, 0)
    frame.offline.text:SetJustifyH("LEFT")
    frame.offline.text:SetText("Offline")

    frame.roleFilter = LibDD:Create_UIDropDownMenu(frameName.."_RoleFilter", frame)
    frame.roleFilter:SetParent(frame)
    frame.roleFilter:SetPoint("TOPLEFT", frame.offline, "TOPRIGHT", 30, 2)
    LibDD:UIDropDownMenu_SetWidth(frame.roleFilter, 100)
    LibDD:UIDropDownMenu_SetText(frame.roleFilter, RoleFilterTitle())
    LibDD:UIDropDownMenu_Initialize(frame.roleFilter, RoleFilterDropDownMenu)

    frame.raid = CreateFrame("CheckButton", frameName.."_Raid", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.raid:SetHeight(24)
    frame.raid:SetWidth(24)
    frame.raid:SetHitRectInsets(0, -60, 0, 0)
    frame.raid:SetPoint("LEFT", frame.roleFilter, "RIGHT", 0, 2)
    frame.raid:SetScript("OnClick", FilterNotInRaid)
    frame.raid.text = frame.raid:CreateFontString(frameName.."_RaidText", "ARTWORK", "GameFontNormalSmall")
    frame.raid.text:SetPoint("LEFT", frame.raid, "RIGHT", 0, 0)
    frame.raid.text:SetJustifyH("LEFT")
    frame.raid.text:SetText("Not in raid")

    frame.mains = CreateFrame("CheckButton", frameName.."_Mains", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.mains:SetHeight(24)
    frame.mains:SetWidth(24)
    frame.mains:SetHitRectInsets(0, -75, 0, 0)
    frame.mains:SetPoint("LEFT", frame.raid, "RIGHT", 65, 0)
    frame.mains:SetScript("OnClick", FilterShowAsMain)
    frame.mains.text = frame.mains:CreateFontString(frameName.."_MainsText", "ARTWORK", "GameFontNormalSmall")
    frame.mains.text:SetPoint("LEFT", frame.mains, "RIGHT", 0, 0)
    frame.mains.text:SetJustifyH("LEFT")
    frame.mains.text:SetText("Show as main")

    frame.inactive = CreateFrame("CheckButton", frameName.."_Inactive", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.inactive:SetHeight(24)
    frame.inactive:SetWidth(24)
    frame.inactive:SetHitRectInsets(0, -75, 0, 0)
    frame.inactive:SetPoint("LEFT", frame.mains, "RIGHT", 75, 0)
    frame.inactive:SetScript("OnClick", FilterInactive)
    frame.inactive.text = frame.inactive:CreateFontString(frameName.."_InactiveText", "ARTWORK", "GameFontNormalSmall")
    frame.inactive.text:SetPoint("LEFT", frame.inactive, "RIGHT", 0, 0)
    frame.inactive.text:SetJustifyH("LEFT")
    frame.inactive.text:SetText("Inactive")

    return frame
end
