local fs = require("fs")

local function check_add(a, b, hard)
        if a + b > 100 then
                return false
        end

        if hard then
                if a < 20 or b < 20 then
                        return false
                end

                local a_unit = a % 10
                local b_unit = b % 10
                if a_unit + b_unit <= 10 then
                        return false
                end
        end

        return true
end

local function check_sub_ab(a, b, hard)
        if a < b then
                return false
        end

        if hard then
                if a < 20 or b < 20 then
                        return false
                end

                local a_unit = a % 10
                local b_unit = b % 10
                if a_unit >= b_unit then
                        return false
                end
        end

        return true
end

local function check_sub_ba(a, b, hard)
        if b < a then
                return false
        end

        if hard then
                if a < 20 or b < 20 then
                        return false
                end

                local a_unit = a % 10
                local b_unit = b % 10
                if a_unit <= b_unit then
                        return false
                end
        end

        return true
end

local types = {
        {
                formula = "(    ) + %s = %s",
                checker = check_sub_ba
        },
        {
                formula = "%s + (    ) = %s",
                checker = check_sub_ba
        },
        {
                formula = "%s + %s = (    )",
                checker = check_add 
        },
        {
                formula = "(    ) - %s = %s",
                checker = check_add
        },
        {
                formula = "%s - (    ) = %s",
                checker = check_sub_ab
        },
        {
                formula = "%s - %s = (    )",
                checker = check_sub_ab
        },
}


function genFormula(num, hard)
        math.randomseed(system.hrtime())
        local n = math.random(6)
        local t = types[n]

        while true do
                local a = math.random(num)
                local b = math.random(num)
                local r = t.checker(a, b, hard)
                if r then
                        return string.format(t.formula, a, b)
                end
        end
end

for d = 1, 60 do
local out = "\r\n\r\n\r\n\r\n"
for i = 1, 10 do
        local line = "                " .. 
                     genFormula(100, true) .. 
                     "                " ..
                     genFormula(100, true) ..
                     "\r\n\r\n\r\n\r\n"
        out = out .. line 
end

local path = string.format("./out/%d.txt", d)

local stream = fs.createWriteStream(path)
local ret = stream:write(out)
stream:close()
end
