; ---------------------------------------------------------------
; teste.asm - Programa de teste do ambiente (pode apagar depois)
; Entra no modo 13h, desenha uma faixa amarela, escreve um texto,
; espera uma tecla e volta ao modo texto.
; ---------------------------------------------------------------
.model small
.stack 100h

.data
    msg     db 'Ambiente OK - aperte uma tecla'
    msg_tam equ $ - msg

.code
inicio:
    mov ax, @data
    mov ds, ax

    ; modo de video 13h (320x200, 256 cores)
    mov ax, 0013h
    int 10h

    ; faixa amarela (cor 0Eh) de 7 linhas a partir da linha 150
    mov ax, 0A000h
    mov es, ax
    mov di, 150*320
    mov al, 0Eh
    mov cx, 7*320
    rep stosb

    ; escreve o texto com INT 10h / 13h em verde-claro (0Ah)
    mov ax, ds
    mov es, ax
    mov bp, offset msg
    mov ax, 1301h
    mov bx, 000Ah
    mov cx, msg_tam
    mov dh, 10
    mov dl, 5
    int 10h

    ; espera uma tecla
    mov ah, 00h
    int 16h

    ; volta ao modo texto e encerra
    mov ax, 0003h
    int 10h
    mov ax, 4C00h
    int 21h
end inicio
