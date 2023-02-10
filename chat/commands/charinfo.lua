local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('charinfo', function(source, args, raw)  
    TriggerServerEvent('chat:server:charInfo')
end)