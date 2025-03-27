ORG 0          ; Endereço da primeira instrução
JMP INICIO     ; Jump para o início do código

; -------- ROTINAS DE INTERRUPÇÃO ----------- 
ORG 000Bh      ; Endereço da interrupção do Timer 0
JMP TIMERSEC   ; Jump para a rotina de interrupção do Timer 0

; -------------------------------------------

; R0 = registrador utilizado para contar quando bater um segundo
; R1 = Registrador para identificar qual estado está para retornar (1= Verde, 2=Amarelo, 3=Vermelho)
; 

TIMERSEC:
    MOV TH0, #11111110b   ; Recarrega TH0 com 0x3C (parte alta de 15536)
    MOV TL0, #00001100b   ; Recarrega TL0 com 0xB0 (parte baixa de 15536)
    CLR TF0          ; Limpa o bit de overflow
    INC R0           ; Incrementa R0
    RETI             ; Retorna da interrupção

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
    JMP AMARELO            ; Vai para o próximo número

INICIO:
    MOV IE, #10000010b ; Habilita interrupções (EA) e interrupção do Timer 0 (ET0)
    MOV TH0, #11111110b     ; Configura TH0 com 0x3C (parte alta de 15536)
    MOV TL0, #00001100b    ; Configura TL0 com 0xB0 (parte baixa de 15536)
    MOV TMOD, #00000001b ; Configura o Timer 0 no Modo 1 (16 bits)
    MOV TCON, #00010000b ; Liga o Timer 0 (TR0 = 1)

AMARELO: 
	MOV P2 , #00000000b  
	JMP QUINZE  


END
