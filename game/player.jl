abstract Player

type Human <: Player
end

function is_valid(m::Char, b::Board)
    y = b.sprite.y
    x = b.sprite.x
    if m == 'h'
        return !robot_in_dist_one(b,y,x-1)
    elseif m == 'j'
        return !robot_in_dist_one(b,y+1,x)
    elseif m == 'k'
        return !robot_in_dist_one(b,y-1,x)
    elseif m == 'l'
        return !robot_in_dist_one(b,y,x+1)
    elseif m == 'y'
        return !robot_in_dist_one(b,y-1,x-1)
    elseif m == 'u'
        return !robot_in_dist_one(b,y-1,x+1)
    elseif m == 'b'
        return !robot_in_dist_one(b,y+1,x-1)
    elseif m == 'n'
        return !robot_in_dist_one(b,y+1,x+1)
    elseif m == ' '
        return !robot_in_dist_one(b,y,x)
    elseif m == 't'
        return true
    elseif m == 'w'
        return true
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
    else
        string(k)
    end
end

function execute_command(com::ASCIIString,b::Board)
    if com == "t"
        teleport_sprite!(b)
    elseif com == " "
        skip_sprite(b)
    elseif com == "w"
    else
        move_sprite!(b,com)
    end
end
