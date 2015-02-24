function test_inp_nc(filtertype,rt)

    % Temp fun of test_inp_c, basically the same
        
    levels = 5;
    %Define the threshold(universal threshold)
    TV = 200;
        
    %Reading the image 
    pic = imread('pics/1','png');
    pic_R = pic(:,:,1);
    pic_G = pic(:,:,2);
    pic_B = pic(:,:,3);
    subplot(2,2,1), imshow(uint8(pic)),title('original iamge');
    
    %Inpainting Process
    %mpic is the mask picture
    %mpic  =  imread('m_line','png');
    %mpic  =  imread('m_circle','png');
    mpic = imread('pics/m1','png');
    mpic = rgb2gray(mpic);
    %mpic  =  imread('m_1','png');
    %mpic  =  rgb2gray(mpic);
    B = constructMask(mpic);
    
    C_RGB = zeros(size(pic));

    B3 = zeros(size(pic)); for i = 1:3; B3(:,:,i) = B; end;
    n_pic = double(pic).*B3;
    PSNR1  =  psnr(double(n_pic),C_RGB,255)
    subplot(2,2,2), imshow(uint8(n_pic)),title('missing Data');

    for i = 1:3
        %npic is the polluted picture

        C = npic;
        TV_TMP = TV;
        for j = 1:rt
            %Doing the wavelet decomposition
            C_dec = D2_dwt(C,filtertype,levels);
            %[C_dec,S] = wavedec2(C,levels,'db1');
        
            %Hard thresholding
            %Doing the hard thresholding-threshold only detail coefficients!!
            hardC = [hthresh(C_dec,TV_TMP)];
        
            %Reconstructing the image from the hard-thresholded wavelet coefficients
            C_thr = D2_idwt(hardC,levels);
            %C_thr = waverec2(hardC,S,'db1');
        
            %Update the missing information of C by 
            C_new  =  (1-B).*C_thr+B.*C;
            
            C  =  C_new;
            
            TV_TMP = decreaseTV(TV_TMP,1);
        end
        
        C_RGB(:,:,i) = C;
    end
        
    %Displaying the hard-denoised image
    subplot(2,2,3),imshow(uint8(C_RGB)),title('hard-denoised image');
    assignin('base','C_RGB',C_RGB);
    figure(3),imshow(uint8(C_RGB));
    
    PSNR  =  psnr(double(pic),C_RGB,255)
    
    % C1 = npic;
    
    % for j = 1:5
    %     %Doing the wavelet decomposition
    %     C_dec = D2_dwt(C1,filtertype,levels);
    
    %     %Soft thresholding
    %     softC = [sthresh(C_dec,TV)];
    
    %     %Reconstructing the image from the soft-thresholded wavelet coefficients
    %     C_thr = D2_idwt(softC,levels);
    %     %Update the missing information of C by 
    %     C_new  =  (1-B).*C_thr+C1;
    
    %     C1  =  C_new;
    
    %     TV  =  TV/2 ; 
    
    % end
    
    
    % %Displaying the soft-denoised image
    % subplot(2,2,4), imshow(uint8(C1)),title('soft-denoised image');
end

function op = sthresh(X,T)
    %A function to perform soft thresholding on a 
    %given an input vector X with a given threshold T
    % S = sthresh(X,T);
    ind = find(abs(X) <= T);
    ind1 = find(abs(X) > T);
    X(ind) = 0;
    X(ind1) = sign(X(ind1)).*(abs(X(ind1))-T);
    op = X;
end
    


function op = hthresh(X,T)
    %A function to perform hard thresholding on a 
    %given an input vector X with a given threshold T
    % H = hthresh(X,T);
    ind = find(abs(X) <= T);
    X(ind) = 0;
    op = X;
end


function res = constructMask(mpic)
	res  =  mpic > 150;
	% size(res)
end


