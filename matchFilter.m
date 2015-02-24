function [FILTER_D,FILTER_R,SHIFT]=matchFilter(filtertype)
    switch filtertype
        case 'db1'  % testing the second set of Filter Bank, biorthogonal wavelet filter bank
            LO_D = [1/2,1/2];
            HI_D = [-1/2,1/2];
            FILTER_D = {LO_D,HI_D};
            FILTER_R = {LO_D,HI_D};
            SHIFT = -1;
        case 'db2'  % testing the second set of Filter Bank, Daubechies 4-tap filter bank
            LO_D = [1-sqrt(3), -3+sqrt(3), 3+sqrt(3), -1-sqrt(3)]*1/8;
            HI_D = [1+sqrt(3), 3+sqrt(3), 3-sqrt(3), 1-sqrt(3)]*1/8;
			FILTER_D = {LO_D,HI_D};
            FILTER_R = {LO_D,HI_D};
            SHIFT = -3;
        case 'tf1'  % testing the 3rd set of Filter Bank, tight framlet wavelet filter bank
            u0 = [1/4,1/2,1/4];
            u1 = [-sqrt(2)/4,0,sqrt(2)/4];
            u2 = [-1/4,1/2,-1/4];
            FILTER_D = {u0,u1,u2};
            FILTER_R = {u0,u1,u2};
            SHIFT = -2;
        case 'tf2' %Tight framlet wavelet filter bank, from Example1
            u0 = [5, 0,  -63, 75, 495, 495, 75, -63, 0, 5]*1/1024;
            u1 = [0, 0,   -3,  0,  22, -45, 45, -22, 0, 3]*sqrt(15)/512;
            u2 = [5, 0, -117, 75, 315,-315,-75, 117, 0,-5]*1/1024;
            FILTER_D = {u0,u1,u2};
            FILTER_R = {u0,u1,u2};
            SHIFT = -9;
        case 'tf3' %Tight framlet wavelet filter bank, from Example2
            u0 = [63, 0, -429, 0, 1309, 1617, 1617, 1309, 0, -429, 0, 63]*1/5120;
            u1 = [ 0, 0,    3, 0,   10,    0,  -77,   77, 0,  -10, 0, -3]*sqrt(231)/2560;
            u2 = [63, 0, -495, 0,  385, 1617,-1617, -385, 0,  495, 0,-63]*1/5120;
            FILTER_D = {u0,u1,u2};
            FILTER_R = {u0,u1,u2};
            SHIFT = -11;
        case 'tf4' %Tight framlet wavelet filter bank, from Example3
            u0 = [ 21, 539, -825, -3927,  6930, 30030, 30030, 6930, -3927, -825, 539, 21]*1/65536;
            u1 = [-21,-539, 1023,  9009,-12474, -9702,  9702,12474, -9009,-1023, 539, 21]*1/65536;
            u2 = [  3,  77, -108,  -308,   898,  -898,   308,  108,   -77,   -3,   0,  0]*sqrt(231)/32768;
            FILTER_D = {u0,u1,u2};
            FILTER_R = {u0,u1,u2};
            SHIFT = -11;
        otherwise
            warndlg(['undefined filter type: ',filtertype]);
    end

end
