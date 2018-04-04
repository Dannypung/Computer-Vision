figure;
% ouput code for planets
planets = imread('planets.jpg');
radias = 95;
centers = detectCircles(planets, radias);
for i = 1:size(centers,1)
    for gradient = 1:360
        theta = gradient*2*pi/360;
        cIndex = centers(i,2) - radias*cos(theta); 
        rIndex = centers(i,1) - radias*sin(theta);
        if cIndex >= 0.5 && rIndex >= 0.5 && cIndex < ...
                size(planets,2)+ 0.5 && rIndex < size(planets,1)+ 0.5  
            planets(int16(rIndex),int16(cIndex),:) = [255 0 0];
        end
    end
end
imshow(planets);
title("planets result, radias = 95");

% ouput code for coins
coins = imread('coins.jpg');
radias = 95;
centers = detectCircles(coins, radias);
for i = 1:size(centers,1)
    for gradient = 1:360
        theta = gradient*2*pi/360;
        cIndex = centers(i,2) - radias*cos(theta); 
        rIndex = centers(i,1) - radias*sin(theta);
        if cIndex >= 0.5 && rIndex >= 0.5 && cIndex < ...
                size(coins,2)+ 0.5 && rIndex < size(coins,1)+ 0.5  
            coins(int16(rIndex),int16(cIndex),:) = [255 0 0];
        end
    end
end
imshow(coins);
title("coins result, radias = 95, bin = 1");

% ouput code for chosenImg
chosenImg = imread('test.png');
radias = 70;
centers = detectCircles(chosenImg, radias);
for i = 1:size(centers,1)
    for gradient = 1:360
        theta = gradient*2*pi/360;
        cIndex = centers(i,2) - radias*cos(theta); 
        rIndex = centers(i,1) - radias*sin(theta);
        if cIndex >= 0.5 && rIndex >= 0.5 && cIndex < ...
                size(chosenImg,2)+ 0.5 && rIndex < size(chosenImg,1)+ 0.5  
            chosenImg(int16(rIndex),int16(cIndex),:) = [255 0 0];
        end
    end
end
imshow(chosenImg);
title("Chosen image result, radias = 70");


% generate accumulator array.
chosenImg = imread('test.png');
radias = 70;
centers = detectCircles(chosenImg, radias);

