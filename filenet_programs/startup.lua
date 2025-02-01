shell.run("bg", "cdsr_base.lua")
shell.run("bg", "cdsr_fort.lua")
shell.run("bg", "cdsd.lua")
shell.run("bg", "updater.lua")
if fs.exists("filenet") then
  _G.filenet = require("filenet")
end
