-- Initialize the database
if not DeathData then DeathData = {} end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        if not DeathData then DeathData = {} end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00DeathCounter Loaded.|r Use /deaths to see the shame of Yip's Harem.")
    
    elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
        -- arg1 is the death message, e.g., "Player dies."
        local _, _, name = string.find(arg1, "(.+) dies")
        if name then
            DeathData[name] = (DeathData[name] or 0) + 1
        end
    end
end)

-- Slash command to show deaths
SLASH_DEATHS1 = "/deaths"
SlashCmdList["DEATHS"] = function(msg)
    if msg == "reset" then
        DeathData = {}
        DEFAULT_CHAT_FRAME:AddMessage("Death counter reset.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("--- Raid Death Standings ---")
        for name, count in pairs(DeathData) do
            DEFAULT_CHAT_FRAME:AddMessage(name .. ": " .. count)
        end
    end
end
