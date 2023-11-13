require "busted.runner" ()
package.path=package.path .. ';?'
arg[1] = "__test__"
local texblend = require("texblend")
describe("test metadata parsing", function()
  it("should parse simple metadata", function()
    local simple = [[
% !TEX root = texblend-doc.tex
% !TEX TS-program = lualatex

hello world
]]
    local metadata = texblend.get_metadata(simple)
    assert.table(metadata)
    assert.string(metadata.root)
    assert.same(metadata.root, "texblend-doc.tex")
    assert.same(metadata.program, "lualatex")
  end)
  it("should parse any metadata", function()
    local more = [[
%!TeX hello=world
    ]]
    local metadata = texblend.get_metadata(more)
    assert.string(metadata.hello)
    assert.same(metadata.hello, "world")
  end)
  it("should support filenames with spaces", function()
    local more = [[
%!TeX root = spaces in filenames are evil.tex
    ]]
    local metadata = texblend.get_metadata(more)
    assert.string(metadata.root)
    assert.same(metadata.root, "spaces in filenames are evil.tex")


  end)

end)

