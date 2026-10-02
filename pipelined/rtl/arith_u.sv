module arith_u(
        input logic[31:0] a,
        input logic[31:0] b,
        input logic[1:0] arith_operation, //4 operations, 2 bits to select
        
        output logic[31:0] out
    );


always_comb begin
    case(arith_operation)
        
        2'b00: begin // ADD
             out = a + b;         
        end
        
        2'b01: begin // SUB
            out = a - b;
        end
        
        2'b10: begin // SLT (set less than)
            out = ($signed(a) <  $signed(b)) ? 32'd1 : 32'd0;
        end
        
        2'b11: begin // SLTU
            out = (a < b) ? 32'd1 : 32'd0;
        end
        
        default: begin //this never gets reached since we have cases that cover all 2 bits of opcode
            out = '0;
        end
    endcase
end

endmodule