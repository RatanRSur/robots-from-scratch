# Contents:
# Player type
# Board type

type Player
        y::Int
        x::Int
        is_alive::Bool

        Player(ypos,xpos) = new(ypos,xpos,true)
end

function move!(player::Player, direction::String)
        contains(direction, "n") && (player.y += 1)
        contains(direction, "s") && (player.y -= 1)
        contains(direction, "e") && (player.x -= 1)
        contains(direction, "w") && (player.x += 1)
end

function teleport!(player::Player, h, w)
        player.y = rand(1:h)
        player.x = rand(1:w)
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
                this = new(h,w,nrobots)
                this.matrix_representations = zeros(Int,2,h,w,3)
                this.active = 1
                this.inactive = 2

                #random initialization of player and robots
                rand_coords = [sample(1:h ,nrobots+1, replace = false) sample(1:w, nrobots+1, replace = false)]
                this.player = Player(rand_coords[1,1], rand_coords[1,2])
                robot_positions = rand_coords[2:end,:]
                this.matrix_representations[this.active,this.player.y,this.player.x,1] = 1
                set_indices_to!(slice(this.matrix_representations,this.active,:,:,2), robot_positions , 1)
                return this
        end

        Board(nrobots::Int) = Board(24,60,nrobots)
end

function move_robots!(old_robot_field::Array{Int,2}, new_robot_field::Array{Int,2})
        height, width = size(old_robot_field)
        for y = 1:height, x = 1:width
                if old_robot_field[y,x] == 1
                        new_robot_field[towards(player.y,y) , towards(player.x,x) ] += 1
                end
        end
end

function scrap_robots!(robot_field::Array{Int,2},scrap_field::Array{Int,2})
        height, width = size(robot_field)
        for y = 1:height, x = 1:width
                if scrap_field[y,x] == 1
                        robot_field[y,x] = 0
                end
                if robot_field[y,x] > 1
                        robot_field[y,x] = 0
                        scrap_field[y,x] = 1
                end
        end
end

function move_and_scrap_robots!(b::Board)
        old_robot_field = slice(b.matrix_representations[b.active,:,:,2])
        new_robot_field = zeros(old_robot_field)
        move_robots!(old_robot_field,new_robot_field)
        scrap_robots!(new_robot_field,b.matrix_representations[inactive,:,:,3])
        b.num_robots = sum(new_robot_field)
        b.matrix_representations[inactive,:,:,2] = new_robot_field
end

function switch_active_board!(board::Board)
        board.active, board.inactive = board.inactive, board.active
end

function update_player_pos!(board::Board)
        if board.matrix_representations[inactive,board.player.y,board.player.x,1] != 1
                board.matrix_representations[inactive,:,:,1] = 0
                board.matrix_representations[inactive,board.player.y,board.player.x,1] = 1
        end
end

function move_player!(board::Board, direction::String)
        move!(board.player, direction)
        update_player_pos(board)
end

function print_cell(board::Board, y, x)
        board.matrix_representations[board.active,y,x,1] == 1 && (print('@'); return)
        board.matrix_representations[board.active,y,x,2] == 1 && (print('+'); return)
        board.matrix_representations[board.active,y,x,3] == 1 && (print('*'); return)
        print(' ')
end

function draw(board::Board)
        print("+")
        for i=1:board.width
                print("-")
        end
        print("+")
        print('\n')
        for y = 1:board.height
                print('|')
                for x = 1:board.width
                        print_cell(board,y,x)
                end
                print('|')
                print('\n')
        end
        print("+")
        for i=1:board.width
                print("-")
        end
        print("+\n")
end
