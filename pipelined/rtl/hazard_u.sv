//detects if a load if followed by an isntruction that uses its result, if so, stalls


module hazard_u(
    input logic[4:0] decode_rs1,
    input logic[4:0] decode_rs2,
    input logic[4:0] execute_rd,
    input logic execute_is_load, //tells us if instruction in execute is a load
    
    output logic hazard_stall
);

always_comb begin
    hazard_stall = 0;
    
    if (execute_is_load) begin
        //check if execute data reg is equal to either decode rs1 or decode  rs2 in fetch/decode stage
        if ( (execute_rd == decode_rs1 && execute_rd != 0) || (execute_rd == decode_rs2 && execute_rd != 0) ) begin 
            hazard_stall = 1;
        end 
        
        else begin
            hazard_stall = 0;
        end
    
    end
end

endmodule
