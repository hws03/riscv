//workout next pc 


module pc(
    input logic[31:0] pc,
    input logic[31:0] imm,
    input logic[31:0] alu_result,
    input logic branch_taken,
    input logic branch,
    input logic jump,
    input logic jalr,
    
    output logic[31:0] pc4,
    output logic[31:0] pc_next
);

assign pc4 = pc + 32'd4;

always_comb begin
    pc_next = pc4;
    
    
    if (jalr) begin
        pc_next = {alu_result[31:1], 1'b0};
    end
    
    
    else if (branch_taken && branch) begin
        pc_next = pc + imm;
    end
    
    else if (jump) begin
        pc_next = pc + imm;  //j-type immediate
    end
    

end

endmodule
