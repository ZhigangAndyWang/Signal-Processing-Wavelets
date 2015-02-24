function [LL,HL,LH,HH]=D2_dwt(x);

    % x is the original 2D signal

    % Output    ：LL,HL,LH,HH —— 4 coefficient matrices with the same size

    %               LL：低频部分分解系数；    HL：垂直方向分解系数；

    %               LH：水平方向分解系数；    HH：对角线方向分解系数。

    lpd=[1/2 1/2];hpd=[-1/2 1/2];           % Use Harr

    Filter0={lpd, hpd};
    Filter1={lpd, hpd};

    [row,col]=size(x);                      % Get the size of the original matrix

    for j=1:row                             % Implement one Dimensional DFRT to each row
        tmp1=x(j,:)';

        [ca1,cd1,newY]=multiLevel_DFrT(tmp1,Filter0,Filter1,1);

        x(j,:)=[ca1; cell2mat(cd1)]';                   % Restore the data into x, [L|H]

    end
    

    for k=1:col                             % Implement one Dimensional DFRT for each column

        tmp2=x(:,k);

        [ca2,cd2,newY]=multiLevel_DFrT(tmp2,Filter0,Filter1,1);

        x(:,k)=[ca2;cell2mat(cd2)]';                 % Restore the data into x [LL,HL;LH,HH]

    end

    LL=x(1:row/2,1:col/2);                  % LL is the upper left part of x

    LH=x(row/2+1:row,1:col/2);              % LH is the upper right part

    HL=x(1:row/2,col/2+1:col);              % HL is the lower left part of x

    HH=x(row/2+1:row,col/2+1:col);          % HH is the lower right part

    y=idwt2(LL,HL,LH,HH);

    disp(y)

function y=idwt2(LL,HL,LH,HH);
    % This function mainly reconstruct the signal

    lpr=[1/2 1/2];hpr=[1/2 -1/2];             % Harr
    Filter0={lpr ,hpr};
    Filter1={lpr,hpr};

    tmp_mat=[LL,HL;LH,HH];          % tempt matrix for further process

    [row,col]=size(tmp_mat);        % get the size 

    for k=1:col                     % Split the tmp_mat to get the low pass coefficient and the high pass coefficient

        ca1=tmp_mat(1:row/2,k);    

        cd1=tmp_mat(row/2+1:row,k);

        tmp1=Reconstruction(ca1,{cd1},Filter0);   % Reconstruction

        yt(:,k)=tmp1;                %  Now , yt=[L|H]

    end

    for j=1:row                    
        ca2=yt(j,1:col/2);           
        cd2=yt(j,col/2+1:col);

        tmp2=Reconstruction(ca2',{cd2'},Filter1);   
        yt(j,:)=tmp2;                

    end

    y=yt;

