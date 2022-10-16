.data
array DB 21 DUP (0), 13, 10, 0      ; Array for printing our number, ends with \r\n\0

.code
my_sum_4 PROC                       ; equivalent to _int64 my_sum(_int64 a, _int64 b, _int64 c, _int64 d)
    push rbp                        ; Saves base pointer to stack
    mov  rbp, rsp                   ; Moves stack pointer to base pointer
    push r10                        ; Saves r10, we will overwrite it in the function
    push 0                          ; I want a local variable initialised to 0, so I could do sub rsp, 8 but I want to guarantee it's initialised to 0, so I just push 0 instead
    cmp rcx, 0                      ; Check if a > 0
    jg  pos                         ; If it is, jump to positive
    xor rax, rax                    ; set RAX to 0
    jmp clean_stack                 ; Jump to clean_stack
pos:
    pop r10                         ; Access local variable
    add r10, rcx                    ; Add a to local variable
    dec rcx                         ; a--
    push r10                        ; Store local variable
    cmp rdx, 0                      ; check if b <= 0
    jle c_label                     ; if it is, jump to c_label
    pop r10                         ; Access local variable
    add r10, rdx                    ; Add b to local variable
    dec rdx                         ; b--
    push r10                        ; Store local variable
c_label:
    cmp r8, 0                       ; check if c <= 0
    jle d_label                     ; if it is, jump to d_label
    pop r10                         ; Access local variable
    add r10, r8                     ; Add c to local variable
    dec r8                          ; c-- (I could make a terrible joke about the actual language c-- here, but I'm a sane human being who isn't writing this code at 01.45am. ow.)
    push r10                        ; Store local variable
d_label:
    cmp r9, 0                       ; check if d <= 0
    jle rec_call                    ; if it is, jump to rec_call
    pop r10                         ; Access local variable
    add r10, r9                     ; Add d to local variable
    dec r9                          ; d--
    push r10                        ; store local variable
rec_call:
    pop r10                         ; Access local variable
    sub rsp, 32                     ; Allocate 32 bytes of shadow space on stack (16 byte aligned as 32%16 == 0), for 4 parameters
    call my_sum_4                   ; Recursively call my_sum_4
    add rax, r10                    ; Add result of my_sum_4 to local variable
    add rsp, 32                     ; Deallocate 32 bytes of shadow space
    push r10                        ; store local variable
clean_stack:
    add rsp, 8                      ; Deallocate local variable                      
    pop r10                         ; Pop r10 saved at start
    mov rsp, rbp                    ; move rbp back into rsp
    pop rbp                         ; pop rbp saved at start
    ret 0                           ; return 0 (OK)
my_sum_4 ENDP

my_sum_4_wrapper PROC               ; Given N, call my_sum_4 with parameters N, N-1, N-2, N-3
    push rcx                        ; Save N
    dec rcx                         ; Decrement rcx for next parameter
    mov rdx, rcx                    ; b = N - 1
    dec rcx                         ; Decrement rcx for next parameter
    mov r8, rcx                     ; b = N - 2
    dec rcx                         ; Decrement rcx for next parameter
    mov r9, rcx                     ; c = N - 3
    pop rcx                         ; a = N
    sub rsp, 32                     ; Allocate 32 bytes of shadow space on stack (16 byte aligned as 32%16 == 0), for 4 parameters
    call my_sum_4                   ; Call my_sum_4
    add rsp, 32                     ; Deallocate 32 bytes of shadow space
    ret 0                           ; return 0 (OK)
my_sum_4_wrapper ENDP

print PROC                          
    push rbp                        ; As per protocol, save rbp
    mov  rbp, rsp                   ; Moves stack pointer to base pointer
    mov rax, 4                      ; Move integers which specify printing to correct registers
    mov rbx, 1
    mov rdx, 13
    int      80h                    ; System calls to print    
    mov rsp, rbp                    ; Restores the stack pointer
    pop rbp                         ; Restores RBP saved at start of subroutine
    ret 0                           ; return 0 (Ok)
print ENDP

stringTo PROC                       ; Function to print an integer
    push rbp                        ; Saves base pointer to stack
    mov rbp, rsp                    ; Moves stack pointer to base pointer
    push rbx                        ; According to calling convention, rbx shouldn't be corrupted, here we save it to the stack
    mov rax, rcx                    ; Moves parameter stored in rcx into rax
    mov rcx, 10                     ; Divisor for getting each digit
    mov rbx, OFFSET (array+20)      ; rbx is a pointer to the array
string_loop:                        
    xor rdx, rdx                    ; Set rdx to 0
    div rcx                         ; Divide rax by 10 (ecx)
    add rdx, 48                     ; Add 48 to the remainder (converts to ASCII)
    mov [rbx], dl                   ; Puts the byte in DL into our character array
    dec rbx                         ; Decrements pointer to array
    cmp rax, 0                      ; Check if result of division is 0
    jne string_loop                 ; If it's not, jump to the string_loop, there's more division to do
printing:                       
    inc rbx                         ; Increments pointer so that it is not looking at null space
    mov rcx, rbx                    ; Move pointer into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call print                      ; Call procedure to do system calls to print our number
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    pop rbx                         ; rbx should not be corrupted, restores ebx from value on stack
    mov rsp, rbp                    ; Restores the stack pointer
    pop rbp                         ; Restores RBP saved at start of subroutine
    ret 0                           ; return 0 (Ok)
stringTo ENDP

_start:
    mov rcx, 0                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 1                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 2                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 3                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 4                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 5                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 6                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 7                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 8                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 9                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned

    mov rcx, 10                      ; Move 0 into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call my_sum_4_wrapper           ; Call wrapper function
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rcx, rax                    ; Move result of calculation into rcx (first parameter)
    sub rsp, 16                     ; Sub 16 from rsp (1 parameter * 8, but must keep stack 16 byte aligned, so sub 16)
    call stringTo                   ; Call stringTo function with result as parameter to print
    add rsp, 16                     ; Add 16 bytes to rsp (move stack pointer to original position) while keeping aligned
    mov rax, 1                      ; Move integers which specify exiting to correct registers
    mov rbx, 0
    int      80h                    ; System calls to exit
    ret 0
end _start