org 100h

;============================================================================;
;LEITURA DO PRIMEIRO LADO

MOV ah, 09h
LEA dx, msg1
INT 21h
CALL SCAN_NUM
MOV bx, cx
          
putc 0Dh      ; pular linha
putc 0Ah      ; pular linha            

;============================================================================;
;LEITURA DO SEGUNDO LADO

MOV ah, 09h
LEA dx, msg2 
INT 21h
CALL SCAN_NUM
MOV si, cx
          
putc 0Dh      ; pular linha
putc 0Ah      ; pular linha            

;============================================================================;
;LEITURA DO TERCEIRO LADO
MOV ah, 09h              

LEA dx, msg3
INT 21h
CALL SCAN_NUM
MOV di, cx
         
putc 0Dh      ; pular linha
putc 0Ah      ; pular linha            

;============================================================================;
;CHAMADA DO PROCEDIMENTO E RETORNO


PUSH bx             
PUSH si             
PUSH di

           
CALL F_FORMATRIANGULO


CMP [return], 1    
JE formaTriangulo        
JMP naoTriangulo  

formaTriangulo:
    MOV ah, 09h
    LEA dx, msg4   
    INT 21h
    JMP fim        

naoTriangulo:
    MOV ah, 09h
    LEA dx, msg5   
    INT 21h

fim:
    RET

;============================================================================;
;PROCEDIMENTO F_FORMATRIANGULO 
F_FORMATRIANGULO PROC
    
    POP bp          ; registrador pra salvar o endereco do retorno que o procedimento der
    POP bx         
    POP si          
    POP di          

    
    MOV ax, si      ; coloca em ax valor de y
    ADD ax, di      ; adiciona o valor de z em ax (ja fica com a soma y + z)
    CMP bx, ax      ; if x < y e z (que estao em ax)
    JGE naoForma    ; se for maior, nao forma (0)

    MOV ax, bx      ; coloca o valor de x em ax
    ADD ax, di      ; adiciona o valor de z em ax (ja fica com a soma de x + z)
    CMP si, ax      ; if y < x e z
    JGE naoForma    ; se for maior, nao forma (0)

    MOV ax, bx      ; coloca o valor de x em ax
    ADD ax, si      ; coloca o valor de y em ax (ja fica com a soma de x + y)
    CMP di, ax      ; if z < x e y 
    JGE naoForma    ; se for maior, nao forma (0)

    MOV [return], 1 ; se nao der nenhum jump, chega aqui e retorna que forma triangulo (1)
    PUSH bp         ; endereco de retorno pra pilha
    RET             ; retorno do procedimento (1)

naoForma:
    MOV [return], 0 ; nao forma triangulo
    PUSH bp         ; endereco de retorno pra pilha
    RET             ; retorno do procedimento (0)

F_FORMATRIANGULO ENDP

;============================================================================;
;DECLARACAO DE VARIAVEIS 
return dw ?
msg1 db "Digite o valor do lado X: $"
msg2 db "Digite o valor do lado Y: $"
msg3 db "Digite o valor do lado Z: $"
msg4 db "Os lados X, Y e Z formam um triangulo.$"
msg5 db "Os lados X, Y e Z nao formam um triangulo.$"
ten dw 10  ; variavel pra funcao propria do emulador 
                                                    
                                                    
;============================================================================;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM
; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0
        ; reset flag:
        MOV     CS:make_minus, 0
next_digit:
        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h
        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus
        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:

        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:

        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:

        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX
        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big
        ; convert from ASCII code:
        SUB     AL, 30h
        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.
        JMP     next_digit
set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit
too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:
        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP                             
; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX
        CMP     AX, 0
        JNZ     not_zero
        PUTC    '0'
        JMP     printed
not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX
        PUTC    '-'
positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP
; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        ; flag to prevent printing zeros before number:
        MOV     CX, 1
        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.
        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero
begin_print:
        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print
        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.
        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).
        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL

        MOV     AX, DX  ; get remainder from last div.
skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX
        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP