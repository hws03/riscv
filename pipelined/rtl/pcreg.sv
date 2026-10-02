module pcreg(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic[31:0] pc_next,
    
    output logic[31:0] pc
);


always_ff @(posedge clk) begin
    if (reset) begin
        pc <= '0;
    end
    else begin
        if (enable) begin
            pc <= pc_next;
        end
        else begin
            pc <= pc;
        end
    end
end

endmodule