easy_print(w::Ptr{Void}, y, x, str::ASCIIString) = TermWin.mvwprintw(w,y - 1,x - 1,"%s",str)

function print_cell(b::Board, w::Ptr{Void}, y, x)
    b.matrix_representations[b.active,y,x,1] == 1 && (easy_print(w, y, x, "@"); return)
    b.matrix_representations[b.active,y,x,2] == 1 && (easy_print(w, y, x, "+"); return)
    b.matrix_representations[b.active,y,x,3] == 1 && (easy_print(w, y, x, "*"); return)
    mvwprintw(w, y, x, "%s", " ")
end

# function draw(b::Board)
    # print("+")
    # for i=1:b.width
        # print("-")
    # end
    # print("+")
    # print('\n')
    # for y = 1:b.height
        # print('|')
        # for x = 1:b.width
            # print_cell(b,y,x)
        # end
        # print('|')
        # print('\n')
    # end
    # print("+")
    # for i=1:b.width
        # print("-")
    # end
    # print('+')
    # print('\n')
# end

function print_corners(w::Ptr{Void})
    easy_print(w,1,1, "+")
    easy_print(w,1,b.width+2, "+")
    easy_print(w,b.height+2,1, "+")
    easy_print(w,b.height+2,b.width+2, "+")
end

function print_border(w::Ptr{Void})
    for i=1:b.width
        easy_print(w,1,i+1,"-")
        easy_print(w,b.height+2,i+1,"-")
    end
    for i=1:b.height
        easy_print(w,i+1,1, "|")
        easy_print(w,i+1,b.width+2, "|")
    end
end

function print_frame(w::Ptr{Void})
    print_corners(w)
    print_border(w)
end
