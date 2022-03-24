//---------------------------------------------------------------------
//               Copyright(c) Synopsys, Inc.                           
//     All Rights reserved - Unpublished -rights reserved under        
//     the Copyright laws of the United States of America.             
//                                                                     
//  U.S. Patents: 7,093,156 B1 and 7,406,620 B2 (and more pending).    
//                                                                     
//  This file includes the Confidential information of Synopsys, Inc.  
//  and Huali.                                                         
//  The receiver of this Confidential Information shall not disclose   
//  it to any third party and shall protect its confidentiality by     
//  using the same degree of care, but not less than a reasonable      
//  degree of care, as the receiver uses to protect receiver's own     
//  Confidential Information.                                          
//  Licensee acknowledges and agrees that all output generated for     
//  Licensee by Synopsys, Inc. as described in the pertinent Program   
//  Schedule(s), or generated by Licensee through use of any Compiler  
//  licensed hereunder contains information that complies with the     
//  Virtual Component Identification Physical Tagging Standard (VCID)  
//  as maintained by the Virtual Socket Interface Alliance (VSIA).     
//  Such information may be expressed in GDSII Layer 63 or other such  
//  layer designated by the VSIA, hardware definition languages, or    
//  other formats.  Licensee is not authorized to alter or change any  
//  such information.                                                  
//---------------------------------------------------------------------
//                                                                     
//  Built for linux64 and running on linux64.                          
//                                                                     
//  Software           : Rev: S-2021.12                                
//  Library Format     : Rev: 1.05.00                                  
//  Compiler Name      : hu55npkb2p22sadsl512sa04                      
//  Platform           : Linux3.10.0-1160.49.1.el7.x86_64              
//                     : #1 SMP Tue Nov 30 15:51:32 UTC 2021x86_64     
//  Date of Generation : Thu Mar 17 14:58:05 CST 2022                  
//                                                                     
//---------------------------------------------------------------------
//   --------------------------------------------------------------     
//                       Template Revision : 3.6.3                      
//   --------------------------------------------------------------     
//                      * Synchronous, 2-Port SRAM *                  
//                      * Verilog Behavioral Model *                  
//                THIS IS A SYNCHRONOUS 2-PORT MEMORY MODEL           
//                                                                    
//   Memory Name:sadslspkb2p24x64m4b1w0cp0d0t0                        
//   Memory Size:24 words x 64 bits                                   
//                                                                    
//                               PORT NAME                            
//                               ---------                            
//               Output Ports                                         
//                                   QA[63:0]                         
//                                   QB[63:0]                         
//               Input Ports:                                         
//                                   ADRA[4:0]                        
//                                   DA[63:0]                         
//                                   WEA                              
//                                   MEA                              
//                                   CLKA                             
//                                   TEST1A                           
//                                   RMEA                             
//                                   RMA[3:0]                         
//                                   ADRB[4:0]                        
//                                   DB[63:0]                         
//                                   WEB                              
//                                   MEB                              
//                                   CLKB                             
//                                   TEST1B                           
//                                   RMEB                             
//                                   RMB[3:0]                         
// -------------------------------------------------------------------- 
`resetall 
`timescale 1 ns / 1 ps 
`celldefine 
`ifdef verifault // for fault simulation purpose 
`suppress_faults 
`enable_portfaults 
`endif 

`define True    1'b1
`define False   1'b0

module sadslspkb2p24x64m4b1w0cp0d0t0 ( QA, QB, ADRA, DA, WEA, MEA, CLKA, TEST1A, RMEA, RMA, ADRB, DB, WEB, MEB, CLKB, TEST1B, RMEB, RMB);

// Input/Output Ports Declaration
output  [63:0] QA;
output  [63:0] QB;
input  [4:0] ADRA;
input  [63:0] DA;
input WEA;
input MEA;
input CLKA;
input TEST1A;
input RMEA;
input  [3:0] RMA;
input  [4:0] ADRB;
input  [63:0] DB;
input WEB;
input MEB;
input CLKB;
input TEST1B;
input RMEB;
input  [3:0] RMB;


// Local registers, wires, etc
parameter PreloadFilename = "init.file";
`ifdef MEM_CHECK_OFF
parameter MES_ALL = "OFF";
`else
parameter MES_ALL = "ON";
`endif


wire [63:0] QA_tmp;
reg  [63:0] QA_reg;

always @(QA_tmp)
begin
  QA_reg <= QA_tmp;
end

assign QA = QA_reg;

wire [63:0] QB_tmp;
reg  [63:0] QB_reg;

always @(QB_tmp)
begin
  QB_reg <= QB_tmp;
end

assign QB = QB_reg;

generic_behav_sadslspkb2p24x64m4b1w0cp0d0t0 #( PreloadFilename, MES_ALL) u0 ( .QA(QA_tmp), .QB(QB_tmp), .ADRA(ADRA), .DA(DA), .WEA(WEA), .MEA(MEA), .CLKA(CLKA), .ADRB(ADRB), .DB(DB), .WEB(WEB), .MEB(MEB), .CLKB(CLKB) );

endmodule

`endcelldefine 
`ifdef verifault 
`disable_portfaults 
`nosuppress_faults 
`endif 


module generic_behav_sadslspkb2p24x64m4b1w0cp0d0t0 (  QA, QB, ADRA, DA, WEA, MEA, CLKA, ADRB, DB, WEB, MEB, CLKB );

parameter PreloadFilename = "init.file";
parameter MES_ALL = "ON";
parameter words = 24, bits = 64, addrbits = 5;

output [bits-1:0] QA;
output [bits-1:0] QB;
input [addrbits-1:0] ADRA;
input [bits-1:0] DA;
input WEA;
input MEA;
input CLKA;
input [addrbits-1:0] ADRB;
input [bits-1:0] DB;
input WEB;
input MEB;
input CLKB;

reg [bits-1:0] QA;
reg [bits-1:0] QB;

reg [addrbits-1:0] ADRAlatched;
reg MEAlatched;
reg WEAlatched;
reg [bits-1:0] DAlatched;

reg [addrbits-1:0] ADRBlatched;
reg MEBlatched;
reg WEBlatched;
reg [bits-1:0] DBlatched;


reg CLK_A_T, CLK_B_T;

reg flaga_clk_valid;
reg flagb_clk_valid;
reg mes_all_valid;

wire [1:0] ADRA_valid;
wire [1:0] ADRB_valid;
reg [63:0] mem_core_array [0:23];

parameter DataX = { bits { 1'bx } };

// -------------------------------------------------------------------
// Common tasks
// -------------------------------------------------------------------

// Task to report unknown messages
task report_unknown;
input [8*6:1] signal;
begin
    if( MES_ALL=="ON" && $realtime != 0 && mes_all_valid )
    begin
      $display("<<%0s unknown>> at time=%t; instance=%m (RAMS1H)",signal,$realtime);
    end
end
endtask


task corrupt_all_loc;
 input flag_range_ok;
 integer addr_index;
 begin
  if( flag_range_ok == `True)
   begin
    for( addr_index = 0; addr_index < words; addr_index = addr_index + 1) begin
     mem_core_array[ addr_index] = DataX;
    end
   end
 end
endtask


/////////////////////////////////////////////
/////Simultaneous Clock handling
/////////////////////////////////////////////

wire same_edge;

assign same_edge =  (CLK_A_T & CLK_B_T) ? 1'b1 : 1'b0;

always @( posedge same_edge)
begin : blk_same_edge
  if ((( ADRAlatched === ADRBlatched ) && (ADRA_valid == 2'b00)) && ( ^ADRAlatched !== 1'bx ) && ( ^ADRBlatched !== 1'bx ))
  begin
    if ( MEAlatched !== 1'b0 && MEBlatched !== 1'b0 )
    begin
      if ( WEAlatched !== 1'b0 && WEBlatched !== 1'b0 )
      begin
        mem_core_array[ADRAlatched] = DataX;
      end // end of A B port write
      else if ( WEAlatched !== 1'b0 )
      begin
        WritePortA;
        QB = DataX;
      end // end of write A
      else if ( WEBlatched !== 1'b0 )
      begin
        WritePortB;
        QA = DataX;
      end // end of write B
      else
      begin
        ReadPortA;
        ReadPortB;
      end // end of A B read
    end // end of if MEAlatched and MEBlatched
  end // end of if ADRA and ADRB
end // end of block blk_same_edge

initial 
begin
  flaga_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

assign ADRA_valid = (( ^ADRA === 1'bx ) ? 2'b01 : ( ( ADRA > 5'b10111 ) ? 2'b10 : 2'b00 ));

always @ ( negedge CLKA )
begin : blk_negedge_clk_0
  if ( CLKA !== 1'bx )
  begin
    flaga_clk_valid = `True;
  end // end if CLKA != X
  else
  begin
    report_unknown("CLKA");
    flaga_clk_valid = `False;
    QA = DataX;
    corrupt_all_loc(`True);
  end // end of else of CLKA != X
end // end of block blk_negedge_clk_0

always @ ( posedge CLKA )
begin : blk_posedge_clk_0
   ADRAlatched = ADRA;
   MEAlatched = MEA;
   WEAlatched = WEA;
   DAlatched = DA;
  if ( flaga_clk_valid )
  begin
    if ( CLKA === 1'b1)
    begin
      if ( MEA === 1'b1) 
      begin
        if ( WEA === 1'b1) 
        begin
          WritePortA;
        end // end of Write
        else if ( WEA === 1'b0 )
        begin
          ReadPortA;
        end // end of Read
        else
        begin
          report_unknown("WEA");
          mem_core_array[ADRA] = DataX;
          if ( ADRA_valid === 2'b00 ) 
          begin
            QA = DataX;
          end // end of if ADRA_valid = 2'b00
          else if ( ADRA_valid === 2'b01 ) 
          begin
            QA = DataX;
            corrupt_all_loc(`True);
          end // end of else of ADRA_valid = 2'b01
        end // end of else of WEA = X
      end // end of MEA = 1
      else
      begin
        if ( MEA === 1'bx ) 
        begin
          report_unknown("MEA");
          `ifdef virage_ignore_read_addrx
            if ( WEA === 1'b1 )
            begin
              corrupt_all_loc(`True);
            end
            else
            begin
              QA = 64'bx;
            end
          `else
            begin
              corrupt_all_loc(`True);
              if ( WEA === 1'b0 )
              begin
                QA = 64'bx;
              end
            end
          `endif
        end // end of if MEA = X
      end // end of else of MEA = 1
      CLK_A_T = 1;
      #2.181
      CLK_A_T = 0;
    end // end of if CLKA = 1
    else 
    begin
      if ( CLKA === 1'bx ) 
      begin
        report_unknown("CLKA");
        QA = DataX;
        corrupt_all_loc(`True);
      end // end of if CLKA = 1'bx
    end // end of else of CLKA = 1
  end // end of if flaga_clk_valid = 1
  else 
  begin
    QA = DataX;
    corrupt_all_loc(`True);
  end // end of else of flaga_clk_valid = 1
end // end of block blk_posedge_clk_0

task WritePortA;
begin : blk_WritePortA
  if ( ADRA_valid === 2'b00 )
  begin
    mem_core_array[ADRA] = DA;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
    if ( ^DA === 1'bx )
    begin
      report_unknown("DA");
    end
  end // end of if ADRA_valid = 2'b00
  else if (ADRA_valid === 2'b10 )
  begin
    if ( MES_ALL == "ON" && $realtime != 0 && mes_all_valid )
    begin
      $display("<<WARNING:address is out of range\n RANGE:0 to 23>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid 
  end // end of else of ADRA_valid = 2'b10
  else 
  begin
    report_unknown("ADRA");
    corrupt_all_loc(`True);
  end // end of else of ADRA_valid = 2'b01
end // end of block blk_WritePortA
endtask

task ReadPortA;
begin : blk_ReadPortA
  if ( ADRA_valid === 2'b00 )
  begin
    QA = mem_core_array[ADRAlatched];
  end // end of if ADRA_valid = 2'b00
  else if ( ADRA_valid === 2'b10 )
  begin
    QA = DataX;
    if ( MES_ALL == "ON" && $realtime != 0 && mes_all_valid )
    begin
      $display("<<WARNING:address is out of range\n RANGE:0 to 23>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid
  end // end of else of ADRA_valid = 2'b10
  else 
  begin
    report_unknown("ADRA");
    QA = DataX;
    `ifdef virage_ignore_read_addrx
      if ( WEA === 1'b1 )
        corrupt_all_loc(`True);
    `else
        corrupt_all_loc(`True);
    `endif
  end // end of else of ADRA_valid = 2'b01
end // end of block blk_ReadPortA
endtask

initial 
begin
  flagb_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

assign ADRB_valid = (( ^ADRB === 1'bx ) ? 2'b01 : ( ( ADRB > 5'b10111 ) ? 2'b10 : 2'b00 ));

always @ ( negedge CLKB )
begin : blk_negedge_clk_1
  if ( CLKB !== 1'bx )
  begin
    flagb_clk_valid = `True;
  end // end if CLKB != X
  else
  begin
    report_unknown("CLKB");
    flagb_clk_valid = `False;
    QB = DataX;
    corrupt_all_loc(`True);
  end // end of else of CLKB != X
end // end of block blk_negedge_clk_1

always @ ( posedge CLKB )
begin : blk_posedge_clk_1
   ADRBlatched = ADRB;
   MEBlatched = MEB;
   WEBlatched = WEB;
   DBlatched = DB;
  if ( flagb_clk_valid )
  begin
    if ( CLKB === 1'b1)
    begin
      if ( MEB === 1'b1) 
      begin
        if ( WEB === 1'b1) 
        begin
          WritePortB;
        end // end of Write
        else if ( WEB === 1'b0 )
        begin
          ReadPortB;
        end // end of Read
        else
        begin
          report_unknown("WEB");
          mem_core_array[ADRB] = DataX;
          if ( ADRB_valid === 2'b00 ) 
          begin
            QB = DataX;
          end // end of if ADRB_valid = 2'b00
          else if ( ADRB_valid === 2'b01 ) 
          begin
            QB = DataX;
            corrupt_all_loc(`True);
          end // end of else of ADRB_valid = 2'b01
        end // end of else of WEB = X
      end // end of MEB = 1
      else
      begin
        if ( MEB === 1'bx ) 
        begin
          report_unknown("MEB");
          `ifdef virage_ignore_read_addrx
            if ( WEB === 1'b1 )
            begin
              corrupt_all_loc(`True);
            end
            else
            begin
              QB = 64'bx;
            end
          `else
            begin
              corrupt_all_loc(`True);
              if ( WEB === 1'b0 )
              begin
                QB = 64'bx;
              end
            end
          `endif
        end // end of if MEB = X
      end // end of else of MEB = 1
      CLK_B_T = 1;
      #2.181
      CLK_B_T = 0;
    end // end of if CLKB = 1
    else 
    begin
      if ( CLKB === 1'bx ) 
      begin
        report_unknown("CLKB");
        QB = DataX;
        corrupt_all_loc(`True);
      end // end of if CLKB = 1'bx
    end // end of else of CLKB = 1
  end // end of if flagb_clk_valid = 1
  else 
  begin
    QB = DataX;
    corrupt_all_loc(`True);
  end // end of else of flagb_clk_valid = 1
end // end of block blk_posedge_clk_1

task WritePortB;
begin : blk_WritePortB
  if ( ADRB_valid === 2'b00 )
  begin
    mem_core_array[ADRB] = DB;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
    if ( ^DB === 1'bx )
    begin
      report_unknown("DB");
    end
  end // end of if ADRB_valid = 2'b00
  else if (ADRB_valid === 2'b10 )
  begin
    if ( MES_ALL == "ON" && $realtime != 0 && mes_all_valid )
    begin
      $display("<<WARNING:address is out of range\n RANGE:0 to 23>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid 
  end // end of else of ADRB_valid = 2'b10
  else 
  begin
    report_unknown("ADRB");
    corrupt_all_loc(`True);
  end // end of else of ADRB_valid = 2'b01
end // end of block blk_WritePortB
endtask

task ReadPortB;
begin : blk_ReadPortB
  if ( ADRB_valid === 2'b00 )
  begin
    QB = mem_core_array[ADRBlatched];
  end // end of if ADRB_valid = 2'b00
  else if ( ADRB_valid === 2'b10 )
  begin
    QB = DataX;
    if ( MES_ALL == "ON" && $realtime != 0 && mes_all_valid )
    begin
      $display("<<WARNING:address is out of range\n RANGE:0 to 23>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid
  end // end of else of ADRB_valid = 2'b10
  else 
  begin
    report_unknown("ADRB");
    QB = DataX;
    `ifdef virage_ignore_read_addrx
      if ( WEB === 1'b1 )
        corrupt_all_loc(`True);
    `else
        corrupt_all_loc(`True);
    `endif
  end // end of else of ADRB_valid = 2'b01
end // end of block blk_ReadPortB
endtask

endmodule
