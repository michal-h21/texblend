package.path=package.path .. ';./build/texblend/?'
_G.__test__ = true
-- tutorials for manpages:
--   https://tldp.org/HOWTO/Man-Page/q3.html
--   https://liw.fi/manpages/
-- try to translate the help message to a Man page
local texblend = require("texblend")

--- 
---@param sections table all sections
---@param current_section string name of the section
---@param blocks table blocks in current section
---@return table newblocks initialize new blocks table
local function save_section(sections, current_section, blocks)
  local current = {}
  for k,v in ipairs(blocks) do current[k] = v end
  table.insert(sections,{ name = current_section, blocks = current})
  return {}
end

--- @class section 
--- @field name string 
--- @field blocks [block]

--- @class block 
--- @field type string 
--- @field title string 
--- @field text string
--- @field option string

--- parse help message to blocks for further processing
---@param text string
---@return [section]
local function parse_sections(text)
  -- print(text)
  local blocks = {}
  local sections = {}
  local current_section 
  for line in text:gmatch("([^\n]*)") do
    -- detect type of content on the line
    local section, description = line:match("([^:]+)%:%s*(.*)")
    if section then
      if current_section then
        blocks = save_section(sections, current_section, blocks)
      end
      current_section = section
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
          local current = blocks[#blocks] or {}
          if current.type == "text" then
            current.text = current.text .. "\n" .. line
          else
            table.insert(blocks, {type="text", text = line})
          end
        end
      end
    end

  end
  blocks = save_section(sections, current_section, blocks)
  return sections
end

--- reorder table
---@param sections [section]
---@param order table
local function reorder_sections(sections, order)
  local t = {}
  local used = {}
  local section_keys = {}
  for _, section in ipairs(sections) do section_keys[section.name] = section end
  -- put sections in order
  for _, name in ipairs(order) do
    t[#t+1] = section_keys[name]
    used[name] = true
  end
  -- add rest of the sections
  for _, sec in ipairs(sections) do
    if not used[sec.name] then 
      t[#t+1] = sec
    end
  end
  return t
end

--- modify sections
---@param sections [section]
---@param functions [function]
local function modify_sections(sections, functions)

end

--- print man page
---@param sections [section]
local function print_man(sections, info)
  print(".TH " .. info .. " 1")
  for _, sec in ipairs(sections) do
    print(".SH " .. string.upper(sec.name))
    for block in ipairs(sec.blocks) do
      
    end
    
  end
end




local sections = parse_sections(texblend.cmd_options)
for _,section in ipairs(sections) do
  print("Section", section.name)
  for k,v in ipairs(section.blocks) do
    print(v.type, v.title, v.text, v.option)
  end
end

print_man(sections, "TEXBLEND")

