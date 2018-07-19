function [phase,maxlocation,minlocation,gt,ct,check] = BB_algorithm(dateSeries,x, lamda,chg)
%Applies the Bry and Boschan (1971) Algorithm to identify the peaks and
%troughs in the daily series x. lamda control the smoothness of sequence
%larger lamda means smoother sequence. chg indicates the standard when we
%decide whether keep a point close to it's neighboor.

if nargin == 2
lamda = 100000;
chg = 0.2;
end



% we conserve points whose change percent compare to it's neighboor is
% bigger than chg


%100 workdays = 5 months,calculate original peaks and troughs
shortPeriod = 100; 
 
%120 workdays = 6 months,elimate consercutive point pair whose distance 
 %is less than 6 months and change percent is lower than chg.
mediumPeriod = 60;

%300 workdays = 15 months,least circle duration(not used now)
longPeriod = 300; 

%STEP I: Smooth row data
n = size(x,1);
I = eye(n);
D = diff(I,3);

%Whittaker smoother
z = (I + lamda * (D' * D)) \ x;
%pure fluction
gt = z;
%noise
ct = x - z;

% z = z';
% use row data no smooth data(a choice)
z = x';

%Check Theorem of Conservation of Moments
order_0 = sum(z')-sum(x);
matrix_1234 = tril(ones(n,n),0)* ones(n,1);
matrix_149 = matrix_1234 .* matrix_1234;
order_1 = matrix_1234'*z' - matrix_1234'*x;
order_2 = matrix_149'*z' - matrix_149'*x;
check = [order_0,order_1,order_2];%should be close to zero

%STEP II: Identifying peaks and troughs
maxlocation = zeros(1,n);
minlocation = zeros(1,n);

for j = 1:n 
    %find points in 5 months£¨100 workdays)
    low = max(1, j-shortPeriod);
    high = min(j+shortPeriod, n);
    ind = low:high;
    if z(j) == max(z(ind))
        maxlocation(j) = j;
    elseif z(j) == min(z(ind))
        minlocation(j) = j;
    end
end
maxlocation = maxlocation(maxlocation~=0);
minlocation = minlocation(minlocation~=0);

% STEP III: Elimate redundant point
[maxlocation,minlocation] = alternate(z,maxlocation,minlocation,mediumPeriod,chg);


%FINAL CLEAN-UP

%Alternate again to make sure previous step did not result in multiple
%peaks or troughs less than 15 months from each other
location = sort([maxlocation,minlocation]);
[Lia1,Locb1] = ismember(location,maxlocation);
phase = zeros(length(location),2);

%ensure all output are column vector
phase(:,1) = location';
phase(:,2) = Lia1';
maxlocation = maxlocation';
minlocation = minlocation';
check = check';

%Check for cycles and phases (do not return)
for i = 1:length(maxlocation)-1
    temp(i) = maxlocation(i+1) - maxlocation(i);
end
for i = 1:length(minlocation)-1
    temp2(i) = minlocation(i+1) - minlocation(i);
end
for i = 1:length(location)-1
    temp3(i) = location(i+1) - location(i);
end

%All cycle durations were 15 months or more and all phase durations were 5
%months or more so no further steps needed.


