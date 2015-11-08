type Game
    board::Board
    player::Player
    level::Int
    previous_levels_score::Int
    players_turn::Bool

    Game(p::Player) = new(Board(),p, 1, 0, true)
end


function next_level!(g::Game)
    g.previous_levels_score += get_score(g.board)
    g.level += 1
    g.board = Board(g.board.height, g.board.width, g.level < 4 ? 10*g.level : 40)
    g.players_turn = true
end

score(g::Game) = g.previous_levels_score + get_score(g.board)
is_over(g::Game) = !g.board.sprite.is_alive
end_turn(g::Game) = g.players_turn = !g.players_turn

function print_score(g::Game, w::Ptr{Void})
    pos = (g.board.height + 3, 1)
    easy_print(w,pos...,string("Score: ",score(g)))
end

function print_level(g::Game, w::Ptr{Void})
    pos = (g.board.height + 4, 1)
    easy_print(w,pos...,string("Level: ",g.level))
end

function print_and_refresh(g::Game,w::Ptr{Void})
    TermWin.erase()
    print_frame(g.board,w)
    print_field(g.board,w)
    print_score(g,w)
    print_level(g,w)
    TermWin.refresh()
end

function play(g::Game, p::Human ,w::Ptr{Void})
    while !is_over(g)
        if !g.board.wait_mode
            print_and_refresh(g,w)
            m = get_valid_move(g.player,g.board, w)
            com = key_to_command(m)
            execute_command(com,g.board)
        end
        process_robot_turn!(g.board)
        scrap_sprite!(g.board)
        switch_active_board!(g.board)
        if g.board.live_robots == 0
            next_level!(g)
        end
    end
end
