local QBCore = exports['qb-core']:GetCoreObject()

PlayerData = {}
PlayerData.job = {}

local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local pedDisplaying = {}
RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

-- deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
    local args = {text}
    if author ~= "" then
        table.insert(args, 1, author)
    end
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            color = color,
            args = args
        }
    })
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function(_PlayerData)
    PlayerData = _PlayerData
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
    print(msg)

    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            templateId = 'print',
            args = {msg}
        }
    })
end)

AddEventHandler('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
    SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = {
            name = name,
            help = help,
            params = params or nil
        }
    })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
            type = 'ON_SUGGESTION_ADD',
            suggestion = suggestion
        })
    end
end)

AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_REMOVE',
        name = name
    })
end)

RegisterNetEvent('chat:resetSuggestions')
AddEventHandler('chat:resetSuggestions', function()
    SendNUIMessage({
        type = 'ON_COMMANDS_RESET'
    })
end)

AddEventHandler('chat:addTemplate', function(id, html)
    SendNUIMessage({
        type = 'ON_TEMPLATE_ADD',
        template = {
            id = id,
            html = html
        }
    })
end)

AddEventHandler('chat:client:ClearChat', function(name)
    SendNUIMessage({
        type = 'ON_CLEAR'
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false)

    if not data.canceled then
        local id = PlayerId()

        -- deprecated
        local r, g, b = 0, 0x99, 255

        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        else
            TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), {r, g, b}, data.message)
        end
    end

    cb('ok')
end)

function Display(ped, text, name, cmd, targetPlayer, sender)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    local color = {0, 0, 0, 0.8}

    if cmd == "do" or cmd == "me" then
        color = {255, 128, 203, 0.8}
    elseif cmd == "ooc" then
        color = {140, 140, 140, 0.8}
    elseif cmd == "tweet" then
        color = {29, 216, 216, 0.8}
    elseif cmd == "advert" then
        color = {255, 255, 30, 0.8}
    elseif cmd == "live" then
        color = {255, 190, 30, 0.8}
    elseif cmd == "lspd" then
        color = {104, 42, 255, 0.8}
    elseif cmd == "lsms" then
        color = {255, 42, 86, 0.8}
    elseif cmd == "pm" then
        color = {255, 252, 42, 0.8}
    end

    if cmd == "tweet" then
        TriggerEvent('chat:addMessage', {
            template = '<i style="color:#1DD8D8" class="fa fa-globe"></i> <b>{0}</b>',
            color = color,
            multiline = true,
            args = {name}
        })
    elseif cmd == "ooc" then
        TriggerEvent('chat:addMessage', {
            template = '<b>{0}</b>',
            color = color,
            multiline = true,
            args = {name}
        })
    elseif cmd == "advert" then
        TriggerEvent('chat:addMessage', {
            template = '<i style="color:#FFFF1E" class="fas fa-ad"></i> <b>{0}</b>',
            color = color,
            multiline = true,
            args = {name}
        })
    elseif cmd == "live" then
        TriggerEvent('chat:addMessage', {
            template = '<i style="color:#FFBE1E" class="fas fa-microphone"></i> <b>{0}</b>',
            color = color,
            multiline = true,
            args = {name}
        })
    elseif cmd == "lspd" then
        TriggerEvent('chat:addMessage', {
            template = '<p style="color:#682AFF"><b>{0}</b> <i style="color:#682AFF" class="fa fa-bullhorn"></i> <b>{1}</b></p>',
            color = color,
            multiline = true,
            args = {name, text}
        })
    elseif cmd == "lsms" then
        TriggerEvent('chat:addMessage', {
            template = '<p style="color:#FF2A56"><b>{0}</b> <i style="color:#FF2A56" class="fa fa-bullhorn"></i> <b>{1}</b></p>',
            color = color,
            multiline = true,
            args = {name, text}
        })
    elseif cmd == "pm" then
        local targetColor = {255, 232, 42, 0.8}
        QBCore.Functions.TriggerCallback("chat:server:getTargetName", function(name)
            name = name.first .." "..name.last
            TriggerEvent('chat:addMessage', {
                template = '<p style="color:#FFE82A"><i style="color:#FFE82A" class="fa fa-envelope"></i> <b>(( PM sended {0} (ID: {2}): {1} ))</b></p>',
                multiline = true,
                args = {name, text, targetPlayer}
            })
 
            TriggerServerEvent("chat:server:sendPm", name, text, targetColor, sender, targetPlayer)
        end, targetPlayer) 
    end

    if cmd == "do" or cmd == "me" then
        if dist <= 250 then
            if dist <= 10 then
                TriggerEvent('chat:addMessage', {
                    color = color,
                    multiline = true,
                    args = {name}
                })
            end

            pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

            -- Timer
            local display = true

            Citizen.CreateThread(function()
                Wait(7000)
                display = false
            end)

            -- Display
            local offset = 1

            if cmd == "do" then
                offset = pedDisplaying[ped] * 0.1
            elseif cmd == "me" then
                offset = 1
            end

            while display do
                if HasEntityClearLosToEntity(playerPed, ped, 17) then
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    z = z + offset
                    DrawText3D(vector3(x, y, z), '* ' .. text .. ' *', color)

                end
                Wait(0)
            end

            pedDisplaying[ped] = pedDisplaying[ped] - 1
        end
    end
end

function DrawText3D(coords, text, color)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)

    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text rgba()
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('chat:client:sendPm')
AddEventHandler('chat:client:sendPm', function(text, name, color, sender)
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#FFCF2A"><i style="color:#FFCF2A" class="fa fa-envelope"></i> (( PM from {0} (ID: ' .. sender .. '): {1} ))</p>',
        multiline = true,
        args = {text, name}
    })
end)

RegisterNetEvent('chat:client:charInfo')
AddEventHandler('chat:client:charInfo', function(data)
    local name = data.name
    local gender = data.gender
    local birth = data.birthdate
    local job = data.job
    local nation = data.nation 
    local playerId = data.playerId
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#00FE92">--------[ {0} | {1} ]--------</p>',
        multiline = true,
        args = {name, data.time}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#B2B2B2">>>ID: {0}</p>',
        multiline = true,
        args = {playerId}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#B2B2B2">>>Gender: {0}</p>',
        multiline = true,
        args = {gender}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#B2B2B2">>>Nationality: {0}</p>',
        multiline = true,
        args = {nation}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#B2B2B2">>>Date of Birth: {0}</p>',
        multiline = true,
        args = {birth}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#B2B2B2">>>Job: {0}</p>',
        multiline = true,
        args = {job}
    })
    TriggerEvent('chat:addMessage', {
        template = ' <p style="color:#00FE92">--------[ {0} | {1} ]--------</p>',
        multiline = true,
        args = {name, data.time}
    })
end)

RegisterNetEvent('chat:client:CashOrBank')
AddEventHandler('chat:client:CashOrBank', function(type, money)
    if type == "bank" then
        TriggerEvent('chat:addMessage', {
            template = '<font color="#FF5DFA"><b>- SYSTEM - </b></font> You have <font color="#13D20D">${0}</font> in your bank',
            color = {},
            multiline = true,
            args = {money}
        })
    else
        TriggerEvent('chat:addMessage', {
            template = '<font color="#FF5DFA"><b>- SYSTEM - </b></font> You have <font color="#13D20D">${0}</font> cash',
            color = {},
            multiline = true,
            args = {money}
        })
    end
end)

RegisterNetEvent('chat:client:shareDisplay')
AddEventHandler('chat:client:shareDisplay', function(text, serverId, name, cmd, targetPlayer, sender)
    local player = GetPlayerFromServerId(serverId)

    if player ~= -1 then
        local ped = GetPlayerPed(player)

        Display(ped, text, name, cmd, targetPlayer, sender)
    end
end)

local function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerEvent('chat:addSuggestions', suggestions)
    end
end

local function refreshThemes()
    local themes = {}

    for resIdx = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(resIdx)

        if GetResourceState(resource) == 'started' then
            local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

            if numThemes > 0 then
                local themeName = GetResourceMetadata(resource, 'chat_theme')
                local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

                if themeName and themeData then
                    themeData.baseUrl = 'nui://' .. resource .. '/'
                    themes[themeName] = themeData
                end
            end
        end
    end

    SendNUIMessage({
        type = 'ON_UPDATE_THEMES',
        themes = themes
    })
end

AddEventHandler('onClientResourceStart', function(resName)
    Wait(500)

    refreshCommands()
    refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
    Wait(500)

    refreshCommands()
    refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');

    refreshCommands()
    refreshThemes()

    chatLoaded = true

    cb('ok')
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)

    while true do
        Wait(0)

        if not chatInputActive then
            if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    type = 'ON_OPEN'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end

        if chatLoaded then
            local shouldBeHidden = false

            if IsScreenFadedOut() or IsPauseMenuActive() then
                shouldBeHidden = true
            end

            if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
                chatHidden = shouldBeHidden

                SendNUIMessage({
                    type = 'ON_SCREEN_STATE_CHANGE',
                    shouldHide = shouldBeHidden
                })
            end
        end
    end
end)
