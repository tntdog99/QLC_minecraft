port = 8080
local vars = {
  1, "Value 2", "Value 3", "Value 4", "Value 5", "Value 6",
  "Value 7", "Value 8", "Value 9", "Value 10", "Value 11", "Value 12",
  "Value 13", "Value 14", "Value 15", "Value 16", "Value 17", "test"
}
local lastCommand = nil

local function send(res, text, contentType)
  res.setStatusCode(200)
  res.setResponseHeader("Content-Type", contentType or "text/plain")
  res.write(text or "")
  res.close()
end

routes = {
  ["/"] = function(req, res)
    local page = [[
<html>
<head>
  <meta charset="utf-8">
  <title>Turtle Relay</title>
  <style>
    body { font:14px Arial; text-align:center; margin:0; padding:10px; }
    button { margin:3px; padding:5px 8px; font-size:14px; }
    input { margin:3px; padding:5px; font-size:14px; }
    table { margin:auto; border-collapse:collapse; font-size:12px; }
    th, td { border:1px solid #ddd; padding:4px 6px; }
  </style>
<script>
    // Send a command to the server
    function sendCommand(cmd) {
      if (!cmd) return;
      fetch('/cmd', {
        method: 'POST',
        body: JSON.stringify({ command: cmd })
      })
      .then(r => r.text())
      .catch(e => console.error(e));
    }

    // Update the variables table by fetching /vars
    function updateVars() {
      fetch('/vars')
        .then(response => response.text())
        .then(html => { document.getElementById('varContent').innerHTML = html; })
        .catch(e => console.error(e));
    }
    // Update every 200ms
    setInterval(updateVars, 200);
    window.onload = updateVars;

    // Key bindings for control commands
    document.addEventListener('keydown', function(e) {
      // Prevent keybinds if an input or textarea is focused
      if (document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA") {
        return;
      }

      switch(e.key.toLowerCase()) {
        case 'w': sendCommand('turtle.forward()'); break;
        case 's': sendCommand('turtle.back()'); break;
        case 'a': sendCommand('turtle.turnLeft()'); break;
        case 'd': sendCommand('turtle.turnRight()'); break;
        case 'e': sendCommand('turtle.up()'); break;
        case 'q': sendCommand('turtle.down()'); break;
      }
    });

    // Handle Enter key on the custom command input
    function handleCustomCommandKey(e) {
      if (e.key === "Enter") {
        sendCommand(document.getElementById('customCommand').value);
        document.getElementById('customCommand').value = "";
      }
    }
</script>
</head>
<body>
  <div>
    <button onclick="sendCommand('turtle.forward()')">Forward</button>
    <button onclick="sendCommand('turtle.back()')">Back</button>
    <button onclick="sendCommand('turtle.turnLeft()')">Left</button>
    <button onclick="sendCommand('turtle.turnRight()')">Right</button>
    <button onclick="sendCommand('turtle.up()')">Up</button>
    <button onclick="sendCommand('turtle.down()')">Down</button>
    <button onclick="sendCommand('turtle.place()')">Place</button>
    <button onclick="sendCommand('turtle.placeDown()')">Place down</button>
    <button onclick="sendCommand('turtle.placeUp()')">Place up</button>
    <button onclick="sendCommand('turtle.dig()')">Dig</button>
    <button onclick="sendCommand('turtle.digDown()')">Dig down</button>
    <button onclick="sendCommand('turtle.digUp()')">Dig up</button>
    <button onclick="sendCommand('if turtle.getSelectedSlot()==16 then turtle.select(1) else turtle.select(turtle.getSelectedSlot()-1) end')">Last</button>
    <button onclick="sendCommand('if turtle.getSelectedSlot()==1 then turtle.select(16) else turtle.select(turtle.getSelectedSlot()+1) end')">Next</button>
    <button onclick="sendCommand('turtle.equipRight()')">Equip right</button>
    <button onclick="sendCommand('turtle.equipLeft()')">Equip left</button>
  </div>
  <div style="margin-top:10px;">
    <input type="text" id="customCommand" placeholder="Enter custom command" onkeydown="handleCustomCommandKey(event)" style="width:300px;">
    <button onclick="sendCommand(document.getElementById('customCommand').value); document.getElementById('customCommand').value = '';">Send Custom Command</button>
  </div>
  <h2>Turtle inventory</h2>
  <table>
    <tr><th>#</th><th>Value</th></tr>
    <tbody id="varContent"></tbody>
  </table>
</body>
</html>
    ]]
    send(res, page, "text/html")
  end,

  ["/vars"] = function(req, res)
    local rows = ""
    for i, v in ipairs(vars) do
      rows = rows .. string.format("<tr><td>%d</td><td>%s</td></tr>", i, tostring(v))
    end
    send(res, rows, "text/html")
  end,

  ["/cmd"] = function(req, res)
    local body = req.readAll() or ""
    local data = textutils.unserializeJSON(body)
    if data and data.command then
      lastCommand = data.command
      res.write("Command stored: " .. data.command)
    else
      res.write("Invalid command format")
    end
    res.close()
  end,

  ["/getcmd"] = function(req, res)
    if lastCommand then
      send(res, lastCommand, "text/plain")
      lastCommand = nil
    else
      send(res, nil, "text/plain")
    end
  end,

  ["/working?"] = function(req, res)
    send(res, "true", "text/plain")
  end,

  ["/filter"] = function(req, res)
    local info = req.readAll()
    print(textutils.serialize(info))
    vars = textutils.unserialize(info)
    send(res, info, "text/plain")
  end
}

function handleRequest(req, res)
  local url = req.getURL()
  if routes[url] then
    routes[url](req, res)
  end
end

function webserver()
  http.listen(port, handleRequest)
end

function listenhttp()
  while true do
    local this = http.get("http://localhost:" .. port .. "/getcmd")
    sleep(0.05)
    if this then
      local this2 = this.readAll()
      if this2 then print(this2) end
    end
  end
end

parallel.waitForAll(webserver, listenhttp)
