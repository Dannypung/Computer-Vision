function drawRectangle(corners, color)
% corners is 2 x 4 matrix
if(size(corners,1)~=2 | size(corners,2)~=4)
    fprintf('size error in corners\n');
    keyboard;
end

hold on;
plot([corners(1,1); corners(1,2)], [corners(2,1); corners(2,2)], color, 'LineWidth', 3);
plot([corners(1,2); corners(1,4)], [corners(2,2); corners(2,4)], color, 'LineWidth', 3);
plot([corners(1,4); corners(1,3)], [corners(2,4); corners(2,3)], color, 'LineWidth', 3);
plot([corners(1,3); corners(1,1)], [corners(2,3); corners(2,1)], color, 'LineWidth', 3);
