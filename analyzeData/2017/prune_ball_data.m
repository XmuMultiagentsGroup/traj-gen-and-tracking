% This function prunes the really bad ball data
% Removes the unreliable - marked as 0 in the text file - ball data
%
% b1 is the pruned data from cameras 1 and 2
% b3 is the pruned data from cameras 3 and 4

function [b1,b3,filtered_balls] = prune_ball_data(B)

t = 0.002 * (1:size(B,1))';
% load table parameters
loadTennisTableValues;
zMax = 0.5;

% PRUNE OBVIOUS OUTLIERS FOR CAMERA 1
% camera 1 time indices for reliable observations
idx1 = find(B(:,2) == 1 & B(:,5) >= table_z & B(:,5) < zMax);
t1 = t(idx1);
% order the ball data w.r.t. time and throw away same values
b1 = [t1,B(idx1,3:5)];
b1 = sortrows(b1);
j = 2;
tol = 1e-3;
idxDiffBallPos1 = 1; % index for diff ball positions
for i = 2:size(b1,1)
    if norm(b1(i,2:4) - b1(i-1,2:4)) > tol
        idxDiffBallPos1(j) = i;
        j = j+1;
    end
end
b1 = b1(idxDiffBallPos1,:);

% HERE REPEAT THE SAME FOR CAMERA 3
% camera 3 time indices for reliable observations
idx3 = find(B(:,7) == 1 & B(:,10) >= table_z & B(:,10) < zMax);
t3 = t(idx3);
% order the ball data w.r.t. time and throw away same values
b3 = [t3,B(idx3,8:10)];
b3 = sortrows(b3);
j = 2; 
tol = 1e-3;
idxDiffBallPos3 = 1; % index for diff ball positions
for i = 2:size(b3,1)
    if norm(b3(i,2:4) - b3(i-1,2:4)) > tol
        idxDiffBallPos3(j) = i;
        j = j+1;
    end
end
b3 = b3(idxDiffBallPos3,:);

% if available get the filter data
try
    b3est = [t3,B(idx3,12:17)];
    b3est = sortrows(b3est);
    filtered_balls = b3est(idxDiffBallPos3,:);
catch 
    warning('SL filter is not available!');
    filtered_balls = [];
end