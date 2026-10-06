//extract immedaites from instruction formats that contain them (I, S, B, U, J)


module immediate(
    input logic[31:0] instruc,
    
    output logic[31:0] immediate_o
);


logic[6:0] opcode;
assign opcode = instruc[6:0]; //assign so it continously updates

always_comb begin
    immediate_o = '0;
    
    case(opcode)
    
        //I
        7'b0010011: begin
            immediate_o = { {20{instruc[31]}}, instruc[31:20] };
        end
        
        //I
        7'b0000011: begin
            immediate_o = { {20{instruc[31]}}, instruc[31:20] };
        end
        
        //I
        7'b1100111: begin
            immediate_o = { {20{instruc[31]}}, instruc[31:20] };
        end
    
        //S
        7'b0100011: begin
            immediate_o = { {20{instruc[31]}}, instruc[31:25], instruc[11:7] };
        end
        
        //B
        7'b1100011: begin
            immediate_o = { {20{instruc[31]}}, instruc[7], instruc[30:25], instruc[11:8], 1'b0 }; 
        end
        
        //U
        7'b0110111: begin
            immediate_o = { instruc[31:12], 12'b0 }; 
        end
        
        //U
        7'b0010111: begin
            immediate_o = { instruc[31:12], 12'b0 }; 
        end
        
        //J
        7'b1101111: begin
            immediate_o = { {12{instruc[31]}}, instruc[19:12], instruc[20], instruc[30:21], 1'b0 }; // J-type
        end
        
        default: begin
            immediate_o = '0;
        end
        
    endcase

end


endmodule
