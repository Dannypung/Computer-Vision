% I

% 2 Describe (in words where appropriate) the result of each of the 
% following Matlab commands. Use the help command as needed, but try to 
% determine the output without entering the commands into Matlab. Do not 
% submit a screenshot of the result of typing these commands.

% a. >> x = randperm(5588);
%       x is a matrix of size 1*N with elements inside be random
%       permutation from 1 to 5588
 
% b. >> a = [1:2:50; 51:2:100];
%       a is matrix with 2 rows
%       the first row are the odd integers start from 1 and ends at 19,
%       the second row are the odd integers start from 51 and ends at 99. 

% c. >> f = randn(500,1);
%       f is a 500*1 matrix filled with normally distributed pseudorandom 
%       numbers
%       >> g = f(find(f > 0));
%       g is a n*1 matrix filled with n values in f which are greater than 
%       0

% d. >> x = zeros(1,100)+0.25;
%       x is a matrix of size 1*100 with each value equals to 0.25
%    >> y = 0.5.*ones(1,length(x));
%       length(x) returns the size of x's longest dimension
%       y is a matrix of size a*length(x) with each values equal to 0.5
%    >> z = x + y;
%       z is the eector addition result of x and y

% e. >> a = [1:300];
%       a is a matrix of size 1*300, with values being 1 to 300 by asending
%       order
%    >> b = a([end:-1:1]);
%       b is a matrix the same size as a, by the values being 300 to 1 by
%       descending order

% 3 Suppose you are given a 100 x 100 matrix A representing a grayscale 
% image. Write a few lines of code to do each of the following. Try to 
% avoid using loops.

% a. Plot all the intensities in A, sorted in increasing value. (Note, 
% in this case we don?t care about the 2D structure of A, we only want 
% to sort all the intensities in one list.)
original = imread('1.png');
A = rgb2gray(original);
imhist(A);

% b. Display a histogram of A?s intensities with 32 bins
imhist(A,32);

% c. Create and display a new color image the same size as A, but with 3 
% channels to represent R G and B values. Set the values to be bright red 
% (i.e., R = 255) wherever the intensity in A is greater than a threshold 
% t, and black everywhere else.
t = 100; 
temp = A;
% replace values greater than t with 255, else 0
temp(find(temp > t)) = 255;
temp(find(temp <= t)) = 0; 
II = zeros([size(temp),3]); 
II(:,:,1) = temp; 
imshow(II);

% d. Create a new image X that consists of the bottom right quadrant of A.
temp = A; 
% grab the bottom right part by index
bottomRight = temp(round(size(temp,1)/2):end, round(size(temp,2)/2):end);
imshow(bottomRight);

% e. Generate a new image, which is the same as A, but with A?s mean 
% intensity value subtracted from each pixel. 
temp = A; 
meanIntensity = mean(mean(temp));
temp = temp - meanIntensity;
imshow(temp);

% f. Use rand to write a function that returns the roll of a six-sided die
function y = rollDie()
    % get a double by rand, mutiply by 10000 and convert it to int,
    % use mod to get an int in [1,6]
    y = mod(uint8(rand(1,1)*1000),7);
end 

% g. Let y be the vector: y = [1 2 3 4 5 6]?. Use the reshape command to 
% form a new matrix z
y = [1 2 3 4 5 6]';
y = reshape(y,2,3);
disp(y);

% h. Use the max and find functions to set x to the maximum value that 
% occurs in A, and set r to the row it occurs in and c to the column it 
% occurs in. 
% max element in temp
x = max(max(A));
% find the rows and columns that max value in
[r,c] = find(A == x);

% i. Create a new variable x containing the number of 8?s in some 2D 
% matrix m.
m = [1 2 3;8 8 7];
x = size(find(m == 8),1);