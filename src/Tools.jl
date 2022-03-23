module Tools

# Exporting after each definition

"""
    print_fields(x, l_max=500, padding=15, padfunc=lpad)

Print all fieldnames of `x`, followed their value.
"""
function print_fields(x, l_max=500, padding=15, padfunc=lpad)
    fields = fieldnames(x)
    for field in fields
        second_part = "$(getfield(x, field))"
        second_part = length(second_part) < l_max ? second_part : "More than $l_max letters."
        println(padfunc("$field = ", padding) *  second_part)
    end
end
export print_fields

"""
    batch(v::AbstractVector, n_batches::Int, shuffle_pics=false; check_even=true, return_indices=false)

Create a vector of `n_batches` vectors, containing all of `v`.
"""
function batch(v::AbstractVector, n_batches::Int, shuffle_input=false; check_even=true, return_indices=false)
    @assert length(v) ≥ n_batches "Trying to make $n_batches batches from $(length(v)) elements. This would result in empty arrays of type `Any`, which is likely to cause problems."
    shuffle_input  &&  (v = shuffle(v))
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
    ⊕(args...) = 1/sum(x->1/x, args)

Compute the reciprocal over sum of reciprocal.
Can be used as infix operator.
"""
⊕(args...) = 1/sum(x->1/x, args)
export ⊕

end