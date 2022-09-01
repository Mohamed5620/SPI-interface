
module Slave #(parameter length=8,parameter bits=4,parameter edges= 4'b1001) (
input Sclk,Cs,rst,
input  Mosi,
input [length-1:0] d_in,
output reg Miso,
output reg [length-1:0] d_rec
);

reg [bits-1:0] wr_bit,rd_bit;
reg [length-1:0] shift_reg;

// sending the data through the shift reg  
always @ (negedge Sclk or negedge rst)
  begin
     if (!rst)
	  begin
	     wr_bit <= 'b0;
		 shift_reg <= d_in;
		 Miso <= 'b0;
	  end
	 else if (!Cs)
      begin
	     Miso <= shift_reg [0];
		 shift_reg <= shift_reg >>1;
		 wr_bit <= wr_bit + 'b1;
	  end
	 else 
	  begin
	     wr_bit <= 'b0;
		 shift_reg <= 'b0;
		 Miso <= 'b0;
	  end
	  
  end

//receiving data from Mosi  
always @ (posedge Sclk or negedge rst)
  begin
     if (!rst)
	  begin
	     rd_bit <= 'b0;
		 d_rec <= 'b0;
	  end
	 else if ((!Cs) && (rd_bit == 'b0))
      begin
		 rd_bit <= rd_bit + 'b1;
	  end
	 else if ((!Cs) && (rd_bit != 'b0))
      begin
	     d_rec[rd_bit-1]=Mosi;
		 rd_bit <= rd_bit + 'b1;
	  end
	 else 
	  begin
	     rd_bit <= 'b0;
		 d_rec <= 'b0;
	  end
	  
  end

endmodule    