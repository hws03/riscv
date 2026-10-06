//alu-logic unit: and, or, xor, shift left logical, shift right logical, shift right arithmetic


module logic_u(
        input logic[31:0] a,
        input logic[31:0] b,
        input logic[2:0] logic_operation, //6 operations, 3 bits to select
        
        output logic[31:0] out
);


always_comb begin
    case(logic_operation)
    
        3'b000: begin //AND
            out = a & b;         
        end
        
        3'b001: begin //OR
            out = a | b;
        end
        
        3'b010: begin //XOR
            out = a ^ b;
        end
        
        3'b011: begin //SLL
            out = a << b[4:0];
        end
        
        3'b100: begin //SRL
            out = a >> b[4:0];
        end
        
        3'b101: begin //SRA
            out = $signed(a) >>> b[4:0];
        end
        
        default: begin
            out = '0;
        end
    
    endcase
end

endmodule
