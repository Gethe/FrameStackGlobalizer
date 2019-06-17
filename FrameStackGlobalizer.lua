local EnumerateFrames = _G.EnumerateFrames
local tostring = _G.tostring

local frames = {}
local function FindFrame(hash)
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
end

local matchPattern, subPattern = "%s%%.(%%x*)%%.?", "(%s%%.%%x*)"
local function GetHash(text)
    local parent = text:match(">%s+(%w+)%.")
    if parent then
        local hash = text:match(matchPattern:format(parent))
        if hash then
            return hash, subPattern:format(parent)
        end
    end
end

_G.hooksecurefunc(_G.FrameStackTooltip, "SetFrameStack", function(self)
    for i = 1, self:NumLines() do
        local line = _G["FrameStackTooltipTextLeft"..i]
        local text = line:GetText()
        if text and text:find("<%d+>") then
            local hash, pattern = GetHash(text)
            if hash then
                local frame = FindFrame(hash:upper())
                --print("frame", frame, hash)
                if frame then
                    line:SetText(text:gsub(pattern, frame:GetName() or frame:GetDebugName()))
                end
            end
        end
    end
end)
