# Who:  Sofia Pineda
# What: reverse_order.asm
# Why:  Prints things on one line in reverse order.
# When: Last Worked on: 9/19/18 | Due on: 9/26/18
# How:  List the uses of registers

.data     # All data declarations will go here

	array:   .space 80						     # The array of ints. Ints are 4 bytes. So 4 x 20 = 80, thus, 80 bytes.
	message: .asciiz "Please enter an int: "     # The message used to prompt the reader.
	secmess: .asciiz "How many ints per line?: " # The message used to prompt how many ints to use
	enterl: .asciiz " "                          # Prints a space.
	enter2: .asciiz "\n"						 # Prints an endline

.text     # All instructions will go here

.globl main


main:	# program entry

	la $s0, array		# We put the base address of array into $s0. LA is load address
	add $s1, $s0, 80    # Find the ending address of the array
	li $s4, 0	    # Set counter to initially equal 0

	GrabInts:

		beq $s0, $s1, Exit  # Branches if equal to. If the address of $s0 is the same as $s1, then we reached the end of the array. Stop here.
		
		li $v0, 4			# This calls load immediate with system call 4 to print a string.
		la $a0, message     # actually shows the message that we made above
		syscall				# Calls the system to do all of the above

		li $v0, 5			# This calls load immediate with a system call 5 to read integer
		syscall				# Tells the system to grab the int

		sw $v0, 0($s0)		# stores int into $s0

		addi $s0, $s0, 4	# Adds 4 (next byte) to array address

		j GrabInts			# Returns the program up above to the loop.

	Exit:

	li $v0, 4			# This calls load immediate with system call 4 to print a string.
	la $a0, secmess     # actually shows the message that we made above
	syscall				# Calls the system to do all of the above

	li $v0, 5			# This calls load immediate with a system call 5 to read integer
	syscall				# Tells the system to grab the int

	move $s3, $v0       # Stores the int into $s3

	la $s1, array			# Load original address into $s1
	sub $s0, $s0, 4			# Loads the index back into the last position

	PrintLine:

		slt $t0, $s0, $s1	 # We see if the address of $s0 is less than the address of $s1. If it is, then we have gone too far. We want this to be false
		bne $t0, $zero, Done # If $t0 is false, then we keep going. If true, we break.

		lw $a0, 0($s0)		# Grabs the appropriate integer.
		li $v0, 1			# Preparing to print an integer
		syscall				# Print Integer

		li $v0, 4			# Print String
		la $a0, enterl		# Prints space
		syscall

		sub $s0, $s0, 4	    # Adds 4 to grab next array address

		addi $s4, $s4, 1    # Increments counter up by one.

		j PrintEndLine		# Jumps to PrintEndLine

		j PrintLine			# Returns up to printLine

	PrintEndLine:

		bne $s4, $s3, PrintLine	# This loop will print an endline if counter is n

		li $v0, 4				# Print String
		la $a0, enter2			# Prints endline
		syscall

		li $s4, 0   			# Set counter back to 0

		j PrintEndLine			# Goes back to PrintLine
	
	Done:


li $v0, 10		# terminate the program
syscall