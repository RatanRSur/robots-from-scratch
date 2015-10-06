function print_cell(b::Board, y, x)
    b.matrix_representations[b.active,y,x,1] == 1 && (print('@'); return)
    b.matrix_representations[b.active,y,x,2] == 1 && (print('+'); return)
    b.matrix_representations[b.active,y,x,3] == 1 && (print('*'); return)
    print(' ')
end

function draw(b::Board)
    print("+")
    for i=1:b.width
        print("-")
    end
    print("+")
    print('\n')
    for y = 1:b.height
        print('|')
        for x = 1:b.width
            print_cell(b,y,x)
        end
        print('|')
        print('\n')
    end
    print("+")
    for i=1:b.width
        print("-")
    end
    print('+')
    print('\n')
end
