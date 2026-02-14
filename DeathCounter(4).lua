-- Initialize the database
if not DeathData then DeathData = {} end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Helper function to find the right chat channel
local function GetDeathChannel()
    if GetNumRaidMembers() > 0 then return "RAID" end
    if GetNumPartyMembers() > 0 then return "PARTY" end
    return "SAY"
end

frame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        if not DeathData then DeathData = {} end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00DeathCounter Loaded.|r /deaths to view, /deaths raid to broadcast.")
    
    elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
        local _, _, name = string.find(arg1, "(.+) dies")
        if name then
            DeathData[name] = (DeathData[name] or 0) + 1
            -- Auto-announce the current death
            SendChatMessage(name .. " has died! (Total: " .. DeathData[name] .. ")", GetDeathChannel())
        end
    end
end)

-- Slash command logic with sorting
SLASH_DEATHS1 = "/deaths"
SlashCmdList["DEATHS"] = function(msg)
    if msg == "reset" then
        DeathData = {}
        DEFAULT_CHAT_FRAME:AddMessage("Death counter reset.")
    else
        -- 1. Move data to a sortable table
        local sortedList = {}
        for name, count in pairs(DeathData) do
            table.insert(sortedList, {name = name, count = count})
        end

        -- 2. Sort the table by count (highest first)
        table.sort(sortedList, function(a, b)
            return a.count > b.count
        end)

        -- 3. Determine output destination
        local isRaidMsg = (msg == "raid")
        local channel = GetDeathChannel()

        if isRaidMsg then
            SendChatMessage("--- Raid Death Standings (Sorted) ---", channel)
        else
            DEFAULT_CHAT_FRAME:AddMessage("--- Local Death Standings (Sorted) ---")
        end

        -- 4. Print the results
        for _, data in ipairs(sortedList) do
            local line = data.name .. ": " .. data.count
            if isRaidMsg then
                SendChatMessage(line, channel)
            else
                DEFAULT_CHAT_FRAME:AddMessage(line)
            end
        end
    end
end
