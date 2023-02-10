local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('ooc', function(source, args, raw)
    local text = string.sub(raw, 4)

    QBCore.Functions.TriggerCallback('chat:server:getFullName', function(name)
        local name = name.first ..' '..  name.last

        if source == 0 then
            source = 1
        end

        name = "(( [".. source .."] "..name ..": ".. text .." ))"
        print("a")
        TriggerServerEvent('chat:server:shareDisplay', text, name, "ooc")
    end)
end)