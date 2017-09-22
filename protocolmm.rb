module ClasMM
    state do
        table :cmmelement, [:c_name_mm, :c_type_mm, :c_anc_mm]
        table :cmmelparam, [:c_name_mm_par, :c_type_vlr_mm, :cmmelement]
    end
end

module TabMM
   state do
       table :tmmelement, [:t_name_mm, :t_type_mm, :t_anc_mm]
       table :tmmelparam, [:t_name_mm_par, :t_type_vlr_mm, :tmmelement]
   end
end

module ModelElements
    state do
        table :srcelemt, [:name_srcelem, :cont_srcelem, :type_cont, :belong_to]
        table :trgelemt, [:name_trgelem, :cont_trgelem, :type_cont, :belong_to]
    end
end

module Commun
    state do
        scratch :aux, [:name_elem, :type_names, :name_param, :vlr_param]
        scratch :auxat, [:name_elem, :type_names, :name_param, :vlr_param]
        interface output, :outelemt, [:name_trgelem, :cont_trgelem, :type_cont] 
    end    
end
