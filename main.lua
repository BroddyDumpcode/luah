local repo = "https://raw.githubusercontent.com/BroddyDumpcode/"
local gui = loadstring(game:HttpGet(repo.."luah/refs/heads/main/utils/GUI.lua"))()

local modules = {
    ngapung = loadstring(game:HttpGet(repo.."luah/refs/heads/main/modules/fly.lua"))()
    ngabret = loadstring(game:HttpGet(repo.."luah/refs/heads/main/modules/ngabret.lua"))()
    esp = loadstring(game:HttpGet(repo.."luah/refs/heads/main/modules/esp.lua"))()
    pepet = loadstring(game:HttpGet(repo.."luah/refs/heads/main/utils/tpgui.lua"))()
    nclip = loadstring(game:HttpGet(repo.."luah/refs/heads/main/modules/nclip.lua"))()
    infjmp = loadstring(game:HttpGet(repo.."luah/refs/heads/main/modules/infjmp.lua"))()
}


gui:Init(modules)
