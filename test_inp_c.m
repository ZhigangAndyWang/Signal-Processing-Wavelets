function test_inp_c(filtertype,rt)
    %Note: Figure window 1 displays the original image, fig 2 the noisy img
    %fig 3 denoised img by hard thresholding, fig 4 denoised by soft thresholding
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
    mpic = imread('pics/masks/m_text','png');
    B = constructMask(mpic);
    C_RGB_H = zeros(size(pic));
    C_RGB_S = zeros(size(pic));
    B3 = zeros(size(pic)); for i = 1:3; B3(:,:,i) = B; end;
    n_pic = double(pic).*B3;
    PSNR1  =  psnr(double(n_pic),double(pic),255)
    subplot(2,2,2), imshow(uint8(n_pic)),title('Corrupted Image');
    for i = 1:3
        %npic is the polluted picture
        npic = double(pic(:,:,i)).*B;
        C_H = npic;
        C_S = npic;
        TV_TMP = TV;
        for j = 1:rt
            C_dec_H = D2_dwt(C_H,filtertype,levels);
            C_dec_S = D2_dwt(C_S,filtertype,levels);
            %Hard thresholding
            hardC = [hthresh(C_dec_H,TV_TMP)];
            C_thr_H = D2_idwt(hardC,levels);
            %Soft thresholding
            softC = [sthresh(C_dec_S,TV_TMP)];
            C_thr_S = D2_idwt(softC,levels);
            %Update the missing information of C by 
            C_new_H = (1-B).*C_thr_H + B.*C_H;
            C_H = C_new_H;
            C_new_S = (1-B).*C_thr_S + B.*C_S;
            C_S = C_new_S;
            TV_TMP = decreaseTV(TV_TMP,1);
        end
        C_RGB_H(:,:,i) = C_H;
        C_RGB_S(:,:,i) = C_S;
    end
    %Displaying the hard-denoised image
    subplot(2,2,3),imshow(uint8(C_RGB_H)),title('hard-denoised image');
    %assignin('base','C_RGB_H',C_RGB_H);
    PSNR  =  psnr(double(pic),C_RGB_H,255)
    subplot(2,2,4),imshow(uint8(C_RGB_S)),title('soft-denoised image');
    %assignin('base','C_RGB_S',C_RGB_S);
    PSNR  =  psnr(double(pic),C_RGB_S,255)
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
