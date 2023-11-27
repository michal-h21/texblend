package.path=package.path .. ';./build/texblend/?'
_G.__test__ = true
-- try to translate the help message to a Man page
local texblend = require("texblend")



print(texblend.cmd_options)
