using Base.Test
include("Robots.jl")

test1 = [1 1 ; 2 3]
test2 = [0 0 ; 0 0]
scrap_robots!(test1,test2)
@test test1 == [1 1 ; 0 0]
@test test2 == [0 0 ; 1 1]

a = [1 1 ; 2 2]
set_indices_to!(a, [1 1;2 2],3)
@test a == [3 1; 2 3]
a = [1 1 ; 2 2]
set_indices_to!(a, [1 1],3)
@test a == [3 1; 2 2]

@test towards(5,5) == 5
@test towards(5,4) == 4
@test towards(8,2) == 7

g = Game(Human())

@test has_robots(g.board)

win = TermWin.initscr()
TermWin.noecho()
TermWin.curs_set(0)

play(g,g.player,win);

TermWin.endwin()

println("You made it to level ",g.level, " with a score of ",score(g),"!")
