rednet.open("top")
local function overworld()
    while true do
    sleep(0.05)
        if fs.exists("cdsdtemp1") then
        rednet.send(19, "_", "drs")
        fs.delete("cdsdtemp1")
        _, msg = rednet.receive("drsb")
        local filewrite = fs.open("cdsdtemp2", "w")
        filewrite.write(msg)
        end
    end
end
local function other()
while true do
sleep(0.05)
if rednet.receive("drs") then
local file2 = fs.open("cdsdtemp1", "w")
file2.close()
while true do
sleep(0.05)
if fs.getSize("cdsdtemp2") == 0 then
else
local fileread = fs.open("cdsdtemp2", "r")
local msgb = fileread.readAll()
rednet.send(11, msgb, "drs")
break
end
end
end
end
end
parallel.waitForAll(other,overworld)
