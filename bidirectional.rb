module Bidirectional
  bloom :linkRules do
		#................................Extracting and Validating Parent elements (traces)
		link_pck_sch <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
			|b, r| 
		  [r.mm_valor, b.rhs_name] if (b.lhs_name == "Package")
		}
		link_pck_sch <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
			|b, r| 
		  [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Schema")
		}   
		link_cla_tab <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
			|b, r| 
		  [r.mm_valor, b.rhs_name] if (b.lhs_name == "Class")
		}
		link_cla_tab <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
			|b, r| 
		  [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Table")
		}   
		link_att_col <= (bloom_rule_name * source_metamodel).pairs(:lhs_name => :mm_valor) {
			|b, r| 
		  [r.mm_valor, b.rhs_name] if (b.lhs_name == "Attribute")
		}
		link_att_col <= (bloom_rule_name * target_metamodel).pairs(:rhs_name => :mm_valor) {
			|b, r| 
		  [b.lhs_name, r.mm_valor,] if (b.rhs_name == "Column")
		}   
		tgt_model_element <= (src_model_element * bloom_rule_name).pairs(:source_value => :lhs_name) { 
			|s, r| 
		  [s.source_element, s.source_ref, r.rhs_name] 
		}
		tgt_model_element <= (src_model_element * bloom_rule_name).pairs(:source_value => :rhs_name) { 
			|s, r| 
		  [s.source_element, s.source_ref, r.lhs_name] 
		}				
	end	
	  
	bloom :Package2Schema do
		tgt_model_subelmt <= (link_pck_sch * src_model_element * src_model_subelmt).pairs(src_model_element.source_element => src_model_subelmt.source_ref) do 
			[c, p, l| 
		  if (p.source_value == c.conf_src) 
				 [l.source_element, l.source_ref, l.source_value] 
				 elsif
					 (p.source_value == c.conf_tgt) # and l.source_value == "name")
					 [l.source_element, l.source_ref, l.source_value]
			end
		end	
		#==================Backward=====================
			backwd_model_element <= (link_pck_sch * tgt_model_element).pairs(:conf_tgt => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_src]
		}
		backwd_model_element <= (link_pck_sch * tgt_model_element).pairs(:conf_src => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_model_subelmt <= (backwd_model_element * tgt_model_subelmt).pairs(:backwd_element => :target_parent) {
			|b, l| 
      [l.target_element, l.target_parent, l.target_value]
		}
	end	
	
	bloom :Class2Table do
		tgt_model_element <= (link_cla_tab * src_model_element * src_model_subelmt).pairs(src_model_element.source_element => src_model_subelmt.source_ref) {
			|c, p, s|                                                                                                                                                   [p.source_element, p.source_ref, p.source_value]	if 
		    (s.source_element == "true" and s.source_value == "persistent")
		}
		aux_persistent  <= (link_cla_tab * src_model_element).pairs(:conf_tgt => :source_value) { 
			|c, p| 
			[p.source_element, p.source_ref, p.source_value]
		} 
		tgt_model_element <= (aux_persistent * src_model_element).pairs(:aux_element => :source_ref) {
			|a, s| 
			[s.source_element, s.source_ref, s.source_value]
		}
		tgt_model_subelmt <= (aux_persistent * tgt_model_element * src_model_subelmt).pairs(aux_persistent.aux_element => 
			tgt_model_element.target_parent, tgt_model_element.target_element => src_model_subelmt.source_ref) {
			|a, p, s| 
			[s.source_element, s.source_ref, s.source_value]
		}
		
		aux_parent <= (link_cla_tab * src_model_element).pairs(:conf_src => :source_value) {
			|c, t| 
			[t.source_element, t.source_ref, t.source_value]
		}
		
		tgt_model_subelmt <= (aux_parent * tgt_model_element * src_model_subelmt).pairs(aux_parent.aux_element => 
			tgt_model_element.target_parent, tgt_model_element.target_element => src_model_subelmt.source_ref) {
			|a, p, s| 
			[s.source_element, s.source_ref, s.source_value] if s.source_value == "name"
		}
    #====================Backward========================================= 		
		backwd_model_element <= (link_cla_tab * tgt_model_element).pairs(:conf_tgt => :target_value) {
			|c, t| 
			[t.target_element, t.target_parent, c.conf_src]
		}
		backwd_model_element <= (link_cla_tab * tgt_model_element).pairs(:conf_src => :target_value) {
		  |c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_model_element <= (link_cla_tab * backwd_model_element * tgt_model_element).pairs(backwd_model_element.backwd_element =>
			tgt_model_element.target_parent) do 
			|c, b, t|
			  if (b.backwd_value == c.conf_src)
					[t.target_element, t.target_parent, t.target_value]
				elsif (b.backwd_value == c.conf_tgt)
					[t.target_element, t.target_parent, t.target_value]
				end
		end
	end	
	
	bloom :Attribute2Column do
		aux_attribute <= (link_att_col * src_model_element).pairs(:conf_src => :source_value) {
			|a, s| 
			[s.source_element, s.source_ref, s.source_value]
		}
		aux_attribute <= (link_att_col * src_model_element).pairs(:conf_tgt => :source_value) {
			|a, s| 
			[s.source_element, s.source_ref, s.source_value]
		}	
		tgt_model_element <= (aux_attribute * src_model_element).pairs(:aux_element => :source_ref) {
			|a, s| 
			[s.source_element, s.source_ref, s.source_value] 
		}
		tgt_model_subelmt <= (aux_attribute * tgt_model_element * src_model_subelmt).pairs(aux_attribute.aux_element =>
			tgt_model_element.target_parent, tgt_model_element.target_element => src_model_subelmt.source_ref) {
			|a, t, s| 
			  [s.source_element, s.source_ref, s.source_value]
		}
		#====================Backward========================================= 		
	  backwd_model_element <= (link_att_col * tgt_model_element).pairs(:conf_tgt => :target_value) {
		  |c, t|
			[t.target_element, t.target_parent, c.conf_src]
	  }
	  backwd_model_element <= (link_att_col * tgt_model_element).pairs(:conf_src => :target_value) {
		  |c, t| 
			[t.target_element, t.target_parent, c.conf_tgt]
		}
		backwd_model_element <= (aux_attribute * src_model_element).pairs(:aux_element => :source_ref) {
			|a, s| 
			[s.source_element, s.source_ref, s.source_value]
		}
	end
end	
	
