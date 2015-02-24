function y=D2_dwt(x,filtertype,levels);
    % x is the original 2D signal
    % Output: LL,HL,LH,HH are 4 coefficient matrices with the same size
    % LL:diag. detail coefficients  HL:diag. detail coefficients
    % LH:diag. detail coefficients  HH:diag. detail coefficients
    x0=x;
    %Define the filter type 
    global FILTER_D;global FILTER_R;global SHIFT;
    [FILTER_D,FILTER_R,SHIFT]=matchFilter(filtertype);
    [row,col]  =  size(x);                      % Get the size of the original matrix
    % x_D will be the decomposed matrix of X, basically the length of x_D will be 
    % (n-1)l0-(n-2)l0/(levels)^n, where n is the length of filter_D, l0 is the length of x.
    n = length(FILTER_D);
    len_x_D  = (n-1)*col-(n-2)*col/(2^levels);
    x_D=zeros(len_x_D);
    for j = 1:row                             % Implement one Dimensional DFRT to each row
        tmp1 = x(j,:)';
        [ca1,cd1] = Decomposition(tmp1,FILTER_D,levels);
        % size(ca1)
        tmp = [ca1; cell2mat(cd1')]';          % Restore the data into x, [L|H]
        
        x_D(j,:) = tmp(1:len_x_D);
    end
    
    for k = 1:len_x_D                             % Implement one Dimensional DFRT for each column
        tmp2 = x_D(1:row,k);
        [ca2,cd2] = Decomposition(tmp2,FILTER_D,levels);
        tmp = [ca2;cell2mat(cd2')]';                  % Restore the data into x [LL,HL;LH,HH]
        x_D(:,k) = tmp(1:len_x_D);
    end
    y = x_D;
    % disp('y-x is');
    % D2_idwt(x)-x;
end
