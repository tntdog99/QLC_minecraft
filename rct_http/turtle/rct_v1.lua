function invtime()
while true do
sleep(0.1)
sendInventoryUpdate()
end
end
function listenhttp()
    while true do
        this = http.get("http://192.168.1.79:8080/getcmd")
        this2 = this.readAll()
        if this2 then
            local func = load(this2)
            pcall(func)
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

    local url = "http://192.168.1.79:8080/filter"
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
if http.checkURL("http://192.168.1.79:8080/working?") then
    parallel.waitForAll(inventoryWatcher, listenhttp, invtime)
else
    _, err = http.checkURL("http://192.168.1.79:8080/working?")
    if err == "Domain not permitted" then
        print("private IPs not allowed change cc server settings")
    end
end
