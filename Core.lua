AntiFrames = LibStub("AceAddon-3.0"):NewAddon("AntiFrames", "AceConsole-3.0", "AceEvent-3.0")

-- AceDB defaults
AntiFrames.defaults = {
    profile = {
        hideBlizPartyFrame = true,
        hideBlizArenaFrame = true,
    },
}

function AntiFrames:OnInitialize()
    self:InitDB() 
    self:InitMedia()
    self:InitOptions()
    self:InitFrames()
end

function AntiFrames:OnEnable()
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:RegisterEvent("UNIT_NAME_UPDATE")
    self:RegisterEvent("RAID_TARGET_UPDATE")
    self:RegisterEvent("UNIT_AURA")
end

function AntiFrames:OnDisable()
    self:UnregisterEvent("PLAYER_LOGIN")
    self:UnregisterEvent("UNIT_HEALTH")
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    self:UnregisterEvent("UNIT_NAME_UPDATE")
    self:UnregisterEvent("RAID_TARGET_UPDATE")
    self:UnregisterEvent("UNIT_AURA")
end

function AntiFrames:InitDB()
    self.db = LibStub("AceDB-3.0"):New("AntiFrames", self.defaults)
end

function AntiFrames:InitMedia()
	local media = LibStub("LibSharedMedia-3.0", true)
	media:Register("statusbar", "Gradient", "Interface\\Addons\\AntiFrames\\Media\\gradient32x32.tga")
    media:Register("border", "Flat", "Interface\\Addons\\AntiFrames\\Media\\white16x16.tga")
end

function AntiFrames:PLAYER_LOGIN(event, isInitialLogin, isReloadingUi)
    --self:Print("Anti Frames loaded. open options with /af")
end
