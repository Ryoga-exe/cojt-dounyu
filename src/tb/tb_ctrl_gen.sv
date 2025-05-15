//-----------------------------------------------------------------------------
// Module : tb_ctrl_gen
//-----------------------------------------------------------------------------
`timescale 1ns / 1ns

module tb_ctrl_gen;

  //-----------------------------------------------------------------------------
  //	Internal Signals
  //-----------------------------------------------------------------------------
  logic clk;  //clock (100MHz)
  logic rst;  //syncronus reset active hi
  logic btnr;  //BTNR button oneshot pulse
  logic btnl;  //BTNL button oneshot pulse
  logic btnu;  //BTNU button oneshot pulse
  logic dummy_1hz;  //dummy mask signal for 1Hz blinking
  logic mode_ms;  //display mode  1:min-sec 0:hour-min
  logic hour_inc;  //hour counter increment
  logic min_inc;  //min counter increment
  logic sec_rst;  //sec counter reset
  logic disp_en_h;  //hour diplay blinking
  logic disp_en_m;  //min diplay blinking
  logic disp_en_s;  //sec diplay blinking

  //-----------------------------------------------------------------------------
  //	Parameter Definition
  //-----------------------------------------------------------------------------
  // CLK = 100MHz : 10ns/T
  parameter cycle = 10;

  //-----------------------------------------------------------------------------
  //	Module Call
  //-----------------------------------------------------------------------------
  ctrl_gen i_ctrl_gen (
      .clk(clk),
      .rst(rst),
      .btnr(btnr),
      .btnl(btnl),
      .btnu(btnu),
      .mask_1hz(dummy_1hz),
      .mode_ms(mode_ms),
      .hour_inc(hour_inc),
      .min_inc(min_inc),
      .sec_rst(sec_rst),
      .disp_en_h(disp_en_h),
      .disp_en_m(disp_en_m),
      .disp_en_s(disp_en_s)
  );

  //-----------------------------------------------------------------------------
  //	Clock Generate
  //-----------------------------------------------------------------------------
  always begin
    clk = 1'b0;
    #(cycle / 2);
    clk = 1'b1;
    #(cycle / 2);
  end

  //-----------------------------------------------------------------------------
  //	make dummy signal mask_1hz
  //-----------------------------------------------------------------------------
  always begin
    dummy_1hz = 1'b0;
    repeat (5000) @(posedge clk);
    #(1);
    dummy_1hz = 1'b1;
    repeat (5000) @(posedge clk);
    #(1);
  end

  //-----------------------------------------------------------------------------
  //	Simulation
  //-----------------------------------------------------------------------------
  initial begin
    // set initial value
    rst  = 1'b0;
    btnr = 1'b0;
    btnl = 1'b0;
    btnu = 1'b0;

    // reset in
    TASK_RESET;
    repeat (1000) @(posedge clk);

    // test 1 
    TASK_BTNR;  //mode_ms -> 1'b1
    repeat (1000) @(posedge clk);

    TASK_BTNR;  //mode_ms -> 1'b0
    repeat (1000) @(posedge clk);

    // test 2
    TASK_BTNL;  //state -> 2'01
    TASK_BTNR;  //state -> 2'11
    TASK_BTNR;  //state -> 2'10
    TASK_BTNR;  //state -> 2'01
    repeat (1000) @(posedge clk);

    //test 3
    TASK_BTNL;  //state 2'b01 -> 2'b00
    repeat (1000) @(posedge clk);

    TASK_BTNL;
    TASK_BTNR;  //state -> 2'11
    TASK_BTNL;  //state 2'b11 -> 2'b00
    repeat (1000) @(posedge clk);

    TASK_BTNL;
    TASK_BTNR;  //state -> 2'11
    TASK_BTNR;  //state -> 2'10
    TASK_BTNL;  //state 2'b10 -> 2'b00
    repeat (1000) @(posedge clk);

    // test 4
    TASK_BTNL;
    repeat (25000) @(posedge clk);  // check disp_en_h = dummy_1hz
    TASK_BTNR;
    repeat (25000) @(posedge clk);  // check disp_en_m = dummy_1hz
    TASK_BTNR;
    repeat (25000) @(posedge clk);  // check disp_en_s = dummy_1hz
    TASK_BTNL;
    repeat (25000) @(posedge clk);  // check disp_en_* = 1'b1

    // test 5
    TASK_BTNU;  //hour_inc=0、min_inc=0、sec_rst=0
    repeat (1000) @(posedge clk);
    TASK_BTNL;  //state -> 2'b01
    repeat (1000) @(posedge clk);
    TASK_BTNU;  //hour_inc=0、min_inc=0、sec_rst=1
    repeat (1000) @(posedge clk);
    TASK_BTNR;  //state -> 2'b11
    repeat (1000) @(posedge clk);
    TASK_BTNU;  //hour_inc=0、min_inc=1、sec_rst=0
    repeat (1000) @(posedge clk);
    TASK_BTNR;  //state -> 2'b10
    repeat (1000) @(posedge clk);
    TASK_BTNU;  //hour_inc=1、min_inc=0、sec_rst=0
    repeat (1000) @(posedge clk);

    // test 7
    TASK_RESET;  //state -> 2'b00
    repeat (1000) @(posedge clk);

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
    rst = 1'b1;
    repeat (3) @(posedge clk);
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
