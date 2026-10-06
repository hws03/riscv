module regfile(
    input logic clk,
    input logic[4:0] rs1,
    input logic[4:0] rs2,
    input logic[4:0] rd,
    input logic[31:0] rd_d,
    input logic reg_write,
    
    output logic[31:0] rs1_d,
    output logic[31:0] rs2_d
);

logic[31:0] register[0:31];


integer i;
initial begin
    for (int i=0; i<32; i++) begin
        register[i] = '0;
    end 
end


//read
assign rs1_d = (rs1=='0) ? '0 : register[rs1]; //read rs1
assign rs2_d = (rs2=='0) ? '0 : register[rs2]; //read rs2


//write on negative edge so writeback stage write lands midcycle and decode reads the new value in the same cycle
always_ff @(negedge clk) begin
    if (reg_write && (rd != '0)) begin
        register[rd] <= rd_d; //write
    end
end

endmodule
