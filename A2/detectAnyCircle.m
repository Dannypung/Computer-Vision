function [origIm] = detectAnyCircle(origIm)
    grayscale = rgb2gray(origIm);
    binaryImage = edge(grayscale, 'canny', 0.7);
    [height, width] = size(binaryImage);
    radiasRange = fix(min([height width])/2);
    accumulator = zeros(height, width, radiasRange);
    [r, c] = find(binaryImage == 1);
    % iterate each pixel and vote on potnetial radius, angel
    for pixelIndex = 1:size(r,1)
        for radias = 1:radiasRange
            for gradient = 1:360
                theta = gradient*2*pi/360;
                radiasC = c(pixelIndex) - radias*cos(theta); 
                radiasR = r(pixelIndex) - radias*sin(theta);
                if radiasC >= 1 && radiasC <= width && radiasR >= 1 && ...
                        radiasR <= height
                    accumulator(int16(radiasR), int16(radiasC), radias) = ...
                        accumulator(int16(radiasR), int16(radiasC), radias) + 1;
                end
            end
        end
    end
    threshhold = max(max(max(accumulator)))/3;
    [r,c,d] = ind2sub(size(accumulator),find(accumulator > threshhold));
    r = r(find(d > max(d)/2));
    c = c(find(d > max(d)/2));
    d = d(find(d > max(d)/2));
    % show circles on image and return
    for i = 1:size(r,1)
        for gradient = 1:360
            theta = gradient*2*pi/360;
            cIndex = c(i) - d(i)*cos(theta); 
            rIndex = r(i) - d(i)*sin(theta);
            if cIndex >= 0.5 && rIndex >= 0.5 && cIndex < ...
                    size(origIm,2)+ 0.5 && rIndex < size(origIm,1)+ 0.5  
                origIm(int16(rIndex),int16(cIndex),:) = [255 0 0];
            end
        end
    end
end