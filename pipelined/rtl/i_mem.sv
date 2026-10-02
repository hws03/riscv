module i_mem(
    input logic clk,
    input logic prog_we,
    input logic[4:0] prog_addr,
    input logic[31:0] prog_data,
    input logic[31:0] pc_addr,
    
    output logic[31:0] instruc
);


logic[31:0] instruction_memory[0:31];


assign instruc = instruction_memory[pc_addr[6:2]];


integer i;
initial begin
    for (int i=0; i<32; i++) begin
        instruction_memory[i] = 32'b00000000000000000000000000010011; //nops
    end 

    $readmemh("program_to_run.mem", instruction_memory);

end


always_ff @(posedge clk) begin
    if (prog_we)
        instruction_memory[prog_addr] <= prog_data;
end


endmodule