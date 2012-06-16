
-- array slice code. API loosely based around the Go slice API http://blog.golang.org/2011/01/go-slices-usage-and-internals.html

local function slice()

local ffi = require "ffi"

local slice = {}

local buffer = ffi.typeof("char [?]")

local mt

local function totable(s)
  local t = {}
  for i = 1, s.len do
    t[#t + 1] = tostring(s.s[i - 1])
  end
  return t
end

-- raw make function
local function make(ct, len, cap)
  cap = cap or len or 0
  local array = ffi.cast(ffi.typeof("$ *", ct), buffer(cap * ffi.sizeof(ffi.typeof(ct))))
  local s = {len = len, cap = cap, s = array, array = array, type = ct}
  return setmetatable(s, mt)
end

local function sametype(a, b) -- not sure how to test if same - should we try casting src to dest?
  if ffi.sizeof(a.type) ~= ffi.sizeof(b.type) then error("cannot copy slices of different types") end
end

mt = {
  __len = function(s) return s.len end, -- only works in 5.2
  __index = function(s, i)
    if i == 'slice' then return function(i, j)
        if not i then i = 0 end
        if not j then j = s.len end
        local len = j - i
        return setmetatable({len = len, cap = s.cap, s = s.s + i, array = s.array, type = s.type}, mt)
      end
    end
    if i == 'table' then return totable(s) end
    return s.s[i]
  end,
  __newindex = function(s, i, v) s.s[i] = v end,
  __tostring = function(s)
    return "[" .. table.concat(totable(s), ",") .."]"
  end,
  __concat = function(a, b)
    sametype(a, b)
    local len = a.len + b.len
    if len > b.cap then
      local s = make(a.type, len)
      ffi.copy(s.s, a.s, ffi.sizeof(a.type) * a.len)
      ffi.copy(s.s + a.len, b.s, ffi.sizeof(a.type) * b.len)
      return s
    end
    ffi.copy(a.s + a.len, b.s, ffi.sizeof(a.type) * b.len)
    return s
  end
}

function slice.make(ct, len, cap) -- allows table initializer
  local t
  if type(len) == 'table' then
    t = len
    len = #t
  end
  local s = make(ct, len, cap)
  if t then for i = 1, len do s.s[i - 1] = ct(t[i]) end end
  return s
end

function slice.copy(dest, src)
  sametype(dest, src)
  local len = math.min(dest.cap, src.len)
  ffi.copy(dest.s, src.s, ffi.sizeof(dest.type) * len)
  dest.len = len
  return dest
end

return slice

end

return slice()


