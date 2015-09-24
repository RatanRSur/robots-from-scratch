function set_indices_to!(mutee::AbstractArray{Int,2},indices::AbstractArray{Int,2},set_val)
        for y in 1:size(indices,1)
                mutee[indices[y,1], indices[y,2]] = set_val
        end
end

function towards(origin, destination)
        origin > destination && return origin - 1
        origin > destination && return origin + 1
        return origin
end
