abstract Player

type Human <: Player
end

function is_valid(m::Char, b::Board)
    y = b.sprite.y
    x = b.sprite.x
    if m == 'h'
        is_inbounds(b,y,x-1) ? !robot_in_dist_one(b,y,x-1) : false
    elseif m == 'j'
        is_inbounds(b,y+1,x) ? !robot_in_dist_one(b,y+1,x) : false
    elseif m == 'k'
        is_inbounds(b,y-1,x) ? !robot_in_dist_one(b,y-1,x) : false
    elseif m == 'l'
        is_inbounds(b,y,x+1) ? !robot_in_dist_one(b,y,x+1) : false
    elseif m == 'y'
        is_inbounds(b,y-1,x-1) ? !robot_in_dist_one(b,y-1,x-1) : false
    elseif m == 'u'
        is_inbounds(b,y-1,x+1) ? !robot_in_dist_one(b,y-1,x+1) : false
    elseif m == 'b'
        is_inbounds(b,y+1,x-1) ? !robot_in_dist_one(b,y+1,x-1) : false
    elseif m == 'n'
        is_inbounds(b,y+1,x+1) ? !robot_in_dist_one(b,y+1,x+1) : false
    elseif m == ' '
        !robot_in_dist_one(b,y,x)
    elseif m == 't'
        true
    elseif m == 'w'
        true
    else
        false
    end
end

function get_valid_move(h::Human, b::Board, w::Ptr{Void})
    m = Char(TermWin.wgetch(w))
    while !is_valid(m,b)
        m = Char(TermWin.wgetch(w))
    end
    return m
end

function key_to_command(k::Char)
    if k == 'h'
        "w"
    elseif k == 'j'
        "s"
    elseif k == 'k'
        "n"
    elseif k == 'l'
        "e"
    elseif k == 'y'
        "nw"
    elseif k == 'u'
        "ne"
    elseif k == 'b'
        "sw"
    elseif k == 'n'
        "se"
    elseif k == 'w'
        "wait"
    else
        string(k)
    end
end


function execute_command(com::AbstractString,b::Board)
    if com == "t"
        teleport_sprite!(b)
    elseif com == " "
        skip_sprite(b)
    elseif com == "wait"
        enter_wait_mode!(b)
    else
        move_sprite!(b,com)
    end
end
