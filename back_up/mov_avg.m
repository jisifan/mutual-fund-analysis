function x_ma = mov_avg(x,point_size)
%Applies a moving average filter of window size point_size to the series x.
pad = floor(point_size/2);
if mod(point_size,2) %Padding the series
    x = [ones(1,pad)*x(1),x,ones(1,pad)*x(end)];
else
    x = [ones(1,pad)*x(1),x,ones(1,pad-1)*x(end)];
end
x_ma = tsmovavg(x,'s',point_size); %Moving average filter
x_ma = circshift(x_ma,-pad);
x_ma = x_ma(isfinite(x_ma));