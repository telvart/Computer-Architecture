caller:		addi 	$a0, $zero, -13		# initialize argument register with n = -13
		jal	fib			# call fib
end:		j	end

###############################################################
# This subroutine calculates Fibonacci numbers for both 
# positive and negative indices such that fib(-n) = - fib(n)
###############################################################
fib: 		addi	$sp, $sp, -12 		# make room on stack
		sw 	$ra, 8($sp) 		# push $ra
		sw 	$t0, 4($sp) 		# push $t0		
		sw 	$a0, 0($sp) 		# push $a0 (n)
		slt	$t0, $a0, $zero		# set flag when n < 0
 		beq	$t0, $zero, call
 		sub	$a0, $zero, $a0	
call:		jal	fib_abs
		beq	$t0, $zero, return
		sub	$v0, $zero, $v0
return:		lw 	$a0, 0($sp) 		# pop $a0
		lw 	$t0, 4($sp) 		# pop $t0
		lw 	$ra, 8($sp) 		# pop $ra
		addi 	$sp, $sp, 12 		# restore sp		
		jr	$ra
###############################################################
				
###############################################################
# This subroutine calculates Fibonacci numbers for positive  
# indices such that fib(|n|)
###############################################################
fib_abs:	addi	$v0, $zero, 1
		slt	$at, $v0, $a0		# set flag when 1 < n
		bne	$at, $zero, gen		# if n > 1, gen
		add	$v0, $zero, $a0		# else fib(0) = 0, fib(1) = 1
		jr	$ra			# return
gen:		addi	$sp, $sp, -12 		# make room on stack
		sw 	$ra, 8($sp) 		# push $ra
		sw 	$s0, 4($sp) 		# push $s0
		sw 	$a0, 0($sp) 		# push $a0 (n)
		addi 	$a0, $a0, -1 		# n-1
		jal 	fib_abs			# call fib(n-1)
		add 	$s0, $v0, $0 		# copy fib(n-1)
		addi 	$a0, $a0, -1 		# n-2
		jal 	fib_abs			# call fib(n-2)
		add 	$v0, $v0, $s0 		# fib(n-1)+fib(n-2)
		lw 	$a0, 0($sp) 		# pop $a0
		lw 	$s0, 4($sp) 		# pop $s0
		lw 	$ra, 8($sp) 		# pop $ra
		addi 	$sp, $sp, 12 		# restore sp
		jr 	$ra
###############################################################
exit:
