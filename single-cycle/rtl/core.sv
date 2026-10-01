module core(
    input logic clk,
    input logic reset,
    input logic prog_we,
    input logic[4:0] prog_addr,
    input logic[31:0] prog_data,


    output logic[31:0] core_o
);

logic[31:0] pc;
logic[31:0] pc_next;
logic[31:0] pc4;
logic[31:0] instruc;
logic[31:0] rs1_d;
logic[31:0] rs2_d; 
logic[31:0] imm; 
logic[31:0] alu_o; 
logic[31:0] d_mem_rd_d; 
logic[31:0] wb_data;
logic[31:0] alu_in_a;
logic[31:0] alu_in_b;
logic[3:0] alu_control;
logic[1:0] alu_op;
logic[1:0] wb_sel;
logic[1:0] alua_sel;
logic reg_write;
logic alu_src;
logic mem_wr;
logic mem_rd;
logic branch;
logic jump; 
logic jalr;
logic branch_taken;

logic[6:0] opcode;
logic[4:0] rd;
logic[4:0] rs1;
logic[4:0] rs2;
logic[2:0] funct3;
logic funct7bit5;

assign opcode = instruc[6:0];
assign rd = instruc[11:7];
assign funct3 = instruc[14:12];
assign rs1 = instruc[19:15];
assign rs2 = instruc[24:20];
assign funct7bit5 = instruc[30];

assign core_o = alu_o;


//mux1
always_comb begin
    case (alua_sel)
        
        2'b00: begin
            alu_in_a = rs1_d;
        end
        
        2'b01: begin
            alu_in_a = pc;
        end
        
        2'b10: begin 
            alu_in_a = '0;
        end
        
        default: begin 
            alu_in_a = '0;
        end
        
    endcase
end


//mux2
assign alu_in_b = alu_src ? imm : rs2_d;


//mux3
always_comb begin
    case (wb_sel)
        
        2'b00: begin
            wb_data = alu_o;
        end
        
        2'b01: begin
            wb_data = d_mem_rd_d;
        end
        
        2'b10: begin
            wb_data = pc4;
        end
        
        default: begin
            wb_data = '0;
        end
    
    endcase
end

//components
pcreg pcreg_inst(
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next),
    .pc(pc)
);

pc pc_inst(
    .pc(pc),
    .imm(imm),
    .alu_result(alu_o),
    .branch_taken(branch_taken),
    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .pc4(pc4),
    .pc_next(pc_next)
);

i_mem i_mem_inst(
    .clk(clk),
    .prog_we(prog_we),
    .prog_addr(prog_addr),
    .prog_data(prog_data),
    .pc_addr(pc),
    .instruc(instruc)
);

decoder decoder_inst(
    .opcode(opcode),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_wr(mem_wr),
    .mem_rd(mem_rd),
    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .alu_op(alu_op),
    .wb_sel(wb_sel),
    .alua_sel(alua_sel)
);

regfile reg_file_inst(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .rd_d(wb_data),
    .reg_write(reg_write),
    .rs1_d(rs1_d),
    .rs2_d(rs2_d)
);

immediate immediate_inst(
    .instruc(instruc),
    .immediate_o(imm)
);

alu_controller alu_controller_inst(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7bit5(funct7bit5),
    .alu_control_o(alu_control)
);

alu alu_inst(
    .in_1(alu_in_a),
    .in_2(alu_in_b),
    .alu_control(alu_control),
    .alu_out(alu_o)
);

branch_comparator branch_comparator_inst(
    .rs1_d(rs1_d),
    .rs2_d(rs2_d),
    .funct3(funct3),
    .branch_taken(branch_taken)
);

d_mem d_mem_inst(
    .clk(clk),
    .addr(alu_o),
    .wr_d(rs2_d),
    .wr_en(mem_wr),
    .rd_en(mem_rd),
    .d_mem_rd_d(d_mem_rd_d)
);

endmodule