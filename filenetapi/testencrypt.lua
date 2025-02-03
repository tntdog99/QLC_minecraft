function shift(text, shift_amount)
    local result = {}
    for i = 1, #text do
        local byte = string.byte(text, i)
        table.insert(result, string.char(byte + shift_amount))
    end
    return table.concat(result)
end

function unshift(text, shift_amount)
    local result = {}
    for i = 1, #text do
        local byte = string.byte(text, i)
        table.insert(result, string.char(byte - shift_amount))
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
local shift_amount = 3

local shifted_text = shift(text, shift_amount)
local encrypted = custom_encrypt(shifted_text, key)
local encrypted2 = xorEncrypt(encrypted, key)
print("Custom Encrypted:", encrypted2)

local decrypted2 = xorDecrypt(encrypted2, key)
local decrypted = custom_decrypt(decrypted2, key)
local unshifted_text = unshift(decrypted, shift_amount)
print("Decrypted:", unshifted_text)