local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('lsms', function(source, args, raw)
    if PlayerData and PlayerData.job and PlayerData.job.name == "ambulance" then
        local text = raw:gsub("lsms", "")
        local name = "LSMS"

        TriggerServerEvent('chat:server:shareDisplay', text, name, "lsms") 
    end
end)