//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

module BASYS3_CLOCK24(
	input	logic		CLKIN,
	input	logic		btnR,
	input	logic		btnL,
	input	logic		btnU,
	input	logic		btnD,
	input	logic		btnC,
	output	logic [3:0]	an,
	output	logic 		dp,
	output	logic [6:0]	seg,
	output	logic [15:0]	led	);

//internal signal declare
logic		clk;
logic		rst;
logic		rone;
logic		lone;
logic		uone;
logic [6:0]	disp0;
logic [6:0]	disp1;
logic [6:0]	disp2;
logic [6:0]	disp3;
logic [4:0]	hour_led;
logic [5:0]	sec_led;


always_comb dp <=1'b1;
always_comb led[15:11]	<= hour_led;
always_comb led[10:6]	<= 5'd0;
always_comb led[5:0]	<= sec_led;


// MMCM_Block  Instance --
clk_core i_clk_core (
	.clk_in1(CLKIN),      // input clk_in1
	.clk_out1(clk)	);     // output clk_out1

btn		i_btn	(
	.clk(clk),
	.btnu(btnU),
	.btnr(btnR),
	.btnl(btnL),
	.btnd(btnD),
	.btnc(btnC),
	.uone(uone),
	.utgl(),
	.rone(rone),
	.rtgl(),
	.lone(lone),
	.ltgl(),
	.done(rst),
	.dtgl(),
	.cone(),
	.ctgl()		);
	
an_ca   i_an_ca	(
	.clk(clk),
	.disp3(disp3),
	.disp2(disp2),
	.disp1(disp1),
	.disp0(disp0),
	.an(an),
	.ca(seg)	);

clock24	i_clock24	(
	.clk(clk),
	.rst(rst),
	.btnr(rone),
	.btnl(lone),
	.btnu(uone),
	.en4sim(1'b0),
	.mask4sim(1'b0),
	.disp0(disp0),
	.disp1(disp1),
	.disp2(disp2),
	.disp3(disp3),
	.hour_led(hour_led),
	.sec_led(sec_led)	);

endmodule