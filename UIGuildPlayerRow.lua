local _, GuildFrame = ...
local BlizzGuildFrame = _G.GuildFrame

local classColorDark = {
    DRUID = "ff803e05",
    HUNTER = "ff556938",
    MAGE = "ff206375",
    PALADIN = "ff804960",
    PRIEST = "ff808080",
    ROGUE = "ff807a34",
    WARLOCK = "ff434375",
    WARRIOR = "ff634e37",
}

-- Modified version of blizzard code
-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/classic/Interface/FrameXML/FriendsFrame.lua#L2677
local function BlizzGuildStatus_Update()
    local fullName, rank, rankIndex, level, class, zone, note, officernote, online;
    local _, _, guildRankIndex = GetGuildInfo("player");
    local maxRankIndex = GuildControlGetNumRanks() - 1;

    -- Get selected guild member info
    fullName, rank, rankIndex, level, class, zone,
        note, officernote, online = GetGuildRosterInfo(GetGuildRosterSelection());
    BlizzGuildFrame.selectedName = fullName;
    -- If there's a selected guildmember
    if ( GetGuildRosterSelection() > 0 ) then
        local displayedName = Ambiguate(fullName, "guild");
        -- Update the guild member details frame
        GuildMemberDetailName:SetText(displayedName);
        GuildMemberDetailLevel:SetText(format(FRIENDS_LEVEL_TEMPLATE, level, class));
        GuildMemberDetailZoneText:SetText(zone);
        GuildMemberDetailRankText:SetText(rank);
        if ( online ) then
            GuildMemberDetailOnlineText:SetText(GUILD_ONLINE_LABEL);
        else
            GuildMemberDetailOnlineText:SetText(GuildFrame_GetLastOnline(GetGuildRosterSelection()));
        end
        -- Update public note
        if ( CanEditPublicNote() ) then
            PersonalNoteText:SetTextColor(1.0, 1.0, 1.0);
            if ( (not note) or (note == "") ) then
                note = GUILD_NOTE_EDITLABEL;
            end
        else
            PersonalNoteText:SetTextColor(0.65, 0.65, 0.65);
        end
        GuildMemberNoteBackground:EnableMouse(CanEditPublicNote());
        PersonalNoteText:SetText(note);
        -- Update officer note
        if ( CanViewOfficerNote() ) then
            if ( CanEditOfficerNote() ) then
                if ( (not officernote) or (officernote == "") ) then
                    officernote = GUILD_OFFICERNOTE_EDITLABEL;
                end
                OfficerNoteText:SetTextColor(1.0, 1.0, 1.0);
            else
                OfficerNoteText:SetTextColor(0.65, 0.65, 0.65);
            end
            GuildMemberOfficerNoteBackground:EnableMouse(CanEditOfficerNote());
            OfficerNoteText:SetText(officernote);

            -- Resize detail frame
            GuildMemberDetailOfficerNoteLabel:Show();
            GuildMemberOfficerNoteBackground:Show();
            GuildMemberDetailFrame:SetHeight(GUILD_DETAIL_OFFICER_HEIGHT);
        else
            GuildMemberDetailOfficerNoteLabel:Hide();
            GuildMemberOfficerNoteBackground:Hide();
            GuildMemberDetailFrame:SetHeight(GUILD_DETAIL_NORM_HEIGHT);
        end

        -- Manage guild member related buttons
        if ( CanGuildPromote() and ( rankIndex > 1 ) and ( rankIndex > (guildRankIndex + 1) ) ) then
            GuildFramePromoteButton:Enable();
        else
            GuildFramePromoteButton:Disable();
        end
        if ( CanGuildDemote() and ( rankIndex >= 1 ) and ( rankIndex > guildRankIndex ) and
            ( rankIndex ~= maxRankIndex ) ) then
            GuildFrameDemoteButton:Enable();
        else
            GuildFrameDemoteButton:Disable();
        end
        -- Hide promote/demote buttons if both disabled
        if ( not GuildFrameDemoteButton:IsEnabled() and not GuildFramePromoteButton:IsEnabled() ) then
            GuildFramePromoteButton:Hide();
            GuildFrameDemoteButton:Hide();
            GuildMemberDetailRankText:SetPoint("RIGHT", "GuildMemberDetailFrame", "RIGHT", -10, 0);
        else
            GuildFramePromoteButton:Show();
            GuildFrameDemoteButton:Show();
            GuildMemberDetailRankText:SetPoint("RIGHT", "GuildFramePromoteButton", "LEFT", 3, 0);
        end
        if ( CanGuildRemove() and ( rankIndex >= 1 ) and ( rankIndex > guildRankIndex ) ) then
            GuildMemberRemoveButton:Enable();
        else
            GuildMemberRemoveButton:Disable();
        end
        if ( (UnitName("player") == displayedName) or (not online) ) then
            GuildMemberGroupInviteButton:Disable();
        else
            GuildMemberGroupInviteButton:Enable();
        end

        BlizzGuildFrame.selectedName = GetGuildRosterInfo(GetGuildRosterSelection());
    end
end

-- Modified version of blizzard code
-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/classic/Interface/FrameXML/FriendsFrame.lua#L2653
local function BlizzGuildOnClick(guildIndex, name)
    BlizzGuildFrame.previousSelectedGuildMember = BlizzGuildFrame.selectedGuildMember;
    BlizzGuildFrame.selectedGuildMember = guildIndex;
    BlizzGuildFrame.selectedName = name
    SetGuildRosterSelection(BlizzGuildFrame.selectedGuildMember);
    -- Toggle guild details frame
    if ( GuildMemberDetailFrame:IsVisible() and BlizzGuildFrame.previousSelectedGuildMember and
        BlizzGuildFrame.previousSelectedGuildMember == BlizzGuildFrame.selectedGuildMember ) then
        GuildMemberDetailFrame:Hide();
        GuildFrame.UI:ReturnGuildMemberDetailFrame()
        BlizzGuildFrame.selectedGuildMember = 0;
        SetGuildRosterSelection(0);
    else
        GuildFrame.UI:StealGuildMemberDetailFrame()
        GuildMemberDetailFrame:Show();
    end
    BlizzGuildStatus_Update()
end


local function OnClick(self, button)
    if button == "LeftButton" then
        BlizzGuildOnClick(self.guildIndex, self.nameRaw)
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
        self.frame.zone:SetText(playerData.zone)
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
