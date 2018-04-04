Image = imread('floor.jpg');
imshow(Image);
title('Please click on the 4 chosen points');
[c1,r1] = ginput(4);
imshow(Image);
c1 = round(c1);
r1 = round(r1);
points1 = zeros(2,4);
points1(1,:) = r1';
points1(2,:) = c1';

% imshow(Image);
% title('Please click on the 4 chosen points');
% [c2,r2] = ginput(4);
% imshow(Image);
% c2 = round(c2);
% r2 = round(r2);
% points2 = zeros(2,4);
% points2(1,:) = r2';
% points2(2,:) = c2';

points2 = [4 295 4 295;162 162 325 325];
H = getHomographyMatrix(points1, points2);

[warppedImage, boundingBox] = warpImage(Image,H);
figure;
imshow(uint8(warppedImage));


