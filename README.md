# myMIPS
## Processador compatível com MIPS DLX

Este projeto será a implementação de um processador RISC de 32 bits. Ele deverá executar um dos dois subconjuntos, mostrados abaixo, das instruções do MIPS DLX.

O subconjunto **"A"** é formado pelas instruções abaixo:

- As instruções de referência à memória:

  - Carrega palavra (load word: lw);
  - Armazena palavra (store word: sw).

- As instruções lógico-aritméticas:

  - Soma (add);
  - Subtração (sub);
  - E lógico (AND);
  - OU lógico (OR);
  - Comparação menor que (set if less than: slt).

- As instruções de desvio:

  - Desvio se igual (branch equal: beq);
  - Salto incondicional (jump: j).

O subconjunto **"B"** possui as instruções do subconjunto **"A"** e adiciona as listadas abaixo:

- A instrução de carga:

  - Carrega imediato para 16 bits MSB (load upper immediate: lui).
  
- As instruções lógico-aritméticas:

  - Soma com imediato (addi);
  - E lógico com imediato (ANDI);
  - OU lógico com imediato (ORI);
  - Comparação menor que imediato (set if less than: slti).

- As instruções de desvio:

  - Desvio se não igual (branch not equal: bne);
  - Salto e conecta (jump and link: jal);
  - Salto por registrador (jump register: jr).

---------------------------------------------------------------

**Entrega intermediária - MIPS single cycle A:**

- - [x] A entrega intermediária corresponde ao MIPS single cycle com as instruções A. 


----------------------------------------------------------------
O projeto final deverá implementar uma das seguintes funcionalidades:

**(1) MIPS single cycle A e B:**

- - [ ] Executando as instruções dos subconjuntos **A** e **B**;

Nota máxima: limitada ao C+.

**(2) MIPS com pipeline:**

- - [ ] Executando todas instruções do subconjunto **A**;

Nota máxima: limitada ao B.

Caso sejam adicionadas as instruções abaixo, o limite da nota será B+.

- - [ ] Salto e conecta (jump and link: jal);

- - [ ] Salto por registrador (jump register: jr).

**(3) MIPS com pipeline:**

- Executando as instruções dos subconjuntos **A** e **B**;

Nota máxima: sem limite (A+).
