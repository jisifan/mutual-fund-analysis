function [maxloc_alt,minloc_alt] = alternate(orig_ser,maxlocation,...
    minlocation,duration,chg)

%Alternates peaks and troughs. Orig_ser denotes the curve currently working
%on, maxlocation is the location of the peaks, minlocation is the location
%of the troughs, and duration indicates how many months apart are
%consecutive peaks and troughs accepted, chg indicates how much change percent in
%index are accepted
location = sort([maxlocation,minlocation]);
maxval = orig_ser(maxlocation); %Values at the peaks
minval = orig_ser(minlocation); %Values at the troughs
[Lia1,Locb1] = ismember(location,maxlocation);
[Lia2,Locb2] = ismember(location,minlocation);
% 
% for i = 1:length(location)-1
%     % if there are three consecutive peaks, then elimate middle one
%     if i>=2 && Lia1(i-1) == 1 && Lia1(i) == 1 && Lia1(i+1) == 1
%         maxlocation(Locb1(i)) = NaN;
%     end
%     % if there are three consecutive troughs, then elimate middle one
%     if i>=2 && Lia2(i-1) == 1 && Lia2(i) == 1 && Lia2(i+1) == 1
%         minlocation(Locb2(i)) = NaN;
%     end
%     % if two extreme points are too close, then compare with their
%     % neighboor points.if the difference is bigger than chg, then accept
%     % that point
%     if location(i+1) - location(i) < duration  && Lia1(i) + Lia1(i+1) + Lia2(i) + Lia2(i+1) > 1 && i>1
%         % if i is not the first point and not the last point,then compare with previous one
%         j = i - 1;
%         while j>1
%             if Lia1(i) + Lia1(j) + Lia2(i) + Lia2(j) >1
%                 break;
%             end
%             j = j - 1;
%         end
%         previousLia1 = Lia1(j);
%         previousval = orig_ser(location(j));
%         if i>1 && i+1<length(location)
%             
%             Reasonable_i = true;
%             Reasonable_iplus1 = true;
%             %check i's score
%             if previousLia1 == Lia1(i) && abs(orig_ser(location(i)) - previousval)/min(previousval,orig_ser(location(i))) > chg
%                 Reasonable_i =  false;
%             end
%             %check  i+1's score
%             if Lia1(i+2) == Lia1(i+1) && abs(orig_ser(location(i+1)) - orig_ser(location(i+2)))/min(orig_ser(location(i+1)),orig_ser(location(i+2))) > chg
%                 Reasonable_iplus1 =  false;
%             end
%             %if i is better than i+1,elimate i+1
%             if ~Reasonable_iplus1
%                 if Lia1(i+1)>0
%                     maxlocation(Locb1(i+1)) = NaN;
%                     Lia1(i+1) = 0;
%                 else
%                     minlocation(Locb2(i+1)) = NaN;
%                     Lia2(i+1) = 0;
%                 end
%             end
%             if ~Reasonable_i
%                 if Lia1(i)>0
%                     maxlocation(Locb1(i)) = NaN;
%                     Lia1(i) = 0;                  
%                 else
%                     minlocation(Locb2(i)) = NaN;
%                     Lia2(i) = 0;                    
%                 end
%             end
%         end
%     end
% end

% maxlocation = maxlocation(isfinite(maxlocation));
% minlocation = minlocation(isfinite(minlocation));
% location = sort([maxlocation,minlocation]);
% [Lia1,Locb1] = ismember(location,maxlocation);
% [Lia2,Locb2] = ismember(location,minlocation);
%elimate three neighboor peek or through
for i = 1:length(location)-1
    % if there are three consecutive peaks, then elimate middle one
    if i>=2 && Lia1(i-1) == 1 && Lia1(i) == 1 && Lia1(i+1) == 1
        maxlocation(Locb1(i)) = NaN;
    end
    % if there are three consecutive troughs, then elimate middle one
    if i>=2 && Lia2(i-1) == 1 && Lia2(i) == 1 && Lia2(i+1) == 1
        minlocation(Locb2(i)) = NaN;
    end
end

maxlocation = maxlocation(isfinite(maxlocation));
minlocation = minlocation(isfinite(minlocation));
location = sort([maxlocation,minlocation]);
[Lia1,Locb1] = ismember(location,maxlocation);
[Lia2,Locb2] = ismember(location,minlocation);


for i = 2:length(location)-1
    j = i - 1;
    while j>1
        if Lia1(i) + Lia1(j) + Lia2(i) + Lia2(j) >1
            break;
        end
        j = j - 1;
    end
    % if the change percent between peak_troughs_peak is too small then
    % elimate the middle one
    if Lia1(j) == 1 && Lia2(i) == 1 && Lia1(i+1) == 1
        if abs(orig_ser(minlocation(Locb2(i))) - orig_ser(maxlocation(Locb1(j))))/orig_ser(maxlocation(Locb1(j))) < chg ...
                && abs(orig_ser(maxlocation(Locb1(i+1))) - orig_ser(minlocation(Locb2(i))))/orig_ser(minlocation(Locb2(i))) < chg ...
                && abs(orig_ser(maxlocation(Locb1(i+1))) - orig_ser(maxlocation(Locb1(j))))/orig_ser(maxlocation(Locb1(j))) < chg
            minlocation(Locb2(i)) = NaN;
            Lia2(i) = 0;
        end
    end
    
    % if the change percent between troughs_peak_troughs is too small then
    % elimate the middle one
    if Lia2(j) == 1 && Lia1(i) == 1 && Lia2(i+1) == 1
        if abs(orig_ser(maxlocation(Locb1(i))) - orig_ser(minlocation(Locb2(j))))/orig_ser(minlocation(Locb2(j))) < chg ...
                && abs(orig_ser(minlocation(Locb2(i+1))) - orig_ser(maxlocation(Locb1(i))))/orig_ser(maxlocation(Locb1(i))) < chg ...
                && abs(orig_ser(minlocation(Locb2(i+1))) - orig_ser(minlocation(Locb2(j))))/orig_ser(minlocation(Locb2(j))) < chg
            maxlocation(Locb1(i)) = NaN;
            Lia1(i)=0;
        end
    end
    
    %troughs_troughs_peak(first trough is smallest)
    %if second trough is much bigger then first trough then elimate
    %second trough
    if Lia2(j) == 1 && Lia2(i) == 1 && Lia1(i+1) == 1 && orig_ser(minlocation(Locb2(j)))<orig_ser(minlocation(Locb2(i)))
        if abs(orig_ser(minlocation(Locb2(i))) - orig_ser(minlocation(Locb2(j))))/orig_ser(minlocation(Locb2(j))) > chg
            minlocation(Locb2(i)) = NaN;
            Lia2(i)=0;
        end
    end
    
    %peak_troughs_troughs(last trough is smallest)
    %if second trough is much smaller then first trough then elimate
    %first trough
    if Lia1(j) == 1 && Lia2(i) == 1 && Lia2(i+1) == 1 && orig_ser(minlocation(Locb2(i+1))) < orig_ser(minlocation(Locb2(i)))
        if abs(orig_ser(minlocation(Locb2(i+1))) - orig_ser(minlocation(Locb2(i))))/orig_ser(minlocation(Locb2(i))) > chg
            minlocation(Locb2(i)) = NaN;
            Lia2(i)=0;
        end
    end
    
    %trough_peaks_peaks(last trough is biggest)
    if Lia2(j) == 1 && Lia1(i) == 1 && Lia1(i+1) == 1 && orig_ser(maxlocation(Locb1(i))) < orig_ser(maxlocation(Locb1(i+1)))
        if abs(orig_ser(maxlocation(Locb1(i))) - orig_ser(maxlocation(Locb1(i+1))))/orig_ser(maxlocation(Locb1(i))) > chg
            maxlocation(Locb1(i)) = NaN;
            Lia1(i)=0;
        end
    end
    
    %peaks_peaks_trough(first trough is biggest)
    if Lia1(j) == 1 && Lia1(i) == 1 && Lia2(i+1) == 1 && orig_ser(maxlocation(Locb1(i))) < orig_ser(maxlocation(Locb1(j)))
        if abs(orig_ser(maxlocation(Locb1(i))) - orig_ser(maxlocation(Locb1(j))))/orig_ser(maxlocation(Locb1(j))) > chg
            maxlocation(Locb1(i)) = NaN;
            Lia1(i)=0;
        end
    end
end

maxlocation = maxlocation(isfinite(maxlocation));
minlocation = minlocation(isfinite(minlocation));
location = sort([maxlocation,minlocation]);
[Lia1,Locb1] = ismember(location,maxlocation);
[Lia2,Locb2] = ismember(location,minlocation);

for i = 2:length(location)-1
    % if there are three consecutive peaks, then elimate middle one
    if Lia1(i-1) == 1 && Lia1(i) == 1 && Lia1(i+1) == 1
        maxlocation(Locb1(i)) = NaN;
    end
    % if there are three consecutive troughs, then elimate middle one
    if Lia2(i-1) == 1 && Lia2(i) == 1 && Lia2(i+1) == 1
        minlocation(Locb2(i)) = NaN;
    end
end


maxlocation = maxlocation(isfinite(maxlocation));
minlocation = minlocation(isfinite(minlocation));
location = sort([maxlocation,minlocation]);

for i = 2:(length(location)-1)
    if abs(orig_ser(location(i+1)) - orig_ser(location(i)))/orig_ser(location(i)) < chg ...
        && abs(orig_ser(location(i)) - orig_ser(location(i-1)))/orig_ser(location(i-1)) < chg ...
        && abs(orig_ser(location(i+1)) - orig_ser(location(i-1)))/orig_ser(location(i-1)) < chg
        if Lia1(i)>0
            maxlocation(Locb1(i)) = NaN;               
        else
            minlocation(Locb2(i)) = NaN;               
        end
    end
end

maxloc_alt = maxlocation(isfinite(maxlocation));
minloc_alt = minlocation(isfinite(minlocation));
