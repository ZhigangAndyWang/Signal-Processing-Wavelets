function [PSNR_opt_H, PSNR_opt_S, PSNR_opt_H_index, PSNR_opt_S_index] = auto_test_inp()
    IMG_S = {'pics/Lena', 'pics/Boat', 'pics/Barbara'};
    FILTERTYPE_S = {'db1','db2','tf1','tf2','tf3'};
    MASK_PREFIX = 'pics/masks/';
    MASK_S = { 'm_l_v','m_l_h', 'm_l_rl', 'm_l_lr','m_ring', 'm_line', 'm_text', 'm_combine', };
    LEVELS_S = [5];
    TV_S = [50,100,200]; %Threshold values set
    SCHEME_S = [1]; %Scheme for decreasing TV
    RT_S = [5]; %Total Recursion Time set
    VAR_S = {IMG_S, FILTERTYPE_S, MASK_PREFIX, MASK_S, LEVELS_S, TV_S, SCHEME_S, RT_S};
    VARNAME_S = {'IMG_S','FILTERTYPE_S','MASK_PREFIX','MASK_S','LEVELS_S','TV_S','SCHEME_S','RT_S'};
    %optiomal PSNR values
    % the last column stores the value of original PSNR
    PSNR_opt_H = zeros(length(MASK_S),length(FILTERTYPE_S)+1,length(IMG_S));  PSNR_opt_H_index = PSNR_opt_H;
    PSNR_opt_S = zeros(length(MASK_S),length(FILTERTYPE_S)+1,length(IMG_S));  PSNR_opt_S_index = PSNR_opt_S;
    c_time = clock;
    for i = 1:length(IMG_S)
        img_name = IMG_S(i);
        img_name = img_name{1};
        pic = imread(img_name,'png');
        fprintf('\n\nTESTING PICTURE %s ...\n\n',img_name);
        %pic=rgb2gray(pic);
        %subplot(2,2,1), imshow(uint8(pic)),title('original iamge');
        for j = 1:length(MASK_S)
            mask = MASK_S(j);
            mask = strcat(MASK_PREFIX,mask{1});
            fprintf('testing inpainting with mask %s ...\n\n',mask);
            mpic = imread(mask,'png');
            B=constructMask(mpic);
            %npic is the noise picture
            npic=double(pic).*B;
            %subplot(2,2,2), imshow(uint8(npic)),title('missing Data');
            PSNR_0 = psnr(double(pic),npic,255);
            PSNR_opt_H(j,end,i) = PSNR_0 ;
            PSNR_opt_S(j,end,i) = PSNR_0 ;
            for k = 1:length(FILTERTYPE_S)
                filtertype = FILTERTYPE_S(k);
                filtertype = filtertype{1};
                fprintf('   testing filtertype %s ...\n',filtertype);
                PSNR_H = [];PSNR_S = [];
                for levels = LEVELS_S
                    for TV = TV_S        
                        fprintf('           using levels = %d and Threshold Value =%d\n',levels,TV);
                        for rt = RT_S
                            fprintf('               Setting Recursion time = %d...\n',rt);
                            for scheme = SCHEME_S
                                fprintf('                   Using %d th scheme...\n',scheme);
                                TV_tmp =TV;
                                C_H = npic;
                                C_S = npic;
                                for tmp_int = 1:rt 
                                    %Doing the wavelet decomposition 
                                    C_dec_H = D2_dwt(C_H,filtertype,levels);
                                    C_dec_S = D2_dwt(C_S,filtertype,levels);
                                    %Hard thresholding
                                    hardC = [hthresh(C_dec_H,TV_tmp)];
                                    C_thr_H = D2_idwt(hardC,levels);
                                    %Soft thresholding
                                    softC = [sthresh(C_dec_S,TV_tmp)];
                                    C_thr_S = D2_idwt(softC,levels);
                                    %Update the missing information of C by 
                                    C_new_H = (1-B).*C_thr_H + B.*C_H;
                                    C_H = C_new_H;
                                    C_new_S = (1-B).*C_thr_S + B.*C_S;
                                    C_S = C_new_S;
                                    TV_tmp = decreaseTV(TV_tmp,scheme);
                                end
                                %Displaying the hard-denoised image
                                %subplot(2,2,3),imshow(uint8(C)),title('hard-denoised image');
                                PSNR_H(end+1) = psnr(double(pic),C_H,255);
                                %Displaying the soft-denoised image
                                %subplot(2,2,4), imshow(uint8(newpics)),title('soft-denoised image');
                                PSNR_S(end+1) = psnr(double(pic),C_S,255);
                            end
                        end
                    end
                end
                [maxv,index] = max(PSNR_H);
                PSNR_opt_H(j,k,i) = maxv; PSNR_opt_H_index(j,k,i) =index;
                [maxv,index] = max(PSNR_S);
                PSNR_opt_S(j,k,i) = maxv; PSNR_opt_S_index(j,k,i) =index;
            end
        end
    end
    printRes(IMG_S,c_time,VAR_S,VARNAME_S, PSNR_opt_H,PSNR_opt_S,PSNR_opt_H_index,PSNR_opt_S_index);
end
function printRes(IMG_S,c_time,VAR_S,VARNAME_S, H,S,H_i,S_i)
    assignin('base','H',H);
    assignin('base','S',S);
    assignin('base','H_i',H_i);
    assignin('base','S_i',S_i);
    fprintf('\nBeginning To Write File...\n');
    fid = fopen('result_inp.tmp','a');
    %print parameter infomation
    fprintf(fid,'*************Parameter Info********\n');  
    for i = 1:length(VAR_S)
        var = VAR_S{i};
        varname = VARNAME_S(i); varname = varname{1};
        vartype = class(var);
        fprintf(fid,'%15s = ',varname);  
        if strcmp(vartype,'cell')
            fprintf(fid,'| %s ',var{:}); fprintf(fid,' |\n');
        elseif strcmp(vartype,'char')
            fprintf(fid,'| %s |\n',var);
        elseif strcmp(vartype,'double')
            fprintf(fid,'| %.0f ',var(:));fprintf(fid,' |\n');
        else
            disp(vartype)
        end
    end
    fprintf(fid,'*************Parameter Info End*************\n\n');  
    fprintf(fid,'Started @ %s \n',datestr(datenum(c_time(1),c_time(2),c_time(3),c_time(4),c_time(5),c_time(6))));
    [row_sig, col_filter, h_pic] = size(H);
    for k = 1:h_pic
        img_name = IMG_S(k); img_name = img_name{1};
        fprintf(fid,'-----Picture: %s Infomation-----\n',img_name);
        fprintf(fid,'Hard Table for Picture: %s \n',img_name);
        for i = 1:row_sig
            fprintf(fid,'%.2f ',H(i,:,k));
            fprintf(fid,'\n');
        end
        fprintf(fid,'Hard Index Table for Picture: %s \n',img_name);
        for i = 1:row_sig
            fprintf(fid,'%d ',H_i(i,:,k));
            fprintf(fid,'\n');
        end
        fprintf(fid,'Soft Table for Picture: %s \n',img_name);
        for i = 1:row_sig
            fprintf(fid,'%.2f ',S(i,:,k));
            fprintf(fid,'\n');
        end
        fprintf(fid,'Soft Index Table for Picture: %s \n',img_name);
        for i = 1:row_sig
            fprintf(fid,'%d ',S_i(i,:,k));
            fprintf(fid,'\n');
        end
    end
    c_time = clock;
    fprintf(fid,'------------------------\n Ended @ %s\n\n\n\n\n\n\n\n',datestr(datenum(c_time(1),c_time(2),c_time(3),c_time(4),c_time(5),c_time(6))));
    fclose(fid);
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
