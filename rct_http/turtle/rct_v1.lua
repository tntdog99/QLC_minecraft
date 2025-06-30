IP = "192.168.1.71:8080"
function invtime()
    while true do
        sleep(0.1)
        sendInventoryUpdate()
    end
end
function listenhttp()
    while true do
<<<<<<< HEAD
        local this = http.get("http://"..IP.."/getcmd")
=======
        local this = http.get("http://"..IP.."/getcmd")
>>>>>>> 8e3dd84112da01d080c37eafae8916ac25845c91
        local this2 = this.readAll()
        if this2 then
            local func = load(this2)
                _, res1, res2, res3 = pcall(func)
                if res1 ~= nil then
                    if textutils.serialise(res1) then
                        new1 = textutils.serialise(res1)
                    else
                    new1 = res1
                    end
                    if textutils.serialise(res2) then
                        new2 = textutils.serialise(res2)
                    else
                    new2 = res2
                    end
                    if textutils.serialise(res3) then
                        new3 = textutils.serialise(res3)
                    else
                    new3 = res3
                    end
                print(new)
                end
                end
    end
end

function sendInventoryUpdate()
    local lines = {} -- Store each item's details as a line
    local selectedSlot = turtle.getSelectedSlot() -- Get the currently selected slot
    local Fuellevel = turtle.getFuelLevel()
    for slot = 1, 16 do
        local itemDetail = turtle.getItemDetail(slot)
        if itemDetail then
            -- Add item's details to the table
            table.insert(lines,  "Name: " .. itemDetail.name .. ", Count: " .. itemDetail.count)
        else
            table.insert(lines, "Empty")
        end
    end
    table.insert(lines, "Fuel level "..Fuellevel)
    lines[selectedSlot] = ">".. lines[selectedSlot]
    table.insert(lines, new1)
    table.insert(lines, new2)
    table.insert(lines, new3)
    invsend(lines)
end
-- Function to handle inventory change events
local function inventoryWatcher()
    while true do
        local event = os.pullEvent("turtle_inventory") -- Wait for inventory change event
        if event then
            sendInventoryUpdate() -- Send the updated inventory
        end
    end
end

function invsend(data2)

<<<<<<< HEAD
    local url = "http://192.168.10.108:8080/filter"
=======
    local url = "http://"..IP.."/filter"
>>>>>>> 8e3dd84112da01d080c37eafae8916ac25845c91
    local data = textutils.serialise(data2)
    local headers = {
        ["Content-Type"] = "text/plain"
    }
    local response = http.post(url, data, headers)
    if response then
        -- Read and print the response
        local responseBody = response.readAll()
        print("Response: " .. responseBody)
        response.close()
    else
        print("HTTP request failed")
    end
end
<<<<<<< HEAD
if http.checkURL("http://192.168.10.108:8080/working?") then
=======
if http.checkURL("http://"..IP.."/working?") then
>>>>>>> 8e3dd84112da01d080c37eafae8916ac25845c91
    parallel.waitForAll(inventoryWatcher, listenhttp, invtime)
else
<<<<<<< HEAD
    _, err = http.checkURL("http://192.168.10.108:8080/working?")
=======
    _, err = http.checkURL("http://"..IP.."/working?")
>>>>>>> 8e3dd84112da01d080c37eafae8916ac25845c91
    if err == "Domain not permitted" then
        print("private IPs not allowed change cc server settings")
    end
end
