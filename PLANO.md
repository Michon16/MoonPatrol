# Plano — Moon Patrol em Assembly 8086

Marque `[x]` quando terminar cada etapa. Daqui em diante, cada etapa já usa os elementos **reais** do enunciado (sprites, tamanhos e posições de verdade), sem objetos de teste.

## ✅ Base (feito)
- [x] Esqueleto, modo 13h, pixel, linha, retângulo, constantes
- [x] Bitmap na memória + rotinas DESENHAR_SPRITE / DESENHAR_RETANGULO
- [x] ESPERAR (INT 1Ah) e MOVER_DIREITA (um passo)
- [x] ESCREVER_TEXTO / ESCREVER_LINHAS (INT 10h, 13h)
- [x] Título ASCII + menu com caixas, setas, Enter e teclado sem travar

## 1. Tela inicial completa
- [ ] Bitmaps reais: jipe (20×10) e as 3 naves (14×14)
- [ ] Jipe + 3 naves andando entre o título e o menu, voltando pela esquerda

## 2. Jogo: cenário e jipe
- [ ] Tela do jogo: chão amarelo (7 px) e montanhas a partir da linha 100
- [ ] Loop do jogo (o mesmo formato do menu) + jipe andando ←/→ até a metade da tela
- [ ] Pulo trapezoidal (sobe 3 px/frame até 15 px, fica no topo, desce)
- [ ] Barra de status: score, corações (vidas) e relógio com o tempo

## 3. Jogo: obstáculos
- [ ] Rolagem contínua das montanhas (sem emenda)
- [ ] Gerador de números aleatórios
- [ ] Crateras (3 tipos, 14×7): surgem à direita, 150 px de distância, colisão, +50
- [ ] Rochas (4 tipos, 12×10) entre crateras, colisão, +50
- [ ] Perder vida: jipe volta para a coluna 0

## 4. Jogo: naves
- [ ] Grupos de 1 a 3 naves do mesmo tipo (aleatório), 30 px entre elas, andando ←
- [ ] *(opcional)* Tiros do jipe: superior (naves, +100) e frontal (rochas)
- [ ] *(opcional)* Tiros das naves × jipe

## 5. Fim e entrega
- [ ] Game Over por vidas ou tempo: tela GAME OVER + score → volta ao menu
- [ ] Revisar cabeçalhos e constantes
- [ ] Testar no GUI Turbo Assembler (Windows)

> Mínimo entregável: tudo, exceto os itens marcados como *opcional* (que valem pontos extras).
