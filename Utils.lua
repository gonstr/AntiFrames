local AntiFrames = AntiFrames

local media = LibStub("LibSharedMedia-3.0", true)

function AntiFrames:HidePartyFrames()
    for i = 1, 4 do
        _G["PartyMemberFrame" .. i]:Hide()
    end
end

function AntiFrames:ShowPartyFrames()
    for i = 1, 4 do
        _G["PartyMemberFrame" .. i]:Show()
    end
end

function AntiFrames:MediaFetch(mediaType, key)
    return media:Fetch(mediaType, key)
end
