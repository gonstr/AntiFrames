local AntiFrames = AntiFrames or {}

local classColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

function AntiFrames:InitFrames()
    self.unitFrames = {}

    self.partyFrame = self:CreateContainerFrame("AntiFramesParty", UIParent, 128, 250, -300, 200)
    self.arenaFrame = self:CreateContainerFrame("AntiFramesArena", UIParent, 128, 250, 200, 200)

    -- Create player frame
    self.unitFrames["player"] = self:CreateUnitFrame("AntiFramesPlayer", self.partyFrame, "player", 128, 48, 0)

    -- Create party frames
    for i = 1, 4 do
        local unit = "party" .. i
        self.unitFrames[unit] = self:CreateUnitFrame("AntiFramesParty" .. i, self.partyFrame, unit, 128, 48, i * -50)
    end

    -- Create arena frames
    for i = 1, 5 do
        local unit = "arena" .. i
        self.unitFrames[unit] = self:CreateUnitFrame("AntiFramesArena" .. i, self.arenaFrame, unit, (i - 1) * -40)
    end

    self:SetVisibility()
    self:SetClasses()
    self:SetNames()
    self:SetHealth()
    self:SetRaidIcons()
    self:SetStatus()
end

function AntiFrames:CreateUnitFrame(name, parent, unit, width, height, yOffset)
    local frame = CreateFrame("Button", name, parent, "SecureUnitButtonTemplate, BackdropTemplate")
    frame:SetSize(128, 48)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    frame.unit = unit

    -- Set the unit attribute for secure unit targeting
    frame:SetAttribute("unit", unit)
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target") -- Left-click targets the unit
    frame:SetAttribute("*type2", "focus")  -- Right-click sets the unit as focus

    -- Create a background texture for the entire frame
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.8)

    -- Create texture for the health bar
    frame.health = frame:CreateTexture(nil, "ARTWORK")
    frame.health:SetTexture(self:MediaFetch("statusbar", "Gradient"))
    frame.health:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame.health:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    frame.health:SetWidth(frame:GetWidth() - 2) -- Initial bar width
    frame.health:SetTexCoord(0, frame:GetWidth() / 32, 0, 1) -- Repeat horizontally, not vertically
    
    frame:SetBackdrop({
        edgeFile = self:MediaFetch("border", "Flat"),
        edgeSize = 1,
        tile = true,
        tileSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 } -- Set insets to 0
    })
    frame:SetBackdropBorderColor(0, 0, 0, 1) -- Transparent black color

    -- Create a raid icon texture
    frame.raidIcon = frame:CreateTexture(nil, "OVERLAY")
    frame.raidIcon:SetSize(12, 12)
    frame.raidIcon:SetPoint("TOP", frame, "TOP", 0, -2) -- Adjust Y-offset as needed
    frame.raidIcon:SetPoint("CENTER", frame, "TOP", 0, 0) -- Align to the center horizontally

    -- Create a FontString for the unit's name
    frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
    frame.name:SetFont("Fonts\\FRIZQT__.TTF", 8)
    frame.name:SetTextColor(1, 1, 1, 1) -- White color

    -- Create a FontString for the status text (e.g., Offline)
    frame.statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.statusText:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.statusText:SetFont("Fonts\\FRIZQT__.TTF", 14) -- Set the font size
    frame.statusText:SetTextColor(1, 1, 1, 1) -- White color
    frame.statusText:Hide() -- Initially hide the status text

    return frame
end

function AntiFrames:CreateContainerFrame(name, parent, width, height, xOffset, yOffset)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetSize(width, height)
    frame:SetPoint("TOPLEFT", parent, "CENTER", xOffset, yOffset)
    return frame
end

function AntiFrames:SetVisibility()
    local _, instanceType = IsInInstance()

    if true or instanceType == "arena" then
        self.partyFrame:Show()
        self.arenaFrame:Show()

        for unit, frame in pairs(self.unitFrames) do
            if UnitExists(unit) then
                frame:Show()
            else
                frame:Hide()
            end
        end
    else
        self.partyFrame:Hide()
        self.arenaFrame:Hide()
    end
end

function AntiFrames:SetClasses()
    for unit, frame in pairs(self.unitFrames) do
        if frame then
            -- Set frame color depending on class
            local _, class = UnitClass(unit)
            local color = classColors[class]
    
            if color then
                frame.health:SetVertexColor(color.r, color.g, color.b, 1)
            else
                frame.health:SetVertexColor(0, 0, 0, 0.5)
            end
        end
    end
end

function AntiFrames:SetNames()
    for unit, _ in pairs(self.unitFrames) do
        self:UpdateUnitFrameUnitName(unit)
    end
end

function AntiFrames:SetHealth()
    for unit, _ in pairs(self.unitFrames) do
        self:UpdateUnitFrameHealth(unit)
    end
end

function AntiFrames:SetRaidIcons()
    for unit, _ in pairs(self.unitFrames) do
        self:UpdateUnitFrameRaidIcon(unit)
    end
end

function AntiFrames:SetStatus()
    for unit, _ in pairs(self.unitFrames) do
        self:UpdateUnitFrameStatus(unit)
    end
end

function AntiFrames:UpdateUnitFrameHealth(unit)
    local frame = self.unitFrames[unit]
    if frame then
        local health = UnitHealth(unit)
        local maxHealth = UnitHealthMax(unit)
        
        -- Update health bar width based on health percentage
        local healthPercentage = health / maxHealth
        frame.health:SetWidth(frame:GetWidth() * healthPercentage - 2)
    end
end

function AntiFrames:UpdateUnitFrameTarget()
    for unit, frame in pairs(self.unitFrames) do
        local targetUID = UnitGUID("target")
        if targetUID and targetUID == UnitGUID(unit) then
            frame:SetBackdropBorderColor(1, 1, 1, 1)
        else
            frame:SetBackdropBorderColor(0, 0, 0, 1)
        end
    end
end

function AntiFrames:UpdateUnitFrameUnitName(unit)
    local frame = self.unitFrames[unit]
    if frame then
        local name = UnitName(unit)
        if name then
            frame.name:SetText(string.sub(name, 1, 20))
        end
    end
end

function AntiFrames:UpdateUnitFrameRaidIcon(unit)
    local frame = self.unitFrames[unit]
    if frame then
        local raidTargetIndex = GetRaidTargetIndex(unit)
        if raidTargetIndex then
            frame.raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. raidTargetIndex)
            frame.raidIcon:Show()
        else
            frame.raidIcon:Hide()
        end
    end
end

function AntiFrames:UpdateUnitFrameStatus(unit)
    local isPlayer = UnitIsUnit(unit, "player")
    if isPlayer then return end

    local frame = self.unitFrames[unit]
    if frame then
        local isConnected = UnitIsConnected(unit)
        if isConnected == false then
            frame:SetAlpha(0.5)
            frame.statusText:SetText("Offline")
            frame.statusText:Show()
        else
            frame:SetAlpha(1)
            frame.statusText:Hide()
        end
    end
end

function AntiFrames:PLAYER_ENTERING_WORLD()
    self:SetVisibility()
end

function AntiFrames:UNIT_AURA()
    self:SetStatus()
end

function AntiFrames:GROUP_ROSTER_UPDATE()
    self:SetVisibility()
    self:SetClasses()
    self:SetHealth()
    self:SetNames()
end

function AntiFrames:UNIT_NAME_UPDATE()
    self:SetVisibility()
    self:SetClasses()
    self:SetHealth()
    self:SetNames()
end

function AntiFrames:RAID_TARGET_UPDATE()
    self:SetRaidIcons()
end

function AntiFrames:UNIT_HEALTH(event, unit)
    self:UpdateUnitFrameHealth(unit)
end

function AntiFrames:PLAYER_TARGET_CHANGED()
    self:UpdateUnitFrameTarget()
end
