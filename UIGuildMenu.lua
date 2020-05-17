local _, GuildFrame = ...


local function FilterOffline()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showOffline = not dbUI.showOffline
    SetGuildRosterShowOffline(dbUI.showOffline)
    GuildFrame:UpdateUI()
end


local function FilterMember()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showMembers = not dbUI.showMembers
    GuildFrame:UpdateUI()
end


local function FilterInitiate()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showInitiates = not dbUI.showInitiates
    GuildFrame:UpdateUI()
end


local function FilterAlt()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showAlts = not dbUI.showAlts
    GuildFrame:UpdateUI()
end


local function FilterSocial()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.showSocial = not dbUI.showSocial
    GuildFrame:UpdateUI()
end


local function FilterNotInRaid()
    local dbUI = GuildFrame:GetUIDB()
    dbUI.hideNotInRaid = not dbUI.hideNotInRaid
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


local function Update(self)
    local dbUI = GuildFrame:GetUIDB()
    self.member:SetChecked(dbUI.showMembers)
    self.initiate:SetChecked(dbUI.showInitiates)
    self.alt:SetChecked(dbUI.showAlts)
    self.social:SetChecked(dbUI.showSocial)
    self.raid:SetChecked(dbUI.hideNotInRaid)
    self.mains:SetChecked(dbUI.showAsMains)
    self.offline:SetChecked(dbUI.showOffline)
end


function GuildFrame.UI.CreateGuildMenu()
    local frameName = "HHGuildFrame_UI-GuildFrame-Menu"

    local frame = CreateFrame("Frame", frameName)
    frame:ClearAllPoints()
    frame:SetHeight(20)
    frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    frame:SetBackdropColor(0.2,0.2,0.2,1)
    frame.Update = Update

    frame.offline = CreateFrame("CheckButton", frameName.."_Offline", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.offline:SetHeight(24)
    frame.offline:SetWidth(24)
    frame.offline:SetHitRectInsets(0, -50, 0, 0)
    frame.offline:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, 1)
    frame.offline:SetScript("OnClick", FilterOffline)
    frame.offline.text = frame.offline:CreateFontString(frameName.."_OfflineText", "ARTWORK", "GameFontNormalSmall")
    frame.offline.text:SetPoint("LEFT", frame.offline, "RIGHT", 0, 0)
    frame.offline.text:SetJustifyH("LEFT")
    frame.offline.text:SetText("Offline")

    frame.member = CreateFrame("CheckButton", frameName.."_Member", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.member:SetHeight(24)
    frame.member:SetWidth(24)
    frame.member:SetHitRectInsets(0, -50, 0, 0)
    frame.member:SetPoint("LEFT", frame.offline, "RIGHT", 50, 0)
    frame.member:SetScript("OnClick", FilterMember)
    frame.member.text = frame.member:CreateFontString(frameName.."_MemberText", "ARTWORK", "GameFontNormalSmall")
    frame.member.text:SetPoint("LEFT", frame.member, "RIGHT", 0, 0)
    frame.member.text:SetJustifyH("LEFT")
    frame.member.text:SetText("Member")

    frame.initiate = CreateFrame("CheckButton", frameName.."_Initiate", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.initiate:SetHeight(24)
    frame.initiate:SetWidth(24)
    frame.initiate:SetHitRectInsets(0, -40, 0, 0)
    frame.initiate:SetPoint("LEFT", frame.member, "RIGHT", 50, 0)
    frame.initiate:SetScript("OnClick", FilterInitiate)
    frame.initiate.text = frame.initiate:CreateFontString(frameName.."_InitiateText", "ARTWORK", "GameFontNormalSmall")
    frame.initiate.text:SetPoint("LEFT", frame.initiate, "RIGHT", 0, 0)
    frame.initiate.text:SetJustifyH("LEFT")
    frame.initiate.text:SetText("Initiate")

    frame.social = CreateFrame("CheckButton", frameName.."_Social", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.social:SetHeight(24)
    frame.social:SetWidth(24)
    frame.social:SetHitRectInsets(0, -35, 0, 0)
    frame.social:SetPoint("LEFT", frame.initiate, "RIGHT", 42, 0)
    frame.social:SetScript("OnClick", FilterSocial)
    frame.social.text = frame.social:CreateFontString(frameName.."_SocialText", "ARTWORK", "GameFontNormalSmall")
    frame.social.text:SetPoint("LEFT", frame.social, "RIGHT", 0, 0)
    frame.social.text:SetJustifyH("LEFT")
    frame.social.text:SetText("Social")

    frame.alt = CreateFrame("CheckButton", frameName.."_Alt", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.alt:SetHeight(24)
    frame.alt:SetWidth(24)
    frame.alt:SetHitRectInsets(0, -20, 0, 0)
    frame.alt:SetPoint("LEFT", frame.social, "RIGHT", 40, 0)
    frame.alt:SetScript("OnClick", FilterAlt)
    frame.alt.text = frame.alt:CreateFontString(frameName.."_AltText", "ARTWORK", "GameFontNormalSmall")
    frame.alt.text:SetPoint("LEFT", frame.alt, "RIGHT", 0, 0)
    frame.alt.text:SetJustifyH("LEFT")
    frame.alt.text:SetText("Alt")

    frame.raid = CreateFrame("CheckButton", frameName.."_Raid", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.raid:SetHeight(24)
    frame.raid:SetWidth(24)
    frame.raid:SetHitRectInsets(0, -60, 0, 0)
    frame.raid:SetPoint("LEFT", frame.alt, "RIGHT", 25, 0)
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
    -- frame.mains.text:SetText("|cff777777Show as main|r")
    -- frame.mains:SetEnabled(false)

    return frame
end
