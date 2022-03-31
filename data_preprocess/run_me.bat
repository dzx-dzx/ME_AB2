@echo off
pip install -i https://mirror.sjtu.edu.cn/pypi/web/simple numpy
python cur_data_process.py
python ref_data_process.py
echo == Finish ==
echo Results are written to './data/*_processed.txt'
pause
exit