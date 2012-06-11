
-- array slice code. API loosely based around the Go slice API

local function slice()

local ffi = require "ffi"

--local arrays = {} -- weak table to 
--setmetatable(arrays, {__mode = "v"} -- weak values

local slice = {}

local buffer = ffi.typeof("char [?]")

local mt = {
  __len = function(s) return s.len end,
  __index = function(s, i) return s.slice[i] end,
  __newindex = function(s, i, v) s.slice[i] = v end,
  __tostring = function(s)
  local t = {}
    for i = 1, s.len do
      t[#t + 1] = tostring(s.slice[i - 1])
    end
    return "[" .. table.concat(t, ",") .."]"
  end
}

-- type needs to be passed as string, as can't do pointer to type. hmmm.

function slice.make(typ, len, cap)
  cap = cap or len or 0
  local array = ffi.cast(ffi.typeof(typ .. "*"), buffer(cap * ffi.sizeof(ffi.typeof(typ))))
  local s = {len = len, cap = cap, slice = array, array = array}
  setmetatable(s, mt)
  return s
end

function slice.slice(typ, t, ...) -- like the Go slice literal, but can also take table
  if type(t) ~= "table" then t = {t, ...} end
  local len = #t
  local s = slice.make(typ, len)
  for i = 1, len do
    s[i - 1] = t[i]
  end
  return s
end


return slice

end

return slice()


