class apb_slave_base_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_slave_base_seq)
	
  //constructor
  function new(string name ="apb_slave_base_seq");
	  super.new(name);
  endfunction
  

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body
endclass

class read_seq extends apb_slave_base_seq;
  `uvm_object_utils(read_seq)

  function new(string name = "read_seq");
    super.new(name);
  endfunction

  apb_base_seq_item read_pkt;

  task body();
    read_pkt = apb_base_seq_item::type_id::create("read_pkt");
    read_pkt.addr.rand_mode(0);
    read_pkt.wdata.rand_mode(0);
    repeat(10) begin
      start_item(read_pkt);
      assert(read_pkt.randomize() with {rdata == 32'h10;});
      finish_item(read_pkt);
    end
  endtask

endclass

