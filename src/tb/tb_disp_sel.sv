//-----------------------------------------------------------------------------
// Module : tb_disp_sel
//-----------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_disp_sel;

//-----------------------------------------------------------------------------
//	Internal Signals
//-----------------------------------------------------------------------------
logic		mode_ms;	//display mode select 
logic [6:0]	hour_hi;	//
logic [6:0]	hour_lo;	//
logic [6:0]	min_hi;		//
logic [6:0]	min_lo;		//
logic [6:0]	sec_hi;		//
logic [6:0]	sec_lo;		//
logic [4:0]	hour_bin;	//hour counter binary data
logic [5:0]	sec_bin;	//second counter binary data
logic [6:0]	disp3;		//disp3 segment data active low
logic [6:0]	disp2;		//disp2 segment data active low
logic [6:0]	disp1;		//disp1 segment data active low
logic [6:0]	disp0;		//disp0 segment data active low
logic [4:0]	hour_led;	//hour counter binary display
logic [5:0]	sec_led;	//second counter binary display

//-----------------------------------------------------------------------------
//	Parameter Definition
//-----------------------------------------------------------------------------
// simulation step
parameter STEP = 10;

//-----------------------------------------------------------------------------
//	Module Call
//-----------------------------------------------------------------------------
disp_sel	i_disp_sel(
	.mode_ms		(mode_ms),
	.hour_hi		(hour_hi),
	.hour_lo		(hour_lo),
	.min_hi			(min_hi),
	.min_lo			(min_lo),
	.sec_hi			(sec_hi),
	.sec_lo			(sec_lo),
	.hour_bin		(hour_bin),
	.sec_bin		(sec_bin),
	.disp3			(disp3),
	.disp2			(disp2),
	.disp1			(disp1),
	.disp0			(disp0),
	.hour_led		(hour_led),
	.sec_led		(sec_led)	);
	
//-----------------------------------------------------------------------------
//	Clock Generate
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//	Simulation
//-----------------------------------------------------------------------------
initial begin
// set initial value
	mode_ms = 1'b0;
	hour_hi = 7'b0000110;
	hour_lo = 7'b1011011;
	min_hi = 7'b1001111;
	min_lo = 7'b1100110;
	sec_hi = 7'b1101101;
	sec_lo = 7'b1111101;
	hour_bin = 5'd12;
	sec_bin = 6'd56;

// test 1
	repeat (5) #STEP;

// test 2
	mode_ms = 1'b1;

	repeat (5) #STEP;

	$display("-----------------------------------------\n");
	$display("            Simulation  Finish !!        \n");
	$display("-----------------------------------------\n");
	$finish;
end

endmodule


