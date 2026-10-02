`timescale 1ns / 1ps

module hazard_u_tb;


logic[4:0] decode_rs1;
logic[4:0] decode_rs2;
logic[4:0] execute_rd;
logic execute_is_load; //tells us if instruction in execute is a load
logic hazard_stall;


hazard_u uut(
    .decode_rs1(decode_rs1),
    .decode_rs2(decode_rs2),
    .execute_rd(execute_rd),
    .execute_is_load(execute_is_load),
    .hazard_stall(hazard_stall)
);

task automatic hazard_u_test(input expected_hazard_stall);
    #1;
    assert (hazard_stall == expected_hazard_stall) 
        $display("Pass");
    else 
        $error("Fail");
endtask


//tests
initial begin
   
    //rs1=rd and execute stage is a load
    decode_rs1 = 4'd2;
    decode_rs2 = 4'd4;
    execute_rd = 4'd2;
    execute_is_load = 1'b1; 
    hazard_u_test(1'b1);
   
    //rs2=rd and execute stage is a load
    decode_rs1 = 4'd2;
    decode_rs2 = 4'd4;
    execute_rd = 4'd4;
    execute_is_load = 1'b1; 
    hazard_u_test(1'b1);
    
    //rs1 and rs2 !=rd and execute stage is a load
    decode_rs1 = 4'd2;
    decode_rs2 = 4'd2;
    execute_rd = 4'd4;
    execute_is_load = 1'b1; 
    hazard_u_test(1'b0);  
    
    //rs1 and rs2 !=rd and execute stage is NOT a load
    decode_rs1 = 4'd2;
    decode_rs2 = 4'd4;
    execute_rd = 4'd4;
    execute_is_load = 1'b0; 
    hazard_u_test(1'b0);
    
    //rs2=rd and execute stage is NOT a load
    decode_rs1 = 4'd2;
    decode_rs2 = 4'd4;
    execute_rd = 4'd4;
    execute_is_load = 1'b0; 
    hazard_u_test(1'b0);
    
    $finish;

end

endmodule