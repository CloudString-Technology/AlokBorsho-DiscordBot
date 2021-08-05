local path = require("luvi").path.join

local cmdModule = path(module.dir, "_Commands")

_G.CMD = {}


require("../../_Commands")

require("./messageCreate")