// 4 digit seven segment display for BASYS3

module an_ca (
	input logic				clk,  // 100MHz input clock
	input logic		[6:0] 	disp3,	//display data digit3
	input logic		[6:0] 	disp2,	//display data digit2
	input logic		[6:0] 	disp1,	//display data digit1
	input logic		[6:0] 	disp0,	//display data digit0
	output logic	[3:0]	an,		//common signal  active lo
	output logic	[6:0]	ca );	//segment data  active lo

reg		[3:0]	common = 4'b1110;	// common signal active lo
reg		[16:0]	count = 17'd0;		//17bit free run counter
reg				digit_rate = 1'b0;


always_ff @(posedge clk) begin
    count <= count + 17'd1;
end

always_ff @(posedge clk) begin
    if (count == 17'h1ffff) begin
       digit_rate <= 1'b1;
    end else begin
       digit_rate <= 1'b0;
    end
end

always_ff @(posedge clk) begin
    if (digit_rate == 1'b1) begin
        common <= {common[2:0],common[3]};
    end
end

always @(posedge clk) begin
    case (common)
        4'b1110		: ca <= disp0;
        4'b1101		: ca <= disp1;
        4'b1011		: ca <= disp2;
        4'b0111		: ca <= disp3;
        default		: ca <= 7'b1111111;
    endcase
end

always_ff @(posedge clk) begin
    an <= common;
end

endmodule
