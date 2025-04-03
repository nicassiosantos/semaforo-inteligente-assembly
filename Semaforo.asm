	ORG 0          ; Endereço da primeira instrução
	AJMP INICIO     ; Jump para o início do código

; -------- ROTINAS DE INTERRUPÇÃO ----------- 

	ORG 0003h ;Endereço da interrupção INT0 para Emergência, que ocorre no pino 3.2
	JMP EMERGENCIA ;Jump para a rotina de interrupção externa do INT0
	ORG 000Bh      ; Endereço da interrupção do Timer 0
	JMP TIMERSEC   ; Jump para a rotina de interrupção do Timer 0
	ORG 0013h ;Endereço da interrupção INT1 para o botão da contagem de veículos, que ocorre no pino 3.1
	JMP BOTAO
	
; -------------------------------------------

; R0 = registrador utilizado para contar quando bater um segundo
; R1 = Registrador para identificar qual estado está para retornar (1= Verde, 2=Amarelo, 3=Vermelho)
; R2 = Registrador para guardar a contagem de carros passando pelo sinal verde
; R3 = Registrador para indicar flag de verde mais
; R4 = Registrador para indicar flag emergencia
; R5 = Registrador para contar os segundos restantes

TIMERSEC:
    	MOV TH0, #11111111b   ; Recarrega TH0 com 0x3C (parte alta de 15536)
    	MOV TL0, #11000000b   ; Recarrega TL0 com 0xB0 (parte baixa de 15536)
    	CLR TF0          ; Limpa o bit de overflow
    	INC R0           ; Incrementa R0
    	RETI             ; Retorna da interrupção

; --- INTERRUPÇÃO DE EMERGÊNCIA ---
EMERGENCIA:
	MOV R4, #00000001b     ; Ativa flag em R4.0 (emergência=1)
	MOV R1, #00000011b     ; Estado vermelho (3)
	MOV R5, #00001111b     ; Tempo: 15 segundos (15)
	MOV P2, #11111011b     ; Liga LED vermelho (P2.2=0)
	RETI

BOTAO:
	MOV A, R1 ; Move o valor do registrador de estado para A
	CJNE A, #3, INCREMENTA ; Verifica se não está no estado vermelho
	SJMP FIM_BOTAO ; Se estiver no vermelho não incrementa
INCREMENTA:
	INC R2            ; Incrementa contador de veículos
FIM_BOTAO:
	RETI

; --- Rotina para Aguardar Tempo ---
AGUARDA_TEMPO:
    MOV R0, #0        ; Zera contador de ciclos
AGUARDA_LOOP:
	MOV A, R5
	DEC A
	MOV R5, A
	JZ FIM_AGUARDA    ; Se tempo acabou, sai
	
	; Chama rotina de display conforme o tempo
	MOV A, R5
	CJNE A, #15, CATORZE
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10010010b ; Exibe "5" no display
	MOV R0, #00000000b ; Zera contador de ciclos
	SJMP AGUARDA_LOOP

FIM_AGUARDA:
	RET

CATORZE:
	CJNE A, #14, TREZE
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10011001b ; Exibe "4" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

TREZE:
	CJNE A, #13, DOZE
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10110000b ; Exibe "3" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

DOZE:
	CJNE A, #12, ONZE
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10100100b ; Exibe "2" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

ONZE:
	CJNE A, #11, DEZ
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #11111001b ; Exibe "1" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

DEZ:
	CJNE A, #10, NOVE
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #11000000b ; Exibe "0" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

NOVE:
	CJNE A, #9, OITO
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10010000b ; Exibe "9" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

OITO:
	CJNE A, #8, SETE
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10000000b ; Exibe "8" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

SETE:
	CJNE A, #7, SEIS
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #11111000b ; Exibe "7" no display
	MOV R0, #00000000b
	SJMP AGUARDA_LOOP

SEIS:
	CJNE A, #6, CINCO
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10000010b ; Exibe "6" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

CINCO:
	CJNE A, #5, QUATRO
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10010010b ; Exibe "5" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

QUATRO:
	CJNE A, #4, TRES
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10011001b ; Exibe "4" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

TRES:
	CJNE A, #3, DOIS
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10110000b ; Exibe "3" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

DOIS:
	CJNE A, #2, UM
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10100100b ; Exibe "2" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

UM:
	CJNE A, #1, ZERO
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #11111001b ; Exibe "1" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP
	
ZERO:
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #11000000b ; Exibe "0" no display
	MOV R0, #00000000b
	AJMP AGUARDA_LOOP

INICIO:
	MOV IE, #10000111b ; Habilita interrupções (EA) 
   			; interrupção do Timer 0 (ET0), interrupção externa (INT0)
	MOV IP, #00000101b ;Configura a prioridade do INT0 e INT1 acima do TIMER1
	MOV TH0, #11111110b     ; Configura TH0 com 0x3C (parte alta de 15536)
	MOV TL0, #00111111b    ; Configura TL0 com 0xB0 (parte baixa de 15536)
	MOV TMOD, #00000001b ; Configura o Timer 0 no Modo 1 (16 bits)
	MOV TCON, #00010101b ; Liga o Timer 0 (TR0 = 1), habilita interrupção externa por borda no INT0 e INT1

	; Inicialização de registradores
	MOV R0, #00000000b  ; Zera contador de ciclos
	MOV R1, #00000001b  ; Estado inicial: verde (1 em binário)
	MOV R2, #00000000b  ; Zera contador de veículos
	MOV R3, #00000000b  ; Zera flag de verde estendido

MAIN_LOOP:
	; Verifica emergência no registrador R4
	MOV A, R4
	ANL A, #00000001b        ; Isola o bit 0 (R4.0)
	JNZ INICIA_EMERGENCIA     ; Se emergência ativa

	; Lógica normal de estados
	MOV A, R1
	CJNE A, #00000001b, VERIFICA_AMARELO
	LJMP VERDE

VERIFICA_AMARELO:
	CJNE A, #00000010b, VERMELHO  ; Se não for amarelo vai pro vermelho
	JMP AMARELO     ; Se for amarelo, vai pro amarelo

VERDE:
	MOV P2, #11111110b ;Ligar o led verde
	MOV R1, #1 ; Indicar que está no estado Verde
	MOV R2, #0 ; Inicializa o contador de carros
	MOV A, R3 ; Verifica se está no verde mais
	ANL A, #00000001b   ; Verifica bit 0 do R3
	JZ VERDE_NORMAL     ; Se não estiver setado, tempo normal
	MOV R5, #00001111b  ; Verde estendido (15 segundos)
	SJMP INICIA_CONTAGEM

VERDE_NORMAL:
	MOV R5, #00001010b  ; Verde normal (10 segundos)
INICIA_CONTAGEM:
	CALL AGUARDA_TEMPO  ; Aguarda tempo configurado
	MOV A, R2
	CJNE A, #00000101b, PROXIMO_ESTADO ; Verifica se o contador está em 5 veículos
	MOV R3, #00000001b	; Ativa flag de verde mais para próxima vez
PROXIMO_ESTADO:
	MOV R1, #2  ; Muda para estado amarelo
	JMP MAIN_LOOP

AMARELO: 
	MOV P2 , #11111101b ; Ligar o led amarelo
	MOV R5, #00000011b    ; Configura 3 segundos
	CALL AGUARDA_TEMPO    ; Aguarda o tempo

	MOV R1, #00000011b    ; Próximo estado: vermelho (3)
	JMP MAIN_LOOP

VERMELHO:
	MOV P2, #11111011b    ; Liga LED vermelho
	MOV R5, #00000111b    ; Configura 7 segundos
	CALL AGUARDA_TEMPO    ; Aguarda o tempo

	MOV R3, #00000000b	; Reseta flag de verde mais
	MOV R1, #00000001b    ; Próximo estado: verde (1)
	JMP MAIN_LOOP

INICIA_EMERGENCIA:
	MOV R5, #15
	CALL AGUARDA_TEMPO
	MOV R3, #00000000b
	MOV R4, #00000000b
	JMP MAIN_LOOP

END
