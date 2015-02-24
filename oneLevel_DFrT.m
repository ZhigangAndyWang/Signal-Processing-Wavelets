function Y=oneLevel_DFrT()

    v=[1,0,-1,-1,-4,60,58,56]'; %ORIGINAL Signal v
    fprintf('\nThe original test input signal: \n');
    disp(v);

    % testing the first set of Filter Bank, Haar orthogonal wavelet filter bank
    % fprintf('[Test1:Using Haar Orthogonal wavelet...]\n\n');
    % u0=[1/2,1/2];
    % u1=[-1/2,1/2];
    % Filter0={u0,u1};
    % Filter1={u0,u1};
    
    % % testing the second set of Filter Bank, biorthogonal wavelet filter bank
    fprintf('[Test2:Using Biorthogonal wavelet...]\n\n');
    u0_=[-1/8,1/4,3/4,1/4,-1/8];
    u1_=[-1/4,1/2,-1/4];
    u0=[1/4,1/2,1/4];
    u1=[-1/8,-1/4,3/4,-1/4,-1/8];
    Filter0={u0_,u1_};
    Filter1={u0,u1};
    


    w=Transition(Filter0,v);
    v1=Subdivision(Filter1,w);
    
    %Final Result
    disp('The final result is:');
    Y=sum(cell2mat(v1),2)




