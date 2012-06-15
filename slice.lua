
-- array slice code. API loosely based around the Go slice API

local function slice()

local ffi = require "ffi"

local slice = {}

local buffer = ffi.typeof("char [?]")

local mt = {
  __len = function(s) return s.len end, -- only works in 5.2
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

function slice.make(ct, len, cap)
  local t
  if type(len) == 'table' then
    t = len
    len = #t
  end
  cap = cap or len or 0
  local array = ffi.cast(ffi.typeof("$ *", ct), buffer(cap * ffi.sizeof(ffi.typeof(ct))))
  local s = {len = len, cap = cap, slice = array, array = array, type = ct}
  if t then for i = 1, len do s.slice[i - 1] = t[i] end end
  return setmetatable(s, mt)
end



return slice

end

return slice()


