# ME_AB2

## 1 RTL代码

### 1.1 ME模块代码

* A.v
* AD.v
* AD_ARRAY.v
* ADD.v
* ADD_8.v
* CurBuffer.v
* FF.v
* FIFO.v
* FIFO_0.v
* FIFO_1to6.v
* FIFO_7.v
* FIFO_AD_ARRAY.v
* ME_input_buffer.v
* MIN.v
* MIN_16.v
* MIN_LEAF.v
* RefSRAM.v
* POST_PROCESSOR.v
* TIMER.v
* ME.v

### 1.2 测试代码

此部分为尝试调高输入带宽的相应代码，因结果不理想被弃用。

* /highBW_Curbuffer

## 2 脚本

### 2.1 数据预处理脚本

* data_preprocess/

### 2.2 其他脚本

根据ME_chip头部IO自动生成对应的完整代码。

* scripts/chip_converter.py

yosys综合脚本。

* scripts/yosys.tcl

## 3 Testbench

任何带有_tb后缀的verilog文件均为其对应模块的测试代码。

### 3.1 Verilog 芯片 Testbench

* ME_tb.v
  * 其将结果打印至控制台同时创建并写入结果到`./output`.

### 3.2 Verilator Testbench

使用Verilator实现的tb。

* ME_top.v
* sim.cpp
* Makefile

相对应的测试结果在

* output/result

该结果基于`hall_qcif_176x144`测试数据。所有sad和motion_vector均经过人工校对，除了一处因对于相同sad时选取向量逻辑不同导致x的值相处1以外，其余所有数据均与提供的输出结果对齐且一致。
