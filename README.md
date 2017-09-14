# purescript-tritium

# Usage

Tritium is a minimalistic and light-weight virtual DOM
(VDOM) _data representation_. This library only provides
the basic types which get you started on building your very
own virtual DOM library. Tritium provides you with the right
data types and the appropriate class instances.

## Keyed nodes

If you've used a library like React in the past, you may
know that the children of unordered lists (`ol`), other
elements in that category, and elements which have been
rendered by some sort of mapping function need to use the
`key` attribute for the most optimized result. Tritium has
something similar called a `KeyedNode`. It can be used to 
speed up the diffing process and to uniquely identify each
generated element.
