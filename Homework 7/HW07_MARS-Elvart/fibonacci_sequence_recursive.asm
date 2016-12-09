
caller:		addi 	$a0, $a0, 0		# initialize argument register $a0 with i = 0
		addi 	$s1, $s1, 15		# initialize argument register $a1 with 15		
		addi	$s2, $s1, 1		# set stopping point for loop
		lui	$s5, 0x1001		# initialize store address
		
		jal fib_seq

next:		j	exit	
##############################################################################
# This routine generates Fibonacci sequence fib(0), fib(1), fib(2), ... fib(n)
# and stores it into the data segment starting at address 0x10010000

fib_seq:
####################### Insert Your Code Here ################################
		
loop:		beq $a0, $zero, store0		# if i=0, store 0 
		beq $a0, 1, store1		# if i=1, store1 
		beq $a0, $s2, exit		# else, generate number and store
		jal fib				# call fib(n)
		sw $v0, 0($s5)			# store returned value
		addi $a0, $a0, 1		# i++
		addi $s5, $s5, 4		# move next store address
		j loop
			
store0:
		sw $a0, 0($s5)			# store 0
		addi $a0, $a0, 1		# i++
		addi $s5, $s5, 4		# move next store address
		j loop
		
store1:
		sw $a0, 0($s5)			# store 1
		addi $a0, $a0, 1		# i++
		addi $s5, $s5, 4		# mopve next store address
		j loop
				
fib:		
		addi 	$sp, $sp, -12		# make room on stack
		sw 	$ra, 8($sp) 		# push $ra
		sw 	$s0, 4($sp)		# push $s0
		sw 	$a0, 0($sp)		# push $a0 (N)
		slt	$at,  $0, $a0
		bne	$at,  $0, test2		# if n>0, test if n=1
		add 	$v0, $0, $0 		# else fib(0) = 0
		j 	rtn 			#

test2: 		addi 	$t0, $0, 1 		# test if n=1
		bne 	$t0, $a0, gen 		# if n>1, gen
		add 	$v0, $0, $t0 		# else fib(1) = 1
		j 	rtn

gen: 		addi 	$a0, $a0, -1 		# n-1
		jal 	fib 			# call fib(n-1)
		add 	$s0, $v0, $0 		# copy fib(n-1)
		addi 	$a0, $a0, -1 		# n-2
		jal 	fib 			# call fib(n-2)
		add 	$v0, $v0, $s0 		# fib(n-1)+fib(n-2)

rtn: 		lw 	$a0, 0($sp)		# pop $a0
		lw 	$s0, 4($sp) 		# pop $s0
		lw 	$ra, 8($sp) 		# pop $ra
		addi 	$sp, $sp, 12		# restore sp
		jr 	$ra
##############################################################################

exit:		
