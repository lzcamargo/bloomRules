module Conformto
  bloom :headRules do
		  #................................Extracting and Validating Parent elements (traces)
		  conform_package <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
		  	|b, r| 
		    [r.mm_valor, b.rhs_name] if (b.lhs_name == "Package")
		  }
		  conform_package <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
			  |b, r| 
		    [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Schema")
		  }   
		  conform_class <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
			  |b, r| 
		    [r.mm_valor, b.rhs_name] if (b.lhs_name == "Class")
		  }
		  conform_class <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
		  	|b, r| 
		    [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Table")
		  }   
		  conform_attribute <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
		  	|b, r| 
		    [r.mm_valor, b.rhs_name] if (b.lhs_name == "Attribute")
		  }
		  conform_attribute <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
			  |b, r| 
		    [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Column")
		  }   
		  target_parent_model <= (source_parent_model * bloom_rule_name).pairs(:source_value => :lhs_name) { 
			  |s, r| 
		    [s.source_element, s.source_parent, r.rhs_name] 
		  }
		  target_parent_model <= (source_parent_model * bloom_rule_name).pairs(:source_value => :rhs_name) { 
			  |s, r| 
		    [s.source_element, s.source_parent, r.lhs_name] 
		  }				
	end
end	
