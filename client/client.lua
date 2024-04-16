local VORPCore = {}

local wildHorseRolled = false
local Spawns = Config.Spawns

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if not IsEntityDead(PlayerPedId()) then
            for k,v in pairs(Spawns) do 
                for l,c in pairs(v.locations) do        
                    --Check if player has entered one of the spawn zone
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = #(playerCoords - c)
                    if dist < 200 then
                        local rdm = math.random(1,20)
                        -- 5% chance for horse to spawn
                        if rdm == 12 then
                            --Pick random horse model from config
                            local horserdm = math.random(1,#v.horses)
                            local horsemodel = v.horses[horserdm]

                            --Create Horse
                            RequestModel(horsemodel)
                            while not HasModelLoaded(horsemodel) do
                                Citizen.Wait(1)
                            end
                            local heading = math.random(1,359)
                            local x, y, z = table.unpack(c)
                            local wildHorse = CreatePed(horsemodel, x, y, z, heading, 1, 1)
                            SetEntityInvincible(wildHorse, false)
                            SetRandomOutfitVar(wildHorse, true)
                            SetEntityAsMissionEntity(wildHorse, true, true)
                            SetModelAsNoLongerNeeded(horsemodel)
                            
                            while not PedReadyToRender(wildHorse) do 
                                Citizen.Wait(1)
                            end

                            Citizen.InvokeNative(0x704C908E9C405136, npc)
                            Citizen.InvokeNative(0xAAB86462966168CE, npc, 1) 
                        
                            Citizen.InvokeNative(0x9F7794730795E019, wildHorse, 17, true) -- Set the horse to flee from danger
                            Citizen.InvokeNative(0xAE6004120C18DF97, wildHorse, 0, true) -- -- SET_PED_LASSO_HOGTIE_FLAG 
                            Citizen.InvokeNative(0xAEB97D84CDF3C00B, wildHorse, true) --_SET_ANIMAL_IS_WILD

                            SetBlockingOfNonTemporaryEvents(wildHorse, false)  -- Set environment can affect the horse

                            TaskWanderStandard(wildHorse, 10.0, 10)  -- Horse behavior is to wander in the direction it's facing

                            SetEntityVisible(wildHorse, true, 0)  -- Spawn horse

                            wildHorseRolled = true

                            --Discord Notification
                            if Config.DiscordIntegration then
                                TriggerServerEvent("hec_wildhorse:discord", v.breed)
                            end

                            --Player Notification
                            if Config.NotificationOn then
                                VORPCore.NotifyTip(Config.Notification, 4000)
                            end
                        end
                    else
                        wildHorseRolled = false
                    end
                    if wildHorseRolled then break end  --Break loop because horse spawned
                end
                if wildHorseRolled then 
                    Citizen.Wait(300000) --Wait 5 minutes to reset Horse Spawn
                    wildHorseRolled = false --Reset Horse Spawn
                    break
                end
            end
        end
    end
end)