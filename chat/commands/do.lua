local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('do', function(source, args, raw)
    local text = string.sub(raw, 4)
    
    QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
        local name = name.first ..' '..  name.last

        name = text .." (( "..name.." ))"
        TriggerServerEvent('chat:server:shareDisplay', text, name, "do")
    end)
end)