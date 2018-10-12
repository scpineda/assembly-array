# Who:  Sofia Pineda
# What: single_line.asm
# Why:  Prints things out on a single ine.
# When: Last Worked on: 9/19/18 | Due on: 9/26/18
# How:  List the uses of registers

.data     # All data declarations will go here

	array:   .space 80						  # The array of ints. Ints are 4 bytes. So 4 x 20 = 80, thus, 80 bytes.
	message: .asciiz "Please enter an int: "  # The message used to prompt the reader.
	enterl: .asciiz " "                       # Prints a space.

.text     # All instructions will go here

.globl main


main:	# program entry

	la $s0, array		# We put the base address of array into $s0. LA is load address
	add $s1, $s0, 80    # Find the ending address of the array


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

	la $s0, array	  # Reset the array address back to the original.

	PrintLine:

		beq $s0, $s1, Done	# Branches if equal to. Same as above.

		lw $a0, 0($s0)		# Grabs the appropriate integer.
		li $v0, 1			# Preparing to print an integer
		syscall				# Print Integer

		li $v0, 4			# Print String
		la $a0, enterl		# Prints endline
		syscall

		addi $s0, $s0, 4	# Adds 4 to grab next array address

		j PrintLine			# Returns the program to print line

	Done:


li $v0, 10		# terminate the program
syscall