
local ffi = require "ffi"
local slice = require "slice"

local int_t = ffi.typeof("int")

local a

a = slice.make(int_t, 5, 5)

assert(a.len == 5)
assert(a.cap == 5)

a = slice.slice(int_t,  1, 2, 3, 4, 5)

for i = 1, a.len do
  assert(a[i - 1] == i)
end

assert(a.len == 5)
assert(a.cap == 5)

a = slice.slice(int_t,  {1, 2, 3, 4, 5})

for i = 1, a.len do
  assert(a[i - 1] == i)
end

assert(a.len == 5)
assert(a.cap == 5)

print(a)

a = slice.slice(int_t, {})
assert(a.len == 0)
assert(a.cap == 0)

