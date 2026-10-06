//parameterised pipeline register reused between stages in core.sv


module pipeline_reg #(
    parameter WIDTH = 32
)(
    input logic clk,
    input logic enable,
    input logic reset,
//    input logic stall,
    input logic flush,
    input logic[WIDTH-1:0] regi,
    
    output logic[WIDTH-1:0] rego
);


always_ff @(posedge clk) begin
    if(reset) begin
        rego <= '0;
    end
    else if (flush) begin
        rego <= '0;
    end
//    else if (stall) begin
//        rego <= rego;
//    end
    else if (enable) begin
        rego <= regi;
    end
end

endmodule
