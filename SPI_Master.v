
module Master #(parameter length=8,parameter bits=4,parameter edges= 4'b1001) (
input clk,rst,
input [length-1:0] d_in,
input Miso,
output reg Mosi,
output wire Sclk,
output reg Cs,
output reg [length-1:0] d_rec
);

wire valid;
reg [bits-1:0] wr_bit,rd_bit;
reg [length-1:0] shift_reg;

// clock gating 
assign Sclk = (valid && ! Cs) ? clk:1'b0;
// valid when Mosi is reseted 
assign valid = ((Mosi == 1'b0) || (Mosi == 1'b1)) ? 1'b1:1'b0;
// Cs is valid when the register is loaded 
always @ (*)
  begin
     if (wr_bit == edges)
	  begin
	     Cs = 1'b1;
	  end
	 else
      begin
	     Cs = 1'b0;
	  end	  
  end
// sending the data through the shift reg  
always @ (negedge Sclk or negedge rst)
  begin
     if (!rst)
	  begin
	     wr_bit <= 'b0;
		 shift_reg <= d_in;
		 Mosi <= 'b0;
	  end
	 else if (!Cs)
      begin
	     Mosi <= shift_reg [0];
		 shift_reg <= shift_reg >>1;
		 wr_bit <= wr_bit + 'b1;
	  end
	 else 
	  begin
	     wr_bit <= 'b0;
		 shift_reg <= 'b0;
		 Mosi <= 'b0;
	  end
	  
  end
  


//receiving data from Miso  
always @ (posedge Sclk or negedge rst)
  begin
     if (!rst)
	  begin
	     rd_bit <= 'b0;
		 d_rec <= 'b0;
	  end
	 else if ((!Cs)&&(rd_bit=='b0))
      begin
		 rd_bit <= rd_bit + 'b1;
	  end
	 else if ((!Cs)&&(rd_bit!='b0))
      begin
	    d_rec[rd_bit-1] <=Miso;		
		 rd_bit <= rd_bit + 'b1;	 
	  end
	 else 
	  begin
	     rd_bit <= 'b0;
		 d_rec <= 'b0;
	  end
	  
  end
    
endmodule  
  