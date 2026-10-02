/*
ADD, SUB, SLT, SLTU:            *0*000 to *0*011
AND, OR, XOR, SLL, SRL, SRA:    *1*000 to *1*101
*/

module alu(
    input logic[31:0] in_1,
    input logic[31:0] in_2,
    input logic[3:0] alu_control,
    
    output logic[31:0] alu_out
);


logic[31:0] logic_result;
logic[31:0] arith_result;


arith_u arith_u_instance(
    .a(in_1),
    .b(in_2),
    .arith_operation(alu_control[1:0]),
    .out(arith_result)
);

logic_u logic_u_instance(
    .a(in_1),
    .b(in_2),
    .logic_operation(alu_control[2:0]),
    .out(logic_result)
);


always_comb begin
    case(alu_control[3])
        
        1'b1: begin
            alu_out = logic_result;
        end 
        
        1'b0: begin
            alu_out = arith_result;
        end
        
        default: begin
            alu_out = '0;
        end
        
    endcase
end

endmodule