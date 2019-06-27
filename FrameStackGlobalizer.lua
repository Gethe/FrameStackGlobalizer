local EnumerateFrames = _G.EnumerateFrames
local tostring = _G.tostring

local ignore = {}
local frames = {}
local function FindFrame(hash)
    if ignore[hash] then return end

    if frames[hash] then
        return frames[hash]
    else
        local frame = EnumerateFrames()
        while frame do
            local frameHash = tostring(frame)
            if frameHash:find(hash) then
                frames[hash] = frame
                return frame
            end
            frame = EnumerateFrames(frame)
        end
    end

    ignore[hash] = true
end

local matchPattern, subPattern = "%s%%.(%%x*)%%.?", "(%s%%.%%x*)"
local function TransformText(text)
    local parent = text:match("%s+([%w_]+)%.")
    if parent then
        local hash = text:match(matchPattern:format(parent))
        if hash and #hash > 5 then
            local frame = FindFrame(hash:upper())
            if frame and frame:GetName() then
                text = text:gsub(subPattern:format(parent), frame:GetName())
                return TransformText(text)
            end
        end
    end

    return text
end

_G.hooksecurefunc(_G.FrameStackTooltip, "SetFrameStack", function(self)
    for i = 1, self:NumLines() do
        local line = _G["FrameStackTooltipTextLeft"..i]
        local text = line:GetText()
        if text and text:find("<%d+>") then
            line:SetText(TransformText(text))
        end
    end
end)
