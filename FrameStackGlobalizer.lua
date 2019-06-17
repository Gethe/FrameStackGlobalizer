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

_G.hooksecurefunc(_G.FrameStackTooltip, "SetFrameStack", function(self, showHidden)
    for i = 1, self:NumLines() do
        local line = _G["FrameStackTooltipTextLeft"..i]
        local text = line:GetText()
        if text and text:find("<%d+>") then
            local hash = text:match("UIParent%.(%x*)%.?")
            if hash then
                local frame = FindFrame(hash:upper())
                --print("frame", frame, hash)
                if frame then
                    local name = frame:GetName() or frame:GetDebugName()
                    line:SetText(text:gsub("(UIParent%.%x*)", name))
                end
            end
        end
    end
end)
