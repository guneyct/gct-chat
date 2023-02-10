local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('pm', function(source, args, raw)
    if tonumber(args[1]) then
        QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
            local text = ""
            local target = tonumber(args[1])
            for k, v in pairs(args) do
                if k ~= 1 then
                    text = text .." "..v
                end
            end

            local name = name.first .. " "..name.last
            TriggerServerEvent('chat:server:shareDisplay', text, name, "pm", target)
        end)
    end
end)