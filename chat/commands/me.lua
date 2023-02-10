local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('me', function(source, args, raw)
    local text = string.sub(raw, 4)
    
    QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
        local name = name.first ..' '..  name.last

        name = "* ".. name.." "..text
        TriggerServerEvent('chat:server:shareDisplay', text, name, "me")
    end)
end)