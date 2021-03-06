----
-- Util
--
-- Various general purpose functions
----

SimpleQuestCounter.Util = {}
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings


function Util.CalculateColor(questsNumber, maxQuestsNumber, minLimitColor, midLimitColor, maxLimitColor)
    local result = {}
    local startColor = minLimitColor
    local endColor = maxLimitColor

    local progress = questsNumber / maxQuestsNumber

    if (progress <= 0.5) then
        startColor = minLimitColor
        endColor = midLimitColor
        progress = progress + 0.5
    else
        startColor = midLimitColor
        endColor = maxLimitColor
        progress = progress + 0
    end

    -- for each color component, 1 -> r, 2 -> g, 3 -> b,
    for i=1,3,1 do
        result[i] = startColor[i] + (endColor[i]-startColor[i]) * progress*progress
    end

    return result
end



Util.Console = {}


function Util.Console.GetDefaultChatFrame()
    return DEFAULT_CHAT_FRAME
end

function Util.Console.GetDebugChatFrame()
    local index = 1
    while _G["ChatFrame"..index] do
        local chatFrame = _G["ChatFrame"..index]
        local chatFrameTab = _G["ChatFrame"..index.."Tab"]
        local chatFrameTabText = _G["ChatFrame"..index.."TabText"]
        -- TODO: what happens if "Debug log" is closed; it remains in memory
        if chatFrame and chatFrameTab and chatFrameTabText and chatFrameTabText:GetText() == "Debug Log" then
            return chatFrame
        end
        index = index + 1
    end
    return DEFAULT_CHAT_FRAME
end

function Util.Console.GetCurrentChatFrame()
    return SimpleQuestCounter.currentChatFrame or Util.Console.GetDefaultChatFrame()
end

function Util.Console.Print(...)
    local defaultChatFrame = Util.Console.GetDefaultChatFrame()
    defaultChatFrame:AddMessage(...)
end

function Util.Console.DPrint(...)
    local debugChatFrame = Util.Console.GetDebugChatFrame()
    debugChatFrame:AddMessage(...)
end

function Util.Console.Printf(format, ...)
    Util.Console.Print(string.format(format, ...))
end

function Util.Console.DPrintf(format, ...)
    Util.Console.DPrint(string.format(format, ...))
end

function Util.Console.FPrintf(format, ...)
    local currentChatFrame = Util.Console.GetCurrentChatFrame()
    currentChatFrame:AddMessage(string.format(format,...))
end

Util.String = {}

function Util.String.Split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end


Util.Table = {}

function Util.Table.Select(t, predicate)
    local result = {}
    for index, elem in pairs(t) do
        local type_value = type(predicate)
        if ( type_value == 'string' and elem[predicate] ) then
            table.insert(result, elem)
        elseif ( type_value == 'function' and predicate(elem, index, t) ) then
            table.insert(result, elem)
        else
            -- do nothing TODO: emit error?
        end
    end
    return result
end


function Util.Table.PrettyPrint(t)
    -- Print contents of `tbl`, with indentation.
    -- `indent` sets the initial level of indentation.
    local function tprint (tbl, indent, print)
        if not print then print = Util.Console.DPrint end
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                print(formatting)
            tprint(v, indent+1)
            elseif type(v) == 'boolean' then
                print(formatting .. tostring(v))
            else
                print(formatting .. v)
            end
        end
    end
    -- Print!
    tprint(t)
end
