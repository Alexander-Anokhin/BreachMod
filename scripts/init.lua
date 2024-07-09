local description = "CyberKn1ght test mod"

local mod = {
    id = "Cyber_test",
    name = "Cyber test mod",
    version = "1.2",
    modApiVersion = "2.9.2",
    gameVersion = "1.2.88",
    icon = "img/mod_icon.png",
    description = description,
}

function mod:init()
    require(self.scriptPath.."weapons")
end

function mod:load(options, version)

end

return mod
