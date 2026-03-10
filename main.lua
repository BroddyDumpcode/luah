

repeat task.wait() until game:IsLoaded()
local repo = "https://raw.githubusercontent.com/BroddyDumpcode/luah/main/"
setProgress(0.2)
local GUI = loadstring(game:HttpGet(repo.."utils/GUI.lua"))()
setProgress(0.4)
local modules = {
    ngapung = loadstring(game:HttpGet(repo.."modules/fly.lua"))(),
    ngabret = loadstring(game:HttpGet(repo.."modules/ngabret.lua"))(),
    esp = loadstring(game:HttpGet(repo.."modules/esp.lua"))(),
    nclip = loadstring(game:HttpGet(repo.."modules/nclip.lua"))(),
    infjmp = loadstring(game:HttpGet(repo.."modules/infjmp.lua"))(),
    pepet = loadstring(game:HttpGet(repo.."utils/tpgui.lua"))()
}
setProgress(0.7)

print("feature has been loaded...")
print("ngabret:", modules.ngabret)
print("setSpeed:", modules.ngabret and modules.ngabret.setSpeed)
setProgress(1)
task.wait(0.5)
loadingGui:Destroy()
GUI:Init(modules)


