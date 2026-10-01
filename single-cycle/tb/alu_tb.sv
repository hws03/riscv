`timescale 1ns / 1ps

module alu_tb;

logic[31:0] in_1;
logic[31:0] in_2;
logic[3:0] alu_control;

logic[31:0] alu_out;


alu uut(
    .in_1(in_1),
    .in_2(in_2),
    .alu_control(alu_control),
    .alu_out(alu_out)
);

int pass_counter;
int error_counter;

task automatic alu_test(input[31:0] expected_alu_o);
    #1;
    if (alu_out == expected_alu_o) begin
        pass_counter = pass_counter + 1;
    end 
    else begin
        error_counter = error_counter + 1;
        $error("ERROR");
    end
endtask


//12 tests
initial begin

    //ADD (overflow wraps)
    in_1 = 32'h7FFFFFFF;
    in_2 = 32'd1;
    alu_control = 4'b0000;
    alu_test(32'h80000000);

    //SUB
    in_1 = 32'd0;
    in_2 = 32'd1;
    alu_control = 4'b0001;
    alu_test(32'hFFFFFFFF);

    //SLT
    in_1 = 32'h80000000;
    in_2 = 32'd1;
    alu_control = 4'b0010;
    alu_test(32'd1);

    //SLTU
    in_1 = 32'h80000000;
    in_2 = 32'd1;
    alu_control = 4'b0011;
    alu_test(32'd0);

    //AND
    in_1 = 32'd12;
    in_2 = 32'd10;
    alu_control = 4'b1000;
    alu_test(32'd8);

    //OR
    in_1 = 32'd12;
    in_2 = 32'd10;
    alu_control = 4'b1001;
    alu_test(32'd14);

    //XOR
    in_1 = 32'd12;
    in_2 = 32'd10;
    alu_control = 4'b1010;
    alu_test(32'd6);

    //SLL
    in_1 = 32'd1;
    in_2 = 32'd4;
    alu_control = 4'b1011;
    alu_test(32'h00000010);

    //SRL
    in_1 = 32'h80000000;
    in_2 = 32'd4;
    alu_control = 4'b1100;
    alu_test(32'h08000000);

    //SRA
    in_1 = 32'h80000000;
    in_2 = 32'd4;

    $display("Passed: %0d, Failed: %0d", pass_counter, error_counter);
    $finish;

end


endmodule
