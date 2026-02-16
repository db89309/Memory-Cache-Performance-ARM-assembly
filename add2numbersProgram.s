.equ JTAG, 0xFF201000

.data
prompt1: .asciz "Enter first number: "
prompt2: .asciz "\nEnter second number: "
result:  .asciz "\nThe sum is: "

.text
.global _start
_start:
    LDR R3, =JTAG           @ R3 = The UART address (our mailbox)

    /* --- 1. Print Prompt 1 --- */
    LDR R4, =prompt1
loop1:
    LDRB R0, [R4], #1       @ Get a letter
    CMP R0, #0              @ End of string?
    BEQ wait1               @ If yes, go wait for the user
    STR R0, [R3]            @ Print letter
    B loop1

    /* --- 2. STOP and WAIT for First Number --- */
wait1:
    LDR R0, [R3]            @ Look at the UART
    ANDS R5, R0, #0x8000    @ Is Bit 15 a '1'? (This means a key was pressed)
    BEQ wait1               @ IF NOT, GO BACK TO wait1 AND CHECK AGAIN
    AND R0, R0, #0xFF       @ Keep the character (e.g., '5')
    STR R0, [R3]            @ Echo it to the screen
    SUB R0, R0, #0x30       @ Convert '5' to the actual number 5

    /* --- 3. Print Prompt 2 --- */
    LDR R4, =prompt2
loop2:
    LDRB R1, [R4], #1
    CMP R1, #0
    BEQ wait2
    STR R1, [R3]
    B loop2

    /* --- 4. STOP and WAIT for Second Number --- */
wait2:
    LDR R1, [R3]
    ANDS R5, R1, #0x8000    @ Is Bit 15 a '1'?
    BEQ wait2               @ IF NOT, GO BACK TO wait2 AND CHECK AGAIN
    AND R1, R1, #0xFF
    STR R1, [R3]
    SUB R1, R1, #0x30

    /* --- 5. Print Result Message --- */
    LDR R4, =result
loop3:
    LDRB R5, [R4], #1
    CMP R5, #0
    BEQ finish
    STR R5, [R3]
    B loop3

    /* --- 6. Math and Output --- */
finish:
    ADD R2, R0, R1          @ R2 = R0 + R1
    ADD R2, R2, #0x30       @ Convert back to ASCII
    STR R2, [R3]            @ Print the final digit

stop:
    B stop
	
	