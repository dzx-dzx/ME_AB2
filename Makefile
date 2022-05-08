default: run

run:
	@rm -rf obj_dir
	@mkdir obj_dir

	verilator -cc --exe -Os -x-assign 0 --build -Wno-WIDTH -Wno-COMBDLY -Wno-TIMESCALEMOD -Wno-CASEINCOMPLETE --top ME_top ME_top.v sim.cpp

	@rm -rf output
	@mkdir output
	obj_dir/VME_top | tee output/result

trace:
	@rm -rf obj_dir/
	@mkdir obj_dir
	verilator -cc --exe -Os -x-assign 0 --build --trace -Wno-WIDTH -Wno-COMBDLY -Wno-TIMESCALEMOD -Wno-CASEINCOMPLETE --top ME_top ME_top.v sim.cpp

	@rm -rf output
	@mkdir output
	obj_dir/VME_top +trace


clean:
	@rm -rf obj_dir
	@rm -rf output