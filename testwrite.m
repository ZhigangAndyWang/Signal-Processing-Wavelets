function testwrite()

    IMG_S = {'pics/Lena'};
    FILTERTYPE_S = {'db1','db2','tf1','tf2','tf3','tf4'};
    MASK_PREFIX = 'pics/masks/';
    MASK_S = { 'm_combine', 'm_l_lr', 'm_l_v',  'm_ring', 'm_circle',  'm_l_h',  'm_l_rl', 'm_line', 'm_text', };
    LEVELS_S = [5];
    TV_S = [100,200]; %Threshold values set
    SCHEME_S = [1,2]; %Scheme for decreasing TV
    RT_S = [5]; %Total Recursion Time set

    VAR_S = {IMG_S, FILTERTYPE_S, MASK_PREFIX, MASK_S, LEVELS_S, TV_S, SCHEME_S, RT_S};
    VARNAME_S = {'IMG_S','FILTERTYPE_S','MASK_PREFIX','MASK_S','LEVELS_S','TV_S','SCHEME_S','RT_S'};

    fid = fopen ('andy','w+');

    for i = 1:length(VAR_S)
        var = VAR_S{i};
        varname = VARNAME_S(i); varname = varname{1};
        vartype = class(var);
        fprintf(fid,'%15s = ',varname);  
        if strcmp(vartype,'cell')
            fprintf(fid,'| %s ',var{:}); fprintf(fid,'\n');
        elseif strcmp(vartype,'char')
            fprintf(fid,'| %s \n',var);
        elseif strcmp(vartype,'double')
            fprintf(fid,'| %.0f ',var(:));fprintf(fid,'\n');
        else
            disp(vartype)
        end
    end
    fclose(fid);
end

