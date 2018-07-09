function [maxloc_new,minloc_new] = turn_pts(orig_ser,maxloc_old,minloc_old,neighborhood)
%Identifies new peaks and troughs in the curve orig_ser corresponding to
%previously identified peaks and troughs, maxloc_old and minloc_old.
%Neighborhood denotes the number of points/months on either side of the old
%turning points.
i = 1:length(orig_ser);
maxloc_new{1,length(maxloc_old)} = [];
minloc_new{1,length(minloc_old)} = [];
%Identifying new peaks
for j = 1:length(maxloc_old)
    ind = abs(i-maxloc_old(j)) <= neighborhood;
    maxtemp = find(orig_ser == max(orig_ser(ind)));
    temp1 = abs(maxloc_old(j)-maxtemp) > neighborhood;
    maxtemp(temp1) = [];
    maxloc_new{j} = maxtemp;
end
maxloc_new = unique(cell2mat(maxloc_new));
%Identifying new troughs
for j = 1:length(minloc_old)
    ind = abs(i-minloc_old(j)) <= neighborhood;
    mintemp = find(orig_ser == min(orig_ser(ind)));
    temp2 = abs(minloc_old(j)-mintemp) > neighborhood;
    mintemp(temp2) = [];
    minloc_new{j} = mintemp;
end
minloc_new = unique(cell2mat(minloc_new));
