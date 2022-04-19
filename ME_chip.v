module ME_chip(clk,rst,en_i,cur_in_i,ref_in_i,cur_read_en,ref_read_en,MSAD,MSAD_column,MSAD_row,data_valid);

input clk;
input rst;
input en_i;
input [31:0] cur_in_i; //4pixels
input [63:0] ref_in_i; //8pixels
output cur_read_en;
output ref_read_en;
output [13:0] MSAD;
output [4:0] MSAD_column;
output [4:0] MSAD_row ;
output data_valid;


wire net_clk;
wire net_rst;
wire net_en_i;
wire [31:0] net_cur_in_i;
wire [63:0] net_ref_in_i;
wire net_cur_read_en;
wire net_ref_read_en;
wire net_data_valid;
wire [13:0] net_MSAD;
wire [4:0] net_MSAD_column;
wire [4:0] net_MSAD_row;

HPDWUW1416DGP
	HPDWUW1416DGP_clk(.PAD(clk), .C(net_clk), .IE(1'b1)),
	HPDWUW1416DGP_rst(.PAD(rst), .C(net_rst), .IE(1'b1)),
	HPDWUW1416DGP_en_i(.PAD(en_i), .C(net_en_i), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i0(.PAD(cur_in_i[0]), .C(net_cur_in_i[0]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i1(.PAD(cur_in_i[1]), .C(net_cur_in_i[1]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i2(.PAD(cur_in_i[2]), .C(net_cur_in_i[2]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i3(.PAD(cur_in_i[3]), .C(net_cur_in_i[3]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i4(.PAD(cur_in_i[4]), .C(net_cur_in_i[4]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i5(.PAD(cur_in_i[5]), .C(net_cur_in_i[5]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i6(.PAD(cur_in_i[6]), .C(net_cur_in_i[6]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i7(.PAD(cur_in_i[7]), .C(net_cur_in_i[7]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i8(.PAD(cur_in_i[8]), .C(net_cur_in_i[8]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i9(.PAD(cur_in_i[9]), .C(net_cur_in_i[9]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i10(.PAD(cur_in_i[10]), .C(net_cur_in_i[10]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i11(.PAD(cur_in_i[11]), .C(net_cur_in_i[11]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i12(.PAD(cur_in_i[12]), .C(net_cur_in_i[12]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i13(.PAD(cur_in_i[13]), .C(net_cur_in_i[13]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i14(.PAD(cur_in_i[14]), .C(net_cur_in_i[14]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i15(.PAD(cur_in_i[15]), .C(net_cur_in_i[15]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i16(.PAD(cur_in_i[16]), .C(net_cur_in_i[16]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i17(.PAD(cur_in_i[17]), .C(net_cur_in_i[17]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i18(.PAD(cur_in_i[18]), .C(net_cur_in_i[18]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i19(.PAD(cur_in_i[19]), .C(net_cur_in_i[19]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i20(.PAD(cur_in_i[20]), .C(net_cur_in_i[20]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i21(.PAD(cur_in_i[21]), .C(net_cur_in_i[21]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i22(.PAD(cur_in_i[22]), .C(net_cur_in_i[22]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i23(.PAD(cur_in_i[23]), .C(net_cur_in_i[23]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i24(.PAD(cur_in_i[24]), .C(net_cur_in_i[24]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i25(.PAD(cur_in_i[25]), .C(net_cur_in_i[25]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i26(.PAD(cur_in_i[26]), .C(net_cur_in_i[26]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i27(.PAD(cur_in_i[27]), .C(net_cur_in_i[27]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i28(.PAD(cur_in_i[28]), .C(net_cur_in_i[28]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i29(.PAD(cur_in_i[29]), .C(net_cur_in_i[29]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i30(.PAD(cur_in_i[30]), .C(net_cur_in_i[30]), .IE(1'b1)),
	HPDWUW1416DGP_cur_in_i31(.PAD(cur_in_i[31]), .C(net_cur_in_i[31]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i0(.PAD(ref_in_i[0]), .C(net_ref_in_i[0]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i1(.PAD(ref_in_i[1]), .C(net_ref_in_i[1]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i2(.PAD(ref_in_i[2]), .C(net_ref_in_i[2]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i3(.PAD(ref_in_i[3]), .C(net_ref_in_i[3]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i4(.PAD(ref_in_i[4]), .C(net_ref_in_i[4]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i5(.PAD(ref_in_i[5]), .C(net_ref_in_i[5]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i6(.PAD(ref_in_i[6]), .C(net_ref_in_i[6]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i7(.PAD(ref_in_i[7]), .C(net_ref_in_i[7]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i8(.PAD(ref_in_i[8]), .C(net_ref_in_i[8]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i9(.PAD(ref_in_i[9]), .C(net_ref_in_i[9]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i10(.PAD(ref_in_i[10]), .C(net_ref_in_i[10]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i11(.PAD(ref_in_i[11]), .C(net_ref_in_i[11]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i12(.PAD(ref_in_i[12]), .C(net_ref_in_i[12]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i13(.PAD(ref_in_i[13]), .C(net_ref_in_i[13]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i14(.PAD(ref_in_i[14]), .C(net_ref_in_i[14]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i15(.PAD(ref_in_i[15]), .C(net_ref_in_i[15]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i16(.PAD(ref_in_i[16]), .C(net_ref_in_i[16]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i17(.PAD(ref_in_i[17]), .C(net_ref_in_i[17]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i18(.PAD(ref_in_i[18]), .C(net_ref_in_i[18]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i19(.PAD(ref_in_i[19]), .C(net_ref_in_i[19]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i20(.PAD(ref_in_i[20]), .C(net_ref_in_i[20]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i21(.PAD(ref_in_i[21]), .C(net_ref_in_i[21]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i22(.PAD(ref_in_i[22]), .C(net_ref_in_i[22]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i23(.PAD(ref_in_i[23]), .C(net_ref_in_i[23]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i24(.PAD(ref_in_i[24]), .C(net_ref_in_i[24]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i25(.PAD(ref_in_i[25]), .C(net_ref_in_i[25]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i26(.PAD(ref_in_i[26]), .C(net_ref_in_i[26]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i27(.PAD(ref_in_i[27]), .C(net_ref_in_i[27]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i28(.PAD(ref_in_i[28]), .C(net_ref_in_i[28]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i29(.PAD(ref_in_i[29]), .C(net_ref_in_i[29]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i30(.PAD(ref_in_i[30]), .C(net_ref_in_i[30]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i31(.PAD(ref_in_i[31]), .C(net_ref_in_i[31]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i32(.PAD(ref_in_i[32]), .C(net_ref_in_i[32]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i33(.PAD(ref_in_i[33]), .C(net_ref_in_i[33]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i34(.PAD(ref_in_i[34]), .C(net_ref_in_i[34]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i35(.PAD(ref_in_i[35]), .C(net_ref_in_i[35]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i36(.PAD(ref_in_i[36]), .C(net_ref_in_i[36]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i37(.PAD(ref_in_i[37]), .C(net_ref_in_i[37]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i38(.PAD(ref_in_i[38]), .C(net_ref_in_i[38]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i39(.PAD(ref_in_i[39]), .C(net_ref_in_i[39]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i40(.PAD(ref_in_i[40]), .C(net_ref_in_i[40]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i41(.PAD(ref_in_i[41]), .C(net_ref_in_i[41]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i42(.PAD(ref_in_i[42]), .C(net_ref_in_i[42]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i43(.PAD(ref_in_i[43]), .C(net_ref_in_i[43]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i44(.PAD(ref_in_i[44]), .C(net_ref_in_i[44]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i45(.PAD(ref_in_i[45]), .C(net_ref_in_i[45]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i46(.PAD(ref_in_i[46]), .C(net_ref_in_i[46]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i47(.PAD(ref_in_i[47]), .C(net_ref_in_i[47]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i48(.PAD(ref_in_i[48]), .C(net_ref_in_i[48]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i49(.PAD(ref_in_i[49]), .C(net_ref_in_i[49]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i50(.PAD(ref_in_i[50]), .C(net_ref_in_i[50]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i51(.PAD(ref_in_i[51]), .C(net_ref_in_i[51]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i52(.PAD(ref_in_i[52]), .C(net_ref_in_i[52]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i53(.PAD(ref_in_i[53]), .C(net_ref_in_i[53]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i54(.PAD(ref_in_i[54]), .C(net_ref_in_i[54]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i55(.PAD(ref_in_i[55]), .C(net_ref_in_i[55]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i56(.PAD(ref_in_i[56]), .C(net_ref_in_i[56]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i57(.PAD(ref_in_i[57]), .C(net_ref_in_i[57]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i58(.PAD(ref_in_i[58]), .C(net_ref_in_i[58]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i59(.PAD(ref_in_i[59]), .C(net_ref_in_i[59]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i60(.PAD(ref_in_i[60]), .C(net_ref_in_i[60]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i61(.PAD(ref_in_i[61]), .C(net_ref_in_i[61]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i62(.PAD(ref_in_i[62]), .C(net_ref_in_i[62]), .IE(1'b1)),
	HPDWUW1416DGP_ref_in_i63(.PAD(ref_in_i[63]), .C(net_ref_in_i[63]), .IE(1'b1));

HPDWUW1416DGP
	HPDWUW1416DGP_cur_read_en(.PAD(cur_read_en), .I(net_cur_read_en), .OE(1'b1)),
	HPDWUW1416DGP_ref_read_en(.PAD(ref_read_en), .I(net_ref_read_en), .OE(1'b1)),
	HPDWUW1416DGP_data_valid(.PAD(data_valid), .I(net_data_valid), .OE(1'b1)),
	HPDWUW1416DGP_MSAD0(.PAD(MSAD[0]), .I(net_MSAD[0]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD1(.PAD(MSAD[1]), .I(net_MSAD[1]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD2(.PAD(MSAD[2]), .I(net_MSAD[2]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD3(.PAD(MSAD[3]), .I(net_MSAD[3]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD4(.PAD(MSAD[4]), .I(net_MSAD[4]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD5(.PAD(MSAD[5]), .I(net_MSAD[5]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD6(.PAD(MSAD[6]), .I(net_MSAD[6]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD7(.PAD(MSAD[7]), .I(net_MSAD[7]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD8(.PAD(MSAD[8]), .I(net_MSAD[8]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD9(.PAD(MSAD[9]), .I(net_MSAD[9]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD10(.PAD(MSAD[10]), .I(net_MSAD[10]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD11(.PAD(MSAD[11]), .I(net_MSAD[11]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD12(.PAD(MSAD[12]), .I(net_MSAD[12]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD13(.PAD(MSAD[13]), .I(net_MSAD[13]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_column0(.PAD(MSAD_column[0]), .I(net_MSAD_column[0]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_column1(.PAD(MSAD_column[1]), .I(net_MSAD_column[1]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_column2(.PAD(MSAD_column[2]), .I(net_MSAD_column[2]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_column3(.PAD(MSAD_column[3]), .I(net_MSAD_column[3]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_column4(.PAD(MSAD_column[4]), .I(net_MSAD_column[4]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_row0(.PAD(MSAD_row[0]), .I(net_MSAD_row[0]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_row1(.PAD(MSAD_row[1]), .I(net_MSAD_row[1]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_row2(.PAD(MSAD_row[2]), .I(net_MSAD_row[2]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_row3(.PAD(MSAD_row[3]), .I(net_MSAD_row[3]), .OE(1'b1)),
	HPDWUW1416DGP_MSAD_row4(.PAD(MSAD_row[4]), .I(net_MSAD_row[4]), .OE(1'b1));

ME inst_ME(.clk(net_clk),.rst(net_rst),.en_i(net_en_i),.cur_in_i(net_cur_in_i),.ref_in_i(net_ref_in_i),.cur_read_en(net_cur_read_en),.ref_read_en(net_ref_read_en),.data_valid(net_data_valid),.MSAD(net_MSAD),.MSAD_column(net_MSAD_column),.MSAD_row(net_MSAD_row));
endmodule