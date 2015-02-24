function compare_deno()
    ft1 = 'db2';
    ft2 = 'tf2';
    TV1 = 50;
    TV2 = 50;
    levels1 = 3;
    levels2 = 3;

    pic=imread('pics/Barbara','png');
    %figure(1), imshow(uint8(pic)),title('original image');
    imwrite(pic,'c1_1_1.png','png');
    %figure(5), imshow(uint8(pic(200:350,1:150)));
    imwrite(uint8(pic(200:350,1:150)),'c1_1_2.png','png');

    
    sig=30;
    V=(sig/256)^2;
    npic=imnoise(pic,'gaussian',0,V);

    %subplot(2,2,2), imshow(uint8(npic)),title('noise');
    %figure(2), imshow(uint8(npic)),title('noise image');
    
    C=D2_dwt(npic,ft1,levels1);
    hardC=[hthresh(C,TV1)];
    newpich=D2_idwt(hardC,levels1);
    PSNR_H_1 = psnr(double(pic),newpich,255)
    %figure(2),imshow(uint8(newpich)),title(ft1);
    %figure(6), imshow(uint8(newpich(200:350,1:150)));
    imwrite(uint8(newpich),'c1_2_1.png','png');
    imwrite(uint8(newpich(200:350,1:150)),'c1_2_2.png','png');

    C=D2_dwt(npic,ft2,levels2);
    hardC=[hthresh(C,TV2)];
    newpich=D2_idwt(hardC,levels2);
    %figure(3),imshow(uint8(newpich)),title(ft2);
    PSNR_H_2 = psnr(double(pic),newpich,255)
    %figure(7), imshow(uint8(newpich(200:350,1:150)));
    imwrite(uint8(newpich),'c1_3_1.png','png');
    imwrite(uint8(newpich(200:350,1:150)),'c1_3_2.png','png');


    %Soft thresholding
    %softC=[sthresh(C,TV)];
    %Reconstructing the image from the soft-thresholded wavelet coefficients
    %newpics=D2_idwt(softC,levels);
    %Displaying the soft-denoised image
    %subplot(2,2,4), imshow(uint8(newpics)),title('soft-denoised image');
    %PSNR_S = psnr(double(pic),newpics,255)
end

function op=sthresh(X,T);
%A function to perform soft thresholding on a 
%given an input vector X with a given threshold T
% S=sthresh(X,T);
    ind=find(abs(X)<=T);
    ind1=find(abs(X)>T);
    X(ind)=0;
    X(ind1)=sign(X(ind1)).*(abs(X(ind1))-T);
    op=X;
end
    
function op=hthresh(X,T);
%A function to perform hard thresholding on a 
%given an input vector X with a given threshold T
% H=hthresh(X,T);
    ind=find(abs(X)<=T);
    X(ind)=0;
    op=X;
end
function res=constructMask(mpic)
	res = mpic > 100;
	% size(res)
end
