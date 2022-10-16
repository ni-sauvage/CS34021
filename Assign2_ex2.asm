.data
array DB 21 DUP (0), 13, 10, 0

.code
my_sum_4 PROC
    push rbp
    mov  rbp, rsp
    push r10
    push 0
    cmp rcx, 0
    jg  pos
    xor rax, rax
    jmp clean_stack
pos:
    pop r10
    add r10, rcx
    dec rcx
    push r10
    cmp rdx, 0
    jle c_label
    pop r10
    add r10, rdx
    dec rdx
    push r10
c_label:
    cmp r8, 0
    jle d_label
    pop r10
    add r10, r8
    dec r8
    push r10
d_label:
    cmp r9, 0
    jle rec_call
    pop r10
    add r10, r9
    dec r9
    push r10
rec_call:
    pop r10
    sub rsp, 32
    call my_sum_4
    add rax, r10
    add rsp, 32
    push r10
clean_stack:
    add rsp, 8
    pop r10
    mov rsp, rbp
    pop rbp
    ret 0
my_sum_4 ENDP

my_sum_4_wrapper PROC
    push rcx
    dec rcx
    mov rdx, rcx
    dec rcx
    mov r8, rcx
    dec rcx
    mov r9, rcx
    pop rcx
    sub rsp, 32
    call my_sum_4
    add rsp, 32
    ret 0
my_sum_4_wrapper ENDP

print PROC
    push rbp
    mov  rbp, rsp
    mov rax, 4
    mov rbx, 1
    mov rdx, 13
    int      80h
    mov rax, 1
    mov rbx, 0
    int      80h
    mov rsp, rbp
    pop rbp
    ret 0
print ENDP

stringTo PROC                       ;  
    push rbp                        ; Saves base pointer to stack
    mov rbp, rsp                    ; Moves stack pointer to base pointer
    push rbx                        ; According to calling convention, ebx shouldn't be corrupted, here we save it to the stack
    mov rax, rcx                    ; Accesses parameter pushed to stack
    mov rcx, 10                     ; Divisor for getting each digit
    mov rbx, OFFSET (array+10)      ; ebx is a pointer to the array
    xor rsi, rsi                    ; Sets ESI to 0
    cmp rax, 0                      ; if the parameter is greater than or equal to 0
    jge string_loop                 ; jump to the string_loop
    neg rax                         ; Negate eax, otherwise we would be doing unsigned division on a signed integer
    mov rsi, 1                      ; Increment pointer after storing '-' at start of string
string_loop:                        
    xor rdx, rdx                    ; Set edx to 0
    div rcx                         ; Divide eax by 10 (ecx)
    add rdx, 48                     ; Add 48 to the remainder (converts to ASCII)
    mov [rbx], dl                   ; Puts the byte in DL into our character array
    dec rbx                         ; Decrements pointer to array
    cmp rax, 0                      ; Check if result of division is 0
    jne string_loop                 ; If it's not, jump to the string_loop, there's move division to do
printing:   
    cmp rsi, 1                      ; Checks if our number is negative
    jne non_neg                     ; If it isn't, jumps to non_neg
    mov rdx, 45                     ; Otherwise, move 45 ('-' in ASCII) to edx
    mov [ebx], dl                   ; Move edx into the address held in ebx
    dec rbx                         ; Decrements pointer to string
non_neg:   
    inc rbx                         ; Increments pointer so that it is not looking at null space
    mov rcx, rbx
    sub rsp, 16
    call print              ; invokes StdOut with the address of the array in memory (prints it)
    add rsp, 16
    pop rbx                         ; ebx should not be corrupted, restores ebx from value on stack
    mov rsp, rbp                    ; Restores the stack pointer
    pop rbp                         ; Restores EBP saved at start of subroutine
    ret 0                           ; return 0 (Ok)
stringTo ENDP

_start:
    mov rcx, 1
    sub rsp, 16
    call my_sum_4_wrapper
    add rsp, 16
    mov rcx, rax
    sub rsp, 16
    call stringTo
    add rsp, 16
	
    ret 0
end _start