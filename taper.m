%funcion taper, es la funcion ventana 10% coseno
function [v]=taper(y);
%Ejemplo
%x=[1:2*pi/100:2*pi];
%y=sin(x)+2*cos(3*x);
%chekeo
l=length(y);
if  rem(l,2)==0
    n=0.1*length(y);
    a=0:pi/(2*n):(pi/2);
    a=sin(a);
    b=fliplr(a);
    dim=0.80*length(y);
    k=ones(1,dim);
    v=[a,k,b];
else
    n=0.1*length(y);
    a=0:pi/(2*n):(pi/2);
    a=sin(a);
    b=fliplr(a);
    dim=0.80*length(y)-1;
    k=ones(1,dim);
    v=[a,k,b];
end

