`timescale 1ns / 1ps

module logic_u_tb;

logic[31:0] a;
logic[31:0] b;
logic[2:0] logic_operation; //6 operations, 3 bits to select
logic[31:0] out;


logic_u uut(
    .a(a),
    .b(b),
    .logic_operation(logic_operation),
    .out(out)
);

task automatic logic_test(input[31:0] expected_logic);
    #1;
    assert (out == expected_logic) 
        $display("Pass");
    else 
        $error("Fail");
endtask


initial begin
   
    //AND (1100 & 1010 = 1000) 
    a = 32'd12;
    b = 32'd10;
    logic_operation = 3'b000; 
    logic_test(32'd8);
   
    //OR (1110)
    a = 32'd12;
    b = 32'd10;
    logic_operation = 3'b001;
    logic_test(32'd14);
    
    //XOR (0110)        
    a = 32'd12;
    b = 32'd10;
    logic_operation = 3'b010;
    logic_test(32'd6);         
    
    //SLL
    a = 32'd1;
    b = 32'd4;
    logic_operation = 3'b011;
    logic_test(32'h00000010);

    //SRL
    a = 32'h80000000;
    b = 32'd4;
    logic_operation = 3'b100;
    logic_test(32'h08000000);

    // RA
    a = 32'h80000000;
    b = 32'd4;
    logic_operation = 3'b101;
    logic_test(32'hF8000000);

    //shift by 0
    a = 32'h12345678;
    b = 32'd0;
    logic_operation = 3'b100;
    logic_test(32'h12345678);

    //shift by 32 masks to 0
    a = 32'h12345678;
    b = 32'd32;
    logic_operation = 3'b100;
    logic_test(32'h12345678);
    
    $finish;

end

endmodule