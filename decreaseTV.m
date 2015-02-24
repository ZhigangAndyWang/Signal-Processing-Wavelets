function y = decreaseTV(TV,schemetype)
    %Decrease the threshold value for next iteration according to variant methods
    y = TV;
    switch schemetype
        case {1,}
            if TV >= 50
                y  =  TV-20 ; 
            end
        case {2,}
            if TV > 10
                y = TV/2;
            end
        otherwise,
            warndlg(['undefined scheme type:',schemetype]);
            y = nan; %not a number
    end
    fprintf('                      TV_old = %.0f, TV_new = %.0f, Jump to next iteration...\n',TV,y);
end
