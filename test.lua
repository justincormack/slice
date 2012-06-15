
local ffi = require "ffi"
local slice = require "slice"

local int_t = ffi.typeof("int")

local a = slice.slice(int_t,  1, 2, 3, 4, 5)

for i = 1, #a do
  assert(a[i - 1] == i)
end

print(a)

