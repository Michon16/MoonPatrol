# Plano — Moon Patrol em Assembly 8086

Marque `[x]` quando terminar cada passo. Cada um gera algo visível: rode e confira antes de seguir.

## Fase 0 — Fundamentos
- [x] 1. Esqueleto do programa: abrir, rodar e voltar ao DOS
- [x] 2. Fazer a tela 320x200 aparecer (modo 13h) e voltar ao modo texto
- [x] 3. Pintar UM pixel numa posição (x, y)
- [x] 4. Pintar uma linha e um retângulo (`rep stosb`)
- [x] 5. Criar as constantes (`equ`) do jogo

## Fase 1 — Sprites (o coração do jogo)
- [ ] 6. Guardar um bitmap na memória (`db`)
- [ ] 7. Rotina genérica: DESENHA_SPRITE (x, y, bitmap, largura, altura)
- [ ] 8. Rotina genérica: APAGA_SPRITE (pinta a área com a cor de fundo)
- [ ] 9. Esperar um tempo com INT 1Ah (ticks)
- [ ] 10. Mover um sprite pela tela (apaga → muda x → desenha → espera)

## Fase 2 — Tela inicial
- [ ] 11. Escrever texto colorido (INT 10h, função 13h)
- [ ] 12. Título "Moon Patrol" em arte ASCII (verde-claro)
- [ ] 13. Ler teclado sem travar (INT 16h, funções 01h e 00h)
- [ ] 14. Menu "Jogar" / "Sair" com caixas, setas e Enter
- [ ] 15. Animação do jipe e das 3 naves andando na tela inicial

## Fase 3 — Base do jogo
- [ ] 16. Loop principal: ler tecla → atualizar → desenhar → esperar
- [ ] 17. Faixa amarela do chão + jipe andando (limitado à metade da tela)
- [ ] 18. Pulo trapezoidal (sobe 3 px/frame, fica no topo, desce)
- [ ] 19. Barra de status: score, corações e relógio com o tempo

## Fase 4 — Cenário
- [ ] 20. Montanhas desenhadas a partir da linha 100
- [ ] 21. Rolagem contínua do cenário (sem emenda visível)
- [ ] 22. Gerador de números aleatórios
- [ ] 23. Crateras: surgir, andar com o chão, distância mínima de 150 px
- [ ] 24. Colisão jipe × cratera, perder vida, voltar na coluna 0, +50 pontos
- [ ] 25. Rochas (4 tipos) entre crateras, colisão e pontos

## Fase 5 — Naves e tiros
- [ ] 26. Tabela de objetos (várias naves usando a mesma rotina)
- [ ] 27. Grupos de 1 a 3 naves aleatórias, regra dos 30 px
- [ ] 28. Tiro superior do jipe (amarelo) × naves, +100 pontos
- [ ] 29. Tiro frontal do jipe (vermelho, 50 px) × rochas
- [ ] 30. Tiros das naves (brancos) × jipe

## Fase 6 — Fim e entrega
- [ ] 31. Fim de jogo por vidas ou por tempo
- [ ] 32. Tela GAME OVER + score final + voltar ao menu
- [ ] 33. Cabeçalhos em todas as rotinas (Função / Entrada / Saída)
- [ ] 34. Testar no GUI Turbo Assembler (Windows)

> Mínimo entregável: tudo, exceto os passos 28–30, que são opcionais (ganham pontos extras).
