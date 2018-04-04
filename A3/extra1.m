Image1 = imread('uttower1.jpg');
Image2 = imread('uttower2.jpg');
disp(size(Image1));
I1 = rgb2gray(Image1);
I2 = rgb2gray(Image2);
I1 = single(I1);
I2 = single(I2);

% find sift points
[f1,d1] = vl_sift(I1);
disp(size(f1));
disp(size(d1));
[f2,d2] = vl_sift(I2);

% sort sift match by score
[matches, scores] = vl_ubcmatch(d1, d2);
[~, ind] = sort(scores,'descend');

pointsToMatch = 4;
pos1 = zeros(pointsToMatch,2);
pos2 = zeros(pointsToMatch,2);

color = {'red','white','green','magenta'};

% get the coordinates
for i=1:pointsToMatch
    pos1(i,1) = round(f1(2,matches(1,ind(i))));
    
    pos1(i,2) = round(f1(1,matches(1,ind(i))));
    
    pos2(i,1) = round(f2(2,matches(2,ind(i))));
    
    pos2(i,2) = round(f2(1,matches(2,ind(i))));
end

% mark images with insertMarker box
Image1  = insertMarker(Image1,pos1,'x','color',color,'size',10);
Image2  = insertMarker(Image2,pos1,'x','color',color,'size',10);
figure;

%imshow(uint8(Image2));

imshow(uint8(Image1));

function [x,y] = convertIndex(a,width)
    x = floor(a/width) + 1;
    y = mod(a,width);
end
    