include \masm32\include\masm32rt.inc

.data
array DB 12 DUP (0)        ; Smallest 32 bit integer is -2147483648 thus we need 11 bytes for a 32 bit integer as it could be negative
endline DB 13, 10, 0       ; End of line array, equivalent to "\r\n" and a null character
.code

stringTo PROC                       ; Function for computing sum of integers below given integer in ebx 
    push ebp                        ; Saves base pointer to stack
    mov ebp, esp                    ; Moves stack pointer to base pointer
    push ebx                        ; According to calling convention, ebx shouldn't be corrupted, here we save it to the stack
    mov eax, [esp+12]               ; Accesses parameter pushed to stack
    mov ecx, 10                     ; Divisor for getting each digit
    mov ebx, OFFSET (array+10)      ; ebx is a pointer to the array
    xor esi, esi                    ; Sets ESI to 0
    cmp eax, 0                      ; if the parameter is greater than or equal to 0
    jge string_loop                 ; jump to the string_loop
    neg eax                         ; Negate eax, otherwise we would be doing unsigned division on a signed integer
    mov esi, 1                      ; Increment pointer after storing '-' at start of string
string_loop:                        
    xor edx, edx                    ; Set edx to 0
    div ecx                         ; Divide eax by 10 (ecx)
    add edx, 48                     ; Add 48 to the remainder (converts to ASCII)
    mov [ebx], dl                   ; Puts the byte in DL into our character array
    dec ebx                         ; Decrements pointer to array
    cmp eax, 0                      ; Check if result of division is 0
    jne string_loop                 ; If it's not, jump to the string_loop, there's move division to do
printing:   
    cmp esi, 1                      ; Checks if our number is negative
    jne non_neg                     ; If it isn't, jumps to non_neg
    mov edx, 45                     ; Otherwise, move 45 ('-' in ASCII) to edx
    mov [ebx], dl                   ; Move edx into the address held in ebx
    dec ebx                         ; Decrements pointer to string
non_neg:   
    inc ebx                         ; Increments pointer so that it is not looking at null space
    invoke StdOut, ebx              ; invokes StdOut with the address of the array in memory (prints it)
    invoke StdOut, ADDR endline     ; prints an end of line and null character
    pop ebx                         ; ebx should not be corrupted, restores ebx from value on stack
    mov esp, ebp                    ; Restores the stack pointer
    pop ebp                         ; Restores EBP saved at start of subroutine
    ret 0                           ; return 0 (Ok)
stringTo ENDP

main:
    push -1                     ; Test case with negative argument               
    call stringTo               ; calling function
    add esp, 4                  ; Pop Parameter off stack

    push -12345                 ; Test case with negative argument                  
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 142857                 ; Test case with positive argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 2                      ; Test case with single digit argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 999999                 ; Test case with positive argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 285714                 ; Test case with positive argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 777777                 ; Test case with positive argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 6                      ; Test case with single digit argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 7                      ; Test case with single digit argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 8                      ; Test case with single digit argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push 1073741823             ; Test case with positive argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    push -1073741823            ; Test case with maximum digits negative argument
    call stringTo               ; calling function
    add esp, 4                  ; Pop parameter off stack

    ret 0                       ; Return 0 (OK)
end main