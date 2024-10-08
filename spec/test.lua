require "busted.runner" ()

local describe = describe
local it = it
local assert = assert
assert.truthy = assert.truthy
assert.same = assert.same
assert.falsy = assert.falsy
assert.string = assert.string

package.path=package.path .. ';?'
_G.__test__ = true
local texblend = require("texblend")
local simple = [[
% !TEX root = texblend-doc.tex
% !TEX TS-program = lualatex

hello world
]]
describe("test metadata parsing", function()
  it("should parse simple metadata", function()
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

local test_main = [[
\documentclass{article}
\usepackage{fontspec}
\begin{document}
hello document
\end{document}
  ]]

local test_content = [[ 
\documentclass{article}
\usepackage{fontspec}
\begin{document}
\maketitle
{{content}}
\end{document}
]]
describe("test preamble parsing", function()
  it("should parse preamble", function()
    local preamble = texblend.get_preamble(test_main)
    assert.string(preamble)
    assert.truthy(preamble:match("fontspec"))
    assert.falsy(preamble:match("hello"))
  end)
end)

describe("test template setting", function()
  it("should build document", function()
    local doc = "this is included text"
    local joined = texblend.prepare_template(doc, test_main)
    assert.string(joined)
    assert.truthy(joined:match("fontspec"))
    assert.truthy(joined:match("document"))
    assert.truthy(joined:match("included"))
    assert.falsy(joined:match("hello"))
  end)
end)

describe("test template with {{content}} tag", function()
  it("should support {{content} tag", function()
    local doc = "hello doc" 
    local joined = texblend.prepare_template(doc, test_content)
    assert.truthy(joined:match("hello"))
    assert.truthy(joined:match("maketitle"))
    assert.truthy(joined:match("fontspec"))
  end)
end)

describe("test commands", function()
  local arguments = {filename="sample.tex"}
  local metadata  = {
    output = "sample",
    program = "lualatex"
  }
  it("should create basic command", function()
    local command = texblend.prepare_command(metadata, arguments)
    assert.string(command)
    assert.same(command, "lualatex -jobname=sample")
  end)
  it("should support make4ht", function()
    metadata.html = true
    local command = texblend.prepare_command(metadata, arguments)
    assert.string(command)
    assert.same(command, "make4ht -j sample -l -")
  end)
  it("should work also by parsing metadata from the tex file", function()
    local metadata = texblend.get_metadata(simple)
    metadata = texblend.use_arguments(metadata, arguments)
    assert.same(metadata.output, "sample")
    assert.same(texblend.prepare_command(metadata, arguments), "lualatex -jobname=sample")
  end)

end)

describe("test expand", function()
  local metadata = {hello = "world"}
  it("should expand variable", function()
    local template = "this is {{hello}}"
    assert.same(texblend.expand(metadata, template), "this is world")
    metadata["x1"] = "numeric"
    template = "try {{x1}}"
    assert.same(texblend.expand(metadata, template), "try numeric")
  end)
  it("should ignore unknown variable",function()
    local template = "this is {{unknown}}"
    -- remove unknown tag
    assert.same(texblend.expand(metadata, template), "this is ")
  end)
  it("should work with tex commands",function()
    local template = "this is \\command{{something} else}"
    -- remove unknown tag
    assert.same(texblend.expand(metadata, template), "this is \\command{{something} else}")
    local template = "\\command{{{hello}}}"
    assert.same(texblend.expand(metadata, template), "\\command{world}")
  end)
  it("should support ignored tags", function()
    local template = "hello {{hello}}, {{content}}"
    assert.same(texblend.expand(metadata, template, {"content"}), "hello world, {{content}}")
  end)
end)

