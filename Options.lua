local AntiFrames = AntiFrames

local getOpt, setOpt
do
	function getOpt(info)
		local key = info[#info]
		return AntiFrames.db.profile[key]
	end

	function setOpt(info, value)
		local key = info[#info]
		AntiFrames.db.profile[key] = value
		AntiFrames:ApplyOptions()
	end
end

local options = {
    type = 'group',
    args = {
        unlock = {
            type = "execute",
            name = "Toggle Frame Lock",
            desc = "Unlock the Frames to be able to move them around.",
            func = function()
                AntiFrames:ToggleLock(true)
            end,
            order = 1,
        },
        hideBlizPartyFrame = {
            type = "toggle",
            name = "Hide Blizzard Party Frame",
            desc = "Hide the standard Blizzard Party frame while in the Arena.",
            order = 2,
            width = "full",
            get = getOpt,
            set = setOpt,
        },
        hideBlizArenaFrame = {
            type = "toggle",
            name = "Hide Blizzard Arena Frame",
            desc = "Hide the standard Blizzard Arena frame while in the Arena.",
            order = 3,
            width = "full",
            get = getOpt,
            set = setOpt,
        },
    },
}

function AntiFrames:InitOptions()
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("AntiFrames", options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AntiFrames", "Anti Frames")

    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("AntiFrames Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AntiFrames Profiles", "Profiles", "Anti Frames")
end

AntiFrames:RegisterChatCommand("af", function()
    LibStub("AceConfigDialog-3.0"):Open("AntiFrames")
end)