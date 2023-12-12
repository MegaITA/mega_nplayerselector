-- Base class from which other classes are derived

local Class = {}

setmetatable(Class, {
	__call = function(self)
		self.__call = getmetatable(self).__call
		self.__index = self
		return setmetatable({}, self)
	end
})

function Class:new()
	return self()
end

NPlayerSelector = Class()

local range = 9999
local callback = nil

function NPlayerSelector:setRange(val) 
    range = val
end

function NPlayerSelector:getRange()
    return range
end

local active = false
function NPlayerSelector:activate()
    active = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    Citizen.CreateThread(function ()
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        while active do
            local players = GetActivePlayers()
            local playerPositions = {}
            for k,v in pairs(players) do
                local player = GetPlayerPed(v)
                local coords = GetEntityCoords(player)
                if #(coords - playerPos) <= range then
                    local success, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
                    table.insert(playerPositions, { 
                        id = GetPlayerServerId(v), 
                        coords = { x, y } 
                    })
                end
            end
            SendNUIMessage({
                active = active,
                positions = playerPositions
            }) 
            Citizen.Wait(100)
        end
    end)
end

Citizen.CreateThread(function ()
    while true do
        if active then
            DisableAllControlActions(0)
            EnableControlAction(0, `INPUT_PUSH_TO_TALK`, true)
            DisablePlayerFiring(PlayerId(), true)
        end
        Wait(1)
    end
end)

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
    callback(data)
end)

function NPlayerSelector:onPlayerSelected(fn) 
    callback = fn
end

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


-- local selectionActive = false

-- exports('ActivatePlayerSelector', function (args)
--     RegisterNUICallback('selectedPlayer', args) 
--     selectionActive = true
--     while selectionActive do
--         local players = GetActivePlayers()
--         -- if not #players then print('caca') return end
--         local playerPositions = {}
--         for k,v in pairs(players) do
--             local player = GetPlayerPed(v)
--             local coords = GetEntityCoords(player)
--             local success, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
--             table.insert(playerPositions, { 
--                 id = GetPlayerServerId(v), 
--                 coords = { x, y } 
--             })
--         end
--         SetNuiFocus(true, true)
--         SendNUIMessage({
--             positions = playerPositions
--         }) 
--         Citizen.Wait(100)
--     end
-- end)

-- RegisterCommand('testsel', function ()
--     exports.mega_nplayerselector:ActivatePlayerSelector(function (data)
--         print(json.encode(data))
--     end)
-- end)