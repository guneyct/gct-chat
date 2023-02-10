local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('advert', function(source, args, raw)
    local text = raw:gsub("advert", "")
    local name = "Advertisement: "..text
    TriggerServerEvent('chat:server:shareDisplay', text, name, "advert")
end)