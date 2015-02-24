function test1()

    %Note: Figure window 1 displays the original image, fig 2 the noisy img
    %fig 3 denoised img by hard thresholding, fig 4 denoised by soft thresholding


    %Reading the image 
    pic=imread('lena_b','jpg');
    % size(pic)
    % size(rgb2gray(pic))
    figure(1), imshow(uint8(pic));


    sig=100;
    V=(sig/256)^2;

    npic=imnoise(pic,'gaussian',0,V);
    figure(2), imshow(uint8(npic));


    filtertype='db4';
    levels=5;

    %Doing the wavelet decomposition
    [C,S]=wavedec2(npic,levels,filtertype);


    %Define the threshold(universal threshold)
    M=size(pic,1)^2;
    UT=sig*sqrt(2*log(M));
    TV=UT;

    %Hard thresholding
    %Doing the hard thresholding-threshold only detail coefficients!!
    hardC=[hthresh(C(1:length(C)),TV)];
    size(hardC)

    %Reconstructing the image from the hard-thresholded wavelet coefficients
    newpich=waverec2(hardC,S,filtertype);

    % %Displaying the hard-denoised image
    figure(3),imshow(uint8(newpich));


    % % %Soft thresholding
    % softC=[sthresh(C(1:length(C)),TV)];

    % %Reconstructing the image from the soft-thresholded wavelet coefficients
    % newpics=waverec2(softC,S,filtertype);

    % %Displaying the soft-denoised image
    % figure(4), imshow(uint8(newpics));

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

