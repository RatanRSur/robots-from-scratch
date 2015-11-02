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

function play(g::Game, p::Human ,w::Ptr{Void})
    print_and_refresh(g.board,w)
    while !is_over(g)
        if !g.board.wait_mode
            m = get_valid_move(g.player,g.board, w)
            com = key_to_command(m)
            execute_command(com,g.board)
        end
        process_robot_turn!(g.board)
        scrap_sprite!(g.board)
        switch_active_board!(g.board)
        print_and_refresh(g.board,w)
    end
end
