bank = load('filterBank.mat');
bank = bank.F;

winSize = 20;
numColorRegions = 3;
numTextureRegions = 2;
figure;

% read in images
snake = imread('snake.jpg');
snakegray = rgb2gray(snake);
chosenjpg = imread('test.png');
chosenjpggray = rgb2gray(chosenjpg);
gumballs = imread('gumballs.jpg');
gumballsgray = rgb2gray(gumballs);
twins = imread('twins.jpg');
twinsgray = rgb2gray(twins);

% call functions to generate textons
imStack = {snakegray, gumballsgray, twinsgray, chosenjpggray};
textons = createTextons(imStack, bank, 8); 

% snake outputs
[colorKmeanResult, textureKmeanResult] = compareSegmentations(snake,... 
bank, textons, winSize, numColorRegions, numTextureRegions);
colorKmeanResult = label2rgb(colorKmeanResult);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(2,2,1);
imshow(snake);
title("Original snake image");

subplot(2,2,2);
imshow(colorKmeanResult);
title("color segmentation output");

subplot(2,2,3);
imshow(textureKmeanResult);
title("texture segmentation output with winSize = 20");

[~, textureKmeanResult] = compareSegmentations(snake,... 
bank, textons, winSize/2, numColorRegions, numTextureRegions);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(2,2,4);
imshow(textureKmeanResult);
title("texture segmentation output with winSize = 10");

% gumballs outputs
[colorKmeanResult, textureKmeanResult] = compareSegmentations(gumballs,... 
bank, textons, 9, 8, 2);
colorKmeanResult = label2rgb(colorKmeanResult);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(2,2,1);
imshow(gumballs);
title("Original gumballs image");

subplot(2,2,2);
imshow(colorKmeanResult);
title("color segmentation output");

subplot(2,2,3);
imshow(textureKmeanResult);
title("texture segmentation output with filter bank size 38");

textons2 = createTextons(imStack, bank(:,:,1:18), 8);
[~, textureKmeanResult] = compareSegmentations(gumballs,... 
bank(:,:,1:18), textons2, 9, 8, 2);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(2,2,4);
imshow(textureKmeanResult);
title("texture segmentation output with with filter bank size 18");

% twins outputs
[colorKmeanResult, textureKmeanResult] = compareSegmentations(twins,... 
bank, textons, 13, 4, 3);
colorKmeanResult = label2rgb(colorKmeanResult);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(3,1,1);
imshow(twins);
title("Original twins image");

subplot(3,1,2);
imshow(colorKmeanResult);
title("color segmentation output");

subplot(3,1,3);
imshow(textureKmeanResult);
title("texture segmentation output");

% chosen image outputs
[colorKmeanResult, textureKmeanResult] = compareSegmentations(chosenjpg,... 
bank, textons, 13, 4, 3);
colorKmeanResult = label2rgb(colorKmeanResult);
textureKmeanResult = label2rgb(textureKmeanResult);
subplot(3,1,1);
imshow(chosenjpg);
title("Original chosen image");

subplot(3,1,2);
imshow(colorKmeanResult);
title("color segmentation output");

subplot(3,1,3);
imshow(textureKmeanResult);
title("texture segmentation output");
