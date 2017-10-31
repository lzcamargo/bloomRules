module BxRules
 	bloom :Package2Schema do
	  target_child_model <= (conform_package * source_parent_model * source_child_model).pairs(source_parent_model.source_element => source_child_model.source_parent) do 
			[c, p, l| 
		  if (p.source_value == c.conf_src) 
			  [l.source_element, l.source_parent, l.source_value] 
			elsif
			  (p.source_value == c.conf_tgt) 
				[l.source_element, l.source_parent, l.source_value]
			end
		end	
		#==================Backward=====================
		backwd_parent_model <= (conform_package * target_parent_model).pairs(:conf_tgt => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_src]
		}
		backwd_parent_model <= (conform_package * target_parent_model).pairs(:conf_src => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_child_model <= (backwd_parent_model * target_child_model).pairs(:backwd_element => :target_parent) {
			|b, l| 
      [l.target_element, l.target_parent, l.target_value]
		}
	end	
	
	bloom :Class2Table do
		target_parent_model <= (conform_class * source_parent_model * source_child_model).pairs(source_parent_model.source_element => source_child_model.source_parent) {
			|c, p, s|                                                                                                                                                   [p.source_element, p.source_parent, p.source_value]	if 
		    (s.source_element == "true" and s.source_value == "persistent")
		}
		aux_persistent  <= (conform_class * source_parent_model).pairs(:conf_tgt => :source_value) { 
			|c, p| 
			[p.source_element, p.source_parent, p.source_value]
		} 
		target_parent_model <= (aux_persistent * source_parent_model).pairs(:aux_element => :source_parent) {
			|a, s| 
			[s.source_element, s.source_parent, s.source_value]
		}
		target_child_model <= (aux_persistent * target_parent_model * source_child_model).pairs(aux_persistent.aux_element => 
			target_parent_model.target_parent, target_parent_model.target_element => source_child_model.source_parent) {
			|a, p, s| 
			[s.source_element, s.source_parent, s.source_value]
		}
		
		aux_parent <= (conform_class * source_parent_model).pairs(:conf_src => :source_value) {
			|c, t| 
			[t.source_element, t.source_parent, t.source_value]
		}
		
		target_child_model <= (aux_parent * target_parent_model * source_child_model).pairs(aux_parent.aux_element => 
			target_parent_model.target_parent, target_parent_model.target_element => source_child_model.source_parent) {
			|a, p, s| 
			[s.source_element, s.source_parent, s.source_value] if s.source_value == "name"
		}
    #====================Backward========================================= 		
		backwd_parent_model <= (conform_class * target_parent_model).pairs(:conf_tgt => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_src]
		}
		backwd_parent_model <= (conform_class * target_parent_model).pairs(:conf_src => :target_value) {
		  |c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_parent_model <= (conform_class * backwd_parent_model * target_parent_model).pairs(backwd_parent_model.backwd_element =>
			target_parent_model.target_parent) do 
			|c, b, t|
			  if (b.backwd_value == c.conf_src)
					[t.target_element, t.target_parent, t.target_value]
				elsif (b.backwd_value == c.conf_tgt)
					[t.target_element, t.target_parent, t.target_value]
				end
		end
	end	
	
	bloom :Attribute2Column do
		aux_attribute <= (conform_attribute * source_parent_model).pairs(:conf_src => :source_value) {
			|a, s| 
			[s.source_element, s.source_parent, s.source_value]
		}
		aux_attribute <= (conform_attribute * source_parent_model).pairs(:conf_tgt => :source_value) {
			|a, s| 
			[s.source_element, s.source_parent, s.source_value]
		}	
		target_parent_model <= (aux_attribute * source_parent_model).pairs(:aux_element => :source_parent) {
			|a, s| 
			[s.source_element, s.source_parent, s.source_value] 
		}
		target_child_model <= (aux_attribute * target_parent_model * source_child_model).pairs(aux_attribute.aux_element =>
			target_parent_model.target_parent, target_parent_model.target_element => source_child_model.source_parent) {
			|a, t, s| 
			  [s.source_element, s.source_parent, s.source_value]
		}
		#====================Backward========================================= 		
	  backwd_parent_model <= (conform_attribute * target_parent_model).pairs(:conf_tgt => :target_value) {
		  |c, t|
			[t.target_element, t.target_parent, c.conf_src]
	  }
	  backwd_parent_model <= (conform_attribute * target_parent_model).pairs(:conf_src => :target_value) {
		  |c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_parent_model <= (aux_attribute * source_parent_model).pairs(:aux_element => :source_parent) {
			|a, s| 
			[s.source_element, s.source_parent, s.source_value]
		}
	end
end	
	
