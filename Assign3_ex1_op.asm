max3:
    sub r27, r26, r0 {C}         ; Does a subtraction and sets flags/CCF. Compares b / second param and M (a)
    jle  c_label                 ; If Negative flag or Zero flag set, jump to c_label, will execute next instruction beforehand
    add r26, r0, r1              ; Moves r26 (a / first param) into return value (r1), which we will call M    
    add r27, r0, r1              ; r1 (M) = r27 (b) - will only get executed if branch is not taken
c_label:
    sub r28, r1, r0 {C}          ; Does a subtraction and sets flags/CCF. Compares c / second param and M (a or b depending on which was greater)
    jle else_label               ; If Negative flag or Zero flag set, jump to c_label
    xor r0,  r0, r0              ; NOP operation, delay while branch being calculated - can't optimise here, sole instruction in branch is overwriting return value
    add r28, r0, r1              ; r1 (M) = r28 (c) - will only get executed if branch is not taken
else_label:            
    ret r31(0)                   ; Return M using address in r31 and no offset
    xor r0, r0, r0               ; NOP operation, delay while return being calculated - can't optimise here, function is complete

max4:
    add r26, r0, r10             ; Set up first call by moving r26 into r10 (first param == a)
    add r27, r0, r11             ; Set up first call by moving r27 into r11 (second param == b)
    callr max3, r15              ; Call max3 with params a, b, c
    add r28, r0, r12             ; Set up first call by moving r28 into r12 (third param == c) - will be moved before PC is updated, i.e. before function call
    add r29, r0, r12             ; Set up second call by moving r29 into r12 (third param == d)
    add r28, r0, r11             ; Set up second call by moving r29 into r11 (second param == c)
    callr max3, r15              ; Call max3 with params max3(a, b, c), c, d.
    add r1,  r0, r10             ; Set up second call by moving result of first call into r10 (first call) - will be done before branch/call is taken   
    ret r31(0)                   ; Return the result of the second call
    xor r0,  r0, r0              ; NOP operation, delay while return being calculated - can't optimise here, function is complete

main:
    add r0, #100, r10           ; Set up call to max4 by moving 100 into r10 (first param == 100)
    add r0, #99,  r11           ; Set up call to max4 by moving 99 into r11 (first param == 99)
    add r0, #43,  r12           ; Set up call to max4 by moving 43 into r12 (first param == 43)
    callr max4, r15             ; Call max4 with params 100, 99, 43 and 111
    add r0, #111, r13           ; Set up call to max4 by moving 111 into r13 (first param == 111)
    add r0, r0,   r1            ; Move 0 into r1
    ret r31(0)                  ; return 0 
    xor r0,  r0, r0             ; NOP operation, delay while return being calculated - can't optimise here, function is complete