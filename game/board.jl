# Contents:
# Sprite type
# Board type

type Sprite
    y::Int
    x::Int
    is_alive::Bool

    Sprite(ypos,xpos) = new(ypos,xpos,true)
end

function move!(s::Sprite, direction::ASCIIString)
    contains(direction, "n") && (s.y -= 1)
    contains(direction, "s") && (s.y += 1)
    contains(direction, "e") && (s.x += 1)
    contains(direction, "w") && (s.x -= 1)
end

function teleport!(s::Sprite, h, w)
    s.y = rand(1:h)
    s.x = rand(1:w)
end

skip(s::Sprite) = nothing

type Board
    height::Int
    width::Int
    init_num_robots::Int
    live_robots::Int
    wait_mode::Bool
    robots_when_waiting::Int

    #=
    The matrix representations is a pair of 3D matrices (1 4D matrix)
    in which each "slice" shows
    the existence of a sprite, robot, or scrap pile at each coordinate
    e.g. matrix_representations[1,2,5,3] will be 1 iff there is a scrap pile at
    coordinate 2,5 in the first 3D matrix.
    Likewise, matrix_representations[2,2,5,1] and [2,2,5,2] denote the existence
    of a sprite or robot at [2,5] in the second 3D matrix.
    All but one function mutate the inactive matrix.
    (unset_sprite_pos zeros the player in the active matrix)
    After mutations are finished, switch_active_board is called.
    =#

    matrix_representations::Array{Int,4}
    active::Int
    inactive::Int

    sprite::Sprite

    # Constructors
    Board(h=24,w=60,nrobots=10) = begin
        this = new( h , w , nrobots , nrobots , false , 0 , zeros(Int,2,h,w,3) , 1 , 2 )

        #random initialization of sprite and robots
        rand_coords = [sample(1:h ,nrobots+1, replace = false) sample(1:w, nrobots+1, replace = false)]
        this.sprite = Sprite(rand_coords[1,1], rand_coords[1,2])
        robot_positions = rand_coords[2:end,:]
        this.matrix_representations[this.active,this.sprite.y,this.sprite.x,1] = 1
        set_indices_to!(slice(this.matrix_representations,this.active,:,:,2), robot_positions , 1)
        return this
    end

    Board(nrobots::Int) = Board(24,60,nrobots)
end

has_robots(b::Board) = b.live_robots != 0

function robots_chase_sprite!(s::Sprite,old_robot_field::AbstractArray{Int,2}, new_robot_field::AbstractArray{Int,2})
    height, width = size(old_robot_field)
    for y = 1:height, x = 1:width
        if old_robot_field[y,x] == 1
            new_robot_field[towards(y,s.y) , towards(x,s.x)] += 1
        end
    end
end

function scrap_robots!(robot_field::AbstractArray{Int,2},scrap_field::AbstractArray{Int,2})
    height, width = size(robot_field)
    for y = 1:height, x = 1:width
        if scrap_field[y,x] == 1
            robot_field[y,x] = 0
        elseif robot_field[y,x] > 1
            robot_field[y,x] = 0
            scrap_field[y,x] = 1
        end
    end
end

function copy_scrap_field!(b::Board)
    b.matrix_representations[b.active,:,:,3] = b.matrix_representations[b.inactive,:,:,3]
end

function process_robot_turn!(b::Board)
    old_robot_field = slice(b.matrix_representations,b.active,:,:,2)
    new_robot_field = zeros(old_robot_field)
    robots_chase_sprite!(b.sprite, old_robot_field, new_robot_field)
    b.matrix_representations[b.inactive,:,:,2] = new_robot_field
    scrap_robots!(slice(b.matrix_representations,b.inactive,:,:,2),slice(b.matrix_representations,b.inactive,:,:,3))
    copy_scrap_field!(b)
    b.live_robots = sum(b.matrix_representations[b.inactive,:,:,2])
end

function switch_active_board!(b::Board)
    b.active, b.inactive = b.inactive, b.active
end

unset_sprite_pos!(b::Board) = b.matrix_representations[b.active,b.sprite.y,b.sprite.x,1] = 0
set_sprite_pos!(b::Board) = b.matrix_representations[b.inactive,b.sprite.y,b.sprite.x,1] = 1

function move_sprite!(b::Board, direction::ASCIIString)
    unset_sprite_pos!(b)
    move!(b.sprite, direction)
    set_sprite_pos!(b)
end

function teleport_sprite!(b::Board)
    unset_sprite_pos!(b)
    teleport!(b.sprite,b.height,b.width)
    set_sprite_pos!(b)
end

function skip_sprite(b::Board) # equivalent to nothing for now
    unset_sprite_pos!(b)
    skip(b.sprite)
    set_sprite_pos!(b)
end

is_sprite_on_scrap(b::Board) = b.matrix_representations[b.inactive,b.sprite.y,b.sprite.x,3] == 1

function scrap_sprite!(b::Board)
    is_sprite_on_scrap(b) && (b.sprite.is_alive = false)
end

function enter_wait_mode!(b::Board)
    b.wait_mode = true
    b.robots_when_waiting = b.live_robots
end

function is_inbounds(b::Board, y ,x)
    (y < 1 || y > b.height) && return false
    (x < 1 || x > b.width) && return false
    return true
end

function robot_in_dist_one(b::Board, y::Int,x::Int)
    for i = -1:1, j = -1:1
        if is_inbounds(b,y+i,x+j)
            if b.matrix_representations[b.active,y+i,x+j,2] == 1
                return true
            end
        end
    end
    return false
end
