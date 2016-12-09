caller:		addi 	$a0, $zero, -13		# initialize argument register with n = -13 0040 0000
		jal	fib			# call fib				    0040 0004
end:		j	end			#					    0040 0008	

###############################################################
# This subroutine calculates Fibonacci numbers for both 
# positive and negative indices such that fib(-n) = - fib(n)
###############################################################
fib: 		addi	$sp, $sp, -12 		# make room on stack 0040 000c
		sw 	$ra, 8($sp) 		# push $ra	     0040 0010
		sw 	$t0, 4($sp) 		# push $t0	     0040 0014	
		sw 	$a0, 0($sp) 		# push $a0 (n)	     0040 0018
		slt	$t0, $a0, $zero		# set flag when n<0  0040 001c
 		beq	$t0, $zero, call	#		     0040 0020
 		sub	$a0, $zero, $a0		#		     0040 0024
call:		jal	fib_abs			#		     0040 0028
		beq	$t0, $zero, return	#		     0040 002c
		sub	$v0, $zero, $v0		#		     0040 0030
return:		lw 	$a0, 0($sp) 		# pop $a0	     0040 0034
		lw 	$t0, 4($sp) 		# pop $t0	     0040 0038
		lw 	$ra, 8($sp) 		# pop $ra	     0040 003c
		addi 	$sp, $sp, 12 		# restore sp	     0040 0040
		jr	$ra			#		     0040 0044
###############################################################
				
###############################################################
# This subroutine calculates Fibonacci numbers for positive  
# indices such that fib(|n|)
###############################################################
fib_abs:	addi	$v0, $zero, 1           #					0040 0048
		slt	$at, $v0, $a0		# set flag when 1 < n			0040 004c
		bne	$at, $zero, gen		# if n > 1, gen				0040 0050
		add	$v0, $zero, $a0		# else fib(0) = 0, fib(1) = 1		0040 0054
		jr	$ra			# return				0040 0058
gen:		addi	$sp, $sp, -12 		# make room on stack			0040 005c
		sw 	$ra, 8($sp) 		# push $ra				0040 0060
		sw 	$s0, 4($sp) 		# push $s0				0040 0064
		sw 	$a0, 0($sp) 		# push $a0 (n)				0040 0068
		addi 	$a0, $a0, -1 		# n-1					0040 006c
		jal 	fib_abs			# call fib(n-1)				0040 0070
		add 	$s0, $v0, $0 		# copy fib(n-1)				0040 0074
		addi 	$a0, $a0, -1 		# n-2					0040 0078
		jal 	fib_abs			# call fib(n-2)				0040 007c
		add 	$v0, $v0, $s0 		# fib(n-1)+fib(n-2)			0040 0080
		lw 	$a0, 0($sp) 		# pop $a0				0040 0084
		lw 	$s0, 4($sp) 		# pop $s0				0040 0088
		lw 	$ra, 8($sp) 		# pop $ra				0040 008c
		addi 	$sp, $sp, 12 		# restore sp				0040 0090
		jr 	$ra
###############################################################
exit:
