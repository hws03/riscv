module core(
    input logic clk,
    input logic reset,
    input logic prog_we,
    input logic[4:0] prog_addr,
    input logic[31:0] prog_data,

    output logic[31:0] core_o
);

//feedback signals
logic hazard_stall;
logic pcsrc_ex;
logic[31:0] pc_target_ex;
logic[4:0] rd_ex;
logic mem_rd_ex;
logic[4:0] rd_mem;
logic reg_write_mem;
logic[31:0] alu_o_mem;
logic[4:0] rd_wb;
logic reg_write_wb;
logic[31:0] wb_data;


   ////////////////////////


//fetch stage
logic[31:0] pc_if;
logic[31:0] pc_plus4_if;
logic[31:0] pc_next_if;
logic[31:0] instruc_if;

assign pc_plus4_if = pc_if + 32'd4;
assign pc_next_if = pcsrc_ex ? pc_target_ex : pc_plus4_if;

pcreg pcreg_inst(
    .clk(clk),
    .reset(reset),
    .enable(~hazard_stall),
    .pc_next(pc_next_if),
    .pc(pc_if)
);

i_mem i_mem_inst(
    .clk(clk),
    .prog_we(prog_we),
    .prog_addr(prog_addr),
    .prog_data(prog_data),
    .pc_addr(pc_if),
    .instruc(instruc_if)
);

   ////////////////////////

//decode stage
logic[31:0] pc_id;
logic[31:0] instruc_id;
logic[6:0] opcode_id;
logic[4:0] rd_id;
logic[4:0] rs1_id;
logic[4:0] rs2_id;
logic[2:0] funct3_id;
logic funct7bit5_id;
logic[31:0] rs1_d_id;
logic[31:0] rs2_d_id;
logic[31:0] imm_id;
logic reg_write_id;
logic alu_src_id;
logic mem_wr_id;
logic mem_rd_id;
logic branch_id;
logic jump_id;
logic jalr_id;
logic[1:0] alu_op_id;
logic[1:0] wb_sel_id;
logic[1:0] alua_sel_id;

//fetch decode pipline register
pipeline_reg #( .WIDTH(64) ) if_id_reg( //width = 64 (pc_if : 32, pc_id : 32)
    .clk(clk),
    .enable(~hazard_stall),
    .reset(reset),
    .flush(pcsrc_ex),
    .regi({pc_if, instruc_if}),
    .rego({pc_id, instruc_id})
);

assign opcode_id = instruc_id[6:0];
assign rd_id = instruc_id[11:7];
assign funct3_id = instruc_id[14:12];
assign rs1_id = instruc_id[19:15];
assign rs2_id = instruc_id[24:20];
assign funct7bit5_id = instruc_id[30];

decoder decoder_inst(
    .opcode(opcode_id),
    .reg_write(reg_write_id),
    .alu_src(alu_src_id),
    .mem_wr(mem_wr_id),
    .mem_rd(mem_rd_id),
    .branch(branch_id),
    .jump(jump_id),
    .jalr(jalr_id),
    .alu_op(alu_op_id),
    .wb_sel(wb_sel_id),
    .alua_sel(alua_sel_id)
);

regfile reg_file_inst(
    .clk(clk),
    .rs1(rs1_id),
    .rs2(rs2_id),
    .rd(rd_wb),
    .rd_d(wb_data),
    .reg_write(reg_write_wb),
    .rs1_d(rs1_d_id),
    .rs2_d(rs2_d_id)
);

immediate immediate_inst(
    .instruc(instruc_id),
    .immediate_o(imm_id)
);

hazard_u hazard_u_inst(
    .decode_rs1(rs1_id),
    .decode_rs2(rs2_id),
    .execute_rd(rd_ex),
    .execute_is_load(mem_rd_ex),
    .hazard_stall(hazard_stall)
);

   ////////////////////////


//execute stage
logic[31:0] pc_ex;
logic[31:0] rs1_d_ex;
logic[31:0] rs2_d_ex;
logic[31:0] imm_ex;
logic[4:0] rs1_ex;
logic[4:0] rs2_ex;
logic[2:0] funct3_ex;
logic funct7bit5_ex;
logic reg_write_ex;
logic alu_src_ex;
logic mem_wr_ex;
logic branch_ex;
logic jump_ex;
logic jalr_ex;
logic[1:0] alu_op_ex;
logic[1:0] wb_sel_ex;
logic[1:0] alua_sel_ex;
logic[1:0] forward_a_sel;
logic[1:0] forward_b_sel;
logic[31:0] src_a_ex;
logic[31:0] src_b_ex;
logic[31:0] alu_in_a;
logic[31:0] alu_in_b;
logic[31:0] alu_o_ex;
logic[3:0] alu_control_ex;
logic branch_taken_ex;
logic[31:0] pc4_ex;

//decode execute pipeline register
pipeline_reg #( .WIDTH(160) ) id_ex_reg( //width = 160 (pc_id: 32, rs1_d_id: 32, rs2_d_id: 32, imm_id: 32, rs1_id: 5, rs2_id: 5, rd_id: 5, funct3_id: 3, funct7bit5_id: 1 reg_write_id: 1, alu_src_id: 1, mem_wr_id: 1, mem_rd_id: 1, branch_id: 1, jump_id: 1, jalr_id: 1, alu_op_id: 2, wb_sel_id: 2, alua_sel_id: 2)
    .clk(clk),
    .enable(1'b1),
    .reset(reset),
    .flush(hazard_stall | pcsrc_ex),
    .regi({pc_id, rs1_d_id, rs2_d_id, imm_id, rs1_id, rs2_id, rd_id, funct3_id, funct7bit5_id, reg_write_id, alu_src_id, mem_wr_id, mem_rd_id, branch_id, jump_id, jalr_id, alu_op_id, wb_sel_id, alua_sel_id}),
    .rego({pc_ex, rs1_d_ex, rs2_d_ex, imm_ex, rs1_ex, rs2_ex, rd_ex, funct3_ex, funct7bit5_ex, reg_write_ex, alu_src_ex, mem_wr_ex, mem_rd_ex, branch_ex, jump_ex, jalr_ex, alu_op_ex, wb_sel_ex, alua_sel_ex})
);

forwarding_u forward_u_inst(
    .execute_rs1(rs1_ex),
    .execute_rs2(rs2_ex),
    .memory_rd(rd_mem),
    .memory_is_writeenable(reg_write_mem),
    .writeback_rd(rd_wb),
    .wb_is_writeenable(reg_write_wb),
    .forward_active_1(forward_a_sel),
    .forward_active_2(forward_b_sel)
);



   ////////////////////////


//forwarding muxes, 00 regfile value, 01 ex/mem alu result, 10 wb data
always_comb begin

    case (forward_a_sel)
        2'b01: src_a_ex = alu_o_mem;
        2'b10: src_a_ex = wb_data;
        default: src_a_ex = rs1_d_ex;
    endcase
    
    case (forward_b_sel)
        2'b01: src_b_ex = alu_o_mem;
        2'b10: src_b_ex = wb_data;
        default: src_b_ex = rs2_d_ex;
    endcase
end


//alu input a, forwarded rs1 or pc for auipc or zero for lui
always_comb begin
    case (alua_sel_ex)
        2'b01:   alu_in_a = pc_ex;
        2'b10:   alu_in_a = '0;
        default: alu_in_a = src_a_ex;
    endcase
end


//alu input b, immediate or forwarded rs2
assign alu_in_b = alu_src_ex ? imm_ex : src_b_ex;

alu_controller alu_controller_inst(
    .alu_op(alu_op_ex),
    .funct3(funct3_ex),
    .funct7bit5(funct7bit5_ex),
    .alu_control_o(alu_control_ex)
);

alu alu_inst(
    .in_1(alu_in_a),
    .in_2(alu_in_b),
    .alu_control(alu_control_ex),
    .alu_out(alu_o_ex)
);

branch_comparator branch_comparator_inst(
    .rs1_d(src_a_ex),
    .rs2_d(src_b_ex),
    .funct3(funct3_ex),
    .branch_taken(branch_taken_ex)
);

pc pc_inst(
    .pc(pc_ex),
    .imm(imm_ex),
    .alu_result(alu_o_ex),
    .branch_taken(branch_taken_ex),
    .branch(branch_ex),
    .jump(jump_ex),
    .jalr(jalr_ex),
    .pc4(pc4_ex),
    .pc_next(pc_target_ex)
);

assign pcsrc_ex = jalr_ex | jump_ex | (branch_ex & branch_taken_ex);
assign core_o = alu_o_ex;


   ////////////////////////


//memory stage
logic[31:0] store_d_mem;
logic[31:0] pc4_mem;
logic mem_wr_mem;
logic mem_rd_mem;
logic[1:0] wb_sel_mem;
logic[31:0] d_mem_rd_d_mem;

//execute memory pipeline register
pipeline_reg #(.WIDTH(106)) ex_mem_reg( //width = 106 (alu_o_ex: 32, src_b_ex: 32, pc4_ex: 32, rd_ex: 5, reg_write_ex: 1, mem_wr_ex: 1, mem_rd_ex: 1, wb_sel_ex: 2)
    .clk(clk),
    .enable(1'b1),
    .reset(reset),
    .flush(1'b0),
    .regi({alu_o_ex, src_b_ex, pc4_ex, rd_ex, reg_write_ex, mem_wr_ex, mem_rd_ex, wb_sel_ex}),
    .rego({alu_o_mem, store_d_mem, pc4_mem, rd_mem, reg_write_mem, mem_wr_mem, mem_rd_mem, wb_sel_mem})
);

d_mem d_mem_inst(
    .clk(clk),
    .addr(alu_o_mem),
    .wr_d(store_d_mem),
    .wr_en(mem_wr_mem),
    .rd_en(mem_rd_mem),
    .d_mem_rd_d(d_mem_rd_d_mem)
);


   ////////////////////////


//writeback stage
logic[31:0] alu_o_wb;
logic[31:0] d_mem_rd_d_wb;
logic[31:0] pc4_wb;
logic[1:0] wb_sel_wb;

//memory writeback pipeline register
pipeline_reg #(.WIDTH(104)) mem_wb_reg( ////width = 104: (alu_o_mem: 32, d_mem_rd_d_mem: 32, pc4_mem: 32, rd_mem: 5, reg_write_mem: 1, wb_sel_mem: 2)
    .clk(clk),
    .enable(1'b1),
    .reset(reset),
    .flush(1'b0),
    .regi({alu_o_mem, d_mem_rd_d_mem, pc4_mem, rd_mem, reg_write_mem, wb_sel_mem}),
    .rego({alu_o_wb, d_mem_rd_d_wb, pc4_wb, rd_wb, reg_write_wb, wb_sel_wb})
);

//write back mux
always_comb begin
    case (wb_sel_wb)
        2'b00:   wb_data = alu_o_wb;
        2'b01:   wb_data = d_mem_rd_d_wb;
        2'b10:   wb_data = pc4_wb;
        default: wb_data = '0;
    endcase
end

endmodule