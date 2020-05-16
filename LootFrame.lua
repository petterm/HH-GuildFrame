local _, Wishlist = ...

Wishlist.UI = {}


local function Update(self, lootList, playerData)
end


function Wishlist.UI.CreateLootFrame()
    local frameName = "HHWishlist_UI-LootFrame"

    local scrollFrameName = frameName.."-ScrollFrame"
    local scrollFrame = CreateFrame("ScrollFrame", scrollFrameName, nil, "UIPanelScrollFrameTemplate")
    scrollFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    scrollFrame:SetBackdropColor(0,0,0,1)
    scrollFrame:ClearAllPoints()
    scrollFrame:SetWidth(570)
    scrollFrame:SetHeight(550)

    scrollFrame.scrollChild = CreateFrame("Frame", frameName)
    scrollFrame.scrollChild:SetWidth(570)
    scrollFrame.scrollChild:SetHeight(550)

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
    scrollFrame.rows = {}

    return scrollFrame
end
