-- CC: Tweaked Web Server for Turtle Control with Live Data and Advanced API
-- Features: Remote Turtle Commands, Live Data, User Authentication, AJAX UI, and CSS Styled Page

local port = 8080
local web = {}
local password = "admin" -- Change this for security
local authenticated = false

-- Web API Functions
function web.send(res, text, contentType, statusCode)
    res.setStatusCode(statusCode or 200)
    res.setResponseHeader("Content-Type", contentType or "text/plain")
    res.write(text or "")
    res.close()
end

function web.html(res, content, refreshTime)
    local refreshTag = refreshTime and ("<meta http-equiv='refresh' content='" .. refreshTime .. "'>") or ""
    local htmlContent = "<html><head>" .. refreshTag ..
        "<style>body { font-family: Arial; text-align: center; } button { margin: 5px; padding: 10px; font-size: 16px; }</style>" ..
        "</head><body>" .. content .. "</body></html>"
    web.send(res, htmlContent, "text/html")
end

function web.json(res, tableData)
    local jsonData = textutils.serializeJSON(tableData)
    web.send(res, jsonData, "application/json")
end

function web.notFound(res)
    web.send(res, "404 Not Found", "text/plain", 404)
end

-- Define API routes (each function now accepts req and res)
local routes = {
    ["/"] = function(req, res)
        web.html(res, [[
            <h1>CC: Tweaked Live Data & Turtle Control</h1>
            <p>Time: <span id="time">Loading...</span></p>
            <button onclick="sendCommand('forward')">Forward</button>
            <button onclick="sendCommand('back')">Back</button>
            <button onclick="sendCommand('left')">Left</button>
            <button onclick="sendCommand('right')">Right</button>
            <button onclick="sendCommand('up')">Up</button>
            <button onclick="sendCommand('down')">Down</button>
            <button onclick="sendCommand('dig')">Dig</button>
            <button onclick="sendCommand('place')">Place</button>
            <button onclick="authenticate()">Login</button>
            <script>
                function updateTime() {
                    fetch('/time')
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById('time').innerText = data.time;
                        })
                        .catch(error => console.error('Error:', error));
                }
                function sendCommand(cmd) {
                    fetch('/cmd', { 
                        method: 'POST', 
                        body: JSON.stringify({command: cmd}) 
                    })
                        .then(res => res.text())
                        .then(alert)
                        .catch(err => console.error(err));
                }
                function authenticate() {
                    let pass = prompt('Enter Password:');
                    fetch('/auth', { 
                        method: 'POST', 
                        body: JSON.stringify({password: pass}) 
                    })
                        .then(res => res.text())
                        .then(alert);
                }
                setInterval(updateTime, 5000);
                updateTime();
            </script>
        ]], 5)
    end,

    ["/time"] = function(req, res)
        web.json(res, { time = textutils.formatTime(os.time(), true) })
    end,

    ["/auth"] = function(req, res)
        local body = req.readAll() or ""
        local data = textutils.unserializeJSON(body)
        if data and data.password == password then
            authenticated = true
            res.write("Authenticated Successfully")
        else
            res.write("Wrong Password")
        end
        res.close()
    end,

    ["/cmd"] = function(req, res)
        if not authenticated then
            res.write("Access Denied")
        else
            local body = req.readAll() or ""
            local data = textutils.unserializeJSON(body)
            if data and turtle[data.command] then
                turtle[data.command]()  -- Execute the turtle command
                res.write("Executed: " .. data.command)
            else
                res.write("Invalid Command")
            end
        end
        res.close()
    end
}

-- Request handler
local function handleRequest(req, res)
    local url = req.getURL()
    print("Received request for " .. url)
    if routes[url] then
        routes[url](req, res)
    else
        web.notFound(res)
    end
end

print("Starting Turtle Web Control on port " .. port)
http.listen(port, handleRequest)
