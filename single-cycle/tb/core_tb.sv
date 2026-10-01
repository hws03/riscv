`timescale 1ns / 1ps

module core_tb;

logic clk = 0;
logic reset;
logic[31:0] core_o;

core uut(
    .clk(clk), 
    .reset(reset), 
    .core_o(core_o)
);

always #5 clk = ~clk;

initial begin
    reset = 1;
    @(posedge clk); #1;
    reset = 0;

    repeat (60) @(posedge clk);
    #1;
    $display("x1=%0d x2=%0d x3=%0d x4=%0d",
        uut.regfile_inst.register[1],
        uut.regfile_inst.register[2],
        uut.regfile_inst.register[3],
        uut.regfile_inst.register[4]);


    if (uut.regfile_inst.register[2] == 55) 
        $display("PASS");
    else 
        $error("FAIL");
    
    $finish;
end

endmodule