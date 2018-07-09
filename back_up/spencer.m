function x_spenc = spencer(x)
%Spencer's 15-Point Moving Average
weights = [-3 -6 -5 3 21 46 67 74 67 46 21 3 -5 -6 -3]/320;
x = [ones(1,7)*x(1),x,ones(1,7)*x(end)]; %Padding the series
x_spenc = tsmovavg(x,'w',weights)'; %Spencer's 15-Point MA filter
x_spenc = circshift(x_spenc,-7)';
x_spenc = x_spenc(isfinite(x_spenc));