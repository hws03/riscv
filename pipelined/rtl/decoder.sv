module decoder(
    input logic[6:0] opcode,
    
    output logic reg_write,
    output logic alu_src,
    output logic mem_wr,
    output logic mem_rd,
//    output logic mem_to_reg,
    output logic branch,
    output logic jump, //jump and link
    output logic jalr, //jump and link register
    output logic[1:0] alu_op,
    output logic[1:0] wb_sel, //write back select
    output logic[1:0] alua_sel //alu input a select
);


always_comb begin
    
    case(opcode)
    
        default: begin
            reg_write = 0;
            alu_src = 0;
            mem_wr = 0;
            mem_rd =0;
//            mem_to_reg = 0;
            branch = 0;
            jump =0;
            jalr =0;
            alu_op = 2'b00;
            wb_sel = 2'b00; 
            alua_sel = 2'b00;
        end
        
        7'b0110011: begin      //r-type
            reg_write = 1'b1; /////
            alu_src = 0;
            mem_wr = 0;
            mem_rd =0;
//            mem_to_reg = 0;
            branch = 0;
            jump =0;
            jalr =0;
            alu_op = 2'b10; /////
            wb_sel = 2'b00; 
            alua_sel = 2'b00;
        end
        
        7'b0010011: begin     //i-arith
            reg_write = 1'b1; /////
            alu_src = 1'b1; /////
            mem_wr = 0;
            mem_rd =0;
            branch = 0;
            jump =0;
            jalr =0;
            alu_op = 2'b11; /////
            wb_sel = 2'b00; 
            alua_sel = 2'b00;
        end
        
        7'b0000011: begin    //load
            reg_write = 1'b1; /////
            alu_src = 1'b1; /////
            mem_wr = 0;
            mem_rd = 1'b1; /////
            branch = 0;
            jump =0;
            jalr =0;
            alu_op = 2'b00;
            wb_sel = 2'b01;  /////
            alua_sel = 2'b00;
        end
        
        7'b0100011: begin    //store
            reg_write = 1'b0;
            alu_src = 1'b1; /////
            mem_wr = 1'b1; /////
            mem_rd = 1'b0;
            branch = 0;
            jump =0;
            jalr =0;
            alu_op = 2'b00;
            wb_sel = 2'b00; 
            alua_sel = 2'b00;
        end
        
        7'b1100011: begin    //branch
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_wr = 1'b0;
            mem_rd = 1'b0;
            branch = 1'b1; /////
            jump =0;
            jalr =0;
            alu_op = 2'b00;
            wb_sel = 2'b00; 
            alua_sel = 2'b00;
        end
        
        7'b1101111: begin    //jal
            reg_write = 1'b1; /////
            alu_src = 1'b0;
            mem_wr = 1'b0;
            mem_rd = 1'b0;
            branch = 1'b0;
            jump = 1'b1; /////
            jalr =0;
            alu_op = 2'b00;
            wb_sel = 2'b10; /////
            alua_sel = 2'b00;
        end

        7'b1100111: begin    //jalr
            reg_write = 1'b1; /////
            alu_src = 1'b1;
            mem_wr = 1'b0;
            mem_rd = 1'b0;
            branch = 1'b0; 
            jump = 1'b0; 
            jalr = 1'b1; /////
            alu_op = 2'b00;
            wb_sel = 2'b10; /////
            alua_sel = 2'b00;
        end
        
        7'b0110111: begin    //lui (load upper immediate)
            reg_write = 1'b1; /////
            alu_src = 1'b1; /////
            mem_wr = 1'b0;
            mem_rd = 1'b0;
            branch = 1'b0; 
            jump = 1'b0; 
            jalr = 1'b0; 
            alu_op = 2'b00;
            wb_sel = 2'b00;
            alua_sel = 2'b10; /////
        end
        
        7'b0010111: begin    //auipc (add upper immediate to PC)
            reg_write = 1'b1; /////
            alu_src = 1'b1; /////
            mem_wr = 1'b0;
            mem_rd = 1'b0;
            branch = 1'b0; 
            jump = 1'b0; 
            jalr = 1'b0; 
            alu_op = 2'b00;
            wb_sel = 2'b00;
            alua_sel = 2'b01; /////
        end
        
    endcase

end

endmodule