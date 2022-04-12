"""
! File Must be initialized properly as follows
module idct_chip(clk,rstn,mode,start,din,dout,dout_mode);

input clk;
input rstn;
input [1:0] mode;
input start;
input [15:0] din;

output [15:0] dout;
output [1:0] dout_mode;
"""

"""
$ python3 converter.py xxx.v
"""

import re
import sys

if __name__ == "__main__":
    file = sys.argv[1]

    patterns = [
        r"input\s+[a-zA-Z_]+",
        r"input\s+\[\d+:\d+\]\s+[a-zA-Z_]+",
        r"output\s+[a-zA-Z_]+",
        r"output\s+\[\d+:\d+\]\s+[a-zA-Z_]+",
    ]

    input_bit_list = []
    input_array_list = []
    output_bit_list = []
    output_array_list = []

    with open(file, "r") as f:
        data = f.read()
        module = re.search(r"module\s+\w+", data).group()[7:-5]
        for index, pattern in enumerate(patterns):
            results = re.findall(pattern, data)
            if results:
                if index == 0:
                    for result in results:
                        input_bit_list.append(result[6:])

                if index == 1:
                    for result in results:
                        length = re.search(r"\d+", result).group()
                        port = re.search(r"\]\s\w+", result).group()[2:]
                        input_array_list.append((length, port))
                if index == 2:
                    for result in results:
                        output_bit_list.append(result[7:])
                if index == 3:
                    for result in results:
                        length = re.search(r"\d+", result).group()
                        port = re.search(r"\]\s\w+", result).group()[2:]
                        output_array_list.append((length, port))

    declare_content = []
    input_pad_content = ["HPDWUW1416DGP\n"]
    output_pad_content = ["HPDWUW1416DGP\n"]
    instantiate_list = []

    for in_bit in input_bit_list:
        port = "net_" + in_bit
        declare_content.append(f"wire {port};\n")
        input_pad_content.append(
            f"\tHPDWUW1416DGP_{in_bit}(.PAD({in_bit}), .C({port}), .IE(1'b1)),\n"
        )
        instantiate_list.append((in_bit, port))

    for in_array in input_array_list:
        port = "net_" + in_array[1]
        declare_content.append(f"wire [{in_array[0]}:0] {port};\n")
        for i in range(0, int(in_array[0]) + 1):
            input_pad_content.append(
                f"\tHPDWUW1416DGP_{in_array[1]}{i}(.PAD({in_array[1]}[{i}]), .C({port}[{i}]), .IE(1'b1)),\n"
            )
        instantiate_list.append((in_array[1], port))

    for bit in output_bit_list:
        port = "net_" + bit
        declare_content.append(f"wire {port};\n")
        output_pad_content.append(
            f"\tHPDWUW1416DGP_{bit}(.PAD({bit}), .I({port}), .OE(1'b1)),\n"
        )
        instantiate_list.append((bit, port))

    for array in output_array_list:
        port = "net_" + array[1]
        declare_content.append(f"wire [{array[0]}:0] {port};\n")
        for i in range(0, int(array[0]) + 1):
            output_pad_content.append(
                f"\tHPDWUW1416DGP_{array[1]}{i}(.PAD({array[1]}[{i}]), .I({port}[{i}]), .OE(1'b1)),\n"
            )
        instantiate_list.append((array[1], port))

    input_pad_content[-1] = input_pad_content[-1][:-2] + ";\n"
    output_pad_content[-1] = output_pad_content[-1][:-2] + ";\n"

    inst = f"{module} inst_{module}("
    for port in instantiate_list:
        inst = inst + f".{port[0]}({port[1]}),"
    inst = inst[:-1] + "); \nendmodule"

    with open(file, "a") as f:
        f.write("\n" * 2)
        for line in declare_content:
            f.write(line)
        f.write("\n")
        for line in input_pad_content:
            f.write(line)
        f.write("\n")
        for line in output_pad_content:
            f.write(line)
        f.write("\n")
        f.write(inst)

    print("File Appended")
