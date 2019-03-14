function [d_x,d_y] = multiscale_lk(I1,I2,rho,epsilon,d_x0,d_y0,N,M)

sigma = 3;
n = ceil(3*sigma)*2+1;
G = fspecial('gaussian',n,sigma);
I1_pyramid = cell(1,N);
I2_pyramid = cell(1,N);

I1_pyramid{1} = I1;
I2_pyramid{1} = I2;
for j = 2:N
   I1_filtered = imfilter(I1_pyramid{j-1},G,'symmetric');
   I1_pyramid{j} = imresize(I1_filtered,0.5);
   I2_filtered = imfilter(I2_pyramid{j-1},G,'symmetric');
   I2_pyramid{j} = imresize(I2_filtered,0.5);
end

for j = N:-1:1
    [d_x,d_y] = lk(I1_pyramid{j},I2_pyramid{j},rho,epsilon,d_x0,d_y0,M);
    if j > 1
        d_x0 = 2*imresize(d_x,[size(I1_pyramid{j-1},1) size(I1_pyramid{j-1},2)]);
        d_y0 = 2*imresize(d_y,[size(I1_pyramid{j-1},1) size(I1_pyramid{j-1},2)]);
    end
    M = M+1;
end

end