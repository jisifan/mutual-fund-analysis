function [maxlocation_alt,minlocation_alt] = BB_algorithm2(x)
%Applies the Bry and Boschan (1971) Algorithm to identify the peaks and
%troughs in the monthly series x.
%STEP I: IDENTIFY AND REPLACE EXTREME VALUES
shortPeriod = 100; %100 workdays = 5 months,calculate original peaks and troughs
mediumPeriod = 120; %120 workdays = 6 months,elimate peaks and troughs within 6 months 
longPeriod = 300; %300 workdays = 15 months,least circle duration

z = replace(x);
%STEP II: TURNING POINTS IN THE 12-POINT MA
z_ma12 = mov_avg(z,12); %Calculate the 12-point MA curve
i = 1:length(z_ma12);
maxlocation_ma12 = zeros(1,length(z_ma12));
minlocation_ma12 = zeros(1,length(z_ma12));

for j = 1:length(z_ma12) %Identifying peaks and troughs
    %find points in 5 months£¨100 workdays)
    ind = find(abs(i-j)<=shortPeriod);
    if z_ma12(j) == max(z_ma12(ind))
        maxlocation_ma12(j) = j;
    elseif z_ma12(j) == min(z_ma12(ind))
        min(z_ma12(ind))
        z_ma12(j)
        minlocation_ma12(j) = j;
    end
end
maxlocation_ma12 = maxlocation_ma12(maxlocation_ma12~=0);
minlocation_ma12 = minlocation_ma12(minlocation_ma12~=0);

%Elimination of points within 6 months £¨120 work days) from either ends of the series
maxlocation_ma12 = maxlocation_ma12(maxlocation_ma12 >= mediumPeriod &...
    maxlocation_ma12 <= length(z_ma12)-mediumPeriod);
minlocation_ma12 = minlocation_ma12(minlocation_ma12 >= mediumPeriod &...
    minlocation_ma12 <= length(z_ma12)-mediumPeriod);
%Alternating peaks and troughs (elimate consecutive peaks and troughs)
[maxlocation_ma12_alt,minlocation_ma12_alt] = alternate(z_ma12,maxlocation_ma12,minlocation_ma12,0);
%STEP III: TURNING POINTS IN THE SPENCER CURVE
z_spenc = spencer(z); %Calculate the Spencer curve
%Identifying new turning points corresponding to those of the 12-poing MA
%curve
[maxlocation_sp,minlocation_sp] = ...
    turn_pts(z_spenc,maxlocation_ma12_alt,minlocation_ma12_alt,shortPeriod);
%Elimination of turning points within 6 months from either ends of the
%series
maxlocation_sp = maxlocation_sp(maxlocation_sp >= mediumPeriod &...
    maxlocation_sp <= length(z_spenc)-mediumPeriod);
minlocation_sp = minlocation_sp(minlocation_sp >= mediumPeriod &...
    minlocation_sp <= length(z_spenc)-mediumPeriod);
%Alternating peaks and troughs but only if they are less than 15 months
%from each other
[maxlocation_sp_alt,minlocation_sp_alt] = ...
    alternate(z_spenc,maxlocation_sp,minlocation_sp,longPeriod);
location_sp_alt = sort([maxlocation_sp_alt,minlocation_sp_alt]);
%STEP IV: TURNING POINTS IN THE 4-POINT MA
z_ma4 = mov_avg(z,4); %Calculate the 4-point MA curve
%Identifying new turning points corresponding to those of the Spencer
%curve
[maxlocation_ma4,minlocation_ma4] = ...
    turn_pts(z_ma4,maxlocation_sp_alt,minlocation_sp_alt,shortPeriod);
%Elimination of turning points within 6 months from either ends of the
%series
maxlocation_ma4 = maxlocation_ma4(maxlocation_ma4 >= mediumPeriod &...
    maxlocation_ma4 <= length(z_ma4)-mediumPeriod);
minlocation_ma4 = minlocation_ma4(minlocation_ma4 >= mediumPeriod &...
    minlocation_ma4 <= length(z_ma4)-mediumPeriod);
%Alternating peaks and troughs but only if they are less than 15 months
%from each other
[maxlocation_ma4_alt,minlocation_ma4_alt] = ...
    alternate(z_ma4,maxlocation_ma4,minlocation_ma4,longPeriod);
location_ma4_alt = sort([maxlocation_ma4_alt,minlocation_ma4_alt]);
%STEP V: TURNING POINTS IN THE UNSMOOTHED SERIES
[maxlocation,minlocation] = ...
    turn_pts(z,maxlocation_sp_alt,minlocation_sp_alt,4);
%FINAL CLEAN-UP
%Elimination of turning points within 6 months from either ends of the
%series
maxlocation = maxlocation(maxlocation >= mediumPeriod & maxlocation <= length(z)-mediumPeriod);
minlocation = minlocation(minlocation >= mediumPeriod & minlocation <= length(z)-mediumPeriod);
%Alternating peaks and troughs but only if they are less than 15 months
%from each other
[maxlocation_alt,minlocation_alt] = ...
    alternate(z,maxlocation,minlocation,longPeriod);
location_alt = sort([maxlocation_alt,minlocation_alt]);
maxval = z(maxlocation_alt);
minval = z(minlocation_alt);
%Elimination of first and last peaks (troughs) that are lower (higher)
%than any values between it and the end of the series
while maxval(1) < max(z(1:maxlocation_alt(1)))
    maxlocation_alt(1) = [];
    maxval = z(maxlocation_alt);
end
while maxval(end) < max(z(maxlocation_alt(end):end))
    maxlocation_alt(end) = [];
    maxval = z(maxlocation_alt);
end
while minval(1) > min(z(1:minlocation_alt(1)))
    minlocation_alt(1) = [];
    minval = z(minlocation_alt);
end
while minval(end) > min(z(minlocation_alt(end):end))
    minlocation_alt(end) = [];
    minval = z(minlocation_alt);
end
%Alternate again to make sure previous step did not result in multiple
%peaks or troughs less than 15 months from each other
[maxlocation_alt,minlocation_alt] = ...
    alternate(z,maxlocation_alt,minlocation_alt,15);
location_alt = sort([maxlocation_alt,minlocation_alt]);
%Check for cycles less than 15 months and phases less than 5 months
for i = 1:length(maxlocation_alt)-1
    temp(i) = maxlocation_alt(i+1) - maxlocation_alt(i);
end
for i = 1:length(minlocation_alt)-1
    temp2(i) = minlocation_alt(i+1) - minlocation_alt(i);
end
for i = 1:length(location_alt)-1
    temp3(i) = location_alt(i+1) - location_alt(i);
end
%All cycle durations were 15 months or more and all phase durations were 5
%months or more so no further steps needed.








