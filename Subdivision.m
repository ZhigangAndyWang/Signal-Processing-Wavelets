%Subdivision operator plays the row of refining and predictiong the data to higher resolution levels
%Input: Filter is the related filter bank cell, W is the original input signal
%Output: V is a cell, with rows v0,v1,v2... each row is one result of the
%        transition Process using the ith element of Filter Bank
function V=Subdivision(Filter,W,shift)
    V=cell(1,length(Filter));
    for i=1:length(Filter)
        v=cell2mat(W(i,1));
        %each v is the result of the procedure of upsample and convolution, sqrt(2) and 2 can be replaced by other numbers instead.
        v_up=upsample(v,2);
        v=fconv(v_up,sqrt(2)*cell2mat(Filter(1,i)));
        v=circshift(v,shift);
        V(1,i)={v};
    end
end
