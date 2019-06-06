local frames = {}
local EnumerateFrames = _G.EnumerateFrames
local tostring = _G.tostring
local function FindFrame(hash)
    --print("FindFrame", frames[hash], hash)
    if frames[hash] then
        return frames[hash]
    else
        local frame = EnumerateFrames()
        while frame do
            if frame:IsVisible() and frame:IsMouseOver() then
                if tostring(frame):find(hash) then
                    frames[hash] = frame
                    return frame
                end
            end
            frame = EnumerateFrames(frame)
        end
    end
end

local next = _G.next
_G.hooksecurefunc(_G.FrameStackTooltip, "SetFrameStack", function(self, showHidden, showRegions, highlightIndexChanged)
    local regions = {self:GetRegions()}
    for _, region in next, regions do
        if region:GetObjectType() == "FontString" then
            local text = region:GetText()
            if text and text:find("<%d+>") then
                local hash = text:match("UIParent%.(%x*)%.?")
                if hash then
                    local frame = FindFrame(hash:upper())
                    --print("frame", frame, hash)
                    if frame then
                        local name = frame:GetName() or frame:GetDebugName()
                        region:SetText(text:gsub("(UIParent%.%x*)", name))
                    end
                end
            end
        end
    end
end)
