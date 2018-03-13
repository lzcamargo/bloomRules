module ProtocolBloomRules
	state do # collections used on rules
		table :src_model_element, [:source_element, :source_ref, :source_value ]   
		table :src_model_subelmt, [:source_element, :source_ref, :source_value ]  
		table :tgt_model_element, [:target_element, :target_ref, :target_value ]   
		table :tgt_model_subelmt, [:target_element, :target_ref, :target_value ]  
		
		scratch :aux_persistent, [:aux_element, :aux_parent, :aux_value]
		scratch :aux_parent, [:aux_element, :aux_parent, :aux_value]
		scratch :aux_attribute, [:aux_element, :aux_parent, :aux_value]
		table :backwd_model_element, [:backwd_element, :backwd_ref, :backwd_value ]  
		table :backwd_model_subelmt, [:backwd_element, :backwd_ref, :backwd_value ]  
		
		table :source_metamodel, [:mm_element, :mm_parent, :mm_valor]
		table :target_metamodel, [:mm_element, :mm_parent, :mm_valor]
	end
  state do	# collections used on conformity with metamodels and links 
		table :bloom_rule_name, [:lhs_name, :rhs_name, :id_rule]
		table	:link_pck_sch, [:lnk_src_element, :lnk_tgt_element] 
		table	:link_cla_tab, [:lnk_src_element, :lnk_tgt_element]
		table	:link_att_col, [:lnk_src_element, :lnk_tgt_element]
	end	
end
