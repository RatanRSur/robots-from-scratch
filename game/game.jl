type Game
    board::Board
    player::Player
    level::Int
    score::Int
    players_turn::Bool
end

Game(p::Player) = new(Board(),p, 1, 0, true)

function next_level!(g::Game)
    g.level += 1
    g.board = Board(g.board.height,g.board.width, g.level < 5 ? 10 * g.level : 40)
    g.players_turn = true
end

is_over(g::Game) = !g.board.sprite.is_alive
end_turn(g::Game) = g.players_turn = !g.players_turn
