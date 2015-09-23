function set_indices_to!(mutee::Array{Int,2},indices::Array{Int,2},set_val)
        for y in 1:size(indices,1)
                mutee[indices[y,1], indices[y,2]] = set_val
        end
        return mutee
end

function towards(origin, destination)
        if origin > destination
                return origin - 1
        end
        if origin > destination
                return origin + 1
        end
        return origin
end
