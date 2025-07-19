`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2025 10:03:55
// Design Name: 
// Module Name: top
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


module top #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter READY_DELAY = 2 //wait length
)(PCLK ,PRESETn ,PADDR ,PWDATA ,PWRITE ,PENABLE ,PRDATA ,PREADY ,PSLVERR);

    input PCLK,PRESETn,PWRITE,PENABLE;
    input [ADDR_WIDTH-1:0] PADDR;
    input [DATA_WIDTH-1:0] PWDATA;
    
    output PREADY,PSLVERR;
    output [DATA_WIDTH-1:0] PRDATA;

    wire PSEL0, PSEL1;
    wire [DATA_WIDTH-1:0] prdata0, prdata1;
    wire pready0, pready1;
    wire pslverr0, pslverr1;

    assign PSEL0 = (PADDR[7:4] == 4'h0);
    assign PSEL1 = (PADDR[7:4] == 4'h1); 

    slave slave1 (.PCLK(PCLK), .PRESETn(PRESETn),.PADDR(PADDR), .PWDATA(PWDATA),.PWRITE(PWRITE), .PSEL(PSEL0), .PENABLE(PENABLE),.PRDATA(prdata0),.PREADY(pready0),.PSLVERR(pslverr0));
    slave slave2 (.PCLK(PCLK), .PRESETn(PRESETn),.PADDR(PADDR), .PWDATA(PWDATA),.PWRITE(PWRITE), .PSEL(PSEL1), .PENABLE(PENABLE),.PRDATA(prdata1),.PREADY(pready1),.PSLVERR(pslverr1));

    assign PRDATA   = PSEL0 ? prdata0   : prdata1  ;
    assign PREADY   = PSEL0 ? pready0   : pready1  ;
    assign PSLVERR  = PSEL0 ? pslverr0  : pslverr1 ;

endmodule
