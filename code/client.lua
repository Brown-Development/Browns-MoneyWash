local Callback = C_CALLBACK()

local percentage = config.percentage

RegisterNUICallback('WashMoney', function(money)
    print(money.amount)
    Callback('wash:GetAccountBalance', function(balance, zero)
        if zero == 'notzero' then 
            if balance then 
                SendNUIMessage({
                    start = 'MoneyWash',
                    washed = 'Amount Washed $'..tostring(math.floor(percentage / 100 * money.amount)),
                    take = math.floor(percentage / 100 * money.amount)
                })
            else
                Notify('You dont have enough money', 'error')
            end
        elseif zero == 'zero' then 
            Notify('You must put an amount greater than 0', 'error')
        end
    end, money.amount)
end)

RegisterNUICallback('TakeMoney', function(cash)
    Callback('wash:AddAccountBalance', function(finished)
        if finished then 
            Notify('You recieved $'..tostring(cash.money) , 'success')
        end
    end, cash.money)
end)

RegisterNUICallback('FocusToggle', function(switch)
    local toggle = switch.toggle
    if toggle then 
        SetNuiFocus(true, true)
    else
        SetNuiFocus(false, false)
    end
end)

function Notify(msg, types)
    lib.notify({
        id = 'browns_moneywash',
        title = 'Money Wash',
        description = msg,
        duration = 5000,
        position = 'top',
        type = types,
        style = {
            backgroundColor = '#000000',
            color = '#008000',
            ['.description'] = {
              color = '#008000'
            }
        },
    })
end

Citizen.CreateThread(function()
    for _, machines in ipairs(config.washlocations) do 
        local model = GetHashKey('prop_washer_02')
        if not HasModelLoaded(model) then 
            RequestModel(model)
            while not HasModelLoaded(model) do 
                Citizen.Wait(0) 
            end
        end 
        local object = CreateObject(model, machines.coords.x, machines.coords.y, machines.coords.z, false, false, false)
        SetEntityInvincible(object, true)
        SetEntityHeading(object, machines.heading)
        FreezeEntityPosition(object, true)
        AddTarget(object)
    end
end)

function AddTarget(entity)
    local target = config.target
    if target == 'qb-target' then 
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    icon = 'fas fa-dollar-sign',
                    label = 'Wash Money', 
                    action = function()
                        Callback('wash:StartAccountBalance', function(bal)
                            local thisBal = bal if thisBal == nil then thisBal = 0 end
                            SendNUIMessage({
                                start = 'UI',
                                text = 'Washable Amount $'..tostring(thisBal),
                                marked = config.dirtymoney.UsingMarkedMoney
                            })
                        end)
                    end
                }
            },
            distance = 2.5, 
        })
    elseif target == 'qtarget' then 
        exports['qtarget']:AddTargetEntity(entity, {
            options = {
                {
                    icon = 'fas fa-dollar-sign',
                    label = 'Wash Money', 
                    action = function()
                        Callback('wash:StartAccountBalance', function(bal)
                            local thisBal = bal if thisBal == nil then thisBal = 0 end
                            SendNUIMessage({
                                start = 'UI',
                                text = 'Washable Amount $'..tostring(thisBal),
                                marked = config.dirtymoney.UsingMarkedMoney
                            })
                        end)
                    end
                }
            },
            distance = 2.5, 
        })
    elseif target == 'ox_target' then 
        local options = {
            {
                icon = 'fas fa-dollar-sign',
                label = 'Wash Money',
                onSelect = function()
                    Callback('wash:StartAccountBalance', function(bal)
                        local thisBal = bal if thisBal == nil then thisBal = 0 end
                        SendNUIMessage({
                            start = 'UI',
                            text = 'Washable Amount $'..tostring(thisBal),
                            marked = config.dirtymoney.UsingMarkedMoney
                        })
                    end)
                end
            },
        }
        exports.ox_target:addLocalEntity(entity, options)
    end
end

Citizen.CreateThread(function()
    local blipsettings = config.blip_settings 
    if blipsettings.enable then 
        for _, loc in ipairs(config.washlocations) do
            local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
            SetBlipSprite(blip, blipsettings.sprite)
            SetBlipColour(blip, blipsettings.color)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, 250)
            SetBlipScale(blip, blipsettings.scale)
            SetBlipAsShortRange(blip, true)
            PulseBlip(blip)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipsettings.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
