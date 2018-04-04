function [centers] = detectCircles(im, radius)
    grayscale = rgb2gray(im);
    bin = 1;
    [row, column] = size(grayscale);
    centerCountMatrix = zeros(idivide(int16(row), bin, 'floor'), idivide(int16(column), bin, 'floor'));
    edgeDetectionResult = edge(grayscale, 'canny', 0.33);
    % iterate through pixel with non zero pixel to vote
    for r = 1:row
        for c = 1:column
            if edgeDetectionResult(r,c) > 0
                for angle = 1:360
                    theta = angle * 2 * pi / 360;
                    tempX = int16(r - radius * cos(theta));
                    tempY = int16(c - radius * sin(theta));
                    tempX = idivide(int16(tempX), bin, 'floor');
                    tempY = idivide(int16(tempY), bin, 'floor');
                    
                    if tempX > 0 && tempX <= size(centerCountMatrix, 1) ...
                            && tempY > 0 && tempY <= size(centerCountMatrix,2)
                        centerCountMatrix(tempX, tempY) = ...
                            centerCountMatrix(tempX, tempY) + 1;
                    end
                end
            end
        end
    end
    
    
    threshhold = 2*max(max(centerCountMatrix))/3;

    % write out centers
    [r, c] = find(centerCountMatrix > threshhold);
    for i = 1:size(r,1)
        im(r(i,1),c(i,1),:) = [0 0 255];
    end
    centers = bin * cat(2,r,c);
    
end