function set_indices_to!(mutee::Array{Int,2},indices::Array{Int,2},set_val)
        for y in 1:size(indices,1)
                mutee[indices[y,1], indices[y,2]] = set_val
        end
        return mutee
end

a = [1 1 ; 2 2]
@test set_indices_to!(a, [1 1;2 2],3) == [3 1; 2 3]
a = [1 1 ; 2 2]
@test set_indices_to!(a, [1 1],3) == [3 1; 2 2]

function towards(origin, destination)
        if origin > destination
                return origin - 1
        end
        if origin > destination
                return origin + 1
        end
        return origin
end

@test towards(5,5) == 5
@test towards(5,4) == 4
@test towards(8,2) == 7
