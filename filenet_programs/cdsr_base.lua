local filenet = require("filenet")
rednet.open("top")
local SNID = 30
local table = {}
local function overworld()
    print("runing")
    while true do
        sleep(0.05)
        local this3 = filenet.receive("cdsrbase1")
        id = this3.id
        msg = this3.msg
        print(msg.type)
        if msg.type == "list" then
            rednet.send(SNID, { type = "list" }, "item_network")
            _, that2 = rednet.receive("item_network")
            filenet.send(that2,"cdsrbase2")
        elseif msg.type == "request" then 
            rednet.send(SNID, msg, "item_network")
            _, that2 = rednet.receive("item_network")
            filenet.send(that2,"cdsrbase1")
        end
    end
end
local function other()
    while true do
        this, that = rednet.receive("twoitem_network")
        table = {id = this, msg = that}
        if this then
            print("msg got")
            filenet.send(table, "cdsrbase1")
            local that3 = filenet.receive("cdsrbase2")
            rednet.send(this, that3, "twoitem_network")
        end
    end
end
parallel.waitForAll(overworld,other)
