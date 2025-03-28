	ORG 0          ; Endereço da primeira instrução
	AJMP INICIO     ; Jump para o início do código

; -------- ROTINAS DE INTERRUPÇÃO ----------- 

	ORG 0003h ;Endereço da interrupção INT0, que ocorre no pino 3.2
	JMP EMERGENCIA ;Jump para a rotina de interrupção externa do INT0
	ORG 000Bh      ; Endereço da interrupção do Timer 0
	JMP TIMERSEC   ; Jump para a rotina de interrupção do Timer 0
	ORG 0013h ;Endereço da interrupção INT1, que ocorre no pino 3.1
	JMP BOTAO
	
; -------------------------------------------

; R0 = registrador utilizado para contar quando bater um segundo
; R1 = Registrador para identificar qual estado está para retornar (1= Verde, 2=Amarelo, 3=Vermelho)
; R2 = Registrador para indicar flag estado de Emergência (0 = Sem Emergência, 1 = Com Emergência)
; R3 = Registrador para guardar a contagem de carros passando pelo sinal verde 
;

TIMERSEC:
    	MOV TH0, #11111110b   ; Recarrega TH0 com 0x3C (parte alta de 15536)
    	MOV TL0, #00111111b   ; Recarrega TL0 com 0xB0 (parte baixa de 15536)
    	CLR TF0          ; Limpa o bit de overflow
    	INC R0           ; Incrementa R0
    	RETI             ; Retorna da interrupção

EMERGENCIA: 
	MOV R2, #1 ; Ativando a flag de Emergência
	MOV P2 , #11111011b ; Liga o led Vermelho
	MOV IE, #10000011b ; Habilita interrupções (EA) 
   			   ; interrupção do Timer 0 (ET0), interrupção externa (INT0)
	MOV TH0, #11111110b     ; Configura TH0 com 0x3C (parte alta de 15536)
	MOV TL0, #00111111b    ; Configura TL0 com 0xB0 (parte baixa de 15536)
	MOV TMOD, #00000001b ; Configura o Timer 0 no Modo 1 (16 bits)
	MOV TCON, #00010001b ; Liga o Timer 0 (TR0 = 1), habilita interrupção externa por borda no INT0
	JMP QUINZE ;Jump para começar a contagem 

BOTAO:
	INC R3
	RETI

QUINZE:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10010010b ; Exibe "5" no display
	CJNE R0, #1, QUINZE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

CATORZE:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10011001b ; Exibe "4" no display
	CJNE R0, #1, CATORZE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

TREZE:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10110000b ; Exibe "3" no display
	CJNE R0, #1, TREZE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

DOZE:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #10100100b ; Exibe "2" no display
	CJNE R0, #1, DOZE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

ONZE:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #11111001b ; Exibe "1" no display
	CJNE R0, #1, ONZE   ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

DEZ:
	MOV P1, #11111001b ; Exibe "1" no display
	MOV P0, #11000000b ; Exibe "0" no display
	CJNE R0, #1, DEZ ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

NOVE:
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10010000b ; Exibe "9" no display
	CJNE R0, #1, NOVE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

OITO:
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10000000b ; Exibe "8" no display
	CJNE R0, #1, OITO ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

SETE:
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #11111000b ; Exibe "7" no display
	CJNE R0, #1, SETE ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

SEIS:
	MOV P1, #11000000b ; Exibe "0" no display
	MOV P0, #10000010b ; Exibe "6" no display
	CJNE R0, #1, SEIS ; Espera R0 atingir 20
	MOV R0, #0         ; Zera R0

CINCO:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #10010010b ; Exibe "5" no display
	 CJNE R0, #1, CINCO ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0

QUATRO:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #10011001b ; Exibe "4" no display
	 CJNE R0, #1, QUATRO ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0

TRES:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #10110000b ; Exibe "3" no display
	 CJNE R0, #1, TRES ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0

DOIS:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #10100100b ; Exibe "2" no display
	 CJNE R0, #1, DOIS ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0

UM:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #11111001b ; Exibe "1" no display
	 CJNE R0, #1, UM   ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0

ZERO:
	 MOV P1, #11000000b ; Exibe "0" no display
	 MOV P0, #11000000b ; Exibe "0" no display
	 CJNE R0, #1, ZERO ; Espera R0 atingir 20
	 MOV R0, #0         ; Zera R0
	 CJNE R2, #0, PROXIMO_ESTADO ; Caso uma emergência tenha occorido, ele volta para o estado anterior
	 JMP AMARELO   ; Vai para o estado AMARELO

PROXIMO_ESTADO: 
	MOV R2, #0 ;Zerando a flag de emergência 
	CJNE R1, #1, AMARELO_ANTERIOR; Caso não seja estado Verde Verifica se é amarelo 
	JMP VERDE ;Caso seja vermelho Volta para o estado Inicial de Vermelho 
AMARELO_ANTERIOR: 
	CJNE R1, #2, VERDE ;Caso não seja estado Amarelo, é o estado Verde 
	JMP VERMELHO ;Vai para o estado Amarelo

INICIO:
	MOV IE, #10000111b ; Habilita interrupções (EA) 
   			; interrupção do Timer 0 (ET0), interrupção externa (INT0)
	MOV IP, #00000101b ;Configura a prioridade do INT0 e INT1 acima do TIMER1
	MOV TH0, #11111110b     ; Configura TH0 com 0x3C (parte alta de 15536)
	MOV TL0, #00111111b    ; Configura TL0 com 0xB0 (parte baixa de 15536)
	MOV TMOD, #00000001b ; Configura o Timer 0 no Modo 1 (16 bits)
	MOV TCON, #00010101b ; Liga o Timer 0 (TR0 = 1), habilita interrupção externa por borda no INT0 e INT1

VERDE:
	MOV R1, #1 ; Indicar que está no estado Verde
	MOV R3, #0 ; Inicializa o contador de carros
	MOV P2, #11111110b ;Ligar o led verde
	JMP DEZ	;Jump para iniciar a contagem de dez segundos do Estado Verde
	CJNE R3, #5, AMARELO ; Se o número de carros não tiver alcançado 5 continua pro amarelo

	MOV R3, #0 ;Zera o contador de carros
	JMP CINCO ; Aumenta duração do sinal verde
	JMP AMARELO ; Vai para o estado amarelo

AMARELO: 
	MOV R1, #2 ;Indicar que está no estado Amarelo 
	MOV P2 , #11111101b ; Ligar o led amarelo
	JMP TRES  ;Jump para Iniciar a contagem do Estado Amarelo

VERMELHO:

END
