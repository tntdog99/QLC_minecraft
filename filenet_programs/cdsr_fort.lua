local filenet = require("filenet")
rednet.open("top")
local SNID = 4
local table = {}
local function overworld()
    print("runing")
    while true do
        sleep(0.05)
        local this3 = filenet.receive("cdsrfort1")
            id = this3.id
            msg = this3.msg
            print(msg.type)
            if this3 then
                if msg.type == "list" then
                     rednet.send(SNID, { type = "list" }, "item_network")
                    _, that2 = rednet.receive("item_network", 5)
                    filenet.send(that2,"cdsrfort2")
                elseif msg.type == "request" then 
        
                    rednet.send(SNID, msg, "item_network")
                    _, that2 = rednet.receive("item_network")
                    filenet.send(that2,"cdsrfort1")
                end
            end
        end
    end
local function other()
    while true do
        this, that = rednet.receive("cdsr_item_network", 5)
        table = {id = this, msg = that}
        sleep(0.05)
        if this then
            print("msg got")
            filenet.send(table, "cdsrfort1")
            sleep(0.05)
            local that3 = filenet.receive("cdsrfort2")
            rednet.send(this, that3, "cdsr_item_network")
        end
    end
end
parallel.waitForAll(overworld,other)
