rednet.open("top")
fs.delete("tempfort2")
fs.delete("tempfort1")

local fileWrite = fs.open("tempfort1", "w")
local fileRead = fs.open("tempfort1", "r")
local fileSNRead = fs.open("tempfort2", "r")
local fileSNWrite = fs.open("tempfort2", "w")
local SNID = 4
local table = {}
fileWrite.write("")
fileSNWrite.write("")
--rednet.receive("id", "message")
local function overworld()
print("runing")
    while true do
    sleep(0.05)
        if fs.getSize("tempfort1") == 0 then
        else
        print("reading file")
            fileRead = fs.open("tempfort1", "r")
            local this3 = textutils.unserialise(fileRead.readAll())
            fileWrite = fs.open("tempfort1", "w")
            id = this3.id
            msg = this3.msg
            print(msg.type)
            fileWrite.write("")
            if this3 then
                if msg.type == "list" then
                     rednet.send(SNID, { type = "list" }, "item_network")
                    _, that2 = rednet.receive("item_network", 5)
                    that2ser = textutils.serialise(that2)
                    local fileSNWrite = fs.open("tempfort2", "w")
                    fileSNWrite.write(that2ser)
                elseif msg.type == "request" then 
        
                    rednet.send(SNID, msg, "item_network")
                    _, that2 = rednet.receive("item_network")
                    local fileSNWrite = fs.open("tempfort2", "w")
                    fileSNWrite.write(textutils.serialise(that2))
                end
            end
        end
    end
end
local function other()
    while true do
    this, that = rednet.receive("cdsr_item_network", 5)
    table = {id = this, msg = that}
    sleep(0.05)
    print(this)
        if this then
        print("msg got")
        fileWrite.write(textutils.serialise(table))
            while true do
            sleep(0.05)
                if fs.getSize("tempfort2") == 0 then
                else
                print("reading file")
                local fileSNRead = fs.open("tempfort2", "r")
                local that3 = textutils.unserialise(fileSNRead.readAll())
                local fileSNWrite = fs.open("tempfort2", "w")
                fileSNWrite.write("")
                print(that3)
                rednet.send(this, that3, "cdsr_item_network")
                break
                end
            end
        end
    end
end
parallel.waitForAll(overworld,other)
