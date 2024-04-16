local VORPCore = {}

-- Load VORP Core
TriggerEvent("getCore", function(core)
    VORPCore = core
end)

RegisterServerEvent('hec_wildhorse:discord')
AddEventHandler("hec_wildhorse:discord", function(breed)
    local _source = source
    local _breed = breed
    local User = VORPCore.getUser(_source)
    local Character = User.getUsedCharacter
    local botname = Config.DiscordBotName
    local avatar = Config.DiscordAvatar
    local webhook = Config.DiscordWebHook
    local CharName
    if Character ~= nil then
        if Character.lastname ~= nil then
            CharName = Character.firstname .. ' ' .. Character.lastname
        else
            CharName = Character.firstname
        end
    end

    local embeds = {
        {
            ["title"] = CharName,
            ["description"] = "A rare " .. _breed .. " horse spawned for player",
            ["type"]="rich",
            ["color"] = 11027200,
            ["footer"] =  {
                ["text"] = "HEC Wild Horses",
                ["icon_url"] = avatar,
            }
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = botname,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end)
