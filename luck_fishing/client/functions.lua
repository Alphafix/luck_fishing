
--[[
╔═══╗╔═══╗╔═══╗╔═══╗╔╗───╔╗─╔╗╔═══╗╔╗╔═╗
║╔═╗║║╔═╗║║╔═╗║╚╗╔╗║║║───║║─║║║╔═╗║║║║╔╝
║║─╚╝║║─║║║║─║║─║║║║║║───║║─║║║║─╚╝║╚╝╝─
║║╔═╗║║─║║║║─║║─║║║║║║─╔╗║║─║║║║─╔╗║╔╗║─
║╚╩═║║╚═╝║║╚═╝║╔╝╚╝║║╚═╝║║╚═╝║║╚═╝║║║║╚╗
╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚╝╚═╝
--]]


local tutma


TryToFish = function()
    if IsPedSwimming(cachedData["ped"]) then return exports['mythic_notify']:DoHudText('error', 'Yüzerken balık tutamazsın!') end
    if IsPedInAnyVehicle(cachedData["ped"]) then return exports['mythic_notify']:DoHudText('error', 'Araçtayken balık tutamazsın!') end
    tutma = false
    exports['mythic_notify']:PersistentHudText('end', 1)
    local waterValidated, castLocation = IsInWater()
    ESX.TriggerServerCallback('luck_fishing:item', function(qtty)
        if qtty > 0 then         
            if waterValidated then
                local fishingRod = GenerateFishingRod(cachedData["ped"])
                CastBait(fishingRod, castLocation)
            else
                exports['mythic_notify']:DoHudText('error', 'Balık tutmak için denize bakmalısın!')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'Yemin yok.')
        end

    end, Config.Fishbait)
    
end

TryToFish2 = function()
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if pos.y <= -1400 and pos.x <= -2100 then
        if IsPedSwimming(cachedData["ped"]) then return exports['mythic_notify']:DoHudText('error', 'Yüzerken balık tutamazsın!') end
    if IsPedInAnyVehicle(cachedData["ped"]) then return exports['mythic_notify']:DoHudText('error', 'Araçtayken balık tutamazsın!') end
    tutma = false
    exports['mythic_notify']:PersistentHudText('end', 1)
    local waterValidated, castLocation = IsInWater()
    ESX.TriggerServerCallback('luck_fishing:item', function(qtty)
        if qtty > 9 then         
            if waterValidated then
                local fishingRod = GenerateFishingRod(cachedData["ped"])
                CastBait2(fishingRod, castLocation)
            else
                exports['mythic_notify']:DoHudText('error', 'Balık tutmak için denize bakmalısın!')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'Yeteri kadar yemin yok.')
        end

    end, Config.Fishbait)
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Burada hiç balık gözükmüyor!"})
    end
   
    
end

local nott

CastBait2 = function(rodHandle, castLocation)
    local startedCasting = GetGameTimer()

    while not IsControlJustPressed(0, 47) do
        Citizen.Wait(5)
        if nott == false then
        exports['mythic_notify']:PersistentHudText('start', 1, 'inform', 'Ağı atmak için [G] tuşuna basınız')
        nott = true
        end
        if GetGameTimer() - startedCasting > 5000 then
            exports['mythic_notify']:PersistentHudText('end', 1)
            nott = false
            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    exports['mythic_notify']:PersistentHudText('end', 1)

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)

    exports['mythic_notify']:DoHudText('inform', 'Balıkların ağa takılmasını bekliyorsun!')

    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    if interupted then
        ClearPedTasks(cachedData["ped"])

        CastBait2(rodHandle, castLocation)

        return
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])
    local yem = math.random(1, 100)
    if caughtFish then
        local fishs = math.random(8,12)
        ESX.TriggerServerCallback("luck_fishing:receiveFish", function(received)
        TriggerServerEvent('luck_fishing:itemekle', 'fish', fishs)
        ESX.TriggerServerCallback('luck_fishing:item', function(qtty)
            if qtty >= 49 then
                tutma = true
            else         
            if received then
                exports['mythic_notify']:DoHudText('success', fishs .. ' tane balık yakaladın!')
            end
        end
        end, 'fish')
            
        end)

        if yem <= 40 then
            TriggerServerEvent('luck_fishing:itemkir', Config.Fishbait)
            exports['mythic_notify']:DoHudText('error', 'Balık yemini yuttu!')
            DeleteEntity(rodHandle)
            nott = false
            tutma = true
        end

    else

        if yem <= 40 then
            TriggerServerEvent('luck_fishing:itemkir', Config.Fishbait)
            exports['mythic_notify']:DoHudText('error', 'Balık yemini yuttu!')
            DeleteEntity(rodHandle)
            nott = false
            tutma = true
        end
               
        local abibasaramadim = math.random(1,100)
        if abibasaramadim <= 25 then
        TriggerServerEvent('luck_fishing:itemkir', Config.Rod2)
        exports['mythic_notify']:DoLongHudText('error', 'Balık kaçarken ağını deldi!')
        DeleteEntity(rodHandle)
        nott = false
        tutma = true
        else
        exports['mythic_notify']:DoHudText('error', 'Balık kaçtı!')
        end

       
    end

    if tutma == false then
    CastBait(rodHandle, castLocation)
    end
end

CastBait = function(rodHandle, castLocation)
    local startedCasting = GetGameTimer()

    while not IsControlJustPressed(0, 47) do
        Citizen.Wait(5)
        if nott == false then
        exports['mythic_notify']:PersistentHudText('start', 1, 'inform', 'Oltayı atmak için [G] tuşuna basınız')
        nott = true
        end
        if GetGameTimer() - startedCasting > 5000 then
            exports['mythic_notify']:PersistentHudText('end', 1)
            nott = false
            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    exports['mythic_notify']:PersistentHudText('end', 1)

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)

    exports['mythic_notify']:DoHudText('inform', 'Balığın takılmasını bekliyorsun!')

    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    if interupted then
        ClearPedTasks(cachedData["ped"])

        CastBait(rodHandle, castLocation)

        return
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])
    local yem = math.random(1, 100)
    if caughtFish then
        local fishs = math.random(2,4)
        ESX.TriggerServerCallback("luck_fishing:receiveFish", function(received)
        TriggerServerEvent('luck_fishing:itemekle', 'fish', fishs)
        ESX.TriggerServerCallback('luck_fishing:item', function(qtty)
            if qtty >= 49 then
                tutma = true
            else         
            if received then
                exports['mythic_notify']:DoHudText('success', fishs .. ' tane balık yakaladın!')
            end
        end
        end, 'fish')
            
        end)

        if yem <= 10 then
            TriggerServerEvent('luck_fishing:itemkir', Config.Fishbait)
            exports['mythic_notify']:DoHudText('error', 'Balık yemini yuttu!')
            DeleteEntity(rodHandle)
            nott = false
            tutma = true
        end

    else

        if yem <= 20 then
            TriggerServerEvent('luck_fishing:itemkir', Config.Fishbait)
            exports['mythic_notify']:DoHudText('error', 'Balık yemini yuttu!')
            DeleteEntity(rodHandle)
            nott = false
            tutma = true
        end
               
        local abibasaramadim = math.random(1,100)
        if abibasaramadim <= 5 then
        TriggerServerEvent('luck_fishing:itemkir', Config.Rod)
        exports['mythic_notify']:DoLongHudText('error', 'Balık kaçarken oltanı kırdı!')
        DeleteEntity(rodHandle)
        nott = false
        tutma = true
        else
        exports['mythic_notify']:DoHudText('error', 'Balık kaçtı!')
        end

       
    end

    if tutma == false then
    CastBait(rodHandle, castLocation)
    end
end

TryToCatchFish = function()

    while true do
        Citizen.Wait(5)

        local basaramadim = exports["reload-skillbar"]:taskBar(5000,math.random(5,15))           
        if basaramadim ~= 100 then
            return false
            else   
                return true
            end
    end

end

IsInWater = function()
    local startedCheck = GetGameTimer()

    local ped = cachedData["ped"]
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    WaitForModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true)

    exports['mythic_notify']:DoHudText('inform', 'Oltanı hazırlıyorsun!')

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end


    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)
    nott = false

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

GenerateFishingRod = function(ped)
    local pedPos = GetEntityCoords(ped)
    
    local fishingRodHash = `prop_fishing_rod_01`

    WaitForModel(fishingRodHash)

    local rodHandle = CreateObject(fishingRodHash, pedPos, true)

    AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(fishingRodHash)

    return rodHandle
end



DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["color"] or vector3(150, 150, 150), 100, false, true, 2, false, false, false, false)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

FadeOut = function(duration)
    DoScreenFadeOut(duration)
    
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end

FadeIn = function(duration)
    DoScreenFadeIn(500)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end


