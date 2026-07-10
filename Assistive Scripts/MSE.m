function [mse] = MSE(signal1, signal2)
%MSE    Computes mean square error between signal1 and signal2, which must
%       be the same length.
%
%   INPUTS:
%   signal1     1xN array of values
%
%   signal2     1xN array of values.
%
%   OUTPUTS:
%   mse         Mean square error between signal 1 and signal 2

    mse = mean((signal1-signal2).^2);
end