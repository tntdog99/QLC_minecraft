function send(string)
    binaryfull = ""
    binaryall = ""
    for pointer2 = 1, #string do
        number = string.byte(string, pointer2)
        for pointer = 7, 0, -1 do -- Extract bits from 7 to 0 (most significant to least significant)
            binarypoint = bit32.extract(number, pointer)
            binaryfull = binaryfull..binarypoint
        end
        binaryall = binaryall.." "..binaryfull
        binaryfull = ""
    end

    redstone.setOutput("back", true)
    sleep(0.05)
    redstone.setOutput("back", false)
    sleep(0.05)
    redstone.setOutput("back", true)
    binaryall = binaryall:gsub(" ", "") -- Remove spaces for transmission
    temp3 = 0
    temp4 = 0
    for pointer3 = 1, #binaryall do
        send = tonumber(binaryall:sub(pointer3, pointer3))
        if pointer3 == 1 and send == 0 then
            sleep(0.05)
            redstone.setOutput("back", false)
        end
        temp3 = temp3 + 1
        if temp3 == 8 then
            temp3 = 0
        end
        temp4 = temp4 + 1
        if temp4 == 32 then
            temp4 = 0
        end
        time = ((#binaryall/8)/2.5) - ((pointer3/8)/2.5)
        timeleft = math.floor(((#binaryall - pointer3) / #binaryall) * 100)
        if send == 1 then
            redstone.setOutput("back", true)
            sleep(0.05)
            redstone.setOutput("back", false)
        elseif send == 0 then
            sleep(0.05)
            redstone.setOutput("back", false)
        end
    end
    -- Send end signal
    endsignal = "1111111110011001"
    for pointer4 = 1, #endsignal do
        send2 = tonumber(endsignal:sub(pointer4, pointer4))
        if send2 == 1 then
            redstone.setOutput("back", true)
            sleep(0.05)
            redstone.setOutput("back", false)
        elseif send2 == 0 then
            sleep(0.05)
            redstone.setOutput("back", false)
        end
    end
end

function receive()
    posy = 1
    timer = 0
    temp3 = 0
    temp4 = 0
    function booleantonumber(temp)
        local temp = tostring(temp)
        local temp2 = temp:gsub("false", "0")
        temp2 = temp2:gsub("true", "1")
        return temp2
    end

    function binaryToDecimal(binary)
        local decimal = 0
        local length = #binary

        for i = 1, length do
            local bit = tonumber(binary:sub(i, i))
            if bit ~= 0 and bit ~= 1 then
                error("Invalid binary number")
            end
            decimal = decimal + bit * 2 ^ (length - i)
        end

        return decimal
    end

    str = ""
    check = ""
    started = false
    while not started do
        check = redstone.getInput("back")
        str = str .. tostring(check)
        sleep(0.05)
        if string.find(str, "truefalsetrue") ~= nil then
            started = true
            str = "" -- Reset the string after detecting the start signal
        end
    end

    str = ""
    check = ""
    textout = ""
    done = false
    while not done do
        check = redstone.getInput("back")
        str = str .. tostring(check)
        sleep(0.05)
        temp3 = temp3 + 1
        if temp3 >= 8 then
            temp3 = 0
        end
        temp4 = temp4 + 1
        if temp4 >= 32 then
            temp4 = 0
        end
        if check == false then
            timer = timer + 0.05
        elseif check == true then
            timer = 0
        end
        if string.find(str, "truetruetruetruetruetruetruetruetruefalsefalsetruetruefalsefalsetrue") ~= nil or timer >= 5 then
            str = string.gsub(str, "truetruetruetruetruetruetruetruetruefalsefalsetruetruefalsefalsetrue.*", "")
            done = true
        end
    end

    -- Convert "true"/"false" to binary
    text2 = booleantonumber(str)
    -- Split the binary string into 8-bit chunks
    result = {}
    partsize = 8
    for i = 1, #text2, partsize do
        table.insert(result, text2:sub(i, i + partsize - 1))
    end

    -- Convert binary chunks to characters
    fullout = ""
    for i = 1, #result do
        textout = binaryToDecimal(tostring(result[i]))
        fullout = fullout .. string.char(textout)
    end
    return fullout
end

return { receive = receive, send = send}