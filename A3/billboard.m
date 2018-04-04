figure;

% get 4 points
image1 = imread('trump.png');
imshow(image1);
title('Please click on the 4 chosen points');
[c1,r1] = ginput(4);
c1 = round(c1);
r1 = round(r1);
points1 = zeros(2,4);
points1(1,:) = r1';
points1(2,:) = c1';

destImage = imread('board.jpg');
imshow(destImage);
title('Please click on the 4 chosen points');
[c2,r2] = ginput(4);
c2 = round(c2);
r2 = round(r2);
points2 = zeros(2,4);
points2(1,:) = r2';
points2(2,:) = c2';

% generate homography matrix
H = getHomographyMatrix(points1, points2);

% generate warped image
[warppedImage, boundingBox] = warpImage(image1, H);


% create mosaic
mosaicImage = mosaicForBillBoard(warppedImage, boundingBox,destImage);

% show image
imshow(mosaicImage);
