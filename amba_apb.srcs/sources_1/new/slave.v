`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2025 09:37:52
// Design Name: 
// Module Name: slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slave #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter READY_DELAY = 2 //wait length
)(PCLK, PRESETn, PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY, PSLVERR);
    
    input PCLK,PRESETn,PWRITE,PSEL,PENABLE;
    input [ADDR_WIDTH-1:0] PADDR;
    input [DATA_WIDTH-1:0] PWDATA;
    
    output reg PREADY,PSLVERR;
    output reg [DATA_WIDTH-1:0] PRDATA;
    
    reg [DATA_WIDTH-1:0] reg_file [0:3];
    reg [$clog2(READY_DELAY+1)-1:0] wait_counter;
    wire [1:0] reg_index = PADDR[3:2];
    reg wait_active;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
        //setting everything to 0 when reset is active (active low)
            reg_file[0] <= 0;
            reg_file[1] <= 0;
            reg_file[2] <= 0;
            reg_file[3] <= 0;
            PRDATA      <= 0;
            PREADY      <= 0;
            PSLVERR     <= 0;
            wait_counter <= 0;
            wait_active <= 0;
        end else begin
            PSLVERR <= 0;

            if (PSEL && PENABLE && !PREADY) begin
                //wait state logic
                if (!wait_active) begin
                    //starting wait state if it hasnt started
                    wait_active <= 1;
                    wait_counter <= READY_DELAY - 1; //starting wait counter
                end else if (wait_counter != 0) begin
                    wait_counter <= wait_counter - 1;
                end else begin
                    wait_active <= 0;
                    PREADY <= 1;

                    // Perform transfer
                    if (PWRITE) begin
                        reg_file[reg_index] <= PWDATA;
                    end else begin
                        PRDATA <= reg_file[reg_index];
                    end
                end
            end else begin
                PREADY <= 0;
                wait_active <= 0;
                wait_counter <= 0;
            end
        end
    end

endmodule
