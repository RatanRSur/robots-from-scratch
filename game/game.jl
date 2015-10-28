type Game
    board::Board
    player::Player
    level::Int
    previous_levels_score::Int
    current_level_score::Int
    players_turn::Bool

    Game(p::Player) = new(Board(),p, 1, 0,0, true)
end


function next_level!(g::Game)
    g.previous_levels_score += current_level_score
    g.current_level_score = 0
    g.level += 1
    g.board = Board(g.board.height,g.board.width, g.level < 5 ? 10 * g.level : 40)
    g.players_turn = true
end

score(g::Game) = previous_levels_score + current_level_score
is_over(g::Game) = !g.board.sprite.is_alive
end_turn(g::Game) = g.players_turn = !g.players_turn

function play(g::Game, w::Ptr{Void})
    if isa(g.player,Human)
        print_frame(g.board,w)
        print_field(g.board,w)
        TermWin.refresh()
        while !is_over(g)
            m = get_valid_move(g.player,g.board, w)
            com = key_to_command(m)
            execute_command(com,g.board)
            process_robot_turn!(g.board)
            switch_active_board!(g.board)
            TermWin.erase()
            print_frame(g.board,w)
            print_field(g.board,w)
            TermWin.refresh()
        end
    end
end
