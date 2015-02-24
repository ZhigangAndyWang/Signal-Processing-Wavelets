function [co_L,co_H_sets,dY]=multiLevel_DFrT(v,filtertype,levels)
    [FILTER_D,FILTER_R,SHIFT]=matchFilter(filtertype);
    %Final Result
    [co_L,co_H_sets]=Decomposition(v,FILTER_D,levels);
    dY=Reconstruction(co_L,co_H_sets,FILTER_R,SHIFT)-v;
end
