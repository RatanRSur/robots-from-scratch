abstract Player

type Human <: Player
end

#=type Network <: Player=#
#=end=#

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
