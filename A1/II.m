figure;
austinJPG = imread('austin.jpg');
disneyJPG = imread('disney.jpg');
% 1. Run your reduceWidth function on the provided austin.jpg with 
% numPixels = 100 (in other words, shrink the height by 100 pixels). Run 
% your reduceHeight function on the provided disney.jpg with numPixels = 
% 100 (in other words, shrink the height by 100 pixels). Display the 
% outputs.
[output1, output1WithSeam,~] = reduceWidth(austinJPG,100);
imshow(output1);
[output2, output2WithSeam,~] = reduceHeight(disneyJPG,100);

subplot(3,2,1);
imshow(austinJPG);
title("Original austin");

subplot(3,2,3);
imshow(output1);
title("Content-aware resizing austin");

subplot(3,2,5);
resizeAustin = imresize(austinJPG,[322,500]);
imshow(resizeAustin);
title("Traditional resizing austin");

subplot(3,2,2);
imshow(disneyJPG);
title("Original disney");

subplot(3,2,4);
imshow(output2);
title("Content-aware resizing disney");

subplot(3,2,6);
resizeDisney = imresize(disneyJPG,[312,617]);
imshow(resizeDisney);
title("Traditional resizing disney");

% 2. Display (a) the energy function output (total gradient magnitudes 
% e1(I)) for the provided image austin.jpg, and (b) the two corresponding 
% cumulative minimum energy maps (M) for the seams in each direction (use 
% the imagesc function). Explain why these outputs look the way they do 
% given the original image's content.

 xEnergy = [-1 1];
 yEnergy = xEnergy';
 grayscale = rgb2gray(austinJPG);
 outa = abs(imfilter(double(grayscale), xEnergy, ...
            'replicate')) + abs(imfilter(double(grayscale), yEnergy, ...
            'replicate'));
 [~,~,outb] = reduceHeight(austinJPG,1);
 [~,~,outc]= reduceWidth(austinJPG,1);
 
 
 subplot(3,1,1);
 imagesc(outa);
 title("a");
 
 subplot(3,1,2);
 imagesc(outb);
 title("b, horizontal");
 
 subplot(3,1,3);
 imagesc(outc);
 title("c, vertical");
 
% 3. For the same image austin.jpg, display the original image together 
% with (a) the first selected horizontal seam and (b) the first selected 
% vertical seam. Explain why these are the optimal seams for this image.

% the seam selected by greedy algorithm has the lowest cumulative energy
% compared to other seams

subplot(3,1,1);
imshow(austinJPG);
title("Original austin");
 
subplot(3,1,3);
[output33, output33WithSeam] = reduceHeight(austinJPG,1);
imshow(output33WithSeam);
title("(a)");

subplot(3,1,2);
[output32, output32WithSeam] = reduceWidth(austinJPG,1);
imshow(output32WithSeam);
title("(b)");


% 4. Make some change to the way the energy function is computed (i.e., 
% filter used, its parameters, or incorporating some other a priori 
% knowledge). Display the result and explain the impact on the results for 
% some example.

 %changed the filter in reduceWidth function to sobel
 [output41, output41WithSeam,~] = reduceWidth(austinJPG,100); 
 imshow(output41WithSeam);

% 5. Now, for the real results! Use your system with different kinds of 
% images and seam combinations, and see what kind of interesting results it 
% can produce. The goal is to form some perceptually pleasing outputs where 
% the resizing better preserves content than a blind resizing would, as 
% well as some examples where the output looks unrealistic or has 
% artifacts.



% (1)bad
JPG51 = imread('7.jpg');
subplot(2,2,1);
imshow(JPG51);
title('original image');

subplot(2,2,2);
[output51, output51WithSeam] = reduceWidth(JPG51,80);
imshow(output51WithSeam);
title('output image with seam');


subplot(2,2,3);
imshow(output51);
title('output image');

output511 = imresize(JPG51,[240,240]);
subplot(2,2,4);
imshow(output511);
title('traditional resize output');

% (2) fun result
JPG52 = imread('8.png');
subplot(2,2,1);
imshow(JPG52);
title('original image');

subplot(2,2,2);
[output52, output52WithSeam] = reduceHeight(JPG52,90);
imshow(output52WithSeam);
title('output image with seam');


subplot(2,2,3);
imshow(output52);
title('output image');

output521 = imresize(JPG52,[209,427]);
subplot(2,2,4);
imshow(output521);
title('traditional resize output');


% (3) fun output
JPG53 = imread('tall_minion.jpg');
subplot(2,2,1);
imshow(JPG53);
title('original image');

subplot(2,2,2);
[output53, output53WithSeam] = reduceHeight(JPG53,150);
imshow(output53WithSeam);
title('output image with seam');


subplot(2,2,3);
imshow(output53);
title('output image');

output531 = imresize(JPG53,[363,570]);
subplot(2,2,4);
imshow(output531);
title('traditional resize output');



% Include results for at least three images of your own choosing. Include 
% an example or two of a ?bad? outcome. Be creative in the images you 
% choose, and in the amount of combined vertical and horizontal carvings 
% you apply. Try to predict types of images where you might see something 
% interesting happen. It?s ok to fiddle with the parameters (seam sequence, 
% number of seams, etc) to look for interesting and explainable outcomes
    
    