`timescale 1ns/1ps

module tb ();

parameter length=8;
parameter cases = 4;

reg clk,rst;
reg [length-1:0] d_inm;
reg [length-1:0] d_ins;
wire Miso;
wire Mosi;
wire Sclk;
wire Cs;
wire [length-1:0] d_fmts,d_fstm;

reg [length-1:0] mmem [cases-1:0];
reg [length-1:0] smem [cases-1:0];

integer i;

initial 
  begin
     $dumpfile("SPI.txt");
	 $dumpvars;
	 $readmemb("data@S.txt",smem);
	 $readmemb("data@M.txt",mmem);
	 start();
	 reset();
	 for (i=0;i<cases;i=i+1)
	 begin
    	 op(mmem[i],smem[i]);
		 #40;
	 end	 
	 $finish; 
  end
  
task start;
 begin
     clk=1'b0;
	 rst=1'b1;
	 d_inm= 'b0;
	 d_ins= 'b0;
end
endtask 

task reset;
 begin
     #1
	 rst=1'b0;
	 #1
	 rst= 1'b1;
 end
endtask 

task op;
input reg [length-1:0] mts,stm;
 begin
     d_inm=mts;
	 d_ins=stm;
	 reset();
	 #200
	 if (( d_fmts == mts) && (d_fstm == stm))
	  $display ("test %d both master and slave data are received correctly",i);
	 else 
     $display ("test %d failed",i);	 
 end
endtask 

Master m1 (
.clk(clk),
.rst(rst),
.d_in(d_inm),
.Miso(Miso),
.Mosi(Mosi),
.Sclk(Sclk),
.Cs(Cs),
.d_rec(d_fstm)
);

Slave s1 (
.Sclk(Sclk),
.Cs(Cs),
.rst(rst),
.Mosi(Mosi),
.d_in(d_ins),
.Miso(Miso),
.d_rec(d_fmts)
);

always #10 clk= ~clk;

endmodule