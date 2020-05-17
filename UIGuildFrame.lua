local _, GuildFrame = ...

local ROW_HEIGHT = 20


-- Rank > (Class) > Level > Name
-- Return true for a to be before b
local function guildPlayerSort(dataA, dataB)
    if dataA.rankIndex == dataB.rankIndex then
        -- if dataA.class == dataB.class then
            if dataA.level == dataB.level then
                return dataA.name < dataB.name
            else
                return dataA.level > dataB.level
            end
        -- else
        --     return dataA.class < dataB.class
        -- end
    else
        return dataA.rankIndex < dataB.rankIndex
    end
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
        local raidCheck = not (IsInRaid() and dbUI.hideNotInRaid and
            (raidData[data.name] or raidData[mainData.name]))

        if memberCheck and altCheck and initiateCheck and socialCheck and offlineCheck and raidCheck then
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
                self.rows[currentRow]:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 5, 0)
            else
                self.rows[currentRow]:SetPoint("TOPLEFT", self.rows[currentRow - 1].frame, "BOTTOMLEFT", 0, 0)
            end
        end
    end

    if dbUI.showAsMains then
        for i = 1, #visibleRows do
            if GuildFrame:IsAltRank(visibleRows[i].rank) then
                local mainData = GuildFrame:GetMainData(visibleRows[i])
                -- Multiboxers..
                if not mainData.online then
                    local alt = visibleRows[i].name
                    visibleRows[i] = mainData
                    visibleRows[i].isOnAlt = alt
                    visibleRows[i].isOnAltClass = guildData[alt].class
                    visibleRows[i].online = true
                end
            end
        end
    end

    table.sort(visibleRows, guildPlayerSort)

    -- For loot in db
    local height = 10
    for i = 1, #self.rows do
        local currentRow = self.rows[i]
        -- update row
        if i <= playerCount then
            currentRow:Update(visibleRows[i], raidData)
            currentRow:Show()
            height = height + ROW_HEIGHT

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

