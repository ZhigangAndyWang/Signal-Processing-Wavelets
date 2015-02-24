function [co_L,co_H_sets]=Decomposition(v,Filter,levels)
    s=length(Filter)-1; %number of High Pass filters
    co_L=v; %coefficent after Lower pass filter
    co_H_sets=cell(0);   %coefficients after high pass filters
    %Decomposition
    for i=1:levels
        w=Transition(Filter,co_L);
        if isempty(co_H_sets)  %First iteration
            co_H_sets=w(2:end)';
        else
            co_H_sets(1,s+1:end+s)=co_H_sets(1:end);
            co_H_sets(1,1:s)=w(2:end);
        end
        co_L=cell2mat(w(1));  % for next iteration
    end
end
