function test1()

%Note: Figure window 1 displays the original image, fig 2 the noisy img
%fig 3 denoised img by hard thresholding, fig 4 denoised by soft thresholding


%Reading the image 
pic=imread('onion','png');
pic=double(rgb2gray(pic));

figure(1), imagesc(pic);colormap(gray);

npic=missing(pic);
figure(2), imagesc(npic);colormap(gray);


filtertype='db4';
levels=5;

%Doing the wavelet decomposition
[C,S]=wavedec2(npic,levels,filtertype);


%Define the threshold(universal threshold)
UT=400;

%Hard thresholding
%Doing the hard thresholding-threshold only detail coefficients!!
% hardC=[hthresh(C(1:length(C)),TV)];
hardC=[C(1:S(1,1)^2), hthresh(C(S(1,1)^2+1:length(C)),UT)];

%Reconstructing the image from the hard-thresholded wavelet coefficients
newpich=waverec2(hardC,S,filtertype);

% %Displaying the hard-denoised image
figure(3), imagesc(uint8(newpich));colormap(gray);

% % %Soft thresholding
% softC=[sthresh(C(1:length(C)),ut)];

% %Reconstructing the image from the soft-thresholded wavelet coefficients
% newpics=waverec2(softC,S,filtertype);

% %Displaying the soft-denoised image
% figure(4), imagesc(uint8(newpics));colormap(gray);

end

function mpic=missing(pic);
	B=rand(size(pic))<0.8;
	mpic=pic.*B;
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

