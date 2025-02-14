port = 8080
term.clear()
term.setCursorPos(1, 1)
print("webserver running on port:" .. port)

local vars = {
  "invdata", "invdata", "invdata", "invdata", "invdata", "invdata",
  "invdata", "invdata", "invdata", "invdata", "invdata", "invdata",
  "invdata", "invdata", "invdata", "invdata", "fueldata"
}
local lastCommand = nil
local displayText = ""  -- Global variable for display text

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
    #displayArea { border:1px solid #ccc; padding:10px; margin:10px; }
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
    // Update display area by fetching /display
    function updateDisplay() {
      fetch('/display')
        .then(response => response.text())
        .then(text => { document.getElementById('displayArea').innerText = text; })
        .catch(e => console.error(e));
    }
    // Update every 200ms
    setInterval(function() {
      updateVars();
      updateDisplay();
    }, 200);
    window.onload = function() {
      updateVars();
      updateDisplay();
    };

    // Key bindings for control commands
    document.addEventListener('keydown', function(e) {
      // Prevent keybinds if an input or textarea is focused
      if (document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA") {
        return;
      }

      switch(e.key.toLowerCase()) {
        case 'w': sendCommand('return turtle.forward()'); break;
        case 's': sendCommand('return turtle.back()'); break;
        case 'a': sendCommand('return turtle.turnLeft()'); break;
        case 'd': sendCommand('return turtle.turnRight()'); break;
        case 'e': sendCommand('return turtle.up()'); break;
        case 'q': sendCommand('return turtle.down()'); break;
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
    <button onclick="sendCommand('return turtle.forward()')">Forward</button>
    <button onclick="sendCommand('return turtle.back()')">Back</button>
    <button onclick="sendCommand('return turtle.turnLeft()')">Left</button>
    <button onclick="sendCommand('return turtle.turnRight()')">Right</button>
    <button onclick="sendCommand('return turtle.up()')">Up</button>
    <button onclick="sendCommand('return turtle.down()')">Down</button>
    <button onclick="sendCommand('return turtle.place()')">Place</button>
    <button onclick="sendCommand('return turtle.placeDown()')">Place down</button>
    <button onclick="sendCommand('return turtle.placeUp()')">Place up</button>
    <button onclick="sendCommand('return turtle.dig()')">Dig</button>
    <button onclick="sendCommand('return turtle.digDown()')">Dig down</button>
    <button onclick="sendCommand('return turtle.digUp()')">Dig up</button>
    <button onclick="sendCommand('if turtle.getSelectedSlot() == 1 then turtle.select(16) else turtle.select(turtle.getSelectedSlot() - 1 ) end')">Last</button>
    <button onclick="sendCommand('if turtle.getSelectedSlot() == 16 then turtle.select(1) else turtle.select(turtle.getSelectedSlot() + 1 ) end')">Next</button>
    <button onclick="sendCommand('return turtle.equipRight()')">Equip right</button>
    <button onclick="sendCommand('return turtle.equipLeft()')">Equip left</button>
    <button onclick="sendCommand('return gps.locate()')">GPS</button>
  </div>
  <div style="margin-top:10px;">
    <input type="text" id="customCommand" placeholder="Enter custom command" onkeydown="handleCustomCommandKey(event)" style="width:300px;">
    <button onclick="sendCommand(document.getElementById('customCommand').value); document.getElementById('customCommand').value = '';">Send Custom Command</button>
  </div>
  <div id="displayArea">Display text will appear here</div>
  <table>
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
    vars = textutils.unserialize(info)
    send(res, info, "text/plain")
  end,

  ["/display"] = function(req, res)
    send(res, displayText, "text/plain")
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

-- Determine terminal size and create separate windows.
local termSizeX, termSizeY = term.getSize()
-- Output window (for HTTP listener output)
local outputWin = window.create(term.current(), 1, 4, termSizeX, termSizeY - 3)
outputWin.clear()
outputWin.setCursorPos(1, 1)

function listenhttp()
  while true do
    local this = http.get("http://localhost:" .. port .. "/getcmd")
    sleep(0.05)
    if this then
      local var = this.readAll()
      if var ~= "" then
        outputWin.setCursorPos(1, 1)
        outputWin.clearLine()
        outputWin.write(var)
      end
    end
  end
end

-- Input window (for display text input)
local inputWin = window.create(term.current(), 1, 2, termSizeX, 1)
inputWin.clear()

function listenForDisplayInput()
  while true do
    inputWin.setCursorPos(1, 1)
    inputWin.clear()
    inputWin.write("Enter display text: ")
    -- Redirect input so that read() uses the input window
    local originalTerm = term.current()
    term.redirect(inputWin)
    local input = read()
    term.redirect(originalTerm)
    displayText = input
  end
end

parallel.waitForAll(webserver, listenhttp, listenForDisplayInput)
