// Anderson de Lima Leite
//

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    //SEG <= SWI;
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end
  
     logic [2:0] y;
     logic [2:0] a;
     logic [2:0] b;
     logic [0:0] flow;
     
   always_comb begin
     y <= SWI[4:3];
     a <= SWI[7:5];
     b <= SWI[2:0];
   end

   always_comb begin
     if(y == 2'b10)
     	if( (a + b) > 3)
     	   flow <= 1'b1;
     	else 
     	   flow <= 1'b0;
     else if(y == 2'b11)
     //necessário reimplementar a lógica do underflow para a operação de subtração
     	if(a - b < -4)
     	   flow <= 1'b1;
     	else 
     	   flow <= 1'b0;
     else
         flow <= 1'b0;
         
   end
  always_comb begin
  	case(y)
  	2'b00 : LED[2:0] <= a & b;
  	2'b01 : LED[2:0] <= a | b;
  	2'b10 : LED[2:0] <= a + b;
  	2'b11 : LED[2:0] <= a - b;
  	default : LED[2:0] <= 3'b000;
  	endcase
  end
  
  always_comb begin
     if((y == 2'b10 | y == 2'b11) & !flow )
        begin
	  	if(LED == 8'b10000000)
	  	 	   SEG <= LED;
	  		else if(LED[2:0] == 3'b000)
	  		    SEG <= 8'b00111111;
	  		else if(LED[2:0] == 3'b001)
	  		    SEG <= 8'b00000110;
	  		else if(LED[2:0] == 3'b010)
	  		    SEG <= 8'b01011011;
	  		else if(LED[2:0] == 3'b011)
	  	 	   SEG <= 8'b01001111;
	  	 	else if(LED[2:0] == 3'b111)
	  	 	   SEG <= 8'b00000110;
	  	 	else if(LED[2:0] == 3'b110)
	  	 	   SEG <= 8'b01011011;
	  	 	else if(LED[2:0] == 3'b101)
	  	 	   SEG <= 8'b01001111;
	  	 	else if(LED[2:0] == 3'b100)
	  	 	   SEG <= 8'b01100110;
	  		else 
	  		    SEG <= 8'b10000000;
	 end
	 
      else
          if(flow)
      		SEG <= 8'b10000000;
      	   else
      	   	SEG <= 8'b00000000;
      		
  end
  
  

endmodule

