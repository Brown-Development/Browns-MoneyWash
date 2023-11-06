config = {}

config.framework = 'esx' -- 'qb-core' or 'esx'

config.inventory = 'ox_inventory' -- 'qb-inventory', 'ox_inventory', 'qs-inventory', 'ps-inventory', or 'lj-inventory'

config.target = 'ox_target' -- 'qb-target', 'ox_target', or 'qtarget'

config.percentage = 70 -- the percentage of washed money you receive out of the dirty money you wash

config.dirtymoney = {

    DirtyMoneyItem = true, -- (true/false) is dirty money an item

    -- if DirtyMoneyItem = false then put the account name ('cash', 'bank', 'dirtymoney', etc.) for DirtyMoneyName
    -- if DirtyMoneyItem = true then put your dirty money item name for DirtyMoneyName
    DirtyMoneyName = 'black_money' 

}

config.washlocations = { -- creates a targetable washing machine to wash money
    {coords = vector3(0, 0, 0), heading = 0},
    -- {coords = vector3(0, 0, 0), heading = 0}, -- add as many as you want...
}

