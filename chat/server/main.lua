local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

AddEventHandler("chatMessage", function(source, color, message)
    local src = source
    args = stringsplit(message, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent('chat:server:shareDisplay')
AddEventHandler('chat:server:shareDisplay', function(text, name, cmd, target)
    TriggerClientEvent('chat:client:shareDisplay', -1, text, source, name, cmd, target, source)
end)

RegisterServerEvent('chat:server:sendPm')
AddEventHandler('chat:server:sendPm', function(text, name, color, sender, target)
    TriggerClientEvent('chat:client:sendPm', target, text, name, color, sender)
end)

RegisterServerEvent('chat:server:charInfo')
AddEventHandler('chat:server:charInfo', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local date = os.date("%x")
        local time = os.date("%X")
        local data = {
            name = Player.PlayerData.charinfo.firstname ..' '..Player.PlayerData.charinfo.lastname,
            gender = Player.PlayerData.charinfo.gender,
            birthdate = Player.PlayerData.charinfo.birthdate,
            nation = Player.PlayerData.charinfo.nationality,
            playerId = Player.PlayerData.source,
            job = Player.PlayerData.job.label .. " - ".. Player.PlayerData.job.grade.name,
            time = date .." "..time
        }

        if data.gender == 0 then
            data.gender = "Male"
        else
            data.gender = "Female"
        end

        TriggerClientEvent('chat:client:charInfo', Player.PlayerData.source, data)
    end
end)

RegisterServerEvent('chat:server:CashOrBank')
AddEventHandler('chat:server:CashOrBank', function(type)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        local money = 0 
        if type == "bank" then
            money = Player.PlayerData.money.bank
        else
            money = Player.PlayerData.money.cash
        end
        TriggerClientEvent('chat:client:CashOrBank', source, type, money)
    end
end)

QBCore.Functions.CreateCallback('chat:server:getFullName', function(source, cb, type)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player then
        cb({
            first = Player.PlayerData.charinfo.firstname,
            last = Player.PlayerData.charinfo.lastname
        })
    end
end)

QBCore.Functions.CreateCallback('chat:server:getMoney', function(source, cb, type)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player then
        cb({
            first = Player.PlayerData.charinfo.firstname,
            last = Player.PlayerData.charinfo.lastname
        })
    end
end)

QBCore.Functions.CreateCallback('chat:server:getTargetName', function(source, data, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        data({
            first = Player.PlayerData.charinfo.firstname,
            last = Player.PlayerData.charinfo.lastname
        })
    end   
end)