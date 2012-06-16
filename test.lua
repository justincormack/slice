
local ffi = require "ffi"
local slice = require "slice"

local int_t = ffi.typeof("int")

local a, b

a = slice.make(int_t, {})
assert(a.len == 0)
assert(a.cap == 0)

a = slice.make(int_t, 5, 5)

assert(a.len == 5)
assert(a.cap == 5)

a = slice.make(int_t,  {1, 2, 3, 4, 5})

for i = 1, a.len do
  assert(a[i - 1] == i)
end

assert(a.len == 5)
assert(a.cap == 5)

print(a)

b = a.slice(1, 4)

assert(b.len == 3)
assert(tostring(b) == "[2,3,4]")

a = slice.make(int_t, 0, 5)
assert(tostring(a) == "[]")

b = slice.make(int_t,  {1, 2, 3, 4, 5})

slice.copy(a, b)

assert(tostring(a) == "[1,2,3,4,5]")
assert(#a.table == 5)

