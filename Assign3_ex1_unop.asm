max3:
    add r26, r0, r1              ; Moves r26 (a / first param) into return value (r1), which we will call M    
    sub r1, r27, r0 {C}          ; Does a subtraction and sets flags/CCF. Compares b / second param and M (a)
    jge c_label                  ; If Negative flag or Zero flag set, jump to c_label
    xor r0,  r0, r0              ; NOP operation, delay while branch being calculated
    add r27, r0, r1              ; r1 (M) = r27 (b)        
c_label:
    sub r1, r28, r0 {C}          ; Does a subtraction and sets flags/CCF. Compares c / second param and M (a or b depending on which was greater)
    jge else_label               ; If Negative flag or Zero flag set, jump to c_label
    xor r0,  r0, r0              ; NOP operation, delay while branch being calculated
    add r28, r0, r1              ; r1 (M) = r28 (c)   
else_label:            
    ret r31(0)                   ; Return M using address in r31 and no offset
    xor r0, r0, r0               ; NOP operation, delay while return being calculated

max4:
    add r26, r0, r10             ; Set up first call by moving r26 into r10 (first param == a)
    add r27, r0, r11             ; Set up first call by moving r27 into r11 (second param == b)
    add r28, r0, r12             ; Set up first call by moving r28 into r12 (third param == c)
    callr max3, r15              ; Call max3 with params a, b, c
    xor r0,  r0, r0              ; NOP operation, delay while call being calculated
    add r29, r0, r12             ; Set up second call by moving r29 into r12 (third param == d)
    add r28, r0, r11             ; Set up second call by moving r29 into r11 (second param == c)
    add r1,  r0, r10             ; Set up second call by moving result of first call into r10 (first call)
    callr max3, r15              ; Call max3 with params max3(a, b, c), c, d.
    xor r0,  r0, r0              ; NOP operation, delay while call being calculated
    ret r31(0)                   ; Return the result of the second call
    xor r0,  r0, r0              ; NOP operation, delay while return being calculated

main:
    add r0, #100, r10           ; Set up call to max4 by moving 100 into r10 (first param == 100)
    add r0, #99,  r11           ; Set up call to max4 by moving 99 into r11 (first param == 99)
    add r0, #43,  r12           ; Set up call to max4 by moving 43 into r12 (first param == 43)
    add r0, #111, r13           ; Set up call to max4 by moving 111 into r13 (first param == 111)
    callr max4, r15             ; Call max4 with params 100, 99, 43 and 111
    xor r0, r0,   r0            ; NOP operation, delay while call being calculated
    add r0, r0,   r1            ; Move 0 into r1
    ret r31(0)                  ; return 0 
    xor r0,  r0, r0             ; NOP operation, delay while return being calculated