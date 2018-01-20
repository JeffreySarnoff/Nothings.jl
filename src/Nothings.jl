__precompile__(true)
module Nothings

using Compat

export allownothing, disallownothing, isnothing, nothing, nothings,
       Nothing, NothingException, levels, coalesce 

if VERSION < v"0.7.0-DEV.2762"
    """
        Nothing

    A type with no fields whose singleton instance [`nothing`](@ref) is used
    to represent nothing values.
    """
    struct Nothing end

    """
        NothingException(msg)

    Exception thrown when a [`nothing`](@ref) value is encountered in a situation
    where it is not supported. The error message, in the `msg` field
    may provide more specific details.
    """
    struct NothingException <: Exception
        msg::AbstractString
    end
end

import Base: ==, !=, <, *, <=, !, +, -, ^, /, &, |, xor

if VERSION >= v"0.7.0-DEV.2762"
    using Base: isnothing, nothing, Nothing, NothingException
else
    """
        nothing

    The singleton instance of type [`Nothing`](@ref) representing a nothing value.
    """
    const nothing = Nothing()

    Base.show(io::IO, x::Nothing) = print(io, "nothing")

    Base.showerror(io::IO, ex::NothingException) =
        print(io, "NothingException: ", ex.msg)

    isnothing(::Any) = false
    isnothing(::Nothing) = true

    Base.promote_rule(::Type{T}, ::Type{Nothing}) where {T} = Union{T, Nothing}
    Base.promote_rule(::Type{T}, ::Type{Union{S,Nothing}}) where {T,S} = Union{promote_type(T, S), Nothing}
    Base.promote_rule(::Type{T}, ::Type{Any}) where {T} = Any
    Base.promote_rule(::Type{Any}, ::Type{Nothing}) = Any
    Base.promote_rule(::Type{Nothing}, ::Type{Any}) = Any
    Base.promote_rule(::Type{Nothing}, ::Type{Nothing}) = Nothing

    Base.convert(::Type{Union{T, Nothing}}, x) where {T} = convert(T, x)

    # Comparison operators
    ==(::Nothing, ::Nothing) = nothing
    ==(::Nothing, b) = nothing
    ==(a, ::Nothing) = nothing
    # != must be defined explicitly since fallback expects a Bool
    !=(::Nothing, ::Nothing) = nothing
    !=(::Nothing, b) = nothing
    !=(a, ::Nothing) = nothing
    Base.isequal(::Nothing, ::Nothing) = true
    Base.isequal(::Nothing, b) = false
    Base.isequal(a, ::Nothing) = false
    <(::Nothing, ::Nothing) = nothing
    <(::Nothing, b) = nothing
    <(a, ::Nothing) = nothing
    Base.isless(::Nothing, ::Nothing) = false
    Base.isless(::Nothing, b) = false
    Base.isless(a, ::Nothing) = true
    if VERSION < v"0.7.0-DEV.300"
        <=(::Nothing, ::Nothing) = nothing
        <=(::Nothing, b) = nothing
        <=(a, ::Nothing) = nothing
    end

    # Unary operators/functions
    for f in (:(!), :(+), :(-), :(Base.identity), :(Base.zero), :(Base.one), :(Base.oneunit),
            :(Base.abs), :(Base.abs2), :(Base.sign),
            :(Base.acos), :(Base.acosh), :(Base.asin), :(Base.asinh), :(Base.atan), :(Base.atanh),
            :(Base.sin), :(Base.sinh), :(Base.cos), :(Base.cosh), :(Base.tan), :(Base.tanh),
            :(Base.exp), :(Base.exp2), :(Base.expm1), :(Base.log), :(Base.log10), :(Base.log1p),
            :(Base.log2), :(Base.exponent), :(Base.sqrt), :(Base.gamma), :(Base.lgamma),
            :(Base.iseven), :(Base.ispow2), :(Base.isfinite), :(Base.isinf), :(Base.isodd),
            :(Base.isinteger), :(Base.isreal), :(Base.isimag), :(Base.isnan), :(Base.isempty),
            :(Base.iszero), :(Base.transpose), :(Base.float))
        @eval $(f)(d::Nothing) = nothing
    end

    for f in (:(Base.zero), :(Base.one), :(Base.oneunit))
        @eval function $(f)(::Type{Union{T, Nothing}}) where T
            T === Any && throw(MethodError($f, (Any,)))
            $f(T)
        end
    end

    # Binary operators/functions
    
    for f in (:(+), :(-), :(*), :(/), :(^),
            :(Base.div), :(Base.mod), :(Base.fld), :(Base.rem), :(Base.min), :(Base.max))
        @eval ($f)(::Nothing, ::Nothing) = nothing
    end

    for f in (:(+), :(*), :(Base.min), :(Base.max))
        @eval begin
            ($f)(a::Number, o::Nothing) = a
            ($f)(o::Nothing, a::Number) = a
        end    
    end

    Base.:(-)(a::Number, o::Nothing) =  a
    Base.:(-)(o::Nothing, a::Number) = -a
    Base.:(^)(a::Number, o::Nothing) =  a
    Base.:(^)(o::Nothing, a::Number) = nothing
    
    for f in (:(/), :(Base.div), :(Base.fld), :(Base.cld))
        @eval begin
            ($f)(a::Number, o::Nothing) = a
            ($f)(o::Nothing, a::Number) = inv(a)
        end    
    end

    for f in (:(Base.mod), :(Base.rem))
        @eval begin
            ($f)(a::Number, o::Nothing) = a
            ($f)(o::Nothing, a::Number) = nothing
        end    
    end

end # module Nothings
