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
    e.g. matrix_rep[1,2,5,3] will be 1 iff there is a scrap pile at
    coordinate 2,5 in the first 3D matrix.
    Likewise, matrix_rep[2,2,5,1] and [2,2,5,2] denote the existence
    of a sprite or robot at [2,5] in the second 3D matrix.
    After mutations are finished, switch_active_board is called.
    =#

    matrix_rep::Array{Int,4}
    active::Int
    inactive::Int

    sprite::Sprite

    # Constructors
    Board(h=24,w=60,nrobots=10) = begin
        this = new( h , w , nrobots , nrobots , false , 0 , zeros(Int,2,h,w,3) , 1 , 2 )

        #random initialization of sprite and robots
        rand_coords = sample(1:h*w ,nrobots+1, replace = false)
        this.sprite = Sprite((rand_coords[1]-1) ÷ w + 1, (rand_coords[1]-1) ÷ h + 1)
        this.matrix_rep[this.active,this.sprite.y,this.sprite.x,1] = 1
        for i = 2:length(rand_coords)
            slice(this.matrix_rep,this.active,:,:,2)[rand_coords[i]] = 1
        end
        return this
    end

    Board(nrobots::Int) = Board(24,60,nrobots)
end

has_robots(b::Board) = b.live_robots != 0

function robots_chase_sprite!(s::Sprite,old_robot_field::AbstractArray{Int,2}, new_robot_field::AbstractArray{Int,2})
    height, width = size(old_robot_field)
    for y = 1:height, x = 1:width
        if old_robot_field[y,x] == 1
            old_robot_field[y,x] = 0
            new_robot_field[towards(y,s.y) , towards(x,s.x)] += 1
        end
    end
end

function scrap_robots!(robot_field::AbstractArray{Int,2},scrap_field::AbstractArray{Int,2})
    for i = 1:length(robot_field)
        if scrap_field[i] == 1
            robot_field[i] = 0
        elseif robot_field[i] > 1
            robot_field[i] = 0
            scrap_field[i] = 1
        end
    end
end

function copy_scrap_field!(b::Board)
    b.matrix_rep[b.active,:,:,3] = b.matrix_rep[b.inactive,:,:,3]
end

function process_robot_turn!(b::Board)
    old_robot_field = slice(b.matrix_rep,b.active,:,:,2)
    new_robot_field = slice(b.matrix_rep,b.inactive,:,:,2)
    old_scrap_field = slice(b.matrix_rep,b.active,:,:,3)
    new_scrap_field = slice(b.matrix_rep,b.inactive,:,:,3)

    new_scrap_field[:] = old_scrap_field[:]

    robots_chase_sprite!(b.sprite, old_robot_field, new_robot_field)

    scrap_robots!(new_robot_field,new_scrap_field)

    b.live_robots = sum(b.matrix_rep[b.inactive,:,:,2])
end

function switch_active_board!(b::Board)
    b.active, b.inactive = b.inactive, b.active
end

unset_sprite_pos!(b::Board) = b.matrix_rep[b.active,b.sprite.y,b.sprite.x,1] = 0
set_sprite_pos!(b::Board) = b.matrix_rep[b.inactive,b.sprite.y,b.sprite.x,1] = 1

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

robot_on_square(b::Board,y,x) = b.matrix_rep[b.inactive,y,x,2] == 1
scrap_on_square(b::Board,y,x) = b.matrix_rep[b.inactive,y,x,3] == 1
is_sprite_on_robot(b::Board) = robot_on_square(b,b.sprite.y,b.sprite.x)
is_sprite_on_scrap(b::Board) = scrap_on_square(b,b.sprite.y,b.sprite.x)

function scrap_sprite!(b::Board)
    (is_sprite_on_scrap(b) || is_sprite_on_robot(b)) && (b.sprite.is_alive = false)
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

function is_valid(m::Char, b::Board)
    y = b.sprite.y
    x = b.sprite.x
    if m == 'h'
        checky, checkx = y,x-1
    elseif m == 'j'
        checky, checkx = y+1,x
    elseif m == 'k'
        checky, checkx = y-1,x
    elseif m == 'l'
        checky, checkx = y,x+1
    elseif m == 'y'
        checky, checkx = y-1,x-1
    elseif m == 'u'
        checky, checkx = y-1,x+1
    elseif m == 'b'
        checky, checkx = y+1,x-1
    elseif m == 'n'
        checky, checkx = y+1,x+1
    elseif m == ' '
        return !robot_in_dist_one(b,y,x)
    elseif m == 't'
        return true
    elseif m == 'w'
        return true
    else
        return false
    end

    #=if is_inbounds(b,checky, checkx) && !robot_in_dist_one(b,checky, checkx) && !scrap_on_square(b,checky, checkx)=#
    #=else=#
        #=@show is_inbounds(b,checky, checkx)=#
        #=@show !robot_in_dist_one(b,checky, checkx)=#
        #=@show !scrap_on_square(b,checky, checkx)=#
    #=end=#
    return is_inbounds(b,checky, checkx) &&
    !robot_in_dist_one(b,checky, checkx) &&
    !scrap_on_square(b,checky, checkx)
end

function robot_in_dist_one(b::Board, y::Int,x::Int)
    for i = -1:1, j = -1:1
        if is_inbounds(b,y+i,x+j)
            if b.matrix_rep[b.active,y+i,x+j,2] == 1
                return true
            end
        end
    end
    return false
end

function get_score(b::Board)
    retVal = 10 * (b.init_num_robots - b.live_robots)
    if b.live_robots == 0 && b.sprite.is_alive && b.wait_mode
        retVal += b.robots_when_waiting - b.live_robots
    end
    retVal
end
