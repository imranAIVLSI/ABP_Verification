// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

// include directories
//*** add incdir include directories here
-incdir ./apb_master // include directory for sv files
-incdir ./apb_slave
-incdir ./apb_top // include directory for sv files

./apb_top/apb_pkg.sv
// ./apb_top/apb_if.sv
// ../slave/slave_pkg.sv
// ../interface/apb_interface.sv
// ../tb/master_test.sv
// ../tb/master_top.sv
./apb_top/apb_testbench.sv

// +UVM_TESTNAME=master_test
+UVM_VERBOSITY=UVM_HIGH