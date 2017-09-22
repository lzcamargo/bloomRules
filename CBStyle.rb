module CBSs
  bloom :cbsRules do
		#................................Forward Package2Schema
	  target_parent_model <= source_parent_model {
			|p| 
		  [p.source_element, p.source_parent, "Schema"] if 
		    (p.source_value == "Package") 
		}
		
		target_child_model <= (source_parent_model * source_child_model).pairs {
			|p, l| 
		  [c.source_element, c.source_parent, c.source_value] if                                  
		    (p.source_value == "Package" and p.source_element == c.source_parent and 
		    c.source_value == "name")
		}                           
	   #...............................Backward Schema2Package
    backwd_parent_model <+ target_parent_model {
			|t| 
		  [t.target_element, t.target_parent, "Package"] if
        (t.target_value == "Schema")
		}                     
    backwd_child_model <= (target_parent_model * target_child_model).pairs {
			|p, c| 
		  [c.target_element, c.target_parent, c.target_value] if                                  
         (p.target_value == "Schema" and p.target_element == c.target_parent and 
		     c.target_value == "name")
		}    
    #..................................Forward Class2Table
    target_parent_model <= source_parent_model {
			|p| 
		  [p.source_element, p.source_parent, "Table"] if 
		     (p.source_value == "Class")
		}
    aux_persistent <= (target_parent_model * source_parent_model * source_child_model).pairs {
			|t, s, c| 
		  [s.source_element, s.source_parent, s.source_value] if 
		     (t.target_value == "Table" and t.target_element == s.source_parent and 
		     s.source_element == c.source_parent and c.source_element == "true" and 
		     c.source_value == "persistent")
		}
		target_parent_model <= aux_persistent
		target_child_model <= (aux_persistent * source_child_model).pairs {
			|a, c| 
		  [c.source_element, c.source_parent, c.source_value] if 
		     (a.aux_element == c.source_parent and c.source_value == "name")
		}
		#.......................Backward Table2Class
    backwd_parent_model <= target_parent_model {
			|t| 
		  [t.target_element, t.target_parent, "Class"] if
         (t.target_value == "Table")
		}                     
		backwd_parent_model <= aux_persistent
    backwd_child_model <= (aux_persistent * target_child_model).pairs {
			|a, c| 
		  [c.target_element, c.target_parent, c.target_value] if 
		     (a.aux_element == c.target_parent and c.target_value == "name")
		}
		#................................Forward Attribute2Column
		target_parent_model <= source_parent_model {
			|p| 
		  [p.source_element, p.source_parent, "Column"] if 
		     (p.source_value == "Attribute")
		}
		aux_parent <= (source_parent_model * target_parent_model).pairs {
			|s,t| 
		  [s.source_element, s.source_parent, s.source_value] if 
		     (t.target_value == "Column" and t.target_element == s.source_parent)
		}    
		target_parent_model <= aux_parent
		target_child_model <= (target_parent_model * aux_parent * source_child_model).pairs {
			|t, a, s| 
		  [s.source_element, s.source_parent, s.source_value] if 
		    (t.target_value == "Column" and t.target_element == a.aux_parent and a.aux_element == s.source_parent)
		}
		#...............................Backward Attribute2Column
		backwd_parent_model <= target_parent_model {
			|t| 
		  [t.target_element, t.target_parent, "Attribute"] if
		    (t.target_value == "Column")
		}  
		backwd_parent_model <= aux_parent
		backwd_child_model <= (backwd_parent_model * target_child_model * aux_parent).pairs {
			|b, c, a| 
		  [c.target_element, c.target_parent, c.target_value] if 
		    (b.backwd_value == "Attribute" and b.backwd_element == a.aux_parent and a.aux_element == c.target_parent)
		}
  end	                              
end		        

