//Top level test class that instanties environment , configurations and start stimulus
import uvm_pkg::*;
`include "uvm_macros.svh"
import apb_pkg::*;
`include "apb_env.sv"

class apb_base_test extends uvm_test;

	//Register with factory
	`uvm_component_utils(apb_base_test)
  
  //instance for environment class
	apb_env  env;	
	// configuration object
	apb_master_config 	m_apb_master_config;
	apb_slave_config 	m_apb_slave_config;
	
	virtual apb_if vif;
		
	apb_master_base_seq master_seq;
	apb_slave_base_seq  slave_seq;	
  
  //constructor for the class
  function new(string name = "apb_base_test", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
  
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
      env = apb_env::type_id::create("env", this);
	  uvm_config_int::set(this, "*", "recording_detail", 1);
	  m_apb_master_config = apb_master_config::type_id::create("m_apb_master_config"); 		
	  m_apb_slave_config  = apb_slave_config::type_id::create("m_apb_slave_config"); 		
		
	  uvm_config_db#(apb_master_config)::set(null, "","apb_master_config", m_apb_master_config);
	  uvm_config_db#(apb_slave_config)::set(null, "" ,"apb_slave_config", m_apb_slave_config);
	
	  if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		  `uvm_fatal(get_full_name(), "No virtual interface specified for this test instance")
	  end 

      uvm_config_wrapper::set(this, "env.master_agent.m_sequencer.run_phase",
                                "default_sequence",
                                simple_seq::get_type());
      uvm_config_wrapper::set(this, "env.slave_agent.m_sequencer.run_phase",
                                "default_sequence",
                                read_seq::get_type());
  endfunction
  
    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);

    endtask

    function void check_phase(uvm_phase phase);
        super.connect_phase(phase);
        check_config_usage();
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass // end of the class

class write_only_test extends apb_base_test;
	`uvm_component_utils(write_only_test)

	function new(string name = "write_only_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      uvm_config_wrapper::set(this, "env.master_agent.m_sequencer.run_phase",
                                "default_sequence",
                                write_only::get_type());	
	endfunction

endclass

class read_only_test extends apb_base_test;
	`uvm_component_utils(read_only_test)

	function new(string name = "read_only_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      uvm_config_wrapper::set(this, "env.master_agent.m_sequencer.run_phase",
                                "default_sequence",
                                wait_state_seq::get_type());	
	endfunction

endclass
