module Unidirectional
	#...................Package2Schema..................
	bloom :Package2Schema do
		tgt_model_element <= src_model_element {
			|p| 
		  [p.source_element, p.source_ref, "Schema"] if 
		    (p.source_value == "Package") 
		}
		
		tgt_model_subelmt <= (src_model_element * src_model_subelmt).pairs {
			|p, c| 
		  [c.source_element, c.source_ref, c.source_value] if                                  
		    (p.source_value == "Package" and p.source_element == c.source_ref and 
		    c.source_value == "name")
		}                           
	end
	#.......................... Class2Table..........
	bloom :Class2Table do    
    tgt_model_element <= src_model_element {
			|p| 
		  [p.source_element, p.source_ref, "Table"] if 
		     (p.source_value == "Class")
		}
   aux_persistent <= (tgt_model_element * src_model_element * src_model_subelmt).pairs {
			|t, s, c| 
		  [s.source_element, s.source_ref, s.source_value] if 
		     (t.target_value == "Table" and t.target_element == s.source_ref and 
		     s.source_element == c.source_ref and c.source_element == "true" and 
		     c.source_value == "persistent")
		}
		tgt_model_element <= aux_persistent
		tgt_model_subelmt <= (aux_persistent * src_model_subelmt).pairs {
			|a, c| 
		  [c.source_element, c.source_ref, c.source_value] if 
		     (a.aux_element == c.source_ref and c.source_value == "name")
		}
	end	
	#................................Forward Attribute2Column
	bloom :Attribute2Column do
	  tgt_model_element <= src_model_element {
			|p| 
		  [p.source_element, p.source_ref, "Column"] if 
		     (p.source_value == "Attribute")
		}
		aux_parent <= (src_model_element * tgt_model_element).pairs {
			|s,t| 
		  [s.source_element, s.source_ref, s.source_value] if 
		     (t.target_value == "Column" and t.target_element == s.source_ref)
		}    
		tgt_model_element <= aux_parent
		tgt_model_subelmt <= (tgt_model_element * aux_parent * src_model_subelmt).pairs {
			|t, a, s| 
		  [s.source_element, s.source_ref, s.source_value] if 
		    (t.target_value == "Column" and t.target_element == a.aux_parent and a.aux_element == s.source_ref)
		}
  end	                              
end		        

