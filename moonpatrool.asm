;; CONSTANTES GLOBAIS
; INFOS DO JOGO
LARGURA equ 320
ALTURA equ 200
ALT_CHAO equ 7
LARG_JIPE equ 20
ALT_JIPE equ 10
; SEGMENTO DE VIDEO
SEG_VIDEO equ 0A000H
; CORES
AMA equ 0Eh
BRA equ 0Fh
PRE equ 00H
; MODOS
MODO_VIDEO equ 0013h
MODO_TEXTO equ 0003h

;; TESTES
LARG_CARINHA equ 8
ALT_CARINHA equ 8

.model small

.stack 100h

.data
    carinha db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, PRE, PRE, AMA, AMA, PRE, PRE, AMA
            db AMA, PRE, PRE, AMA, AMA, PRE, PRE, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, AMA, PRE, AMA, AMA, PRE, AMA, AMA
            db AMA, AMA, AMA, PRE, PRE, AMA, AMA, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
.code

;-----------------------------------------------------------
; DESENHA_SPRITE
; Fun‡?o:   ...
; Entrada:  SI = ..., DI = ..., DX = ..., BX = ...
; Sa¡da:    ...
;-----------------------------------------------------------

inicio:
    mov ax, @data
    mov ds, ax
    cld

    ; muda para modo de v¡deo
    mov ax, MODO_VIDEO
    int 10h

    ; pinta um pixel BRA
    mov ax, SEG_VIDEO
    mov es, ax
    mov di, 100*LARGURA+160
    mov al, BRA
    mov es:[di], al

    ; pinta uma linha amarela que atravessa a tela
    mov di, 150*LARGURA+0
    mov al, AMA
    mov cx, LARGURA*ALT_CHAO
    rep stosb
    

    ; pinta um retangulo BRA de 20x10 pixels (jipe)
    mov bx, ALT_JIPE
    mov di, 90*LARGURA+150
    mov al, BRA

    desenha_jipe:
        mov cx, LARG_JIPE
        rep stosb
        add di, LARGURA-LARG_JIPE

        dec bx
        jnz desenha_jipe

    mov bx, ALT_CARINHA
    mov di, 20*LARGURA+156
    mov si, offset carinha
    desenha_carinha:
        mov cx, LARG_CARINHA
        rep movsb
        add di, LARGURA-LARG_CARINHA
        
        dec bx
        jnz desenha_carinha

    ; espera uma tecla
    mov ah, 00h
    int 16h

    ; muda para modo texto
    mov ax, MODO_TEXTO
    int 10h

    mov ah, 4Ch
    mov al, 0
    int 21h
end inicio

