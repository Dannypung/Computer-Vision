
% Getting correspondences
figure;
%uttower2 = imread('1.jpg');
uttower2 = imread('uttower2.jpg');
imshow(uttower2);
title('Please click on the 4 chosen points');
[c1,r1] = ginput(4);
c1 = round(c1);
r1 = round(r1);
disp(size(c1));
points1 = zeros(2,4);
points1(1,:) = r1';
points1(2,:) = c1';

%uttower1 = imread('2.jpg');
uttower1 = imread('uttower1.jpg');
imshow(uttower1);
title('Please click on the 4 chosen points');
[c2,r2] = ginput(4);
c2 = round(c2);
r2 = round(r2);
points2 = zeros(2,4);
points2(1,:) = r2';
points2(2,:) = c2';

H = getHomographyMatrix(points2, points1);

[warpedImage,index] = warpImage(uttower1,H);


result = mosaic(warpedImage,index,uttower2);
imshow(uint8(result))
%close;
