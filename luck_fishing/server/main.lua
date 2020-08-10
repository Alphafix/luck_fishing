
--[[
╔═══╗╔═══╗╔═══╗╔═══╗╔╗───╔╗─╔╗╔═══╗╔╗╔═╗
║╔═╗║║╔═╗║║╔═╗║╚╗╔╗║║║───║║─║║║╔═╗║║║║╔╝
║║─╚╝║║─║║║║─║║─║║║║║║───║║─║║║║─╚╝║╚╝╝─
║║╔═╗║║─║║║║─║║─║║║║║║─╔╗║║─║║║║─╔╗║╔╗║─
║╚╩═║║╚═╝║║╚═╝║╔╝╚╝║║╚═╝║║╚═╝║║╚═╝║║║║╚╗
╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝╚╝╚═╝
--]]


ESX = nil

local cachedData = {}

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

ESX.RegisterUsableItem('fishingrod', function(source)
	TriggerClientEvent("luck_fishing:tryToFish", source)
end)

ESX.RegisterUsableItem('balikagi', function(source)
	TriggerClientEvent("luck_fishing:tryToFish2", source)
end)

RegisterServerEvent('luck_fishing:itemkir')
AddEventHandler('luck_fishing:itemkir', function(item)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
xPlayer.removeInventoryItem(item, 1)
end)

RegisterServerEvent('luck_fishing:itemekle')
AddEventHandler('luck_fishing:itemekle', function(item, count)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local count2 = xPlayer.getInventoryItem(item).count
if Config.Limit <= count + count2 then
TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Daha fazla taşıyamazsın!"})
else
xPlayer.addInventoryItem(item, count)
end
end)



ESX.RegisterServerCallback("luck_fishing:receiveFish", function(source, callback, fishs)
	local player = ESX.GetPlayerFromId(source)
	if not player then return callback(false) end
	callback(true)
end)

ESX.RegisterServerCallback('luck_fishing:item', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
end)
