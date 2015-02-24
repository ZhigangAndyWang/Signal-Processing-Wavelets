function compare_inp()
    rt = 5;
    levels = 5;
    filtertype = 'db1';
    TV = 200;

    pic=imread('pics/Boat','png');
    %figure(1), imshow(uint8(pic)),title('original image');
    %figure(4), imshow(uint8(pic(200:350,300:450)));
    imwrite(uint8(pic),'c2_1_1.png','png');
    imwrite(uint8(pic(200:350,300:450)),'c2_1_2.png','png');

    mpic = imread('pics/masks/m_text','png');
    B=constructMask(mpic);
    npic=double(pic).*B;

    C=npic;
    for j=1:rt
        C_dec=D2_dwt(C,filtertype,levels);
        hardC=[hthresh(C_dec,TV)];
        C_thr=D2_idwt(hardC,levels);
        C_new = (1-B).*C_thr+B.*C;
        C = C_new;
        TV = decreaseTV(TV,1);
    end
    %figure(2), imshow(uint8(C)),title(filtertype);
    %figure(5), imshow(uint8(C(200:350,300:450)));
    imwrite(uint8(C),'c2_2_1.png','png');
    imwrite(uint8(C(200:350,300:450)),'c2_2_2.png','png');
    %PSNR = psnr(double(pic),C,255)

    filtertype = 'tf1';
    TV = 100;
    C=npic;
    for j=1:rt
        C_dec=D2_dwt(C,filtertype,levels);
        hardC=[hthresh(C_dec,TV)];
        C_thr=D2_idwt(hardC,levels);
        C_new = (1-B).*C_thr+B.*C;
        C = C_new;
        TV = decreaseTV(TV,1);
    end
    %figure(3), imshow(uint8(C)),title(filtertype);
    %figure(6), imshow(uint8(C(200:350,300:450)));
    imwrite(uint8(C),'c2_3_1.png','png');
    imwrite(uint8(C(200:350,300:450)),'c2_3_2.png','png');
    %PSNR = psnr(double(pic),C,255)

end

function op=sthresh(X,T)
%A function to perform soft thresholding on a 
%given an input vector X with a given threshold T
% S=sthresh(X,T);
    ind=find(abs(X)<=T);
    ind1=find(abs(X)>T);
    X(ind)=0;
    X(ind1)=sign(X(ind1)).*(abs(X(ind1))-T);
    op=X;
end
    
function op=hthresh(X,T)
%A function to perform hard thresholding on a 
%given an input vector X with a given threshold T
% H=hthresh(X,T);
    ind=find(abs(X)<=T);
    X(ind)=0;
    op=X;
end
function res=constructMask(mpic)
	res = mpic > 150;
	% size(res)
end
