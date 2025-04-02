    ORG 0          ; Endereço da primeira instrução
    AJMP INICIO     ; Jump para o início do código

; -------- ROTINAS DE INTERRUPÇÃO ----------- 
    ORG 0003h       ; Endereço da interrupção INT0 (pino 3.2)
    JMP EMERGENCIA  ; Rotina de emergência
    ORG 000Bh       ; Endereço da interrupção do Timer 0
    JMP TIMERSEC    ; Rotina do timer
    ORG 0013h 	    ; Endereço da interrupção INT1 (pino 3.3)
    JMP BOTAO        ; Rotina da contagem de veiculos
; -------------------------------------------

; Variáveis:
; R0 = Contador de segundos
; R1 = Estado atual (1=Verde, 2=Amarelo, 3=Vermelho)
; R2 = Controle de emergência (0=normal, 1=emergência ativa)
; R3 = Estado salvo antes da emergência
; R4 = Contador de emergência (15s)
; R5 = R3 = Indicar a flag de verde mais 
; R6 = R2 = Indicar número de veiculos

BOTAO: 
    INC R6 ;incrementa o contador de veículos 
    MOV     A, R6      ; Move o valor de R6 ara o acumulador
    CLR     C           ; Limpa o carry antes da subtração
    SUBB    A, #6       ; Subtrai 6 do valor (pois se for maior que 5, A será >=0 após SUBB #6)
    JC      MENOR_IGUAL ; Se carry=1, significa que R0 < 6 (ou seja, R0 <=5)
   ; Se chegou aqui, R6 > 5
    CJNE R5, #0,  MENOR_IGUAL ;Segue o fluxo normal com a flag ativada
    MOV R5, #1 ;Ativa flag de aumento de tempo do sinal verde
    MOV     R0, #15 ; Seta os segundos para 15  
    RETI
MENOR_IGUAL:
    RETI

TIMERSEC:
    MOV IE, #00000011b  ; Desabilita interrupções
    MOV TH0, #11111111b      ; Recarrega timer
    MOV TL0, #11000000b 
    CLR TF0
    
    CJNE R2, #1, CONTADOR_NORMAL  ; Se não está em emergência
    
    ; Lógica de contagem de emergência
    DJNZ R4, FIM_TIMER            ; Decrementa contador de emergência
    MOV R2, #0                    ; Finaliza emergência
    
    ; Restaura estado anterior com contagem completa
    MOV A, R3
    MOV R1, A                    ; Restaura estado anterior
    
    ; Configura contagem inicial conforme estado
    CJNE R3, #1, CHECK_AMARELO_RESTORE
    ; Estado Verde
    MOV R0, #10                   ; 15 segundos
    SJMP FIM_TIMER
    
CHECK_AMARELO_RESTORE:
    CJNE R3, #1, VERDE_RESTORE
    ; Estado Verde
    MOV R0, #10                    ; 10 segundos
    SJMP FIM_TIMER

VERDE_RESTORE:
    CJNE R3, #2, VERMELHO_RESTORE
    ; Estado Amarelo (volta com 3s)
    MOV R0, #3                   ;  3 segundos
    SJMP FIM_TIMER

VERMELHO_RESTORE:
    ; Estado Vermelho
    MOV R0, #7                   ; 15 segundos
    SJMP FIM_TIMER

CONTADOR_NORMAL:
    DJNZ R0, FIM_TIMER            ; Decrementa contador normal
    
    ; Transição de estados normais
    CJNE R1, #1, CHECK_AMARELO
    ; Verde -> Amarelo
    MOV R1, #2
    MOV R0, #3
    SJMP FIM_TIMER
    
CHECK_AMARELO:
    CJNE R1, #2, CHECK_VERMELHO
    ; Amarelo -> Vermelho
    MOV R1, #3
    MOV R0, #7
    SJMP FIM_TIMER
    
CHECK_VERMELHO:
    ; Vermelho -> Verde
    MOV R1, #1
    MOV R0, #10

FIM_TIMER:
    MOV IE, #10000011b  ; Reabilita interrupções
    RETI

EMERGENCIA: 
    MOV R2, #1          ; Ativa emergência
    MOV A, R1
    MOV R3, A          ; Salva estado atual
    MOV R4, #15         ; Configura 15s de emergência
    MOV R5, #0 		;Zera flag de passagem de veículos
    MOV P2, #11111011b  ; Acende vermelho
    RETI

; Rotina para exibir contagem no display
ATUALIZA_DISPLAY:
    ; Verifica se está em modo de emergência
    CJNE R2, #1, MODO_NORMAL
    
    ; MODO EMERGÊNCIA - usa R4 como contador
    MOV A, R4
    SJMP EXIBE_NUMERO
    
MODO_NORMAL:
    ; MODO NORMAL - usa R0 como contador
    MOV A, R0

EXIBE_NUMERO:
    ; A partir deste ponto, a lógica é a mesma para ambos os modos
    ; O valor a ser exibido está no acumulador (A)
    
    CJNE A, #15, DISP_14
    MOV P1, #11111001b ; Exibe "1"
    MOV P0, #10010010b ; Exibe "5"
    RET
    
DISP_14:
    CJNE A, #14, DISP_13
    MOV P1, #11111001b ; "1"
    MOV P0, #10011001b ; "4"
    RET
    
DISP_13: 
    CJNE A, #13, DISP_12
    MOV P1, #11111001b ; "1" 
    MOV P0, #10110000b ; "3" 
    RET

DISP_12:
    CJNE A, #12, DISP_11
    MOV P1, #11111001b ; "1" 
    MOV P0, #10100100b ; "2" 
    RET

DISP_11:
    CJNE A, #11, DISP_10
    MOV P1, #11111001b ; "1" 
    MOV P0, #11111001b ; "1" 
    RET

DISP_10:
    CJNE A, #10, DISP_9
    MOV P1, #11111001b ; "1" 
    MOV P0, #11000000b ; "0" 
    RET

DISP_9:
    CJNE A, #9, DISP_8
    MOV P1, #11000000b ; "0" 
    MOV P0, #10010000b ; "9" 
    RET
    
DISP_8:
    CJNE A, #8, DISP_7
    MOV P1, #11000000b ; "0" 
    MOV P0, #10000000b ; "8" 
    RET

DISP_7:
    CJNE A, #7, DISP_6
    MOV P1, #11000000b ; "0" 
    MOV P0, #11111000b ; "7" 
    RET

DISP_6:
    CJNE A, #6, DISP_5
    MOV P1, #11000000b ; "0" 
    MOV P0, #10000010b ; "6" 
    RET
    
DISP_5:
    CJNE A, #5, DISP_4 
    MOV P1, #11000000b ; "0" 
    MOV P0, #10010010b ; "5" 
    RET

DISP_4:
    CJNE A, #4, DISP_3
    MOV P1, #11000000b ; "0" 
    MOV P0, #10011001b ; "4" 
    RET

DISP_3:
    CJNE A, #3, DISP_2
    MOV P1, #11000000b ; Exibe "0" no display
    MOV P0, #10110000b ; Exibe "3" no display
    RET

DISP_2:
    CJNE A, #2, DISP_1
    MOV P1, #11000000b ; Exibe "0" no display
    MOV P0, #10100100b ; Exibe "2" no display
    RET

DISP_1: 
    CJNE A, #1, DISP_0
    MOV P1, #11000000b ; Exibe "0" no display
    MOV P0, #11111001b ; Exibe "1" no display
    RET

DISP_0:
    MOV P1, #11000000b ; "0"
    MOV P0, #11000000b ; "0"
    RET

; Rotina principal
INICIO:
    MOV IE, #10000011b  ; Habilita interrupções INT0, TIMER0 
    MOV TMOD, #00000001b ; Timer modo 1
    MOV TH0, #11111111b       ; Valor inicial do timer
    MOV TL0, #11000000b ;
    MOV IP, #00000101b; Configura prioridade de INT0 e INT1 acima de TIMER0
    MOV TCON, #00010101b ; Habilita interrupção externa do INT0 e do INT1 e liga o TIMER0
    
    ; Estado inicial
    MOV R1, #1          ; Verde
    MOV R0, #10         ; 10 segundos
    MOV R2, #0          ; Sem emergência
    MOV P2, #11111110b  ; Acende verde

MAIN_LOOP:
    LCALL ATUALIZA_DISPLAY
    
    ; O resto do código permanece igual
    CJNE R2, #1, LEDS_NORMAIS
    ; Modo emergência - vermelho constante
    MOV P2, #11111011b
    SJMP MAIN_LOOP

MOSTRA_NORMAL:
    MOV A, R0
    LCALL ATUALIZA_DISPLAY

CONTROLA_LEDS:
    CJNE R2, #1, LEDS_NORMAIS
    ; Modo emergência - vermelho constante
    MOV P2, #11111011b
    SJMP MAIN_LOOP

LEDS_NORMAIS:
    CJNE R1, #1, CHECK_AMARELO_LED
    ; Verde
    MOV IE, #10000111b ;Habilita a interrupção do INT1
    MOV P2, #11111110b ; Liga o led Verde
    MOV     A, R6      ; Move o valor de R6 ara o acumulador
    CLR     C           ; Limpa o carry antes da subtração
    SUBB    A, #6       ; Subtrai 6 do valor (pois se for maior que 5, A será >=0 após SUBB #6)
    JC      MENOR_IGUAL_ ; Se carry=1, significa que R0 < 6 (ou seja, R0 <=5)
   ; Se chegou aqui, R6 > 5
    CJNE R5, #0,  MENOR_IGUAL_ ;Segue o fluxo normal com a flag ativada
    MOV R5, #1 ;Ativa flag de aumento de tempo do sinal verde
    MOV     R0, #15 ; Seta os segundos para 15  
    SJMP MAIN_LOOP
MENOR_IGUAL_:
    SJMP MAIN_LOOP
    
CHECK_AMARELO_LED:
    MOV IE, #10000011b ;Desabilita a interrupção do INT1
    MOV R6, #0 ;Zera quantidade de veículos que passou
    MOV R5, #0 ;Zera flag de quantidade passagem de veículos
    CJNE R1, #2, VERMELHO_LED
    ; Amarelo
    MOV P2, #11111101b
    SJMP MAIN_LOOP
    
VERMELHO_LED:
    ; Vermelho
    MOV P2, #11111011b
    SJMP MAIN_LOOP

END


