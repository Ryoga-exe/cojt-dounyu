//-----------------------------------------------------------------------------
// Module : tb_clock24_1
//-----------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_clock24_1;

//-----------------------------------------------------------------------------
//	Internal Signals
//-----------------------------------------------------------------------------
logic		clk;		//clock (100MHz)
logic		rst;		//syncronus reset active hi
logic		btnr;		//BTNR button oneshot pulse
logic		btnl;		//BTNL button oneshot pulse
logic		btnu;		//BTNU button oneshot pulse
logic		en4sim;		//dummy signal for simulation
logic		mask4sim;	//dummy signal for simulation
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
	.en4sim		(en4sim),
	.mask4sim	(mask4sim),
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
//	make dummy signal en_1hz
//-----------------------------------------------------------------------------
always begin
	en4sim = 1'b0;
	repeat (9999) @(posedge clk);
	#(1);
	en4sim = 1'b1;
	repeat (1) @(posedge clk);
	#(1);
end

//-----------------------------------------------------------------------------
//	make dummy signal mask_1hz
//-----------------------------------------------------------------------------
always begin
	mask4sim = 1'b0;
	repeat (5000) @(posedge clk);
	#(1);
	mask4sim = 1'b1;
	repeat (5000) @(posedge clk);
	#(1);
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
	repeat (10000*91) @(posedge clk);

// test 2
	TASK_BTNL;		//blink sec_led
	repeat (10000*5) @(posedge clk);
	TASK_BTNU;		//reset sec_led
	repeat (1000) @(posedge clk);

//test 3
	TASK_BTNR;		//blink disp1, disp0
	repeat (10000*3) @(posedge clk);
	TASK_BTNU;		//countup disp1, disp0
	repeat (1000) @(posedge clk);
	TASK_BTNU;		//countup disp1, disp0
	repeat (1000) @(posedge clk);
	TASK_BTNU;		//countup disp1, disp0
	repeat (1000) @(posedge clk);

// test 4
	TASK_BTNR;		//blink disp3, disp2
	repeat (10000*3) @(posedge clk);
	TASK_BTNU;		//countup disp3, disp2
	repeat (1000) @(posedge clk);
	TASK_BTNU;		//countup disp3, disp2
	repeat (1000) @(posedge clk);
	TASK_BTNU;		//countup disp3, disp2
	repeat (1000) @(posedge clk);

// reset in (test8)
	TASK_RESET;
	repeat (1000) @(posedge clk);

// test 5
	TASK_BTNL;		//
	repeat (1000) @(posedge clk);
	TASK_BTNR;		//
	repeat (1000) @(posedge clk);
	repeat (59)	TASK_BTNU;		//disp1, disp0 : "5", "9"
	repeat (1000) @(posedge clk);
	TASK_BTNL;		//
	repeat (1000) @(posedge clk);
	repeat (10000*65) @(posedge clk);	//disp1, disp0 : "0", "0",  disp3, disp2 : countup

// reset in (test8)
	TASK_RESET;
	repeat (1000) @(posedge clk);

// test 6
	TASK_BTNL;		//
	repeat (1000) @(posedge clk);
	TASK_BTNR;		//
	repeat (1000) @(posedge clk);
	repeat (59)	TASK_BTNU;		//disp1, disp0 : "5", "9"
	repeat (1000) @(posedge clk);
	TASK_BTNR;		//
	repeat (1000) @(posedge clk);
	repeat (23)	TASK_BTNU;		//disp1, disp0 : "5", "9"
	repeat (1000) @(posedge clk);
	TASK_BTNL;		//
	repeat (1000) @(posedge clk);
	repeat (10000*65) @(posedge clk);	//disp1, disp0 : "0", "0",  disp3, disp2 : "0", "0"
	
// test 7
	TASK_BTNL;		//
	repeat (1000) @(posedge clk);
	TASK_BTNR;		//
	repeat (1000) @(posedge clk);
	repeat (34)	TASK_BTNU;		//disp1, disp0 : "3", "4"
	repeat (1000) @(posedge clk);
	TASK_BTNR;		//
	repeat (1000) @(posedge clk);
	repeat (12)	TASK_BTNU;		//disp1, disp0 : "1", "2"
	repeat (1000) @(posedge clk);
	TASK_BTNL;		//
	repeat (10000*5) @(posedge clk);
	TASK_BTNR;		//display mode change
	repeat (10000*5) @(posedge clk);
	
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


