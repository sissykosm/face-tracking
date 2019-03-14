function [d_x,d_y] = lk(I1,I2,rho,epsilon,d_x0,d_y0,M)

[x_0,y_0] = meshgrid(1:size(I1,2),1:size(I1,1));
d_x = d_x0;
d_y = d_y0;

if M == 0
    ux = 100;
    uy = 100;
    while norm(sqrt(ux.^2+uy.^2)) > 1         
        if M == 30
            break
        end 
        
        E = I2-interp2(I1,x_0+d_x,y_0+d_y,'linear',0);
        [I1_x, I1_y] = imgradientxy(I1);
        A1 = interp2(I1_x,x_0+d_x,y_0+d_y,'linear',0);
        A2 = interp2(I1_y,x_0+d_x,y_0+d_y,'linear',0);                
        n = ceil(3*rho)*2 + 1; 
        Grho = fspecial('gaussian',n,rho);

        a11 = imfilter(A1.^2,Grho,'symmetric')+epsilon;
        a12 = imfilter(A1.*A2,Grho,'symmetric');
        a22 = imfilter(A2.^2,Grho,'symmetric')+epsilon;
        b1 = imfilter(A1.*E,Grho,'symmetric');
        b2 = imfilter(A2.*E,Grho,'symmetric');

        D = a11.*a22-a12.^2;
        a11 = a11./D;
        a12 = a12./D;
        a22 = a22./D;

        ux = a22.*b1-a12.*b2;
        uy = -a12.*b1+a11.*b2;

        d_x = d_x+ux;
        d_y = d_y+uy;
        
        M = M + 1;
    end 
else    
    for i = 1:M
        
        E = I2-interp2(I1,x_0+d_x,y_0+d_y,'linear',0);
        [I1_x, I1_y] = imgradientxy(I1);
        A1 = interp2(I1_x,x_0+d_x,y_0+d_y,'linear',0);
        A2 = interp2(I1_y,x_0+d_x,y_0+d_y,'linear',0);                
        n = ceil(3*rho)*2 + 1; 
        Grho = fspecial('gaussian',n,rho);

        a11 = imfilter(A1.^2,Grho,'symmetric')+epsilon;
        a12 = imfilter(A1.*A2,Grho,'symmetric');
        a22 = imfilter(A2.^2,Grho,'symmetric')+epsilon;
        b1 = imfilter(A1.*E,Grho,'symmetric');
        b2 = imfilter(A2.*E,Grho,'symmetric');

        D = a11.*a22-a12.^2;
        a11 = a11./D;
        a12 = a12./D;
        a22 = a22./D;

        ux = a22.*b1-a12.*b2;
        uy = -a12.*b1+a11.*b2;

        d_x = d_x+ux;
        d_y = d_y+uy;
    end
end

end