%Transition operator plays the role of coarsening and frequency seperating the data to lower resolution levels
%Input: Filter is the related filter bank cell, V is the original input signal
%Output: W is a cell, with rows w0,w1,w2... each row is one result of the
%        transition Process using the ith element of Filter Bank
function W=Transition(Filter,V)
    W=cell(length(Filter),1);
    for i=1:length(Filter)
        %for each ui, we calculate its complex conjugate sequence reflected about the origin,u_star
        u_star=conj(fliplr(cell2mat(Filter(1,i))));
        %each w is the result of the procedure of convolution and downsample, sqrt(2) and 2 can be replaced by other numbers instead.
        w=fconv(V,sqrt(2)*u_star);
        w=downsample(w,2);
        %keep the vector w in each row of cell W
        W(i,1)={w};
    end
end

