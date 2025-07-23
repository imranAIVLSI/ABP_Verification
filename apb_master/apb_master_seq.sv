//define apb_master sequence class
class apb_master_base_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_base_seq)
  
  //constructor
  function new(string name ="apb_master_base_seq");
    //call thebase class constructor
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

	
endclass  // end of the class

class simple_seq extends apb_master_base_seq;
  `uvm_object_utils(simple_seq)

  function new(string name = "simple_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), " Executing simpe_seq", UVM_LOW)
    repeat(10)
    `uvm_do(req);
  endtask

endclass

class write_only extends apb_master_base_seq;
    `uvm_object_utils(write_only)

    function new(string name = "write_only");
      super.new(name);
    endfunction

    task body();
      repeat(10)
      `uvm_do_with(req, {apb_tr == WRITE;})
    endtask


endclass

class read_only_seq extends apb_master_base_seq;
    `uvm_object_utils(read_only_seq)

    function new(string name = "read_only_seq");
      super.new(name);
    endfunction

    task body();
      repeat(10)
      `uvm_do_with(req, {apb_tr == READ;})
    endtask
endclass

class write_read_seq extends apb_master_base_seq;

  `uvm_object_utils(write_read_seq)

  function new(string name  = "write_read_seq");
    super.new(name);
  endfunction
write_only wr_only;
read_only_seq rd_only;

  task body();
    `uvm_info(get_type_name(), " Executing Write_read Seq", UVM_LOW)
    `uvm_do(wr_only)
    `uvm_do(rd_only)
  endtask

endclass

class alternating_rw extends apb_master_base_seq;
  `uvm_object_utils(alternating_rw)

  function new(string name = "alternating_rw");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), " Executing alternating_rw", UVM_LOW)
    repeat(10)
    `uvm_do_with(req, {apb_tr dist {READ:=5, WRITE:=5};})
  endtask

endclass

class wait_state_seq extends apb_master_base_seq;
  `uvm_object_utils(wait_state_seq)

  function new(string name = "wait_state_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), " Executing wait_state_seq", UVM_LOW)
    repeat(10)
    // `uvm_do_with(req, {delay inside {[0:3]};})
    `uvm_do(req)
  endtask

endclass