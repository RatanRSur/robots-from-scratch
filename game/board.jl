# Board class, includes:
# matrix representation of the board
# method to draw the board

using StatsBase.sample
using Base.Test

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

type Board
        height::Int
        width::Int
        num_robots::Int

        #=
        The matrix representation is a 3D matrix in which each "slice" shows
        the existence of a player, robot, or scrap pile at each coordinate
        e.g. matrix_representation[2,5,3] will be 1 iff there is a scrap pile at
        coordinate 2,5. Likewise, matrix_representation[2,5,1] and [2,5,2] denote the
        existence of a player or robot at [2,5], respectively.
        =#
        matrix_representation::Array{Int,3}
        player_position::Array{Int}
        robot_positions::Array{Int,2}
        scrap_positions::Array{Int,2}

        # Constructors
        Board(h,w,nrobots) = begin
                board = new(h,w,nrobots)
                board.height = h
                board.width = w
                board.num_robots = nrobots
                matrix_representation = zeros(Int,h,w,3)

                #random initialization of player and robots, empty initialization of scrap pile
                rand_coords = [sample(1:h ,nrobots+1, replace = false) sample(1:w, nrobots+1, replace = false)]
                board.player_position = rand_coords[1,:]
                robot_positions = rand_coords[2:end,:]
                scrap_positions = []

                matrix_representation[board.player_position[1],board.player_position[2],1] = 1
                set_indices_to!(matrix_representation[2],robot_positions,1)
                # initialize robots as well
                return board
        end

        Board() = Board(24,60,10)
        Board(nrobots ::Int) = Board(24,60,nrobots)

        # Methods
        # move_robots() = begin
        # matrix_representation[:,:,2] = 0
        # end

        # move(direction::String) = begin
        # if direction == "u"
end


b = Board()
# println(b.robot_positions)
