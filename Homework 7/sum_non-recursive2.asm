caller:		addi 	$a0, $zero, 10		# initialize argument register with n = 10
		jal	sum			# call sum
next:		j	exit

###############################################################
### Subroutine for summing numbers from 0 
### to the value stored in register $a0
sum:		addi	$sp, $sp, -8		# adjust stack pointer
		sw	$ra, 4($sp)		# save return address
		sw	$a0, 0($sp)		# save argument n
		add	$v0, $0, $0		# initialize return value
loop:		add	$v0, $v0, $a0		# sum = sum + i
		addi	$a0, $a0, -1		# calculate (i-1) in $a0
		slt	$at, $a0, $0		#
		beq	$at, $0, loop		# test if i < 0
		lw	$a0, 0($sp)		# restore argument n
		lw	$ra, 4($sp)		# restore return address
		addi	$sp, $sp, 8		# adjust stack pointer
		jr	$ra			# return to caller
###############################################################

exit:
