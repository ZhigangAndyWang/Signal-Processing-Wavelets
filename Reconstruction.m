function y=Reconstruction(co_L,co_H_sets,Filter,shift)
    
    s=length(Filter)-1; %number of High Pass filters
    w=cell(s+1,1); %To store the values of signals
    %Iterating while co_H_sets is not empty
    while ~isempty(co_H_sets)
        w(1)={co_L};
        w(2:end)=co_H_sets(1:s);
        co_H_sets=co_H_sets(s+1:end); %eliminate the used s elements
        v=Subdivision(Filter,w,shift);
        co_L=sum(cell2mat(v),2);  %sum up horizonally
    end
    y=co_L;
end
