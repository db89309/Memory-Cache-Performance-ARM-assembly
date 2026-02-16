.global _start
_start:
	jal main
	li $v0, 10
	syscall		# Use syscall 10 to stop simulation

main:

.data
prompt1:    .asciiz "Enter first number: "
prompt2:    .asciiz "Enter second number: "
resultMsg:  .asciiz "Sum of squares: "

.text
.globl main

main:

    li $v0, 4			#first number prompt
    la $a0, prompt1
    syscall

    li $v0, 5          # Read integer
    syscall
    move $t0, $v0      # R0 = first number

    li $v0, 4			#second number prompt
    la $a0, prompt2
    syscall

    li $v0, 5          # Read integer
    syscall
    move $t1, $v0      # R1 = second number

    mul $t3, $t0, $t0  # R3 = R0^2	#calc squares
    mul $t4, $t1, $t1  # R4 = R1^2

    add $t5, $t3, $t4  # R5 = R3 + R4		#calc sum of squares

    # ---- Print result message ----
    li $v0, 4
    la $a0, resultMsg
    syscall

    # ---- Print sum ----
    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 10		#exit
    syscall

	