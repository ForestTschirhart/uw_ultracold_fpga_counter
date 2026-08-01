module counter (
    input wire hclkin,
    output wire overflow
);

// clock division front end is super helpful here
CLKDIV clkdiv_inst (
    .HCLKIN(hclkin),
    .RESETN(1'b1),
    .CALIB(1'b0),
    .CLKOUT(clk)
);
defparam clkdiv_inst.DIV_MODE="8";
defparam clkdiv_inst.GSREN="false";


wire [29:0] counter; 
reg [25:0] ms_bits = 26'd0; // 26 bits
reg [3:0] ls_bits = 4'd0;   // 4 bits (only counts 0 to 15)

// pipeline register to fix fan-out related slack issue 
// and also to allow for 1 cycle between the enable bit being asserted and the msb reg being updated
// note that this will not cause skipped counting, just a phase shift. 
reg ms_en_pipe = 1'b0; 

// fast single-cycle path at 300 MHz
always @(posedge clk) begin
    ls_bits <= ls_bits + 4'd1;           // 4-bit math is fast enough for 3.33ns
    ms_en_pipe <= (ls_bits == 4'd15);    // calculate enable and store it in the pipeline
end

// slow multi-cycle path
always @(posedge clk) begin
    if (ms_en_pipe) begin
        ms_bits <= ms_bits + 26'd1;
    end
end 


// placeholder code for what to do with the signal once it is sucessfully divided down
assign counter = {ms_bits, ls_bits}; 
assign overflow = counter[29];

endmodule