package.path=package.path .. ';./build/texblend/?'
_G.__test__ = true
-- tutorials for manpages:
--   https://tldp.org/HOWTO/Man-Page/q3.html
--   https://liw.fi/manpages/
-- try to translate the help message to a Man page
local texblend = require("texblend")

local function parse_sections(text)
  print(text)
  local blocks = {}
  local sections = {}
  for line in text:gmatch("([^\n]*)") do
    local section, description = line:match("([^:]+)%:%s*(.*)")
    if section then
      table.insert(blocks, {type="section", title = section, text = description})
    else
      local option, description = line:match("^%s*([%-%<][%a%d%-%,%>]+)%s*(.+)")
      if option then
        description = description:gsub("^%([^%)]+%)%s*", "")
        table.insert(blocks, {type="option", option = option, text = description})
      else
        local whitespace = line:match("^(%s*)$")
        if whitespace then
          table.insert(blocks, {type="whitespace", text = whitespace})
        else
          table.insert(blocks, {type="text", text = line})
        end
      end
    end

  end
  for k,v in ipairs(blocks) do
    print(v.type, v.text)
  end

end


local sections = parse_sections(texblend.cmd_options)
