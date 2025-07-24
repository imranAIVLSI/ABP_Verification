//APB interfcae named apb_if
`define ADDR_WIDTH 8               // APB PADDR BUS width           
`define DATA_WIDTH 8               // APB PWDATA and PRDATA Bus width

interface apb_if(input bit PCLK, PRESET_N);
	
  //signals
	logic [`ADDR_WIDTH-1:0] PADDR;
	logic [`DATA_WIDTH-1:0] PWDATA;
	logic [`DATA_WIDTH-1:0] PRDATA;	
	logic 		PSEL;
	logic 		PENABLE;
	logic 		PWRITE;
	logic 		PREADY;
	bit 		PWAKEUP;
	
	//master clocking block
	clocking master_cb @(posedge PCLK);
		output PADDR, PSEL, PENABLE, PWRITE, PWDATA, PWAKEUP;
		input  PRDATA, PREADY;
	endclocking: master_cb
	
	//slave clocking block
	clocking slave_cb @(posedge PCLK);
		input  PADDR, PSEL, PENABLE, PWRITE, PWDATA, PWAKEUP;
		output PRDATA, PREADY;
	endclocking: slave_cb
	
  //master modport to define directions of master
	modport master(	input  PRDATA, PREADY,PRESET_N,
					output PADDR, PSEL, PENABLE, PWRITE, PWDATA, PWAKEUP	);
	
  //slave modport to define directions of slave
	modport slave(	input  PADDR, PSEL, PENABLE, PWRITE, PWDATA,PRESET_N, PWAKEUP,
					output PRDATA, PREADY);
  
	// property reset_check;
	// 		@(posedge clk) !ARESET_n |=> !AWVALID && !WVALID && !ARVALID && !RVALID && !BVALID;     
	// endproperty : reset_check

	// property penable;
	// 		@(posedge PCLK) disable iff (!PRESET_N) 
	// 			PENABLE && !PREADY |-> ##1 $stable(PADDR) && $stable(PSEL) && $stable(PWRITE) && $stable(PWDATA);  
	// endproperty : penable


	// property penable_stable;
	// 		@(posedge PCLK) disable iff (!PRESET_N)
	// 			(PENABLE && !PREADY) |-> ##1 PENABLE;
	// endproperty

	// property PSEL_not_enable;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 		PSEL && !PENABLE |=> PENABLE;
	// endproperty

	// property ready;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 		PSEL && PENABLE |-> PREADY;
	// endproperty

	// property stable_addr;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 		PSEL && PENABLE |-> $stable(PADDR);
	// endproperty

	// property simoultaneous_read_write;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 		// PWRITE |-> !PWRITE;
	// 	!(PSEL && PENABLE && PREADY && PWRITE) || !(PSEL && PENABLE && PREADY && !PWRITE)
	// endproperty

	// property awake;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 	PSEL && PENABLE |-> PWAKEUP
	// endproperty

	// property not_sel;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 	PENABLE |-> PSEL
	// endproperty

	// property wait_limit;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 		PSEL && PENABLE && !PREADY |-> ##[1:3] PREADY;
	// endproperty

	// property transfer_done;
	// 	@(posedge PCLK) disable iff (!PRESET_N)
	// 	(PSEL && PENABLE && PREADY) |=> !PENABLE;
	// endproperty

	// assert property (transfer_done);
	// assert property (wait_limit);
	// assert property (not_sel);
	// assert property (awake);
	// assert property (simoultaneous_read_write);
	// assert property (stable_addr);
	// // assert property (ready); // will be asserted when wait state will be decided
	// assert property (PSEL_not_enable);
	// assert property (penable_stable);
	// assert property (penable);


endinterface // end of the interface
