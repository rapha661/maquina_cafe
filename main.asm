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

org 0030h
	; DEFINICAO DOS TEXTOS UTILIZADOS
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

org 0100h
	Start:
		ACALL lcd_init
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

	iniciar:
		esperaIniciar:
			CLR F0
			ACALL leituraTeclado
			JNB F0, esperaIniciar
			ACALL delay
		  	CJNE R0, #11, esperaIniciar
		RET

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

    preparaCafe:
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
        fim:
            mov b, #50h
            ACALL delayX
	    ACALL desligaMotor
	    ret

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

    finalizar:
        	ACALL clearDisplay
		mov b, #10h
		ACALL delayX
        	ACALL displayFinal
        	ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		ret
        
    displayFinal:
        	MOV A, #02h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgPronto
		ACALL ESCREVESTRINGROM
		RET

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

	displayTamanho:
		ACALL clearDisplay
		mov b, #10h
		ACALL delayX
		MOV A, #03h
		ACALL POSICIONACURSOR
		MOV DPTR,#msgTamanho
		ACALL ESCREVESTRINGROM
        MOV A, #0Bh
		ACALL POSICIONACURSOR
        CJNE r3, #4, mostra5
		MOV DPTR,#msgTamanhoP
        SJMP fimDisplayTamanho
        mostra5:
            CJNE r3, #5, mostra6
            MOV DPTR,#msgTamanhoM
            SJMP fimDisplayTamanho
        mostra6:
            MOV DPTR,#msgTamanhoG
            SJMP fimDisplayTamanho
        fimDisplayTamanho:
            RET

    desligaMotor:
		setb P3.0
		SETB P3.1
		ret

	ligaMotor:
		SETB P3.0
		CLR P3.1
		RET
	
	delayX:
		rotina:
			ACALL delay
			djnz b, rotina
		ret

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
			RET; | (because the pressed key was found and its number is in  R0)

	escreveStringROM:
	  MOV R1, #00h
		; Inicia a escrita da String no Display LCD
	loop:
	  MOV A, R1
		MOVC A,@A+DPTR 	 ;l� da mem�ria de programa
		JZ final2	; if A is 0, then end of data has been reached - jump out of loop
		ACALL sendCharacter	; send data in A to LCD module
		INC R1			; point to next piece of data
	   MOV A, R1
		JMP loop		; repeat
	final2:
		RET
	
	; column-scan subroutine
	colScan:
		JNB P0.4, gotKey	; if col0 is cleared - key found
		INC R0				; otherwise move to next key
		JNB P0.5, gotKey	; if col1 is cleared - key found
		INC R0				; otherwise move to next key
		JNB P0.6, gotKey	; if col2 is cleared - key found
		INC R0				; otherwise move to next key
		RET					; return from subroutine - key not found
	gotKey:
		SETB F0				; key found - set F0
		RET					; and return from subroutine
	
	lcd_init:
		CLR RS		; clear RS - indicates that instructions are being sent to the module
	
	; function set	
		CLR P1.7		; |
		CLR P1.6		; |
		SETB P1.5		; |
		CLR P1.4		; | high nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		CALL delay		; wait for BF to clear	
						; function set sent for first time - tells module to go into 4-bit mode
	; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.
	
		SETB EN		; |
		CLR EN		; | negative edge on E
						; same function set high nibble sent a second time
	
		SETB P1.7		; low nibble set (only P1.7 needed to be changed)
	
		SETB EN		; |
		CLR EN		; | negative edge on E
					; function set low nibble sent
		CALL delay		; wait for BF to clear
	
	; entry mode set
	; set to increment with no shift
		CLR P1.7		; |
		CLR P1.6		; |
		CLR P1.5		; |
		CLR P1.4		; | high nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		SETB P1.6		; |
		SETB P1.5		; |low nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		CALL delay		; wait for BF to clear
	
	; display on/off control
	; the display is turned on, the cursor is turned on and blinking is turned on
		CLR P1.7		; |
		CLR P1.6		; |
		CLR P1.5		; |
		CLR P1.4		; | high nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		SETB P1.7		; |
		SETB P1.6		; |
		SETB P1.5		; |
		SETB P1.4		; | low nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		CALL delay		; wait for BF to clear
		RET
	
	sendCharacter:
		SETB RS  		; setb RS - indicates that data is being sent to module
		MOV C, ACC.7		; |
		MOV P1.7, C			; |
		MOV C, ACC.6		; |
		MOV P1.6, C			; |
		MOV C, ACC.5		; |
		MOV P1.5, C			; |
		MOV C, ACC.4		; |
		MOV P1.4, C			; | high nibble set
	
		SETB EN			; |
		CLR EN			; | negative edge on E
	
		MOV C, ACC.3		; |
		MOV P1.7, C			; |
		MOV C, ACC.2		; |
		MOV P1.6, C			; |
		MOV C, ACC.1		; |
		MOV P1.5, C			; |
		MOV C, ACC.0		; |
		MOV P1.4, C			; | low nibble set
	
		SETB EN			; |
		CLR EN			; | negative edge on E
	
		CALL delay			; wait for BF to clear
		CALL delay			; wait for BF to clear
		RET
	posicionaCursor:
		CLR RS	
		SETB P1.7		    ; |
		MOV C, ACC.6		; |
		MOV P1.6, C			; |
		MOV C, ACC.5		; |
		MOV P1.5, C			; |
		MOV C, ACC.4		; |
		MOV P1.4, C			; | high nibble set
	
		SETB EN			; |
		CLR EN			; | negative edge on E
	
		MOV C, ACC.3		; |
		MOV P1.7, C			; |
		MOV C, ACC.2		; |
		MOV P1.6, C			; |
		MOV C, ACC.1		; |
		MOV P1.5, C			; |
		MOV C, ACC.0		; |
		MOV P1.4, C			; | low nibble set
	
		SETB EN			; |
		CLR EN			; | negative edge on E
	
		CALL delay			; wait for BF to clear
		CALL delay			; wait for BF to clear
		RET
	
	;Limpa o display
	clearDisplay:
		CLR RS	
		CLR P1.7		; |
		CLR P1.6		; |
		CLR P1.5		; |
		CLR P1.4		; | high nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		CLR P1.7		; |
		CLR P1.6		; |
		CLR P1.5		; |
		SETB P1.4		; | low nibble set
	
		SETB EN		; |
		CLR EN		; | negative edge on E
	
		CALL delay		; wait for BF to clear
		RET
	
	delay:
		MOV R7, #50
		DJNZ R7, $
		RET