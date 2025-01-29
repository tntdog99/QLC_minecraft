rednet.open("top")
fs.delete("temp2")
fs.delete("temp")

local fileWrite = fs.open("temp", "w")
local fileRead = fs.open("temp", "r")
local fileSNRead = fs.open("temp2", "r")
local fileSNWrite = fs.open("temp2", "w")
local SNID = 4
local table = {}
fileWrite.write("")
fileSNWrite.write("")
--rednet.receive("id", "message")
local function overworld()
print("runing")
    while true do
    sleep(0.05)
        if fs.getSize("temp") == 0 then
        else
        print("reading file")
            fileRead = fs.open("temp", "r")
            local this3 = textutils.unserialise(fileRead.readAll())
            fileWrite = fs.open("temp", "w")
            id = this3.id
            msg = this3.msg
            print(msg.type)
            fileWrite.write("")
            if this3 then
                if msg.type == "list" then
                     rednet.send(SNID, { type = "list" }, "item_network")
                    _, that2 = rednet.receive("item_network", 5)
                    that2ser = textutils.serialise(that2)
                    local fileSNWrite = fs.open("temp2", "w")
                    fileSNWrite.write(that2ser)
                elseif msg.type == "request" then 
        
                    rednet.send(SNID, msg, "item_network")
                    _, that2 = rednet.receive("item_network")
                    local fileSNWrite = fs.open("temp2", "w")
                    fileSNWrite.write(textutils.serialise(that2))
                end
            end
        end
    end
end
local function other()
    while true do
    this, that = rednet.receive("twoitem_network", 5)
    table = {id = this, msg = that}
    sleep(0.05)
    print(this)
        if this then
        print("msg got")
        fileWrite.write(textutils.serialise(table))
            while true do
            sleep(0.05)
                if fs.getSize("temp2") == 0 then
                else
                print("reading file")
                local fileSNRead = fs.open("temp2", "r")
                local that3 = textutils.unserialise(fileSNRead.readAll())
                local fileSNWrite = fs.open("temp2", "w")
                fileSNWrite.write("")
                print(that3)
                rednet.send(this, that3, "twoitem_network")
                break
                end
            end
        end
    end
end
parallel.waitForAll(overworld,other)
