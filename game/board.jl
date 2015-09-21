# Board class, includes:
# matrix representation of the board
# method to draw the board

type Board
        height::Int
        width::Int
        num_robots::Int

        matrix_representation::Array{Int,3}
        player_position::Array{Int}
        robot_positions::Array{Int,2}
        scrap_positions::Array{Int,2}

        Board(h,w,robots) = begin
                board = new(h,w,robots)
                board.height = h
                board.width = w
                board.num_robots = robots
                matrix_representation = zeros(h,w,3)
                board.player_pos = [rand(1:h),rand(1:w)]
                matrix_representation[board.player_pos[1],board.player_pos[2],1] = 1
                # initialize robots as well
                return board
        end

        Board() = Board(24,60,10)

        move_robots() = begin
                matrix_representation[:,:,2] = 0


        # move(direction::String) = begin
                # if direction == "u"
end

b = Board()
print(b.width)
