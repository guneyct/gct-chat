local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('lspd', function(source, args, raw)
    if PlayerData and PlayerData.job and PlayerData.job.name == "police" then
        local text = raw:gsub("lspd", "")
        local name = "LSPD"

        TriggerServerEvent('chat:server:shareDisplay', text, name, "lspd") 
    end
end)