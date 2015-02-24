function test2()

%Note: Figure window 1 displays the original image, fig 2 the noisy img
%fig 3 denoised img by hard thresholding, fig 4 denoised by soft thresholding


%Reading the image 
pic=imread('lenna_b','png');
% size(pic)
% size(rgb2gray(pic))
pic=rgb2gray(pic);
subplot(2,2,1), imshow(uint8(pic)),title('original iamge');



%Denoising Process
sig=50;
V=(sig/256)^2;

npic=imnoise(pic,'gaussian',0,V);
subplot(2,2,2), imshow(uint8(npic)),title('noise');

filtertype='db1';
levels=2;

%Doing the wavelet decomposition
C=D2_dwt(npic,filtertype,levels);

%Define the threshold(universal threshold)
TV=50;

%Hard thresholding
%Doing the hard thresholding-threshold only detail coefficients!!
hardC=[hthresh(C,TV)];

%Reconstructing the image from the hard-thresholded wavelet coefficients
newpich=D2_idwt(hardC,levels);

%Displaying the hard-denoised image
subplot(2,2,3),imshow(uint8(newpich)),title('hard-denoised image');


%Soft thresholding
softC=[sthresh(C,TV)];

%Reconstructing the image from the soft-thresholded wavelet coefficients
newpics=D2_idwt(softC,levels);

%Displaying the soft-denoised image
subplot(2,2,4), imshow(uint8(newpics)),title('soft-denoised image');

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
