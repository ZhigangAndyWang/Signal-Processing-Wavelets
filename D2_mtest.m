function y=D2_mtest(x,type,levels);
yt=D2_dwtmmm(x,type,levels);
y_r=D2_idwtmmm(yt);
end

function y=D2_dwtmmm(x,filtertype,levels);

    % x is the original 2D signal
    
    % Output    ：LL,HL,LH,HH —— 4 coefficient matrices with the same size

    %               LL：diag. detail coefficients,    HL：diag. detail coefficients,

    %               LH：diag. detail coefficients,    HH：diag. detail coefficients,  
    x0=x;



    %Define the filter type 
    global FILTER_D;global FILTER_R;global SHIFT;global LEVELS;
    LEVELS=levels;
    [FILTER_D,FILTER_R,SHIFT]=matchFilter(filtertype);


    [row,col]  =  size(x);                      % Get the size of the original matrix
    % x_D will be the decomposed matrix of X, basically the length of x_D will be 
    % (n-1)l0-(n-2)l0/(levels)^n, where n is the length of filter_D, l0 is the length of x.
    n = length(FILTER_D);
    len_x_D  = (n-1)*col-(n-2)*col/(2^levels);
    x_D=zeros(len_x_D);

    for j = 1:row                             % Implement one Dimensional DFRT to each row
        tmp1 = x(j,:)';

        [ca1,cd1] = Decomposition(tmp1,FILTER_D,LEVELS);
        % size(ca1)
        tmp = [ca1; cell2mat(cd1')]';          % Restore the data into x, [L|H]
        
        x_D(j,:) = tmp(1:len_x_D);
    end
    

    for k = 1:len_x_D                             % Implement one Dimensional DFRT for each column

        tmp2 = x_D(1:row,k);
        [ca2,cd2] = Decomposition(tmp2,FILTER_D,LEVELS);

        tmp = [ca2;cell2mat(cd2')]';                  % Restore the data into x [LL,HL;LH,HH]
        x_D(:,k) = tmp(1:len_x_D);
    end

    y = x_D;
    % disp('y-x is');
    % D2_idwt(x)-x;
end



function y = D2_idwtmmm(x);

    global FILTER_D;
    global FILTER_R;
    global SHIFT;
    global LEVELS;

    % This function mainly reconstruct the signal

    % get the size of the original signal
    org_row = 2^(floor(log2(length(x))));
    org_col = 2^(floor(log2(length(x))));
    
    ca1_len  =  org_row/(2^LEVELS);
    ca2_len  =  org_col/(2^LEVELS);
    y=zeros(org_row,org_col);

    n = length(FILTER_D);
    [row,col]=size(x);

    
    for k = 1:col                     % Split the x to get the low pass coefficient and the high pass coefficient
        tmp = x(:,k);
        ca1 = vector_pop(tmp,ca1_len,'tmp');    
        cd1 = cell(0);
        
        for m = 1:LEVELS
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

        for m = 1:LEVELS
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
