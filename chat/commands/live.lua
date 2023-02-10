local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('live', function(source, args, raw)
    if PlayerData and PlayerData.job and PlayerData.job.name == "reporter" then
        QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
            local text = raw:gsub("live", "")
            local name = "[Live] "..name.first .." ".. name.last..": "..text
            TriggerServerEvent('chat:server:shareDisplay', text, name, "live") 
        end)
    end
end)