type Game
    board::Board
    level::Int
    score::Int
end

Game() = new(Board(), 0, 0, false)

function next_level!(g::Game)
    g.level += 1
    g.board = Board(g.board.height,g.board.width, g.level < 5 ? 10 * g.level : 40)
end

is_over(g::Game) = !g.sprite.is_alive
