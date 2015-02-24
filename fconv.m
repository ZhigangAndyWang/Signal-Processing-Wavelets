function y=fconv(v,a)
    if length(v) < length(a)
        warndlg('signal length smaller than low pass filter length','!! Warning !!')
    end
    x=zeros(size(v));
    x(1:length(a))=a;
    y=ifft(fft(v).*fft(x));
end
