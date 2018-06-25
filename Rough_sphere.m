clear all
%Rough sphere
R0=100E-9; %Maximum radius [m]
n=100; %Density
theta_0=linspace(0,pi,n);
phi_0=linspace(0,2*pi,2*n);
[theta,phi]=meshgrid(theta_0,phi_0);


 N = [length(phi_0) length(theta_0)]; % size in pixels of image
 F = 10;        % frequency-filter width
 [X,Y] = ndgrid(1:N(1),1:N(2));
 i = min(X-1,N(1)-X+1);
 j = min(Y-1,N(2)-Y+1);
 H = exp(-.5*(i.^2+j.^2)/F^2);
 R = R0+real(ifft2(H.*fft2(randn(N))))*2E-7;
 


x=R.*cos(phi).*sin(theta);
y=R.*sin(phi).*sin(theta);
z=R.*cos(theta);

surf(x,y,z);
axis equal;
