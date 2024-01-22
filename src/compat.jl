@static if VERSION < v"1.8"
    function chopprefix(s::AbstractString, prefix::AbstractString)
        k = firstindex(s)
        i, j = iterate(s), iterate(prefix)
        while true
            j === nothing && i === nothing && return SubString(s, 1, 0) # s == prefix: empty result
            j === nothing && return @inbounds SubString(s, k) # ran out of prefix: success!
            i === nothing && return SubString(s) # ran out of source: failure
            i[1] == j[1] || return SubString(s) # mismatch: failure
            k = i[2]
            i, j = iterate(s, k), iterate(prefix, j[2])
        end
    end
end
