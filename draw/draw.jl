easy_print(w::Ptr{Void}, y, x, str::ASCIIString) = TermWin.mvwprintw(w,y - 1,x - 1,"%s",str)

function print_cell(b::Board, w::Ptr{Void}, y, x)
    b.matrix_rep[b.active,y,x,1] == 1 && (easy_print(w, y+1, x+1, "@"); return)
    b.matrix_rep[b.active,y,x,2] == 1 && (easy_print(w, y+1, x+1, "+"); return)
    b.matrix_rep[b.active,y,x,3] == 1 && (easy_print(w, y+1, x+1, "*"); return)
end

function print_corners(b::Board,w::Ptr{Void})
    easy_print(w,1,1, "+")
    easy_print(w,1,b.width+2, "+")
    easy_print(w,b.height+2,1, "+")
    easy_print(w,b.height+2,b.width+2, "+")
end

function print_border(b::Board,w::Ptr{Void})
    for i=1:b.width
        easy_print(w,1,i+1,"-")
        easy_print(w,b.height+2,i+1,"-")
    end
    for i=1:b.height
        easy_print(w,i+1,1, "|")
        easy_print(w,i+1,b.width+2, "|")
    end
end

function print_frame(b::Board,w::Ptr{Void})
    print_corners(b,w)
    print_border(b,w)
end

function print_field(b::Board, w::Ptr{Void})
    for y = 1:b.height, x=1:b.width
        print_cell(b,w,y,x)
    end
end
