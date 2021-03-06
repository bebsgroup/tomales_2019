function [W,E] = f_ensemble_average_spectra(T,U,instance_length,varargin)
% F_ENSEMBLE_AVERAGE_SPECTRA returns the power spectrum of U(T), using
% ezfft(T,U). T is accepted as a scalar, the sampling time of the signal U
% in seconds. The instance length is the length (in seconds) of 
% (non-overlapping) chunks that are treated as separate instances. 

% Optional inputs are, firstly, a number of points to use as a moving-mean
% frequency average. If this is not desired, use "1" to leave the signal
% unaffected by the averaging. The second optional input is a "number of
% intervals", as a tool to squeeze more intervals together. 

% Note, script is very "stupid" w.r.t windowing, and clips the end of U if
% the interval length does not evenly fit into the signal series. 

% Lukas WinklerPrins
% lukas_wp@berkeley.edu

% Last Edited 13 February 2020

measurements_per_instance = (1/T)*instance_length;
running_E = zeros(1,measurements_per_instance*T);
n_ensembles = floor(length(U)/measurements_per_instance);

if nargin == 5
    % Then the last argument is a "number of intervals"
    if varargin{2} > n_ensembles
        n_ensembles = varargin{2};
    else
        error('The indicated number of intervals will not span the input data length.\n');
    end
else
    
end

for hh = 0:n_ensembles-1
    [W,tE] = ezfft(T,U((hh*measurements_per_instance+1):(hh+1)*measurements_per_instance));
    running_E = running_E + tE;
end

if nargin >= 4
    % Then included is a window size for a moving-mean frequency average
    running_E = movmean(running_E,varargin{1});
end

E = running_E./n_ensembles;

end