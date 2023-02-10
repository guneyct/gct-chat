local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('cash', function(source, args, raw)
    TriggerServerEvent('chat:server:CashOrBank', "cash")
end)

RegisterCommand('bank', function(source, args, raw)
    TriggerServerEvent('chat:server:CashOrBank', "bank")
end)