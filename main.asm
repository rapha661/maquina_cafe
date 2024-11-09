;	+----+----+----+
;	| 11 | 10 |  9 |	row3
;	+----+----+----+
;	|  8 |  7 |  6 |	row2
;	+----+----|----+
;	|  5 |  4 |  3 |	row1
;	+----+----+----+
;	|  2 |  1 |  0 |	row0
;	+----+----+----+
;	 col2 col1 col0

;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|

RS equ P1.3
EN equ P1.2

org 0000h
	LJMP Start

ORG 0003H
    LJMP fimPrograma

org 0030h
	msgErro2:
		DB "Erro 05"
		DB 00h
	msgErro2Parte2:
		DB "Falta de copo"
		DB 00h
	msgErro3:
		DB "Erro 29"
		DB 00h
	msgErro3Parte2:
		DB "Falta de agua"
		DB 00h
	msgIniciarParte1: 
		DB "Pressione o"
		DB 00H
	msgIniciarParte2: 
		DB "botao 1"
		DB 00H
	msgSelecaoCafeParte1:
		DB "Selecione o cafe"
		DB 00H
	msgSelecaoCafeParte2: 
		DB "4-Expresso"
		DB 00H
	msgSelecaoCafeParte3:
		DB "5-Mocha"
		DB 00H
	msgSelecaoCafeParte4:
		DB "6-Cappuccino"
		DB 00H
	msgTamanhoCafeParte1:
		DB "Selecione o tam"
		DB 00H
	msgTamanhoCafeParte2: 
		DB "P-4 M-5 G-6"
		DB 00H
	msgTamanho:
		DB "Tamanho"
		DB 00h
	selecaoCafe4: 
		DB "Cafe expresso"
		DB 00H 
	selecaoCafe5: 
		DB "Cafe Mocha"
		DB 00H
	selecaoCafe6: 
		DB "Cafe Cappuccino"
		DB 00H 
	msgPreparado: 
		DB "sendo preparado"
		DB 00H
	msgExpresso: 
		DB "Expresso"
		DB 00H
	msgMocha: 
		DB "Mocha"
		DB 00H
	msgCappuccino: 
		DB "Cappuccino"
		DB 00H
	msgTamanhoP:
		DB "P"
		DB 00H
	msgTamanhoM:
		DB "M"
		DB 00H
	msgTamanhoG:
		DB "G"
		DB 00H
    msgPronto:
        DB "Cafe pronto"
		DB 00H

org 0150h
	fimPrograma:
    	CLR EA
		ACALL clearDisplay
		MOV B, #10h
		ACALL delayX
    	SJMP $

	Start:
		ACALL lcd_init
		SETB EA
		SETB EX0
		SETB IT0
		MAIN:
			ACALL menuInicio
	  		ACALL iniciar
			ACALL menuSelecaoCafe
			ACALL selecionaCafe
			ACALL menuSelecaoTamanho
			ACALL selecionaTamanho
           	ACALL preparaCafe
           	ACALL finalizar
			SJMP MAIN
	
	; Exibe no display lcd a mensagem "Pressione o botão 1"
	menuInicio:
		MOV A, #02h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgIniciarParte1
		ACALL ESCREVESTRINGROM
		MOV A, #44h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgIniciarParte2
		ACALL ESCREVESTRINGROM
		RET

	; Lê o teclado matricial e verifica se alguma tecla foi pressionada.
	; Se sim, verifica se a tecla é o 1, 2 ou 3.
	; Se sim, move o valor do botão pressionado para o R4.
	; Se não é a tecla correta ou não foi pressionada, repete a rotina.
	iniciar:
		esperaIniciar:
			CLR F0
			ACALL leituraTeclado
			JNB F0, esperaIniciar
			ACALL delay
		  	CJNE R0, #11, verifica2
			MOV R4, #1
			RET
			verifica2:
				ACALL delay
				CJNE R0, #10, verifica3
				MOV R4, #2
				RET
			verifica3:
				ACALL delay
				CJNE R0, #9, esperaIniciar
				MOV R4, #3
				RET

	; Exibe a mensagem "Selecione o café 4-Expresso 5-Mocha 6-Cappuccino".
	; Essa mensagem é dividida em 2 parte.
	; Parte 1: "Selecione o café 4-Expresso".
	; Parte 2: "5-Mocha 6-Cappuccino".
	menuSelecaoCafe:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #00h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgSelecaoCafeParte1
		ACALL ESCREVESTRINGROM
		MOV A, #43h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgSelecaoCafeParte2
		ACALL ESCREVESTRINGROM
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #04h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgSelecaoCafeParte3
		ACALL ESCREVESTRINGROM
		MOV A, #42h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgSelecaoCafeParte4
		ACALL ESCREVESTRINGROM
		RET
	
	; Se o 4, 5 ou 6 foram pressionados move o número correspondente para o r2.
	selecionaCafe:
		CLR F0
	  	ACALL leituraTeclado
	  	JNB F0, selecionaCafe
	  	CJNE R0, #8, verifica5
		mov r2, #4
		sjmp final
		verifica5:
			CJNE R0, #7, verifica6
			mov r2, #5
			sjmp final
		verifica6:
			CJNE R0, #6, selecionaCafe
			mov r2, #6
			sjmp final
		final:
			ret

	; Exibe a mensagem "Selecione o tam P-4 M-5 G-6".
	menuSelecaoTamanho:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #00h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgTamanhoCafeParte1
		ACALL ESCREVESTRINGROM
		MOV A, #42h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgTamanhoCafeParte2
		ACALL ESCREVESTRINGROM
		RET

	; Se o 4, 5 ou 6 foram pressionados move o número correspondente para o r3.
	selecionaTamanho:
		CLR F0
	  	ACALL leituraTeclado
	  	JNB F0, selecionaTamanho
	  	CJNE R0, #8, verificaM
	    MOV R3, #4
	    SJMP acaba
	    verificaM:
	        CJNE R0, #7, verificaG
          	MOV R3, #5
	        SJMP acaba
	    verificaG:
	        CJNE R0, #6, selecionaTamanho
	        MOV R3, #6
	        SJMP acaba
		acaba:
			mov b, #10h
			ACALL clearDisplay
    		ACALL delayX
			ret

	; Primeiramente verifica qual modo foi acionado.
	; Se foi o 2 ou o 3, só exibe uma mensagem de erro.
	; Caso seja o modo 1 verifica qual foi o café selecionado.
	; Chama o preparo do café correspondente.
    preparaCafe:
		CJNE R4, #1, erro2
        CJNE R2, #4, verificaMocha
        ACALL preparaExpresso
        SJMP fim
        verificaMocha:
            CJNE R2, #5, verificaCappuccino
            ACALL preparaMocha
            SJMP fim
        verificaCappuccino:
            ACALL preparaCappuccino
            SJMP fim
		erro2:
			CJNE R4, #2, erro3
			ACALL clearDisplay
			MOV B, #10H
			ACALL delayX
			MOV A, #04H
			ACALL POSICIONACURSOR
			MOV DPTR, #msgErro2
			ACALL ESCREVESTRINGROM
			MOV A, #41H
			ACALL POSICIONACURSOR
			MOV DPTR, #msgErro2Parte2
			ACALL ESCREVESTRINGROM
			SJMP fim
		erro3:
			ACALL clearDisplay
			MOV B, #10H
			ACALL delayX
			MOV A, #04H
			ACALL POSICIONACURSOR
			MOV DPTR, #msgErro3
			ACALL ESCREVESTRINGROM
			MOV A, #41H
			ACALL POSICIONACURSOR
			MOV DPTR, #msgErro3Parte2
			ACALL ESCREVESTRINGROM
			SJMP fim
        fim:
            mov b, #50h
            ACALL delayX
	    	ACALL desligaMotor
	   		ret

	; Verifica qual o tamanho selecionado através do r3.
	; Exibe uma mensagem correspondente ao tamanho selecionado e liga o motor.
    preparaExpresso:
        CJNE R3, #4, preparaExpressoM
        ACALL fazendoExpresso
        MOV A, #0CH
        ACALL POSICIONACURSOR
        MOV DPTR, #msgTamanhoP
        ACALL ESCREVESTRINGROM
		ACALL ligaMotor
        ret
        preparaExpressoM:
            CJNE R3, #5, preparaExpressoG
            ACALL fazendoExpresso
            MOV A, #0CH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoM
            ACALL ESCREVESTRINGROM
	   		ACALL ligaMotor
            ret
        preparaExpressoG:
            ACALL fazendoExpresso
            MOV A, #0CH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoG
            ACALL ESCREVESTRINGROM
	    	ACALL ligaMotor
            ret
    
	; Verifica qual o tamanho selecionado através do r3.
	; Exibe uma mensagem correspondente ao tamanho selecionado e liga o motor.
    preparaMocha:
        CJNE R3, #4, preparaMochaM
        ACALL fazendoMocha
        MOV A, #0AH
        ACALL POSICIONACURSOR
        MOV DPTR, #msgTamanhoP
        ACALL ESCREVESTRINGROM
		ACALL ligaMotor
        ret
        preparaMochaM:
            CJNE R3, #5, preparaMochaG
            ACALL fazendoMocha
            MOV A, #0AH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoM
            ACALL ESCREVESTRINGROM
	   		ACALL ligaMotor
            ret
        preparaMochaG:
            ACALL fazendoMocha
            MOV A, #0AH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoG
            ACALL ESCREVESTRINGROM
	    	ACALL ligaMotor
            ret

	; Verifica qual o tamanho selecionado através do r3.
	; Exibe uma mensagem correspondente ao tamanho selecionado e liga o motor.
    preparaCappuccino:
        CJNE R3, #4, preparaCappuccinoM
        ACALL fazendoCappuccino
        MOV A, #0EH
        ACALL POSICIONACURSOR
        MOV DPTR, #msgTamanhoP
        ACALL ESCREVESTRINGROM
		ACALL ligaMotor
        ret
        preparaCappuccinoM:
            CJNE R3, #5, preparaCappuccinoG
            ACALL fazendoCappuccino
            MOV A, #0EH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoM
            ACALL ESCREVESTRINGROM
	    	ACALL ligaMotor
            ret
        preparaCappuccinoG:
            ACALL fazendoCappuccino
            MOV A, #0EH
            ACALL POSICIONACURSOR
            MOV DPTR, #msgTamanhoG
            ACALL ESCREVESTRINGROM
	    	ACALL ligaMotor
            ret

	; Limpa o display lcd e verifica se o modo é 1.
	; Se sim, exibe uma mensagem de "Café pronto".
	; Caso contrário só retorna.
    finalizar:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		CJNE R4, #1, finalizarCafe
        ACALL displayFinal
        ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		finalizarCafe:
			ret
        
	; Exibe a mensagem de "Café pronto".
    displayFinal:
        MOV A, #02h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgPronto
		ACALL ESCREVESTRINGROM
		RET

	; Exibe a mensagem de "Expresso sendo preparado".
	fazendoExpresso:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #03h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgExpresso
		ACALL ESCREVESTRINGROM
		MOV A, #40h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgPreparado
		ACALL ESCREVESTRINGROM
		RET

	; Exibe a mensagem de "Mocha sendo preparado".
    fazendoMocha:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #03h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgMocha
		ACALL ESCREVESTRINGROM
		MOV A, #40h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgPreparado
		ACALL ESCREVESTRINGROM
		RET

	; Exibe a mensagem de "Cappuccino sendo preparado".
    fazendoCappuccino:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #03h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgCappuccino
		ACALL ESCREVESTRINGROM
		MOV A, #40h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgPreparado
		ACALL ESCREVESTRINGROM
		RET

    desligaMotor:
		setb P3.0
		SETB P3.1
		ret

	ligaMotor:
		SETB P3.0
		CLR P3.1
		RET
	
	; Repete a rotina delay de acordo com o valor que estiver em b.
	delayX:
		rotina:
			ACALL delay
			djnz b, rotina
		ret

	; Código retirado do material do professor da disciplina.
	leituraTeclado:
		MOV R0, #0

		MOV P0, #0FFh	
		CLR P0.0
		CALL colScan
		JB F0, finish

		SETB P0.0
		CLR P0.1
		CALL colScan
		JB F0, finish

		SETB P0.1
		CLR P0.2
		CALL colScan
		JB F0, finish

		SETB P0.2
		CLR P0.3
		CALL colScan
		JB F0, finish
		finish:
			RET

	; Código retirado do material do professor da disciplina.
	escreveStringROM:
	  MOV R1, #00h
	loop:
	  MOV A, R1
		MOVC A,@A+DPTR
		JZ final2
		ACALL sendCharacter
		INC R1
	   MOV A, R1
		JMP loop
	final2:
		RET

	; Código retirado do material do professor da disciplina.
	colScan:
		JNB P0.4, gotKey
		INC R0
		JNB P0.5, gotKey
		INC R0
		JNB P0.6, gotKey
		INC R0
		RET
	gotKey:
		SETB F0
		RET

	; Código retirado do material do professor da disciplina.
	lcd_init:
		CLR RS
	
		CLR P1.7
		CLR P1.6
		SETB P1.5
		CLR P1.4
	
		SETB EN
		CLR EN
	
		CALL delay
	
		SETB EN
		CLR EN
	
		SETB P1.7
	
		SETB EN
		CLR EN
		CALL delay
	
		CLR P1.7
		CLR P1.6
		CLR P1.5
		CLR P1.4
	
		SETB EN
		CLR EN
	
		SETB P1.6
		SETB P1.5
	
		SETB EN
		CLR EN
	
		CALL delay
	
		CLR P1.7
		CLR P1.6
		CLR P1.5
		CLR P1.4
	
		SETB EN
		CLR EN
	
		SETB P1.7
		SETB P1.6
		SETB P1.5
		SETB P1.4
	
		SETB EN
		CLR EN
	
		CALL delay
		RET

	; Código retirado do material do professor da disciplina.
	sendCharacter:
		SETB RS
		MOV C, ACC.7
		MOV P1.7, C
		MOV C, ACC.6
		MOV P1.6, C
		MOV C, ACC.5
		MOV P1.5, C
		MOV C, ACC.4
		MOV P1.4, C
	
		SETB EN
		CLR EN
	
		MOV C, ACC.3
		MOV P1.7, C
		MOV C, ACC.2
		MOV P1.6, C
		MOV C, ACC.1
		MOV P1.5, C
		MOV C, ACC.0
		MOV P1.4, C
	
		SETB EN
		CLR EN
	
		CALL delay
		CALL delay
		RET

	; Código retirado do material do professor da disciplina.
	posicionaCursor:
		CLR RS	
		SETB P1.7
		MOV C, ACC.6
		MOV P1.6, C
		MOV C, ACC.5
		MOV P1.5, C
		MOV C, ACC.4
		MOV P1.4, C
	
		SETB EN
		CLR EN
	
		MOV C, ACC.3
		MOV P1.7, C
		MOV C, ACC.2
		MOV P1.6, C
		MOV C, ACC.1
		MOV P1.5, C
		MOV C, ACC.0
		MOV P1.4, C
	
		SETB EN
		CLR EN
	
		CALL delay
		CALL delay
		RET

	; Código retirado do material do professor da disciplina.
	clearDisplay:
		CLR RS	
		CLR P1.7
		CLR P1.6
		CLR P1.5
		CLR P1.4
	
		SETB EN
		CLR EN
	
		CLR P1.7
		CLR P1.6
		CLR P1.5
		SETB P1.4
	
		SETB EN
		CLR EN
	
		CALL delay
		RET
	
	delay:
		MOV R7, #50
		DJNZ R7, $
		RET
