local var = 3600
repeat 
  var = var - 1
  term.write(var.." seconds until reboot")
  term.setCursorPos(1,1)
sleep(1)
until var == 0
shell.run("rm", "*")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/rct_http/turtle/checker.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/rct_http/turtle/rct_v1.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/rct_http/turtle/startup.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/rct_http/turtle/updater.lua")
os.reboot()
