# ULA-em-SystemVerilog
Criação do circuito lógico combinacional ULA com operações básicas de apenas 3 bits (AND,OR, soma, subtração) para a disciplina de LOAC na UFCG.

## Como rodar o projeto:
* **1.** Abrir o simulador de FPGA da UFCG:  http://lad.ufcg.edu.br/hdl/simulate.php 
* **2.** Selecionar o arquivo top.sv, selecionar LCD e fazer o upload.
* **3.** Utilizar os Switches como entradas binarias A = SWI[7:5], B = SWI[2:0] a saída será mostrada nos LEDs e no segmento.
         Os SWI[4:3] definem o tipo de operação, 00 == A & B, 01 == A | B, 10 = A + B, 11 = A - B, em caso de underflow ou overflow, um ponto será mostrado no segmento.
