module Tools

using Random
# Exporting after each definition

"""
    print_properties(x, l_max=500, padding=15, padfunc=lpad)

Print all propertynames of `x`, followed their value.
"""
function print_properties(x, l_max=500, padding=15, padfunc=lpad)
    props = propertynames(x)
    for prop in props
        second_part = "$(getproperty(x, prop))"
        second_part = length(second_part) < l_max ? second_part : "More than $l_max letters."
        println(padfunc("$prop = ", padding) *  second_part)
    end
end
export print_properties

"""
    batch(v::AbstractVector, n_batches::Int, shuffle_pics=false; check_even=true, return_indices=false)

Create a vector of `n_batches` vectors, containing all of `v`.
"""
function batch(v::AbstractVector, n_batches::Int, shuffle_input=false; check_even=true, return_indices=false)
    @assert length(v) ≥ n_batches "Trying to make $n_batches batches from $(length(v)) elements. This would result in empty arrays of type `Any`, which is likely to cause problems."
    shuffle_input  &&  (v = Random.shuffle(v))
    check_even  &&  length(v) % n_batches != 0   &&   @warn "Number of elements not divisible by number of batches. Batches will be uneven. Set `check_even` to false to silence this warning"
    divs, rems = divrem(length(v), n_batches)
    batchlengths = fill(divs, n_batches)
    batchlengths[end-rems+1:end] .+= 1
    
    cumsums = pushfirst!(cumsum(batchlengths), 0)
    ranges = [cumsums[i]+1:cumsums[i+1] for i in 1:n_batches]
    if return_indices
        return (ranges, getindex.([v], ranges))
    else
        return getindex.([v], ranges)
    end
end
export batch

"""
    ⊕(args...) = 1/sum(inv, args)

Compute the reciprocal of sum of reciprocals.
Can be used as infix operator.
"""
⊕(args...) = 1/sum(inv, args)
export ⊕
const ∥ = ⊕

"""
    moving_avg(v::AbstractVector, n)

Iterate over `v`, computing the average of the current and 
next n-1 (n total) elements, returning it as a vector.
"""
function moving_avg(v::AbstractVector, n)
    output = Vector{Float64}(undef, length(v)-(n-1))
    for i in eachindex(output)
        output[i] = sum(v[i:i+(n-1)])/(n)
    end
    return output
end
export moving_avg

end
