function y=D2_idwt(x,levels);
    global FILTER_D;
    global FILTER_R;
    global SHIFT;
    % This function mainly reconstruct the signal
    % get the size of the original signal
    org_row = 2^(floor(log2(length(x))));
    org_col = 2^(floor(log2(length(x))));
    
    ca1_len  =  org_row/(2^levels);
    ca2_len  =  org_col/(2^levels);
    y=zeros(org_row,org_col);
    n = length(FILTER_D);
    [row,col]=size(x);
    
    for k = 1:col                     % Split the x to get the low pass coefficient and the high pass coefficient
        tmp = x(:,k);
        ca1 = vector_pop(tmp,ca1_len,'tmp');    
        cd1 = cell(0);
        
        for m = 1:levels
            len1 = ca1_len*2^(m-1);
            for jt=1:n-1
                cd1(end+1) = {vector_pop(tmp,len1,'tmp')};
            end
        end
        tmp1 = Reconstruction(ca1,cd1,FILTER_D,SHIFT);   % Reconstruction
        yt(:,k) = tmp1;                %  Now , yt = [L|H]
    end
    for j = 1:org_row 
        tmp = yt(j,:);
        ca2 = vector_pop(tmp,ca2_len,'tmp')';
        cd2 = cell(0);
        for m = 1:levels
            len1 = ca2_len*2^(m-1);
            for jt=1:n-1
                cd2(end+1) = {vector_pop(tmp,len1,'tmp')'};
            end
        end
        tmp2 = Reconstruction(ca2,cd2,FILTER_R,SHIFT);   
        y(j,:) = tmp2;               
    end
end
function y = vector_pop(x,k,name)
% x is the value of vector, name is the vector name is the caller workspace 
    ind = [1:k];
    y = x(ind);
    x(ind) = [];
    assignin('caller',name,x)
end
