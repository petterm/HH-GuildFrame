local _, GuildFrame = ...

local ROW_HEIGHT = 20


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
    GuildFrame:UpdateUI()
end


local function UpdateMenu(self)
    local dbUI = GuildFrame:GetUIDB()
    self.member:SetChecked(dbUI.showMembers)
    self.initiate:SetChecked(dbUI.showInitiates)
    self.alt:SetChecked(dbUI.showAlts)
    self.social:SetChecked(dbUI.showSocial)
    self.raid:SetChecked(dbUI.hideNotInRaid)
    self.mains:SetChecked(dbUI.showAsMains)
    self.offline:SetChecked(dbUI.showOffline)
end


local visibleRows = {}
local function Update(self, guildPlayers, guildData, raidData)
    local exisitingRows = #self.rows
    local dbUI = GuildFrame:GetUIDB()

    wipe(visibleRows)
    for _, name in ipairs(guildPlayers) do
        local data = guildData[name]
        local offlineCheck = dbUI.showOffline or data.online
        local altCheck = dbUI.showAlts or not GuildFrame:IsAltRank(data.rank)

        -- Check rank of main if this is an alt character
        local mainData = GuildFrame:GetMainData(data)
        local memberCheck = dbUI.showMembers or not GuildFrame:IsMemberRank(mainData.rank)
        local initiateCheck = dbUI.showInitiates or mainData.rank ~= "Initiate"
        local socialCheck = dbUI.showSocial or mainData.rank ~= "Social"

        if memberCheck and altCheck and initiateCheck and socialCheck and offlineCheck then
            tinsert(visibleRows, data)
        end
    end

    local playerCount = #visibleRows
    local missingRows = playerCount - exisitingRows
    if missingRows > 0 then
        for i = 1, missingRows do
            local currentRow = exisitingRows + i
            self.rows[currentRow] = GuildFrame.UI.CreateGuildPlayerRow()
            self.rows[currentRow]:SetHeight(ROW_HEIGHT)
            self.rows[currentRow]:SetWidth(510)
            self.rows[currentRow]:SetParent(self.scrollChild)

            if currentRow == 1 then
                self.rows[currentRow]:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 5, -5)
            else
                self.rows[currentRow]:SetPoint("TOPLEFT", self.rows[currentRow - 1].frame, "BOTTOMLEFT", 0, 0)
            end
        end
    end

    -- For loot in db
    local height = 15
    for i = 1, #self.rows do
        local currentRow = self.rows[i]
        -- update row
        if i <= playerCount then
            currentRow:Update(visibleRows[i], raidData)
            currentRow:Show()

            -- if raidLootData[i].bossKill and (i == 1 or raidLootData[i].bossKill ~= raidLootData[i-1].bossKill) then
            --     height = height + ROW_HEIGHT + 15
            --     currentRow:SetHeight(ROW_HEIGHT + 15)
            --     currentRow.frame.prefix.title:SetText("|cffaaaaaa"..raidLootData[i].bossKill.."|r")
            --     currentRow.frame.prefix:Show()
            -- else
            --     height = height + ROW_HEIGHT
            --     currentRow:SetHeight(ROW_HEIGHT)
            --     currentRow.frame.prefix:Hide()
            -- end
        else
            currentRow:Hide()
        end
    end
    self.scrollChild:SetHeight(math.max(height, self:GetHeight()))
end


function GuildFrame.UI.CreateGuildMenu()
    local frameName = "HHGuildFrame_UI-GuildFrame-Menu"

    local frame = CreateFrame("Frame", frameName)
    frame:ClearAllPoints()
    frame:SetHeight(20)
    frame.Update = UpdateMenu

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
    frame.raid.text:SetText("|cff777777Not in raid|r")
    frame.raid:SetEnabled(false)

    frame.mains = CreateFrame("CheckButton", frameName.."_Mains", frame, "ChatConfigBaseCheckButtonTemplate")
    frame.mains:SetHeight(24)
    frame.mains:SetWidth(24)
    frame.mains:SetHitRectInsets(0, -75, 0, 0)
    frame.mains:SetPoint("LEFT", frame.raid, "RIGHT", 65, 0)
    frame.mains:SetScript("OnClick", FilterShowAsMain)
    frame.mains.text = frame.mains:CreateFontString(frameName.."_MainsText", "ARTWORK", "GameFontNormalSmall")
    frame.mains.text:SetPoint("LEFT", frame.mains, "RIGHT", 0, 0)
    frame.mains.text:SetJustifyH("LEFT")
    frame.mains.text:SetText("|cff777777Show as main|r")
    frame.mains:SetEnabled(false)

    return frame
end


function GuildFrame.UI.CreateGuildFrame()
    local frameName = "HHGuildFrame_UI-GuildFrame"

    local scrollFrameName = frameName.."-ScrollFrame"
    local scrollFrame = CreateFrame("ScrollFrame", scrollFrameName, nil, "UIPanelScrollFrameTemplate")
    scrollFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    scrollFrame:SetBackdropColor(0,0,0,1)
    scrollFrame:ClearAllPoints()
    scrollFrame:SetWidth(520)
    scrollFrame:SetHeight(480)

    scrollFrame.scrollChild = CreateFrame("Frame", frameName)
    scrollFrame.scrollChild:SetWidth(520)
    scrollFrame.scrollChild:SetHeight(480)

    scrollFrame.scrollupbutton = _G[scrollFrameName.."ScrollBarScrollUpButton"];
    scrollFrame.scrollupbutton:ClearAllPoints();
    scrollFrame.scrollupbutton:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -2);

    scrollFrame.scrolldownbutton = _G[scrollFrameName.."ScrollBarScrollDownButton"];
    scrollFrame.scrolldownbutton:ClearAllPoints();
    scrollFrame.scrolldownbutton:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 2);

    scrollFrame.scrollbar = _G[scrollFrameName.."ScrollBar"];
    scrollFrame.scrollbar:ClearAllPoints();
    scrollFrame.scrollbar:SetPoint("TOP", scrollFrame.scrollupbutton, "BOTTOM", 0, -2);
    scrollFrame.scrollbar:SetPoint("BOTTOM", scrollFrame.scrolldownbutton, "TOP", 0, 2);

    scrollFrame:SetScrollChild(scrollFrame.scrollChild)

    scrollFrame.Update = Update
    -- scrollFrame.ScrollToBottom = ScrollToBottom
    scrollFrame.rows = {}

    return scrollFrame
end

