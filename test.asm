include \masm32\include\masm32rt.inc
.data
array DB 10 DUP (49) 
.code
main:
    invoke StdOut, ADDR array
end main