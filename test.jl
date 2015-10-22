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

b = Board()

@test has_robots(b)

h = Human()

scr = TermWin.initscr()
TermWin.noecho()
TermWin.curs_set(0)

print_frame(scr)
print_field(b,scr)
TermWin.refresh()

while true
    m = get_valid_move(h,b,scr)
    com = key_to_command(m)
    execute_command(com,b)
    process_robot_turn!(b)
    switch_active_board!(b)
    TermWin.erase()
    print_frame(scr)
    print_field(b,scr)
    TermWin.refresh()
end

TermWin.wgetch(scr)
TermWin.endwin()
