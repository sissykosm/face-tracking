function boundingBox = fd(I0,mu,covariance)

I = rgb2ycbcr(I0);

cb = I(:,:,2).';
cr = I(:,:,3).';
c = [cb(:) cr(:)];

P = mvnpdf(c,mu,covariance);

x1 = (mu(1)-0.06):0.001:(mu(1)+0.06);
x2 = (mu(2)-0.06):0.001:(mu(2)+0.06);
[X1,X2] = meshgrid(x1,x2);
P2 = mvnpdf([X1(:) X2(:)],mu,covariance);
figure(1);
surf(X1,X2,(reshape(P2, [size(X1,1),size(X1,2)])));
title('Gaussian distribution');

P = (P(:)-min(P(:)))./(max(P(:))-min(P(:)));
figure(2);
imshow((reshape(P, [size(I,2),size(I,1)])).');
title('Skin probalility image');

thres = 0.28;                                                        
Pthres = (P > thres);
Ibin = (reshape(Pthres, [size(I,2),size(I,1)])).';
figure(3);
imshow(Ibin);
title('Skin binary image before morphological filtering');

se = strel('disk',1);
Iopen = imopen(Ibin,se);

se = strel('disk',5);                                              
Ifilter = imclose(Iopen,se);
figure(4);
imshow(Ifilter);
title('Skin binary image after morphological filtering');

L = bwlabel(Ifilter);                                               
Region = regionprops(L,'BoundingBox');
Region = cell2mat(struct2cell(Region));
Region = reshape(Region,[4,length(Region)/4]).';
[~,row] = max(Region(:,3).*(Region(:,4)));
boundingBox = Region(row,:);

figure(5);
imshow(I0);
rectangle('Position',boundingBox,'EdgeColor','g');
title('Face detection on the first frame');

end