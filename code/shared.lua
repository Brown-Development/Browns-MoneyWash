local CORES = config.framework
local INV = config.inventory
local MONEYITEM = config.dirtymoney.DirtyMoneyName 

function getCore()
    if CORES == 'esx' then 
        return exports['es_extended']:getSharedObject()
    elseif CORES == 'qb-core' then 
        return exports['qb-core']:GetCoreObject()
    end
end

function getPlayer(source)
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.GetPlayer(source)
    elseif CORES == 'esx' then 
        return _CORE.GetPlayerFromId(source)
    end
end

function AddMoney(source, amount)
    local xPlayer = getPlayer(source)
    if CORES == 'qb-core' then 
        return xPlayer.Functions.AddMoney('cash', amount, 'Washed Money')
    elseif CORES == 'esx' then 
        return xPlayer.addMoney(amount)
    end
end

function RemoveMoney(source, amount)
    local xPlayer = getPlayer(source)
    if config.dirtymoney.DirtyMoneyItem then 
        if INV == 'qb-inventory' then 
            exports['qb-inventory']:RemoveItem(source, MONEYITEM, amount)
        elseif INV == 'qs-inventory' then 
            exports['qs-inventory']:RemoveItem(source, MONEYITEM, amount)
        elseif INV == 'lj-inventory' then 
            exports['lj-inventory']:RemoveItem(source, MONEYITEM, amount)
        elseif INV == 'ps-inventory' then 
            exports['ps-inventory']:RemoveItem(source, MONEYITEM, amount)
        elseif INV == 'ox_inventory' then 
            exports.ox_inventory:RemoveItem(source, MONEYITEM, amount)
        end
    else
        if CORES == 'qb-core' then 
            xPlayer.Functions.RemoveMoney(MONEYITEM, amount, 'Money Wash')
        elseif CORES == 'esx' then 
            xPlayer.removeAccountMoney(MONEYITEM, amount)
        end
    end
end

function GetMoney(source)
    local xPlayer = getPlayer(source)
    if config.dirtymoney.DirtyMoneyItem then 
        if INV == 'qb-inventory' then 
            local item = exports['qb-inventory']:GetItemByName(source, MONEYITEM)
            if item == nil then return 0 else return item.amount end
        elseif INV == 'qs-inventory' then 
            local item = exports['qs-inventory']:GetItemByName(source, MONEYITEM)
            if item == nil then return 0 else return item.amount end
        elseif INV == 'lj-inventory' then 
            local item = exports['lj-inventory']:GetItemByName(source, MONEYITEM)
            if item == nil then return 0 else return item.amount end
        elseif INV == 'ps-inventory' then 
            local item = exports['ps-inventory']:GetItemByName(source, MONEYITEM)
            if item == nil then return 0 else return item.amount end
        elseif INV == 'ox_inventory' then 
            local item = exports.ox_inventory:GetItemCount(source, MONEYITEM)
            if item == nil then return 0 else return item end
        end
    else
        if CORES == 'qb-core' then 
            return xPlayer.Functions.GetMoney(MONEYITEM)
        elseif CORES == 'esx' then 
            local account = xPlayer.getAccount(MONEYITEM)
            return account.money
        end
    end
end

function C_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.TriggerCallback
    elseif CORES == 'esx' then
        return _CORE.TriggerServerCallback
    end 
end

function S_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.CreateCallback
    elseif CORES == 'esx' then 
        return _CORE.RegisterServerCallback
    end 
end