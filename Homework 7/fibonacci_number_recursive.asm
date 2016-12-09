
caller:		lui	$s5, 0x1001
		addi 	$a0, $zero, 15	
						# initialize argument register $a0 with n = 15
		jal	fib
						# call fib
next:		j	exit

##############################################################################
# This routine recursively generates the nth Fibonacci number fib(n) and 
# returns it into register $v0
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
