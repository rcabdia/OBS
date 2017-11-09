function [geoc4] = geoc4(arg)
% Converts from a geographic colatitude to geocentric.
%
% input:
%   arg    = geographic colatitude (radians)
% output:
%   geoc4 = geocentric colatitude (radians)
%
% (n.b. fac=(1-f)**2)
%
fac = 0.993305621334896;
%
geoc4 = (pi / 2.0) - atan(fac*cos(arg) / max(1.e-30,sin(arg)) );