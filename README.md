# Nothings.jl
#### Additional support for Nothing

Copyright &copy; 2018 by Jeffrey Sarnoff.  This work is available under the MIT License.

-----
`nothing` is the singleton of type `Nothing` that represents absence of valuation.  It is distinct from `missing`, which represents the unavailability of a data value.

`missing` dominates operations: `1 + missing == missing`, `sin(missing) == missing`.  

`nothing` is dominated in operations: `1 + nothing == 1`, `sin(nothing) == NothingError`.

This is a variation of @quinnj's Missings.jl, and copies liberally therefrom.
