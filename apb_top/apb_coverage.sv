class apb_coverage extends uvm_component;
    `uvm_component_utils(apb_coverage)

    `uvm_analysis_imp_decl(_master)
    `uvm_analysis_imp_decl(_slave)

    uvm_analysis_imp_master#(apb_base_seq_item, apb_coverage) master_in;
    uvm_analysis_imp_slave#(apb_base_seq_item, apb_coverage) slave_in;

    function new(string name = "apb_coverage", uvm_component parent);
        super.new(name, parent);
        master_in = new("master_in", this);
        slave_in = new("slave_in", this);
    endfunction

    function void write_master(apb_base_seq_item tr);
        // tr.print();
        `uvm_info("APB_MASTER_COV", $sformatf("%s",tr.apb_master()),UVM_MEDIUM);
    endfunction

    function void write_slave(apb_base_seq_item tr);
        // tr.print();
        `uvm_info("APB_SLAVE_COV", $sformatf("%s",tr.apb_slave()),UVM_MEDIUM);
    endfunction

endclass