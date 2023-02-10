local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('tweet', function(source, args, raw)
    local text = raw:gsub("tweet", "")

    QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
        local name = name.first ..' '..  name.last

        name = '@'..name ..': '.. text
        TriggerServerEvent('chat:server:shareDisplay', text, name, "tweet")
    end)
end)