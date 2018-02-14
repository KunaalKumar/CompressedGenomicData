.data

prompt: .asciiz "Provide an input of less than 40 characters:\n"
.align 0
userInput: .space 40

.text

main:
	li $v0, 4		# Load 4 into $v0 to call syscall - print string
	la $a0, prompt		# String to print for syscall
	syscall			# Print prompt
	
	li $v0, 8		# Load 8 into $v0 to call syscall - get string
	la $a0, userInput	# Variable to store input in
	li $a1, 40		# Length of string
	syscall			# Get string from user
	
	la $t0, userInput	# t0 = base address of userInput
	li $t3, 0x23		# t3 = '#' Replace with A
	li $t4, 0x24		# t4 = '$' Replace with C
	li $t5, 0x25		# t5 = '%' Replace with G
	li $t6, 0x26		# t6 = '&' Replace with T

countChr:
	lb $t2, 0($t0)		# first byte from t0
	beqz $t2, end		# if character is 0, go to end
	beq $t2, $t3, replaceA	# if character is '#', go to replace
	beq $t2, $t4, replaceC 	# if character is '$', go to replace
	beq $t2, $t5, replaceG 	# if character is '%', go to replace
	beq $t2, $t6, replaceT 	# if character is '&', go to replace
	
	li $v0, 11		# else print chracter
	la $a0, ($t2)
	syscall
	
	add $t0, $t0, 1		# increment address
	j countChr

inc_add:
	addi $t0, $t0, 1	# increment address
	j countChr

inc_add_spc:
	li $v0, 11
	syscall 
	add $t0, $t0, 1		# increment address
	j countChr
	
replaceA:
	addi $t0, $t0, 1	# increment address
	lb $t2, 0($t0)		# t0 byte from userInput
	li $a0, '#'
	beq $t2, 0x20, inc_add_spc
	addi $s0, $t2, -32	# incrementer value to stop
	li $s1, 0		# i = 0

loopA:
	beq $s1, $s0, inc_add	# If i == $s0, go to countChr
	li $v0, 11		# Load 11 into v0 to call syscall - print character
	li $a0, 'A'		# Character to print is 'A'
	syscall 
	
	addi $s1, $s1, 1	# i++
	j loopA
	
replaceC:
	addi $t0, $t0, 1	# increment address
	lb $t2, 0($t0)		# t0 byte from userInput
	li $a0, '$'
	beq $t2, 0x20, inc_add_spc
	addi $s0, $t2, -32	# incrementer value to stop
	li $s1, 0		# i = 0

loopC:
	beq $s1, $s0, inc_add	# If i == $s0, go to countChr
	li $v0, 11		# Load 11 into v0 to call syscall - print character
	li $a0, 'C'		# Character to print is 'C'
	syscall 
	
	addi $s1, $s1, 1	# i++
	j loopC

replaceG:
	addi $t0, $t0, 1	# increment address
	lb $t2, 0($t0)		# t0 byte from userInput
	li $a0, '%'
	beq $t2, 0x20, inc_add_spc
	addi $s0, $t2, -32	# incrementer value to stop
	li $s1, 0		# i = 0

loopG:
	beq $s1, $s0, inc_add	# If i == $s0, go to countChr
	li $v0, 11		# Load 11 into v0 to call syscall - print character
	li $a0, 'G'		# Character to print is 'G'
	syscall 
	
	addi $s1, $s1, 1	# i++
	j loopG

replaceT:
	addi $t0, $t0, 1	# increment address
	lb $t2, 0($t0)		# t0 byte from userInput
	li $a0, '&'
	beq $t2, 0x20, inc_add_spc
	addi $s0, $t2, -32	# incrementer value to stop
	li $s1, 0		# i = 0

loopT:
	beq $s1, $s0, inc_add	# If i == $s0, go to countChr
	li $v0, 11		# Load 11 into v0 to call syscall - print character
	li $a0, 'T'		# Character to print is 'T'
	syscall 
	
	addi $s1, $s1, 1	# i++
	j loopT
	
end:
