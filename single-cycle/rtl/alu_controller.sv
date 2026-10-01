module alu_controller(
    input logic[1:0] alu_op,
    input logic[2:0] funct3,
    input logic funct7bit5,

    output logic[3:0] alu_control_o
);

always_comb begin
    alu_control_o = '0;

    
    case(alu_op)
        
        2'b00: begin                        //LOAD, STORE
            alu_control_o = 4'b0000;        //ADD
        end



//------------ R Type ----------------------------------------//
        2'b10: begin
            case(funct3)
            
                3'b000: begin
                    case(funct7bit5)
                       
                        1'b0: begin
                            alu_control_o = 4'b0000;   //ADD
                        end
                       
                        1'b1: begin
                            alu_control_o = 4'b0001;   //SUB
                        end
                    endcase
                end
            
                3'b001: begin
                    alu_control_o = 4'b1011;          //SLL
                end
                
                3'b010: begin
                    alu_control_o = 4'b0010;          //SLT
                end
                
                3'b011: begin
                    alu_control_o = 4'b0011;          //SLTU
                end
                
                3'b100: begin
                    alu_control_o = 4'b1010;          //XOR
                end
                
                3'b101: begin
                    case(funct7bit5)
                        
                        1'b0: begin
                            alu_control_o = 4'b1100;  //SRL
                        end
                        
                        1'b1: begin
                            alu_control_o = 4'b1101;  //SRA
                        end
                    endcase        
                end
                
                3'b110: begin
                    alu_control_o = 4'b1001;          //OR
                end
                
                3'b111: begin
                    alu_control_o = 4'b1000;          //AND
                end
            endcase
        end

      
        

//------------ I Type ----------------------------------------//
        2'b11: begin
            case(funct3)
            
                3'b000: begin
                    alu_control_o = 4'b0000;         //ADDI
                end
            
                3'b001: begin
                    alu_control_o = 4'b1011;          //SLLI
                end
                
                3'b010: begin
                    alu_control_o = 4'b0010;          //SLTI
                end
                
                3'b011: begin
                    alu_control_o = 4'b0011;          //SLTIU
                end
                
                3'b100: begin
                    alu_control_o = 4'b1010;          //XORI
                end
                
                3'b101: begin
                    case(funct7bit5)
                        
                        1'b0: begin
                            alu_control_o = 4'b1100;  //SRLI
                        end
                        
                        1'b1: begin
                            alu_control_o = 4'b1101;  //SRAI
                        end
                    endcase        
                end
                
                3'b110: begin
                    alu_control_o = 4'b1001;          //ORI
                end
                
                3'b111: begin
                    alu_control_o = 4'b1000;          //ANDI
                end
            endcase
        end
        
        
//anything else
        default: begin
            alu_control_o = '0;
        end
    
    
    endcase
end


endmodule
