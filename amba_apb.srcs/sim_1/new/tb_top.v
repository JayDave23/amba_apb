`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2025 10:34:17
// Design Name: 
// Module Name: tb_top
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


module tb_top#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter READY_DELAY = 2 //wait length
)();

    reg PCLK;
    reg PRESETn;
    reg PWRITE;
    reg PENABLE;
    reg [7:0] PADDR;
    reg [31:0] PWDATA;
    wire PREADY;
    wire PSLVERR;
    wire [31:0] PRDATA;
    
    initial PCLK = 0;
    always #5 PCLK = ~PCLK;

    top dut (.PCLK(PCLK),.PRESETn(PRESETn),.PADDR(PADDR),.PWDATA(PWDATA),.PWRITE(PWRITE),.PENABLE(PENABLE),.PRDATA(PRDATA),.PREADY(PREADY),.PSLVERR(PSLVERR));

    task apb_write(input [7:0] addr, input [31:0] data);
        begin
            @(posedge PCLK);
            PADDR   <= addr;
            PWDATA  <= data;
            PWRITE  <= 1;
            PENABLE <= 0;
            @(posedge PCLK);
            PENABLE <= 1;
            wait (PREADY);
            @(posedge PCLK);
            PENABLE <= 0;
            PWRITE  <= 0;
        end
    endtask

    task apb_read(input [7:0] addr);
        begin
            @(posedge PCLK);
            PADDR   <= addr;
            PWRITE  <= 0;
            PENABLE <= 0;
            @(posedge PCLK);
            PENABLE <= 1;
            wait (PREADY);
            @(posedge PCLK);
            PENABLE <= 0;
        end
    endtask

    initial begin
        PADDR   = 0;
        PWDATA  = 0;
        PWRITE  = 0;
        PENABLE = 0;
        PRESETn = 0;
        
        repeat (2) @(posedge PCLK);
        PRESETn = 1;

        // Writing first slave
        apb_write(8'h00, 32'hABCDEF11);
        #10;

        // Reading the same from first slave
        apb_read(8'h00);
        #10;

        // Writing to second salve 
        apb_write(8'h10, 32'h11FEDCBA);
        #10;

        // Reading the same from second slave
        apb_read(8'h10);
        #10;
        
        #10 $finish;
    end


endmodule
