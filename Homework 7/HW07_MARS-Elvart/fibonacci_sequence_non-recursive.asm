
caller:		addi 	$a0, $zero, 15		# initialize argument register $a0 with n = 15
		jal	fib_seq			# call fib_seq
next:		j	exit

##############################################################################
# This routine generates Fibonacci sequence fib(0), fib(1), fib(2), ... fib(n)
# and stores it into the data segment starting at address 0x10010000

fib_seq:	
####################### Insert Your Code Here ################################
		lui $s5, 0x1001		#starting store address
		add $t5, $t5, $zero	# i = 0
		add $t0, $t0, $zero	#set $t0 to 0 for comparison
		addi $t1, $t1, 1	#set $t1 to 1 for comparison
		addi $t7, $a0, 1	#use $as stopping point for generation
		
loop:		beq $t5, $zero, store0	# if fib(n) = 0, store 0
		beq $t5, 1, store1	# if fib(n) = 1, store 1
		beq $t5, $t7, exit	# if i != 0 or 1 and i < 15, generate the number and store it
		lw $t2, -4($s5)		# $t2 = n-1
		lw $t3, -8($s5)		# $t3 = n-2
		add $t4, $t2, $t3	# $t4 = fib(n-1) + fib(n-2)
		sw $t4, 0($s5)		# store $t4
		addi $s5, $s5, 4	# move next store address
		addi $t5, $t5, 1	# i++
		j loop			
		
store1:		sw $t5, 0($s5)		# store 1
		addi $s5, $s5, 4	# move next store address
		addi $t5, $t5, 1	# i++
		j loop
		

store0:		sw $t5, 0($s5)		# store 0
		addi $s5, $s5, 4	# move next store address
		addi $t5, $t5, 1	# i++
		j loop
	

	

##############################################################################

exit:		
