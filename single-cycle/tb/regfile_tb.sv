`timescale 1ns / 1ps

module regfile_tb;

logic clk;
logic[4:0] rs1;
logic[4:0] rs2;
logic[4:0] rd;
logic[31:0] rd_d;
logic reg_write;
    
logic[31:0] rs1_d;
logic[31:0] rs2_d;


regfile uut(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .rd_d(rd_d),
    .reg_write(reg_write),
    
    .rs1_d(rs1_d),
    .rs2_d(rs2_d)
);

initial clk = 0;
always #5 clk = ~clk;

int pass_counter;
int error_counter;


task automatic reg_file_test(input[31:0] expected_reg_file_o1, input[31:0] expected_reg_file_o2);
    #1;
    if (rs1_d == expected_reg_file_o1) begin
        pass_counter = pass_counter + 1;
    end
    else if(rs2_d == expected_reg_file_o2) begin
         pass_counter = pass_counter + 1;
    end
    else begin
        error_counter = error_counter + 1;
        $error("error");
    end
endtask


task automatic write_reg(input[4:0] r, input[31:0] d, input en);
    rd = r;
    rd_d = d;
    reg_write = en;
    
    @(posedge clk);
    #1;
    reg_write = 0;
endtask


//tests
initial begin
    reg_write = 0; rd = 0; rd_d = 0; rs1 = 0; rs2 = 0;
    #1;

    //write reg5, read on both ports
    write_reg(5'd5, 32'd100, 1);
    rs1 = 5'd5; 
    rs2 = 5'd5;
    reg_file_test(32'd100, 32'd100);

    //write reg0, must still read 0
    write_reg(5'd0, 32'd55, 1);
    rs1 = 5'd0; 
    rs2 = 5'd0;
    reg_file_test(32'd0, 32'd0);

    //reg_write = 0, reg6 must stay 0
    write_reg(5'd6, 32'd77, 0);
    rs1 = 5'd6; 
    rs2 = 5'd6;
    reg_file_test(32'd0, 32'd0);

    //two different registers at once (reg5 and reg7)
    write_reg(5'd7, 32'd200, 1);
    rs1 = 5'd5; 
    rs2 = 5'd7;
    reg_file_test(32'd100, 32'd200);

    //reg31 write and read back
    write_reg(5'd31, 32'd300, 1);
    rs1 = 5'd31; 
    rs2 = 5'd0;
    reg_file_test(32'd300, 32'd0);

    $display("Passed: %0d, Failed: %0d", pass_counter, error_counter);
    $finish;

end

endmodule
