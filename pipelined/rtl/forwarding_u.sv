module forwarding_u(
    input logic[4:0] execute_rs1,
    input logic[4:0] execute_rs2,
    input logic[4:0] memory_rd,
    input logic memory_is_writeenable, //memory stage is currently write enable
    input logic[4:0] writeback_rd,
    input logic wb_is_writeenable, //writeback stage is currently write enable
    
    output logic[1:0] forward_active_1,
    output logic[1:0] forward_active_2
);

always_comb begin

    forward_active_1 = 2'b00;
    forward_active_2 = 2'b00;

    //forward_active 1 (rs1)
    if ( (memory_is_writeenable) && (memory_rd==execute_rs1) && (memory_rd != '0) ) begin
        forward_active_1 = 2'b01;
    end
    else if ( (wb_is_writeenable) && (writeback_rd==execute_rs1) && (writeback_rd != '0) ) begin
        forward_active_1 = 2'b10;
    end
    
    //forward_active 2 (rs2)
    if ( (memory_is_writeenable) && (memory_rd==execute_rs2) && (memory_rd != '0) ) begin
        forward_active_2 = 2'b01;
    end
    else if ( (wb_is_writeenable) && (writeback_rd==execute_rs2) && (writeback_rd != '0) ) begin
        forward_active_2 = 2'b10;
    end
    
end

endmodule
