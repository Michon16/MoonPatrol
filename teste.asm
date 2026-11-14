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
VER equ 0Ch
; MODOS
MODO_VIDEO equ 0013h
MODO_TEXTO equ 0003h

;; TESTES
LARG_CARINHA equ 8
ALT_CARINHA equ 8
DELTA_TIME equ 1

.model small

.stack 100h

.data
    tick_inicial dw 0
    voltas db 0
    pos_x dw 50
    pos_y dw 0

    txt_jogar db 'Jogar'
    TAM_JOGAR equ $ - txt_jogar

    txt_sair db 'Sair'
    TAM_SAIR equ $ - txt_sair

    carinha db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, PRE, PRE, AMA, AMA, PRE, PRE, AMA
            db AMA, PRE, PRE, AMA, AMA, PRE, PRE, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
            db AMA, AMA, PRE, AMA, AMA, PRE, AMA, AMA
            db AMA, AMA, AMA, PRE, PRE, AMA, AMA, AMA
            db AMA, AMA, AMA, AMA, AMA, AMA, AMA, AMA
.code

inicio:
    mov ax, @data
    mov ds, ax
    cld

    ; muda para modo de v¡deo
    mov ax, MODO_VIDEO
    int 10h

    mov ax, SEG_VIDEO
    mov es, ax

    ; ; desenha um pixel BRA
    ; mov di, 100*LARGURA+160
    ; mov al, BRA
    ; mov es:[di], al

    ; ; desenha uma linha amarela que atravessa a tela
    ; mov di, 150*LARGURA+0
    ; mov al, AMA
    ; mov CX, LARGURA*ALT_CHAO
    ; rep stosb

    ; ; desenha um retangulo branco
    ; mov bx, ALT_JIPE
    ; mov dx, LARG_JIPE
    ; mov di, 90*LARGURA+150
    ; mov al, BRA
    ; call DESENHAR_RETANGULO

    

    ; mov bx, ALT_CARINHA
    ; mov dx, LARG_CARINHA
    ; mov di, 50*LARGURA
    ; add di, pos_x
    ; mov si, offset carinha
    ; call DESENHAR_SPRITE

    ; mov voltas, 20

    ; laco:
    ;     mov bx, ALT_CARINHA
    ;     mov dx, LARG_CARINHA
    ;     mov di, 50*LARGURA
    ;     add di, pos_x 
    ;     mov si, offset carinha
    ;     call MOVER_DIREITA

    ;     inc pos_x

    ;     ; espera X ticks
    ;     mov bx, DELTA_TIME
    ;     call ESPERAR

    ;     dec voltas
    ;     jnz laco


    mov BP, offset txt_jogar
    mov CX, TAM_JOGAR
    mov DH, 12
    mov DL, 17
    mov BL, BRA
    call ESCREVER_TEXTO

    mov BP, offset txt_sair
    mov CX, TAM_SAIR
    mov DH, 14
    mov DL, 17
    mov BL, VER
    call ESCREVER_TEXTO
    
    ; espera uma tecla
    mov ah, 00h
    int 16h

    ; muda para modo texto
    mov ax, MODO_TEXTO
    int 10h

    mov ah, 4Ch
    mov al, 0
    int 21h

;-----------------------------------------------------------
; DESENHAR_SPRITE
; Fun‡?o:   DESENHA UM SPRITE NA TELA
; Entrada:  SI = SPRITE, DI = POSICAO, DX = LARGURA SPRITE, BX = ALTURA SPRITE
; Sa¡da:    BX = 0, CX = 0, DI e SI alterados
;-----------------------------------------------------------
DESENHAR_SPRITE proc
    desenhar_sprite:
        mov CX, dx
        rep movsb
        add di, LARGURA
        sub di, dx
        
        dec bx
        jnz desenhar_sprite

    ret
DESENHAR_SPRITE endp

;-----------------------------------------------------------
; DESENHAR_RETANGULO
; Fun‡?o:   DESENHA UM RETANGULO NA TELA
; Entrada:  AL = COR, DI = POSICAO, DX = LARGURA SPRITE, BX = ALTURA SPRITE
; Sa¡da:    CX = 0, BX = 0, DI alterado
;-----------------------------------------------------------
DESENHAR_RETANGULO proc
    desenhar_retangulo:
        mov CX, dx
        rep stosb
        add di, LARGURA
        sub di, dx

        dec bx
        jnz desenhar_retangulo
    
    ret
DESENHAR_RETANGULO endp

;-----------------------------------------------------------
; ESPERAR
; Fun‡?o:   ESPERA X TICKS
; Entrada:  BX = TICKS
; Sa¡da:    AX, DX, AH, CX alterados
;-----------------------------------------------------------
ESPERAR proc
    mov ah, 00h
    int 1Ah
    mov tick_inicial, dx

    esperar_rotina:
        mov ah, 00h
        int 1Ah
        mov ax, dx
        sub ax, tick_inicial

        cmp ax, bx
        jb esperar_rotina

    ret
ESPERAR endp

;-----------------------------------------------------------
; MOVER_DIREITA
; Fun‡?o:   MOVE SPRITE PARA DIREITA 1px
; Entrada:  BX = ALTURA, DX = LARGURA, DI = POSICAO, SI = SPRITE
; Sa¡da:    DI, SI, BX, CX e AL alterados
;-----------------------------------------------------------
MOVER_DIREITA proc
    push bx
    push dx
    push di

    ; apaga o sprite
    mov al, PRE
    call DESENHAR_RETANGULO

    pop di
    pop dx
    pop bx

    inc di

    call DESENHAR_SPRITE

    ret
MOVER_DIREITA endp

ESCREVER_TEXTO proc
    push es
    
    mov ax, ds
    mov es, ax

    mov AH, 13h
    mov AL, 01h
    mov BH, 0
    int 10h

    pop es
    ret
ESCREVER_TEXTO endp

end inicio