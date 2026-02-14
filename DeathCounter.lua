-- Initialize the database
if not DeathData then DeathData = {} end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Helper function to find the right chat channel
local function GetDeathChannel()
    if GetNumRaidMembers() > 0 then return "RAID" end
    if GetNumPartyMembers() > 0 then return "PARTY" end
    return "SAY" -- Default if solo
end

frame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        if not DeathData then DeathData = {} end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00DeathCounter Active!|r Auto-announcing to raid.")
    
    elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
        -- arg1 is the combat log message, e.g., "Player dies."
        local _, _, name = string.find(arg1, "(.+) dies")
        
        if name then
            -- 1. Update the internal counter
            DeathData[name] = (DeathData[name] or 0) + 1
            
            -- 2. Announce it IMMEDIATELY to the group
            local count = DeathData[name]
            local msg = name .. " has died! (Total deaths: " .. count .. ")"
            SendChatMessage(msg, GetDeathChannel())
        end
    end
end)

-- Manual Slash Commands
SLASH_DEATHS1 = "/deaths"
SlashCmdList["DEATHS"] = function(msg)
    if msg == "reset" then
        DeathData = {}
        DEFAULT_CHAT_FRAME:AddMessage("Death counter reset.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("--- Local Death Summary ---")
        for name, count in pairs(DeathData) do
            DEFAULT_CHAT_FRAME:AddMessage(name .. ": " .. count)
        end
    end
end
