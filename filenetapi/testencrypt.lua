function custom_encrypt(text, key)
    local text_len = #text
    local key_len = #key
    local interval = math.floor(text_len / key_len)
    local result = {}

    local key_index = 1
    for i = 1, text_len do
        table.insert(result, string.sub(text, i, i))
        if i % interval == 0 and key_index <= key_len then
            table.insert(result, string.sub(key, key_index, key_index))
            key_index = key_index + 1
        end
    end

    -- Append remaining key characters if any
    while key_index <= key_len do
        table.insert(result, string.sub(key, key_index, key_index))
        key_index = key_index + 1
    end

    return table.concat(result)
end


function xorEncrypt(data, key)
    local result = {}
    for i = 1, #data do
        local byte = string.byte(data, i)
        local keyByte = string.byte(key, (i - 1) % #key + 1)
        result[i] = string.char(bit.bxor(byte, keyByte))
    end
    return table.concat(result)
end

function xorDecrypt(data, key)
    return xorEncrypt(data, key) -- XOR encryption is symmetric
end

-- Example usage
local text = "HelloWorld"
local key = "Key"
local encrypted = custom_encrypt(text, key)
local encrypted2 = xorEncrypt(encrypted, key)
print("Custom Encrypted:", encrypted2)
