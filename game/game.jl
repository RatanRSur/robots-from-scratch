type Game
    board::Board
    level::Int
    score::Int
    is_over::Bool
end

Game() = new(Board(), 0, 0, false)
