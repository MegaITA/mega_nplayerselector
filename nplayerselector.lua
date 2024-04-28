local active = false
NPlayerSelector = {}
NPlayerSelector.range = 9999
NPlayerSelector.callback = nil

function NPlayerSelector:setRange(val) 
    NPlayerSelector.range = val
end

function NPlayerSelector:getRange()
    return NPlayerSelector.range
end

function NPlayerSelector:onPlayerSelected(fn) 
    NPlayerSelector.callback = fn
end

function NPlayerSelector:activate()
    active = true
    Citizen.CreateThread(function ()
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        while active do
            local players = GetActivePlayers()
            local playerPositions = {}
            for k,v in pairs(players) do
                local player = GetPlayerPed(v)
                local coords = GetEntityCoords(player)
                if #(coords - playerPos) <= NPlayerSelector.range then
                    local success, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
                    table.insert(playerPositions, { 
                        id = GetPlayerServerId(v), 
                        coords = { x, y } 
                    })
                end
            end
            SetNuiFocus(true, true)
            SendNUIMessage({
                active = active,
                positions = playerPositions
            }) 
            Citizen.Wait(100)
        end
    end)
end

RegisterNUICallback('closeSelector', function (data, cb)
    cb({})
    active = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        active = active
    })
end)

RegisterNUICallback('onPlayerSelected', function (data, cb)
    cb({})
    NPlayerSelector.callback(data)
end)

function NPlayerSelector:deactivate()
    active = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        active = active
    }) 
end

RegisterNetEvent('mega_nplayerselector:load')
AddEventHandler('mega_nplayerselector:load', function (cb)
    cb(NPlayerSelector)
end)

RegisterCommand('testsel', function ()
    NPlayerSelector.callback = (function (data)
        print(json.encode(data))
    end)
    NPlayerSelector:activate()
end)