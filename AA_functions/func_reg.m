function func_reg(x,y);
 

width = 4.5e-6; 
height = 7.6e-6;
xCenter = x; 
yCenter = y; 
xLeft = xCenter - width/2;
yBottom = yCenter - height/2;
rectangle('Position', [xLeft, yBottom, width, height], 'EdgeColor', 'b',  'LineWidth', 1);

grid on;
