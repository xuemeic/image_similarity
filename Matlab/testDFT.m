n = 10;
h = randn(n,1) + 1i*randn(n,1);
x = randn(n,1) + 1i*randn(n,1);

% build circulant matrix
C = zeros(n);
for k = 0:n-1
    C(k+1, :) = h(mod((0:n-1)-k, n)+1).';
end

y1 = C*x;                                 % matrix-vector
y2 = ifft( fft(h) .* fft(x) );            % circular convolution via FFT

disp(norm(y1 - y2));
