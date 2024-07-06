local VORPCore = {}

local jobCheck = true
local wildHorseRolled = false
local Spawns = Config.Spawns
local Delay = Config.RespawnDelay
local Frequency = Config.RNGTimer
local Radius = Config.Radius



-- Load VORP Core
TriggerEvent("getCore", function(core)
    VORPCore = core
end)

function PedReadyToRender(ped)
    -- Wait for model to load
    return Citizen.InvokeNative(0xA0BC8FAED8CFEB3C,ped)
end

function SetRandomOutfitVar(ped, bool1)
    -- Property needs to be set no matter what
    return Citizen.InvokeNative(0x283978A15512B2FE, ped, bool1)
end

function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xAAB86462966168CE, ped, true) -- UNKNOWN "Fixes outfit"- always paired with _UPDATE_PED_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end
function DiscordNotification(breed)
    TriggerServerEvent("hec_wildhorse:discord", breed)
end

function PlayerTip()
    VORPCore.NotifyTip(Config.Notification, 4000)
end

function JobCheck()
    --Check Job (if applicable)
    if next(Config.Jobs) ~= nil then
        local cbresult =  VORPCore.Callback.TriggerAwait('hec_wildhorse:callback:jobcheck', source)
        if cbresult then
            return true
        else
            return false
        end
    else
        return true
    end
end

function SpawnChance()
    --Convert spawn chance percentage to max value
    local SpawnChanceMax = 20
    if Config.SpawnChance == 1 then
        SpawnChanceMax = 400
    elseif Config.SpawnChance == 2 then
        SpawnChanceMax = 200
    elseif Config.SpawnChance == 3 then
        SpawnChanceMax = 100
    elseif Config.SpawnChance == 4 then
        SpawnChanceMax = 50
    elseif Config.SpawnChance == 5 then
        SpawnChanceMax = 33
    elseif Config.SpawnChance == 6 then
        SpawnChanceMax = 25
    end
    return SpawnChanceMax
end

function SpawnHorse(x, y, z, h, model)
    --Create Horse
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    local wildHorse = CreatePed(model, x, y, z, h, 1, 1)
    SetEntityInvincible(wildHorse, false)
    SetRandomOutfitVar(wildHorse, true)
    SetEntityAsMissionEntity(wildHorse, true, true)
    SetModelAsNoLongerNeeded(model)
    while not PedReadyToRender(wildHorse) do 
        Citizen.Wait(1)
    end

    --Determine Horse Gender
    math.randomseed(h)  --Reseed RNG
    local rng = math.random(10) --Randomly generate number
    local gender = 0.0
    if (rng % 2 == 0) then
        gender = 1.0  --Even number change to female
    end

    Citizen.InvokeNative(0x5653AB26C82938CF, wildHorse, 0xA28B, gender)  --Assign the gender to the horse
    UpdatePedVariation(wildHorse)  --Redraw the horse

    Citizen.InvokeNative(0x704C908E9C405136, npc)
    Citizen.InvokeNative(0xAAB86462966168CE, npc, 1)
    Citizen.InvokeNative(0x9F7794730795E019, wildHorse, 17, true) -- Set the horse to flee from danger
    Citizen.InvokeNative(0xAE6004120C18DF97, wildHorse, 0, true) -- -- SET_PED_LASSO_HOGTIE_FLAG 
    Citizen.InvokeNative(0xAEB97D84CDF3C00B, wildHorse, true) --_SET_ANIMAL_IS_WILD

    SetBlockingOfNonTemporaryEvents(wildHorse, false)  -- Set environment can affect the horse

    TaskWanderStandard(wildHorse, 3.0, 5)  -- Horse behavior is to wander in the direction it's facing

    SetEntityVisible(wildHorse, true, 0)  -- Spawn horse
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Frequency)
        if not IsEntityDead(PlayerPedId()) and jobCheck then
            for k,v in pairs(Spawns) do 
                for l,c in pairs(v.locations) do        
                    --Check if player has entered one of the spawn zone
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = #(playerCoords - c)
                    if dist < Radius then
                        local max = SpawnChance()
                        local rdm = math.random(1,max)
                        -- Up to 5% chance for horse to spawn
                        if rdm == 12 then                    
                            
                            local x, y, z = table.unpack(c)  -- Unpack the coordinates table from the config
                            local cnt = 1  -- Max number of horses to spawn variable.  Defaults to 1

                            --Randomize the number of horses spawned based on config
                            if (Config.MaxHorses > 1 and Config.MaxHorses <= 5) then
                                cnt = math.random(1, Config.MaxHorses)
                            end

                            local offset = 0  -- Offset the spawn coordinates between horses variable
                            local newx = 0  -- Offset x axis variable
                            local newy = 0  -- Offset y axis variable
                            local heading = 0  -- Ped heading (i.e, which way its facing) variable
                            local horserdm = 0 -- Random number for the horse model to spawn variable
                            local horsemodel = ""  --Horse model selected variable

                            -- Spawn the horse(s)
                            for i = 1, cnt, 1
                            do
                                math.randomseed(i*2) --reset the rng seed

                                --Calculate axis offset
                                repeat
                                    offset = math.random(-10, 10)
                                until offset ~= 0

                                newx = x + offset  -- Offset x axis
                                newy = y + offset  -- Offset y axis
                                heading = math.random(1,359)
                                horserdm = math.random(1,#v.horses)
                                horsemodel = v.horses[horserdm]
                                SpawnHorse(newx, newy, z, heading, horsemodel)
                            end
                            
                            wildHorseRolled = true

                            --Discord Notification
                            if Config.DiscordIntegration then DiscordNotification(v.breed) end

                            --Player Notification
                            if Config.NotificationOn then 
                                PlayerTip()
                            end
                        end
                    else
                        wildHorseRolled = false
                    end
                    if wildHorseRolled then break end  --Break loop because horse spawned
                end
                if wildHorseRolled then

                    Citizen.Wait(Delay) --Wait time to reset Horse Spawn
                    wildHorseRolled = false --Reset Horse Spawn
                    break
                end
            end
        end
    end
end)

-- Check for job change every 15 seconds (if applicable)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not IsEntityDead(PlayerPedId()) then
            jobCheck = JobCheck()
            Citizen.Wait(15000)
        end
    end
end)