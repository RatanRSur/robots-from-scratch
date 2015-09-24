function print_cell(board::Board, y, x)
        board.matrix_representations[board.active,y,x,1] == 1 && (print('@'); return)
        board.matrix_representations[board.active,y,x,2] == 1 && (print('+'); return)
        board.matrix_representations[board.active,y,x,3] == 1 && (print('*'); return)
        print(' ')
end

function draw(board::Board)
        print("+")
        for i=1:board.width
                print("-")
        end
        print("+")
        print('\n')
        for y = 1:board.height
                print('|')
                for x = 1:board.width
                        print_cell(board,y,x)
                end
                print('|')
                print('\n')
        end
        print("+")
        for i=1:board.width
                print("-")
        end
        print("+\n")
end
