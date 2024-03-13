.globl main 

.data
msg: .asciz "# "
enter: .asciz "\n"
store: .space 512	#수식이 저장될 공간

.text
main:
	la a0, msg
	li a7,4
	ecall		# 출력

	la a0, store
	addi a1, x0, 512
	li a7, 8
	ecall		# 512 character 수식 입력받기
	
	li a7, 4	#입력받은 수식 출력 
	ecall
	
	add s2, a0, x0 # string 저장된 주소 s2로 옮겨 저장
	
	addi a3, x0 ,-1 
	addi a4, x0, -1 
	addi a2, x0, 10
Loop: 
	lb s1 , 0(s2) # store[i] 값 구하기 처음엔 i=0;
	
	addi t1, x0, 0x2B
	beq s1, t1, plus #+
	addi t1, x0, 0x2D
	beq s1, t1, minus #-
	addi t1, x0, 0x78
	beq s1, t1, multi #x
	addi t1, x0, 0x2F
	beq s1, t1, divide #/
	addi t1, x0,0x3D
	beq s1, t1, exit # =
	
	
	addi s0, x0, '0'
	sub s1,s1, s0	#char to int
	
	bne a4, a3, insert #a4가 -1과 같으면 입력값을 a4에 넣고 -1이 아니라면 a5에 값을 넣어라
	mv a4, s1
	mv a6, a4  #한자리수 일때는 그냥 한글자만 받음
	
	addi s2,s2,1
	jal Loop
insert:
	mv a5, s1	#두번째 루프부터는 a5에 값을 넣어 주고 *10해주고 
	mul a6, a6, a2
	add a6, a6, a5
	
	addi s2, s2, 1	#store의 i++
	jal Loop

plus:

	addi s2,s2, 1
	lb s1 , 0(s2) # store[i] 값 구하기
	
	addi t1, x0, 0x2B
	beq s1, t1,  pluscal#+
	addi t1, x0, 0x2D
	beq s1, t1,  pluscal#-
	addi t1, x0, 0x78
	beq s1, t1,  pluscal#x
	addi t1, x0, 0x2F
	beq s1, t1,  pluscal#/
	addi t1, x0, 0x3D
	beq s1, t1,  pluscal# =
	
	addi s0, x0, '0'
	sub s1, s1 , s0
	
	bne a4, a3, insert2 #a4가 -1과 같으면 입력값을 a4에 넣고 -1이 아니라면 a5에 값을 넣어라
	mv a4, s1
	mv t4, a4  #한자리수 일때는 그냥 한글자만 받음
	
	jal plus
insert2:
	mv a5, s1	#두번째 루프부터는 a5에 값을 넣어 주고 *10해주고 
	mul t4, t4, a2
	add t4, t4 a5
	
	jal plus
	
pluscal:
	mv a4,a3
	add a6, a6, t4
	
	add a0, a6, x0
	li a7, 1
	ecall
	
	la a0, enter
	li a7, 4
	ecall
	
	jal Loop
	
minus:
	addi s2,s2, 1
	lb s1 , 0(s2) # store[i] 값 구하기
	
	addi t1, x0, 0x2B
	beq s1, t1,  minuscal#+
	addi t1, x0, 0x2D
	beq s1, t1,  minuscal#-
	addi t1, x0, 0x78
	beq s1, t1,  minuscal#x
	addi t1, x0, 0x2F
	beq s1, t1,  minuscal#/
	addi t1, x0,0x3D
	beq s1, t1,  minuscal# =
	
	addi s0, x0, '0'
	sub s1, s1 , s0
	
	bne a4, a3, insert3 #a4가 -1과 같으면 입력값을 a4에 넣고 -1이 아니라면 a5에 값을 넣어라
	mv a4, s1
	mv t4, a4  #한자리수 일때는 그냥 한글자만 받음
	
	jal minus
insert3:
	mv a5, s1	#두번째 루프부터는 a5에 값을 넣어 주고 *10해주고 
	mul t4, t4, a2
	add t4, t4, a5
	
	jal minus
minuscal:
	mv a4,a3
	sub a6, a6, t4
	
	add a0, a6, x0
	li a7, 1
	ecall
	
	la a0, enter
	li a7,4
	ecall
	
	jal Loop
	
multi:
	addi s2,s2, 1
	lb s1 , 0(s2) # store[i] 값 구하기
	
	addi t1, x0, 0x2B
	beq s1, t1,  multical#+
	addi t1, x0, 0x2D
	beq s1, t1,  multical#-
	addi t1, x0, 0x78
	beq s1, t1,  multical#x
	addi t1, x0, 0x2F
	beq s1, t1,  multical#/
	addi t1, x0, 0x3D
	beq s1, t1,  multical# =
	
	addi s0, x0, '0'
	sub s1, s1 , s0
	
	bne a4, a3, insert4 #a4가 -1과 같으면 입력값을 a4에 넣고 -1이 아니라면 a5에 값을 넣어라
	mv a4, s1
	mv t4, a4  #한자리수 일때는 그냥 한글자만 받음
	
	jal multi
insert4:
	mv a5, s1	#두번째 루프부터는 a5에 값을 넣어 주고 *10해주고 
	mul t4, t4, a2
	add t4, t4, a5
	
	jal multi
	
multical:
	mv a4, a3
	mul a6, a6, t4
	
	add a0, a6, x0
	li a7, 1
	ecall
	
	la a0, enter
	li a7,4
	ecall
	
	jal Loop
divide:

	addi s2,s2, 1
	lb s1 , 0(s2) # store[i] 값 구하기
	
	addi t1, x0, 0x2B
	beq s1, t1,  dividecal#+
	addi t1, x0, 0x2D
	beq s1, t1,  dividecal#-
	addi t1, x0, 0x78
	beq s1, t1,  dividecal#x
	addi t1, x0, 0x2F
	beq s1, t1,  dividecal#/
	addi t1, x0,0x3D
	beq s1, t1,  dividecal#=
		
	addi s0, x0, '0'
	sub s1, s1 , s0
	bne a4, a3, insert5 #a4가 -1과 같으면 입력값을 a4에 넣고 -1이 아니라면 a5에 값을 넣어라
	mv a4, s1
	mv t4, a4  #한자리수 일때는 그냥 한글자만 받음
	
	jal divide
insert5:
	mv a5, s1	#두번째 루프부터는 a5에 값을 넣어 주고 *10해주고 
	mul t4,t4, a2
	add t4, t4, a5
	
	jal divide
	
dividecal:
	mv a4,a3
	div a6, a6, t4
	
	add a0, a6, x0
	li a7, 1
	ecall
	
	la a0, enter
	li a7,4
	ecall
	
	jal Loop
	
exit:
	li a0,0
	li a7, 93
	ecall