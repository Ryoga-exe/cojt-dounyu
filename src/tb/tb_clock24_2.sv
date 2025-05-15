//-----------------------------------------------------------------------------
// Module : tb_clock24_2
//-----------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_clock24_2;

//-----------------------------------------------------------------------------
//	Internal Signals
//-----------------------------------------------------------------------------
logic		clk;		//clock (100MHz)
logic		rst;		//syncronus reset active hi
logic		btnr;		//BTNR button oneshot pulse
logic		btnl;		//BTNL button oneshot pulse
logic		btnu;		//BTNU button oneshot pulse
logic [6:0]	disp3;		//disp3 segment data active low
logic [6:0]	disp2;		//disp2 segment data active low
logic [6:0]	disp1;		//disp1 segment data active low
logic [6:0]	disp0;		//disp0 segment data active low
logic [4:0]	hour_led;	//hour counter binary display
logic [5:0]	sec_led;	//second counter binary display

//-----------------------------------------------------------------------------
//	Parameter Definition
//-----------------------------------------------------------------------------
// CLK = 100MHz : 10ns/T
parameter cycle = 10;

//-----------------------------------------------------------------------------
//	Module Call
//-----------------------------------------------------------------------------
clock24	i_clock24(
	.clk		(clk),
	.rst		(rst),
	.btnr		(btnr),
	.btnl		(btnl),
	.btnu		(btnu),
	.en4sim		(1'b0),
	.mask4sim	(1'b0),
	.disp3		(disp3),
	.disp2		(disp2),
	.disp1		(disp1),
	.disp0		(disp0),
	.hour_led	(hour_led),
	.sec_led	(sec_led)	);
	
//-----------------------------------------------------------------------------
//	Clock Generate
//-----------------------------------------------------------------------------
always begin
	clk = 1'b0;
	#(cycle/2);
	clk = 1'b1;
	#(cycle/2);
end

//-----------------------------------------------------------------------------
//	Simulation
//-----------------------------------------------------------------------------
initial begin
// set initial value
	rst = 1'b0;
	btnr = 1'b0;
	btnl = 1'b0;
	btnu = 1'b0;

// reset in
	TASK_RESET;
	repeat (1000) @(posedge clk);

// test 1 
	repeat (129999999) @(posedge clk);	//countup sec_led

// test 2
	TASK_BTNL;		//blink sec_led
	repeat (129999999) @(posedge clk);
	
	$display("-----------------------------------------\n");
	$display("            Simulation  Finish !!        \n");
	$display("-----------------------------------------\n");
	$finish;
end

//-----------------------------------------------------------------------------
//	Task Definition
//-----------------------------------------------------------------------------
task TASK_RESET;
	@(posedge clk);
	#(1);
	rst= 1'b1 ;
	repeat(3) @(posedge clk);
	#(1);
	rst = 1'b0;
endtask

task TASK_BTNR;
	@(posedge clk);
	#(1);
	btnr = 1'b1;
	@(posedge clk);
	#(1);
	btnr = 1'b0;
	repeat (100) @(posedge clk);
endtask

task TASK_BTNL;
	@(posedge clk);
	#(1);
	btnl = 1'b1;
	@(posedge clk);
	#(1);
	btnl = 1'b0;
	repeat (100) @(posedge clk);
endtask

task TASK_BTNU;
	@(posedge clk);
	#(1);
	btnu = 1'b1;
	@(posedge clk);
	#(1);
	btnu = 1'b0;
	repeat (100) @(posedge clk);
endtask

endmodule


