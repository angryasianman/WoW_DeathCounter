-- Initialize the database
if not DeathData then DeathData = {} end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        if not DeathData then DeathData = {} end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00DeathCounter Loaded.|r /deaths to view, /deaths raid to broadcast.")
    
    elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
        local _, _, name = string.find(arg1, "(.+) dies")
        if name then
            DeathData[name] = (DeathData[name] or 0) + 1
        end
    end
end)

-- Slash command logic
SLASH_DEATHS1 = "/deaths"
SlashCmdList["DEATHS"] = function(msg)
    if msg == "reset" then
        DeathData = {}
        DEFAULT_CHAT_FRAME:AddMessage("Death counter reset.")
    
    elseif msg == "raid" then
        -- Determine the correct channel (Raid or Party)
        local channel = "SAY"
        if GetNumRaidMembers() > 0 then
            channel = "RAID"
        elseif GetNumPartyMembers() > 0 then
            channel = "PARTY"
        end

        SendChatMessage("--- Current Raid Death Standings ---", channel)
        for name, count in pairs(DeathData) do
            SendChatMessage(name .. ": " .. count, channel)
        end

    else
        -- Default: Show only to you
        DEFAULT_CHAT_FRAME:AddMessage("--- Local Death Standings ---")
        for name, count in pairs(DeathData) do
            DEFAULT_CHAT_FRAME:AddMessage(name .. ": " .. count)
        end
        DEFAULT_CHAT_FRAME:AddMessage("Type '/deaths raid' to share with the group.")
    end
end
