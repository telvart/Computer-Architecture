	addi	$t0, $zero, 5	# Instruction 00
	addi	$t1, $zero, 7	# Instruction 01
start:	sw	$t0,  0($sp)	# Instruction 02
	sw	$t1, -4($sp)	# Instruction 03
	lw	$s0,  0($sp)	# Instruction 04
	lw	$s1, -4($sp)	# Instruction 05
	beq	$s0, $s1, Else	# Instruction 06
	add	$s3, $s0, $s1	# Instruction 07
	j	Exit		# Instruction 08
Else:	sub	$s3, $s0, $s1	# Instruction 09
Exit:	add	$s0, $s0, $s3	# Instruction 10
	or	$s1, $s1, $s3	# Instruction 11
	addi	$t0, $t0,  3	# Instruction 12
	addi	$t1, $t1,  3	# Instruction 13
	addi	$sp, $sp, -8	# Instruction 14
        j	start		# Instruction 15
