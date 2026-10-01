`timescale 1ns / 1ps

module arith_u_tb;

logic[31:0] a;
logic[31:0] b;
logic[1:0] arith_operation; //4 operations, 2 bits to select
logic[31:0] out;


arith_u uut(
    .a(a),
    .b(b),
    .arith_operation(arith_operation),
    .out(out)
);

task automatic arith_test(input[31:0] expected_arith);
    #1;
    assert (out == expected_arith) 
        $display("Pass");
    else 
        $error("Fail");
endtask


initial begin

    //ADD (1+2)
    a = 32'd1;
    b = 32'd2;
    arith_operation = 2'b00;
    arith_test(32'd3);
    
    //ADD (overflow)
    a = 32'h7FFFFFFF;
    b = 32'd1;
    arith_operation = 2'b00;
    arith_test(32'h80000000);
    
    //SUB (16-4)
    a = 32'd16;
    b = 32'd4;
    arith_operation = 2'b01;
    arith_test(32'd12);
    
    //SLT
    a = 32'h80000000;
    b = 32'd1;
    arith_operation = 2'b10;
    arith_test(32'd1);
    
    //SLTU
    a = 32'h80000000;
    b = 32'd1;
    arith_operation = 2'b11;
    arith_test(32'd0);
    
    $finish;

end

endmodule