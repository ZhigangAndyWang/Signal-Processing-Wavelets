function yend = testD2(x,filtertype,levels,testtype)
    if nargin < 4
        testtype=11;
    end
    
    if mod(testtype,1000)/100 >=1
        v=[1:28]';
        [co_L,co_H_sets,Y]=multiLevel_DFrT(v,filtertype,levels);
        Y
    end

    if mod(testtype,100)/10 >= 1
        v=[1:16]';
        [co_L,co_H_sets,Y]=multiLevel_DFrT(v,filtertype,levels);
        Y
    end

    if mod(testtype,10)==1
        %y1 = D2_mtest(x,type,level)
        %dy1 = y1-x
        y2t = D2_dwt(x,filtertype,levels);
        y2 = D2_idwt(y2t,levels)
        dy2=y2-x

        %dy12 = y1-y2
    end


end
