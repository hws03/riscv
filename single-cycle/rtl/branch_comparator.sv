module branch_comparator(
    input logic[31:0] rs1_d,
    input logic[31:0] rs2_d,
    input logic[2:0] funct3,
    
    output logic branch_taken
);

always_comb begin
    
    case(funct3)
    
        3'b000: begin //branch equal BEQ
            branch_taken = (rs1_d == rs2_d) ? 1 : 0;
        end
        
        3'b001: begin //branch not equal BNE
            branch_taken = (rs1_d != rs2_d) ? 1 : 0;
        end
        
        3'b100: begin //branch less than BLT
            branch_taken = ($signed(rs1_d) < $signed(rs2_d)) ? 1 : 0;
        end
        
        3'b101: begin //branch greater equal BGE
            branch_taken = ($signed(rs1_d) >= $signed(rs2_d)) ? 1 : 0;
        end
        
        3'b110: begin //branch less than unsigned BLTU
            branch_taken = (rs1_d < rs2_d) ? 1 : 0;
        end
        
        3'b111: begin //branch greater equal unsigned BGEU
            branch_taken = (rs1_d >= rs2_d) ? 1 : 0;
        end
        
        default: begin
            branch_taken = 0;
        end
        
    endcase
end

endmodule
