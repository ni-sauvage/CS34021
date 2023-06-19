include \masm32\include\masm32rt.inc


.data
.code

sumTo PROC              ; Function for computing sum of integers below given integer in ebx 
    push ebp            ; Saves base pointer to stack
    mov ebp, esp        ; Moves stack pointer to base pointer
    push ebx            ; According to calling convention, ebx shouldn't be corrupted, here we save it to the stack
    mov ebx, [esp+12]   ; Accesses parameter pushed to stack
    
    cmp ebx, 0          ; Checks for invalid parameter
    jl negative         ; Jumps to negative label if parameter is invalid
    xor edx, edx        ; Set edx to 0 for future comparison
    
  ; EXPLANATION
  ; Gauss' formula is Sum(0..N) = N(N+1)/2 where N is an integer
  ; Case 1: N is odd -> N+1 is even, in order not to lose accuracy/have a remainder when we divide by two we shall have to divide N+1 by 2
  ; Case 2: N is even -> N+1 is odd, in order not to lose accuracy/have a remainder when we divide by two we shall have to divide N by 2
    
    mov eax, ebx        ; Move N into eax
    inc eax             ; eax = N+1
    mov ecx, eax        ; set ecx to eax for temporary comparison
    and ecx, 1          ; get least significant bit of eax (N+1)
    cmp ecx, 0          ; compare LSB(eax) to 0
    jne ebx_even        ; jump if not equal to ebx_even
eax_even:
    shr eax, 1          ; eax is even, shift right by 1, will not lose precision
    jmp shift_done      ; jump to shift done
ebx_even:
    shr ebx, 1
shift_done:
    mul ebx             ; Multiply ebx by eax, i.e. N * (N+1) / 2
    cmp edx, 0          ; Check to see if upper 32 bits are equal to 0
    je no_overflow      ; If they are, jump past handling overflow
    print   "Error, numeral too large to compute sum in 32 bits", 13, 10, 0 ; Print an error message if result is longer than 32 bits
    jmp no_overflow     ; Jump to end of function
negative:
    print   "Error, negative number passed as parameter", 13, 10, 0    ; Print an error message if parameter was less than 0
no_overflow:
    pop ebx             ; Restore ebx, should not be corrupted
    mov esp, ebp        ; Restores the stack pointer
    pop ebp             ; Restores EBP saved at start of subroutine
    ret 0               ; return 0 (Ok)
sumTo ENDP

main:
    push -1                     ; Test case with invalid argument, expect error                  
    call sumTo                  ; calling function
    add esp, 4                  ; Pop Parameter off stack

    push 0                      ; Test case with invalid argument, expect 0                  
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 0", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 1                      ; Test case with valid argument, expect 1
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 1", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 2                      ; Test case with valid argument, expect 3
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 2", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 3                      ; Test case with valid argument, expect 6
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 3", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 4                      ; Test case with valid argument, expect 10
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 4", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 5                      ; Test case with valid argument, expect 15
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 5", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 6                      ; Test case with valid argument, expect 21
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 6", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 7                      ; Test case with valid argument, expect 28
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 7", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 8                      ; Test case with valid argument, expect 36
    call sumTo                  ; calling function
    print str$(eax), " was the result when N = 8", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 1073741823             ; Test case with invalid argument, expect error
    call sumTo                  ; calling function
    add esp, 4

    ret 0                       ; Return 0 (OK)
end main