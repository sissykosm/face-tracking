function [] = multiscale_total_displ(boundingBox1,N,rho,epsilon,M,type)

boundingBox = boundingBox1;                                                    
energy_thres = 0.3;

for i = 1:65
    I1 = imread([num2str(i),'.png']);
    I1 = im2double(I1);
    I2 = imread([num2str(i+1),'.png']);
    I2 = im2double(I2);
    
    %*****Comment out the next line to save all the frames with the face detection*****% 
%     fig = figure;
    clf;
    hold on;
    imshow(I1);
    rectangle('Position',boundingBox,'EdgeColor','g');
    hold off;
    pause(.01);
    %*****Comment out the next lines to save all the frames with the face detection*****% 
%     title(['Face detection on the frame ',num2str(i)]);
%     saveas(fig,['Multi-BoundingBox',num2str(i)],'jpeg');

    I1_frame = imcrop(I1,boundingBox);
    I1_frame = rgb2gray(I1_frame);
    I2_frame = imcrop(I2,boundingBox);
    I2_frame = rgb2gray(I2_frame);
    
    d_x0 = 0;
    d_y0 = 0;
    [d_x,d_y] = multiscale_lk(I1_frame,I2_frame,rho,epsilon,d_x0,d_y0,N,M);

    %*****Comment out these lines to save the optical flow for all the frames*****% 
%     d_x_r = imresize(d_x,0.3);
%     d_y_r = imresize(d_y,0.3);
%     fig = figure;
%     quiver(-d_x_r,-d_y_r);
%     axis equal;
%     title(['Optical flow from the frame ',num2str(i),' to ',num2str(i+1)]);
%     saveas(fig,['Multi-OpticalFlow-',num2str(i),'-',num2str(i+1)],'jpeg');
    
    %*****Comment out these lines to save the vectors' energy for all the frames*****% 
%     Energy = d_x.^2 + d_y.^2;
%     Energy = (Energy-min(Energy(:)))./(max(Energy(:))-min(Energy(:)));
%     fig = figure;
%     imshow(Energy);
%     title(['Energy of the translation vectors from the frame ',num2str(i),' to ',num2str(i+1)]);
%     saveas(fig,['Multi-VectorsEnergy-',num2str(i),'-',num2str(i+1)],'jpeg');
 
    [displ_x,displ_y] = displ(d_x,d_y,energy_thres,type);
    boundingBox(1:2) = boundingBox(1:2)-[displ_x displ_y];
end    
    
%*****Comment out the next line to save the last frame with the face detection*****% 
% fig = figure;
clf;
hold on;
imshow(I2);
rectangle('Position',boundingBox,'EdgeColor','g');
hold off;
%*****Comment out the next lines to save all the frames with the face detection*****% 
% title(['Face detection on the frame ',num2str(i+1)]);
% saveas(fig,'Multi-BoundingBox66','jpeg');

end