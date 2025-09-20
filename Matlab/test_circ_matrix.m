n = 10;
h = randn(n,1) + 1i*randn(n,1);
x = randn(n,1) + 1i*randn(n,1);
fft_H = fft(h); % discrete fourier transform (dft) of vector X

c1 = cconv(h, x, length(x)); %return central part of the conv w/ same size
c2 = ifft(fft_H.*fft(x)); 
norm(c1-c2); 
left = fft(c1); 
right = fft_H.*fft(x);
disp(norm(c1-c2));
disp(left);
disp(right);