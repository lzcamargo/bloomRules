module ProtocolBloomRules
	state do # collections used on rules
		table :source_parent_model, [:source_element, :source_parent, :source_value ]   
		table :source_child_model, [:source_element, :source_parent, :source_value ]  
		table :target_parent_model, [:target_element, :target_parent, :target_value ]   
		table :target_child_model, [:target_element, :target_parent, :target_value ]  
		
		scratch :aux_persistent, [:aux_element, :aux_parent, :aux_value]
		scratch :aux_parent, [:aux_element, :aux_parent, :aux_value]
		scratch :aux_attribute, [:aux_element, :aux_parent, :aux_value]
		table :backwd_parent_model, [:backwd_element, :backwd_parent, :backwd_value ]  
		table :backwd_child_model, [:backwd_element, :backwd_parent, :backwd_value ]  
		
		table :source_metamodel, [:mm_element, :mm_parent, :mm_valor]
		table :target_metamodel, [:mm_element, :mm_parent, :mm_valor]
	end
  state do	# for receiving elements from mapping and conformity metamodels 
		table :bloom_rule_name, [:lhs_name, :hs_name, :id_rule]
		table	:conform_package, [:map_pck_element, :map_pck_value] 
		table	:conform_class, [:map_cla_element, :map_cla_value]
		table	:conform_attribute, [:map_atr_element, :map_atr_value]
end
