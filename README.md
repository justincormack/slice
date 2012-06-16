This is a simple Luajit ffi array slice library, loosely based on he Go slice API

This requires Luajit head is it uses the new parameterized types http://www.freelists.org/post/luajit/ffi-type-of-pointer-to,4

The Go API is documented here http://blog.golang.org/2011/01/go-slices-usage-and-internals.html and http://golang.org/ref/spec#Slice_types

TODO: add append operation, plus expand length helper. Decide how best to check two types are the same.

This code is licensed under the MIT license.


