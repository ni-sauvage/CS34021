include \masm32\include\masm32rt.inc


.data

.code

my_factorial PROC       ; Function for computing factorial of integers 
    push ebp            ; Saves base pointer to stack
    mov ebp, esp        ; Moves stack pointer to base pointer
    push ebx            ; According to calling convention, ebx shouldn't be corrupted, here we save it to the stack
    mov ebx, [esp+12]   ; Accesses parameter pushed to stack
    cmp ebx, 0          ; Check if parameter is negative
    jge no_err          ; jump to no_err if ebx is above or equal to 0
    print "Error, input must be ", 62, 61, " 0", 13, 10, 0
    jmp clean           ; Jump to cleaning stack and returning after error
no_err:
    jne not_base_case   ; Jump to not_base_case if ebx != 0
    mov eax, 1          ; Move 1 into eax
    je clean            ; Jump to cleaning stack and returning after base case
not_base_case:
    dec ebx             ; N = N - 1
    push ebx            ; Push N-1 to stack
    call my_factorial   ; Call my_factorial with parameter N-1, returning into eax
    inc ebx             ; N = N+1 (returning original value of N to ebx)
    add esp, 4          ; Pop N-1 from stack
    mul ebx             ; Multiply eax with ebx, i.e. N * myfactorial(N-1)
clean:
    pop ebx             ; Restore ebx, should not be corrupted
    mov esp, ebp        ; Restores the stack pointer
    pop ebp             ; Restores EBP saved at start of subroutine
    ret 0               ; return 0 (Ok)
my_factorial ENDP

main:
    push -1                     ; Test case with invalid argument, expect error                  
    call my_factorial           ; calling function
    add esp, 4                  ; Pop Parameter off stack

    push 0                      ; Test case with invalid argument, expect 1                  
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 0", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 1                      ; Test case with valid argument, expect 1
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 1", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 2                      ; Test case with valid argument, expect 2
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 2", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 3                      ; Test case with valid argument, expect 6
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 3", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 4                      ; Test case with valid argument, expect 24
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 4", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 5                      ; Test case with valid argument, expect 120
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 5", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 6                      ; Test case with valid argument, expect 720
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 6", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 7                      ; Test case with valid argument, expect 5040
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 7", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 8                      ; Test case with valid argument, expect 40320
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 8", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    push 9                      ; Test case with valid argument, expect 362880
    call my_factorial           ; calling function
    print str$(eax), " was the result when N = 9", 13, 10, 0
    add esp, 4                  ; Pop parameter off stack

    ret 0                       ; Return 0 (OK)
end main