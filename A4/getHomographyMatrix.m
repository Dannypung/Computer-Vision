function H = getHomographyMatrix(points1, points2)
    % function to calculate Homography Matrix
    % format as following:
    % points1: [x1 x2 x3 x4;
    %           y1 y2 y3 y4]
    % points2: [x1 x2 x3 x4;
    %           y1 y2 y3 y4]
    % where points1 are the points in matrix 1
    % and points2 are the corresponding points in matrix 2
    n = size(points1,2);  
    A = zeros(2*n,9);  
    A(1:2:2*n,1:2) = points1';  
    A(1:2:2*n,3) = 1;  
    A(2:2:2*n,4:5) = points1';  
    A(2:2:2*n,6) = 1;  
    x1 = points1(1,:)';  
    y1 = points1(2,:)';  
    x2 = points2(1,:)';  
    y2 = points2(2,:)';  
    A(1:2:2*n,7) = -x2.*x1;  
    A(2:2:2*n,7) = -y2.*x1;  
    A(1:2:2*n,8) = -x2.*y1;  
    A(2:2:2*n,8) = -y2.*y1;  
    A(1:2:2*n,9) = -x2;  
    A(2:2:2*n,9) = -y2;  
  
    [evec,~] = eig(A'*A);  
    H = reshape(evec(:,1),[3,3])';  
    H = H/H(end);  
end