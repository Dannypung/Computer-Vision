function [result, index] = warpImage(img1, H)
    
    % get the converted index of 4 corners
    corners = [1,1;size(img1,1),1;1,size(img1,2);size(img1,1),size(img1,2)];
    convertedIndex1 = H*[corners(1,1);corners(1,2);1];
    convertedIndex1 = round(convertedIndex1/convertedIndex1(3));
    convertedIndex2 = H*[corners(2,1);corners(2,2);1];
    convertedIndex2 = round(convertedIndex2/convertedIndex2(3));
    convertedIndex3 = H*[corners(3,1);corners(3,2);1];
    convertedIndex3 = round(convertedIndex3/convertedIndex3(3));
    convertedIndex4 = H*[corners(4,1);corners(4,2);1];
    convertedIndex4 = round(convertedIndex4/convertedIndex4(3));
    
    %find the min left index, max right index, min top index, max bottom
    %index
    minX = min([convertedIndex1(1),convertedIndex2(1),convertedIndex3(1),convertedIndex4(1)]);
    maxX = max([convertedIndex1(1),convertedIndex2(1),convertedIndex3(1),convertedIndex4(1)]);
    minY = min([convertedIndex1(2),convertedIndex2(2),convertedIndex3(2),convertedIndex4(2)]);
    maxY = max([convertedIndex1(2),convertedIndex2(2),convertedIndex3(2),convertedIndex4(2)]);
    
    index = [minX,maxX,minY,maxY];
    
    % create the output image, size decided by the min max boudary values
    result = zeros(maxX-minX+1,maxY-minY+1,3);
    % get inverse of HomographyMatrx
    invH = inv(H);
    
    % two matrix stores the x,y index of pixels
    rows = zeros(1,size(result,1)*size(result,2));
    columns = zeros(1,size(result,1)*size(result,2));

    i = 1;
    for k = minY:maxY
        for j = minX:maxX
           tempConvertedIndex = invH*[j;k;1]; 
           tempConvertedIndex = tempConvertedIndex/tempConvertedIndex(3);
           rows(1,i) = tempConvertedIndex(1);
           columns(1,i) = tempConvertedIndex(2);
           i = i + 1;
         end
    end
    
    % write values to three color channels
    for i=1:3
        result(:,:,i) = reshape(interp2(double(img1(:,:,i)),columns,rows), size(result,1), size(result,2));
    end
    % set pixels with NaN value to black.
    result(isnan(result)) = 0;
    result = uint8(round(result));

end