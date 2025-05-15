//-----------------------------------------------------------------------------
// Module : tb_cnt24
//-----------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_cnt24;

//-----------------------------------------------------------------------------
//	Internal Signals
//-----------------------------------------------------------------------------
logic			clk;					// system clk
logic			rst;					// synchronous reset
logic			cnt_en;					// count enable
logic			cnt_inc;				// count increment

logic	[1:0]	cnt_hi;					// count number
logic	[3:0]	cnt_lo;					// count number
logic	[4:0]	cnt_bin;				// count binary number

//-----------------------------------------------------------------------------
//	Parameter Definition
//-----------------------------------------------------------------------------
// CLK = 100MHz : 10ns/T
parameter cycle = 10;

//-----------------------------------------------------------------------------
//	Module Call
//-----------------------------------------------------------------------------
cnt24	i_cnt24(
	.clk		(clk),
	.rst		(rst),
	.cnt_en		(cnt_en),
	.cnt_inc	(cnt_inc),
	.cnt_hi		(cnt_hi),
	.cnt_lo		(cnt_lo),
	.cnt_bin	(cnt_bin)	);

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
	cnt_en = 1'b0;
	cnt_inc = 1'b0;

// reset in
	TASK_RESET;
	@(posedge clk);

// test 1, 3, 4, 5 
	#(1);
	cnt_en = 1'b1;
	repeat (40) @(posedge clk);
	#(1);
	cnt_en = 1'b0;
	repeat (10) @(posedge clk);

// test 6 reset in
	TASK_RESET;
	@(posedge clk);
	
// test 2, 3, 4, 5 
	#(1);
	cnt_inc = 1'b1;
	repeat (40) @(posedge clk);
	#(1);
	cnt_inc = 1'b0;
	repeat (10) @(posedge clk);

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

task TASK_CNT_EN;
	@(posedge clk);
	#(1);
	cnt_en = 1'b1;
	@(posedge clk);
	#(1);
	cnt_en = 1'b0;
endtask

task TASK_CNT_INC;
	@(posedge clk);
	#(1);
	cnt_inc = 1'b1;
	@(posedge clk);
	#(1);
	cnt_inc = 1'b0;
endtask

endmodule


