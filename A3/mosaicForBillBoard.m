function result = mosaicForBillBoard(image1,image1Index,image2)

% get the converted indexes from image1Index
minX = image1Index(1);
maxX = image1Index(2);
minY = image1Index(3);
maxY = image1Index(4);
if minX < 1
    top = minX;
else
    top = 1;
end

if maxX > size(image2,1)
    bottom = maxX;
else
    bottom = size(image2,1);
end

if minY < 1
    left = minY;
else
    left = 1;
end    
    
if maxY > size(image2,2)
    right = maxY;
else
    right = size(image2,2);
end 

length = right - left + 1;
depth = bottom - top + 1;
% put two images together
result = zeros(depth,length,3);
result(1 - top + 1:size(image2,1) - top + 1, 1 - left + 1:size(image2,2) - left + 1,:) = image2;
result(minX - top + 1:maxX - top + 1,minY - left + 1:maxY - left + 1,:) = image1;

result = uint8(result);
end