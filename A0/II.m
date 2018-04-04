figure;
I = imread('1.png');
% convert image to grayscale
grayscale = rgb2gray(I);
subplot(3,2,1);
imshow(I);
title('original');

% a) map a grayscale image to its negative image, in which the lightest 
%values appear dark and vice versa.
%use imcomplement to get a negative image matrix
A = imcomplement(grayscale);
subplot(3,2,2);
imshow(A);
title('negative image');

%b) map the image to its mirror image, i.e., flipping it left to right.]]
% flip the grayscale matrix on horizontal level
B = flip(grayscale ,2);
subplot(3,2,3);
imshow(B);
title('mirror image');

%c) swap the red and green color channels of the input color image
C = I;
%use temp to keep R channel values, then swap R and G
temp = C(:,:,1);
C(:,:,1) = C(:,:,2);
C(:,:,2) = temp;
subplot(3,2,4);
imshow(C);
title('swap red and green');

%d) average the input image with its mirror image (use typecasting!)
% typecasting
D1 = im2double(grayscale);
D2 = im2double(flip(grayscale ,2));
% average the 2 matrix
D = (D1 + D2) / 2;
subplot(3,2,5);
imshow(D);
title('average with mirror');

%e) add or subtract a random value between [0,255] to every pixel in a 
%grayscale image, then clip the resulting image to have a minimum value of 
%0 and a maximum value of 255.
subplot(3,2,6);
imshow(grayscale);
randomInt = randi([-255,255],1,1);
% add a value in [-255,255]
E1 = grayscale + randomInt;
% set minimum value of 0 and a maximum value of 255 by mat2gray
E = uint8(255 * mat2gray(E1));
%disp(max(max(E)));
%disp(min(min(E)));
imshow(E);
title('full pixel range');