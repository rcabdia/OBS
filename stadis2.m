function [ del , az ] = stadis2(lat1,lon1,lat2,lon2)
%
% Computes the epicentral distance and azimuth from source to receiver.
% Latitudes are converted to geocentric latitudes prior to performing
% the computations (it is assumed that input latitudes are geographic).
%
% This version has "standard" inputs.
%  input:
%    lat1 = source latitude (degrees)
%    lon1 = source longitdue (degrees)
%    lat2 = station latitude (degrees)
%    lon2 = station longitdue (degrees)
%  output:
%    del   = epicentral distance (degrees)
%    az    = azimuth from source to receiver, measure from North (degrees)
%
rad = 180.0 / pi;
% Convert source to to co-latitudes and co-longitudes, in degrees
%   colat = source colatitude
%   colon =   "    colongitude
colat = 90.0 - lat1;
colon = lon1;
if (colon < 0.0)
    colon = 360.0 + colon;
end;
% Convert station to to co-latitudes and co-longitudes, in radians
%   t1    = station colatidue
%   p1    =    "    colongitude
t1 = (90.0 - lat2) / rad;
p1 = lon2;
if (p1 < 0.0)
    p1 = 360.0 + p1;
end;
p1 = p1 / rad;
%
% Conversions are done - drop into some really old code
%
%  first do eq coords.
%  use geocentric e.q.colat
t0=geoc4(colat/rad);
p0=colon/rad;
c0=cos(t0);
s0=sin(t0);
%  now do station coords.
%  use geocentric station colat
t2=geoc4(t1);
c1=cos(t2);
s1=sin(t2);
%  now calculate distance
dp=p1-p0;
co=c0*c1+s0*s1*cos(dp);
si=sqrt(1.d0-co*co);
del=atan2(si,co)*rad;
%  now calculate azimuth
caz=(c1-c0*co)/(si*s0);
dp2=-dp;
saz=-s1*sin(dp2)/si;
az=atan2(saz,caz)*rad;
%  change az to be between 0 and 360
if(az < 0.0)
    az=360.0 + az;
end;