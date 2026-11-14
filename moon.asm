;; CONSTANTES GLOBAIS
; INFOS DO JOGO
DELTA_TIME equ 1
LARGURA equ 320
ALTURA equ 200
ALT_CHAO equ 7
LARG_JIPE equ 20
ALT_JIPE equ 10

; SEGMENTO DE VIDEO
SEG_VIDEO equ 0A000H

; CORES
AMARELO equ 0Eh
BRANCO equ 0Fh
PRETO equ 00H
VERMELHO equ 0Ch
VERDE_CLARO equ 0Ah

; MODOS
MODO_VIDEO equ 0013h
MODO_TEXTO equ 0003h

; MENU
LINHA_JOGAR equ 12
LINHAS_JOGAR equ 3
COLUNA_JOGAR equ 15

LINHA_SAIR equ 16
LINHAS_SAIR equ 3
COLUNA_SAIR equ 15

LINHA_TITULO equ 2
COLUNA_TITULO equ 4
LINHAS_TITULO equ 3

; TECLAS
TECLA_CIMA equ 48h
TECLA_BAIXO equ 50h
TECLA_ENTER equ 1Ch

; TESTES
LARG_CARINHA equ 8
ALT_CARINHA equ 8

.model small

.stack 100h

.data
    tick_inicial dw 0
    voltas db 0
    pos_x dw 50
    pos_y dw 0

    txt_jogar_topo  db 'ÚÄÄÄÄÄÄÄ¿'
    txt_jogar_meio  db '³ Jogar ³'
    txt_jogar_fim   db 'ÀÄÄÄÄÄÄÄÙ'
    TAM_JOGAR equ $ - txt_jogar_fim

    txt_sair_topo   db 'ÚÄÄÄÄÄÄÄ¿'
    txt_sair_meio   db '³ Sair  ³'
    txt_sair_fim    db 'ÀÄÄÄÄÄÄÄÙ'
    TAM_SAIR equ $ - txt_sair_fim

    txt_jogando db 'Jogando...'
    TAM_JOGANDO equ $ - txt_jogando

    titulo1 db  '                _                '
    TAM_TITULO equ $ - titulo1
    titulo2 db  '|V| _  _ __    |_) _ _|_ __ _  | '
    titulo3 db  '| |(_)(_)| |   |  (_| |_ | (_) | '      

    opcao db 0

    carinha db AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO
            db AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO
            db AMARELO, PRETO, PRETO, AMARELO, AMARELO, PRETO, PRETO, AMARELO
            db AMARELO, PRETO, PRETO, AMARELO, AMARELO, PRETO, PRETO, AMARELO
            db AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO
            db AMARELO, AMARELO, PRETO, AMARELO, AMARELO, PRETO, AMARELO, AMARELO
            db AMARELO, AMARELO, AMARELO, PRETO, PRETO, AMARELO, AMARELO, AMARELO
            db AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO

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

    ; escreve o t¡tulo do jogo
    mov BP, offset titulo1
    mov CX, TAM_TITULO
    mov DH, LINHA_TITULO
    mov DL, COLUNA_TITULO
    mov BL, VERDE_CLARO
    mov SI, LINHAS_TITULO
    call ESCREVER_LINHAS

    ; desenha carinha
    mov bx, ALT_CARINHA
    mov dx, LARG_CARINHA
    mov di, 50*LARGURA
    add di, pos_x
    mov si, offset carinha
    call DESENHAR_SPRITE

    desenha_menu:
        ; escreve JOGAR
        mov BP, offset txt_jogar_topo
        mov CX, TAM_JOGAR
        mov DH, LINHA_JOGAR
        mov DL, COLUNA_JOGAR
        mov BL, BRANCO
        mov SI, LINHAS_JOGAR
        
        cmp opcao, 0
        jne jogar_cor_ok
        mov BL, VERMELHO
        
        jogar_cor_ok:
            call ESCREVER_LINHAS

        ; escreve SAIR
        mov BP, offset txt_sair_topo
        mov CX, TAM_SAIR
        mov DH, LINHA_SAIR
        mov DL, COLUNA_SAIR
        mov BL, BRANCO
        mov SI, LINHAS_SAIR

        cmp opcao, 1
        jne sair_cor_ok
        mov BL, VERMELHO
        
        sair_cor_ok:
            call ESCREVER_LINHAS

    laco_menu:
        ; faz carinha passar para o lado
        mov bx, ALT_CARINHA
        mov dx, LARG_CARINHA
        mov di, 50*LARGURA
        add di, pos_x 
        mov si, offset carinha
        call MOVER_DIREITA

        inc pos_x

        ; espera X ticks
        mov bx, DELTA_TIME
        call ESPERAR

        ; verifica se tem tecla
        mov ah, 01h
        int 16h
        jz nao_tem_tecla
        
        ; pega a tecla
        mov ah, 00h
        int 16h

        cmp ah, TECLA_CIMA
        je press_cima
        cmp ah, TECLA_BAIXO
        je press_baixo
        cmp ah, TECLA_ENTER
        je press_enter
        jmp laco_menu

        press_cima:
            mov opcao, 0
            jmp desenha_menu
        press_baixo:
            mov opcao, 1
            jmp desenha_menu
        press_enter:
            cmp opcao, 0
            je laco_jogo
            cmp opcao, 1
            je encerra

        nao_tem_tecla:
            jmp laco_menu

    laco_jogo:
        ; limpa a tela
        mov al, PRETO
        call LIMPA_TELA

        ; escreve jogando...
        mov BP, offset txt_jogando
        mov CX, TAM_JOGANDO
        mov DH, 12
        mov DL, 15
        mov BL, BRANCO
        call ESCREVER_TEXTO

        ; espera uma tecla
        mov ah, 00h
        int 16h

    encerra:
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
    mov al, PRETO
    call DESENHAR_RETANGULO

    pop di
    pop dx
    pop bx

    inc di

    call DESENHAR_SPRITE

    ret
MOVER_DIREITA endp

;-----------------------------------------------------------
; ESCREVER_TEXTO
; Fun‡?o:   ESCREVE TEXTO NA TELA
; Entrada:  BP = ENDERE€O TEXTO, CX = TAMANHO, DH = LINHA, DL = COLUNA, BL = COR
; Sa¡da:    AX, AH, AL, BH alterados
;-----------------------------------------------------------
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

;-----------------------------------------------------------
; LIMPA_TELA
; Fun‡?o:   PINTA A TELA TODA DE PRETO
; Entrada:  AL = COR
; Sa¡da:    CX = 0, DI alterado
;-----------------------------------------------------------
LIMPA_TELA proc
    mov di, 0*LARGURA+0
    mov cx, LARGURA*ALTURA
    rep stosb
    ret
LIMPA_TELA endp

;-----------------------------------------------------------
; ESCREVER_LINHAS
; Fun‡?o:   ESCREVE TEXTO COM MAIS DE UMA LINHA NA TELA
; Entrada:  BP = ENDERE€O TEXTO, CX = TAMANHO, DH = LINHA, DL = COLUNA, BL = COR, SI = LINHAS
; Sa¡da:    AX, AH, AL, BH, BP, SI, DH alterados
;-----------------------------------------------------------
ESCREVER_LINHAS proc
    laco_escrever:
        call ESCREVER_TEXTO
        add BP, CX
        inc DH

        dec SI
        jnz laco_escrever
    ret
ESCREVER_LINHAS endp
    
end inicio