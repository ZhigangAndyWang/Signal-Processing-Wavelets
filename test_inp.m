function test_inp(filtertype,rt)
        %Note: Figure window 1 displays the original image, fig 2 the noisy img
        %fig 3 denoised img by hard thresholding, fig 4 denoised by soft thresholding
    %Reading the image 
    pic=imread('pics/bagua','png');
    % size(pic)
    subplot(2,2,1), imshow(uint8(pic)),title('original iamge');
    %Inpainting Process
    mpic = imread('pics/masks/m_text','png');
    B=constructMask(mpic);
    %npic is the noise picture
    npic=double(pic).*B;
    subplot(2,2,2), imshow(uint8(npic)),title('missing Data');
    levels=5;
    %Define the threshold(universal threshold)
    TV=200;
    C=npic;
    for j=1:rt
        %Doing the wavelet decomposition
        C_dec=D2_dwt(C,filtertype,levels);
        %Hard thresholding
        hardC=[hthresh(C_dec,TV)];
        %Reconstructing the image from the hard-thresholded wavelet coefficients
        C_thr=D2_idwt(hardC,levels);
        %C_thr=waverec2(hardC,S,'db1');
        C_new = (1-B).*C_thr+B.*C;
        
        C = C_new;
        if TV>300
            TV = TV-20 ; 
        end
    end
    %Displaying the hard-denoised image
    subplot(2,2,3),imshow(uint8(C)),title('hard-denoised image');
    PSNR = psnr(double(pic),C,255)

    C1=npic;
    for j=1:5
        %Doing the wavelet decomposition
        C_dec=D2_dwt(C1,filtertype,levels);
        %Soft thresholding
        softC=[sthresh(C_dec,TV)];
        %Reconstructing the image from the soft-thresholded wavelet coefficients
        C_thr=D2_idwt(softC,levels);
        %Update the missing information of C by 
        C_new = (1-B).*C_thr+C1;
      
        C1 = C_new;
        TV = TV/2 ; 
    end
    %Displaying the soft-denoised image
    subplot(2,2,4), imshow(uint8(C1)),title('soft-denoised image');
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
