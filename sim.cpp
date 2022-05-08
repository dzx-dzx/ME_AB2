// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// For std::unique_ptr
#include <memory>

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "ME_top.v"
#include "VME_top.h"

#include <iostream>
// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

int main(int argc, char** argv, char** env) {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.

    // Prevent unused variable warnings
    if (false && argc && argv && env) {}
    // Construct a VerilatedContext to hold simulation time, etc.
    // Multiple modules (made later below with VME_top) may share the same
    // context to share time, or modules may have different contexts if
    // they should be independent from each other.

    // Using unique_ptr is similar to
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs argument parsing
    contextp->randReset(2);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from VME_top.h generated from Verilating "ME_top.v".
    // Using unique_ptr is similar to "VME_top* ME_top = new VME_top" then deleting at end.
    // "ME_top" will be the hierarchical name of the module.
    const std::unique_ptr<VME_top> ME_top{new VME_top{contextp.get(), "ME_top"}};

    // Set VME_top's input signals
    ME_top->clk = 0;
    ME_top->rst = 1;
    ME_top->en_i = 0;
    ME_top->finish_flag = 0;

    // Simulate until $finish
    while (!contextp->gotFinish()) {

        contextp->timeInc(1);  // 1 timeprecision period passes...

        // Toggle a fast (time/2 period) clock
        ME_top->clk = !ME_top->clk;

        if (ME_top->clk) {
            int cycle = (contextp->time() + 1) / 2;

            if (cycle > 5) ME_top->rst = 0;
            if (cycle > 10) ME_top->en_i = 1;
            // std::cout << "contextp->time() = " << contextp->time() << std::endl;

            if (cycle == 11000) ME_top->finish_flag = 1;
        }

        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each. See the manual.)
        ME_top->eval();

        // Read outputs
    }

    // Final model cleanup
    ME_top->final();

    // Coverage analysis (calling write only after the test is known to pass)

    // Return good completion status
    // Don't use exit() or destructor won't get called
    return 0;
}
