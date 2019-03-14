function [displ_x,displ_y] = displ(d_x, d_y, energy_thres, type)

Energy = d_x.^2 + d_y.^2;
Energy_reg = (Energy-min(Energy(:)))/(max(Energy(:))-min(Energy(:)));
Energy = (Energy_reg >= energy_thres);

Energy_dx = d_x.*Energy;
Energy_dx = Energy_dx(Energy_dx~=0);
Energy_dy = d_y.*Energy;
Energy_dy = Energy_dy(Energy_dy~=0);

if type == 0
    displ_x = mean(Energy_dx);
    displ_y = mean(Energy_dy);
else 
    displ_x = median(Energy_dx);
    displ_y = median(Energy_dy);
end
end

