local Callback = S_CALLBACK()

Callback('wash:GetAccountBalance', function(source, cb, input)
    local src = source
    local balance = false
    local zero = 'zero'
    if math.floor(tonumber(input)) ~= 0 then
        zero = 'notzero'
        if GetMoney(src) >= math.floor(tonumber(input)) then 
            balance = true
            RemoveMoney(src, math.floor(tonumber(input)))
        end
    end
    cb(balance, zero)
end)

Callback('wash:AddAccountBalance', function(source, cb, returns)
    local src = source 
    AddMoney(src, tonumber(returns))
    cb(true)
end)

Callback('wash:StartAccountBalance', function(source, cb)
    local src = source 
    cb(GetMoney(src))
end)