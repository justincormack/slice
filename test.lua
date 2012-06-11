
local slice = require "slice"

local a = slice.slice("int", 1, 2, 3, 4, 5)

for i = 1, #a do
  assert(a[i - 1] == i)
end

print(a)

