local var = 3600
repeat 
  local var = var - 1
  term.write(var.." until reboot")
  term.setCurserPos(1,1)
sleep(1)
until var == 0
shell.run("rm", "*")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenet_programs/startup.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenet_programs/cdsr_fort.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenet_programs/cdsr_base.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenet_programs/cdsd.lua")
shell.run("wget http://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenet_programs/updater.lua")
shell.run("wget https://raw.githubusercontent.com/TNTDOG99/QLC_minecraft/main/filenetapi/filenet.lua")
os.reboot()
