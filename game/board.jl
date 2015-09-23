# Board class, includes:
# matrix representation of the board
# method to draw the board

type Player
        y::Int
        x::Int
end

type Board
        height::Int
        width::Int
        num_robots::Int

        #=
        The matrix representations is a pair of 3D matrices (1 4D matrix)
        in which each "slice" shows
        the existence of a player, robot, or scrap pile at each coordinate in
        e.g. matrix_representations[1,2,5,3] will be 1 iff there is a scrap pile at
        coordinate 2,5 in the first 3D matrix.
        Likewise, matrix_representations[2,2,5,1] and [2,2,5,2] denote the existence
        of a player or robot at [2,5] in the second 3D matrix.
        =#

        matrix_representations::Array{Int,4}
        active::Int
        inactive::Int
        player::Player

        # Constructors
        Board(h=24,w=60,nrobots=10) = begin
                board = new(h,w,nrobots)
                matrix_representations = zeros(Int,2,h,w,3)
                board.active = 1
                board.inactive = 2

                #random initialization of player and robots
                rand_coords = [sample(1:h ,nrobots+1, replace = false) sample(1:w, nrobots+1, replace = false)]
                player = Player(rand_coords[1,1], rand_coords[1,2])
                robot_positions = rand_coords[2:end,:]

                matrix_representations[active,player.y,player.x,1] = 1
                set_indices_to!(matrix_representations[active,:,:,2], robot_positions , 1)
                return board
        end

        Board(nrobots::Int) = Board(24,60,nrobots)
end

function move_robots!(old_robot_field::Array{Int,2}, new_robot_field::Array{Int,2})
        height = size(old_robot_field,1)
        width = size(old_robot_field,2)
        for y = 1:height, x = 1:width
                if old_robot_field[y,x] == 1
                        new_robot_field[towards(player.y,y) , towards(player.x,x) ] += 1
                end
        end
end

function scrap_robots!(robot_field::Array{Int,2},scrap_field::Array{Int,2})
        height = size(robot_field,1)
        width = size(robot_field,2)
        for y = 1:height, x = 1:width
                if robot_field[y,x] > 1
                        robot_field[y,x] = 0
                        scrap_field[y,x] = 1
                end
        end
end

function move_and_scrap_robots!(b::Board)
        old_slice = slice(b.matrix_representations[b.active,:,:,2])
        new_slice = zeros(old_slice)
        move_robots!(old_slice,new_slice)
        scrap_robots!(new_slice,b.matrix_representations[inactive,:,:,3])
        b.matrix_representations[inactive,:,:,2] = new_slice
end


function switch_active_board(board::Board)
        board.active, board.inactive = board.inactive, board.active
end
