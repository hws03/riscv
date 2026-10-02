module d_mem(
    input logic clk,
    input logic[31:0] addr,
    input logic[31:0] wr_d,
    input logic wr_en,
    input logic rd_en,

    output logic[31:0] d_mem_rd_d
);

logic[31:0] data_memory[0:31];


integer i;
initial begin
    for (int i=0; i<32; i++) begin
        data_memory[i] = '0;
    end 
end


always_ff @(posedge clk) begin
    if (wr_en) begin
        data_memory[addr[6:2]] <= wr_d;
    end    
end

assign d_mem_rd_d = data_memory[addr[6:2]];

endmodule