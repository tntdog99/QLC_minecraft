local filenet = require("filenet")
rednet.open("top")
local function overworld()
    while true do
    sleep(0.05)
        if filenet.receive("cdsd1") then
        rednet.send(19, "_", "drs")
        _, msg = rednet.receive("drsb")
filenet.send(msg,"cdsd2")
        end
    end
end
local function other()
    while true do
    sleep(0.05)
        if rednet.receive("drs") then
filenet.send("true", "cdsd1")
local msgb = filenet.receive("cdsd2")
                rednet.send(11, msgb, "drs")
        end
    end
end
parallel.waitForAll(other,overworld)
