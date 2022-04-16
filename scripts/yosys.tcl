yosys read_verilog A.v
yosys read_verilog AD.v
yosys read_verilog AD_ARRAY.v
yosys read_verilog ADD.v
yosys read_verilog ADD_8.v
yosys read_verilog CurBuffer.v
yosys read_verilog FF.v
yosys read_verilog FIFO.v
yosys read_verilog FIFO_0.v
yosys read_verilog FIFO_1to6.v
yosys read_verilog FIFO_7.v
yosys read_verilog FIFO_AD_ARRAY.v
yosys read_verilog ME_input_buffer.v
yosys read_verilog MIN.v
yosys read_verilog MIN_16.v
yosys read_verilog MIN_LEAF.v
yosys read_verilog RefSRAM.v
yosys read_verilog POST_PROCESSOR.v
yosys read_verilog TIMER.v
yosys read_verilog ME.v
yosys hierarchy -top ME
yosys proc
yosys opt
yosys stat
yosys write_json -compat-int out.json