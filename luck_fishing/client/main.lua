ESX = nil

cachedData = {}

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

RegisterNetEvent("red_fishing:tryToFish")
AddEventHandler("red_fishing:tryToFish", function()
	TryToFish()
end)

RegisterNetEvent("red_fishing:tryToFish2")
AddEventHandler("red_fishing:tryToFish2", function()
	TryToFish2()
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)