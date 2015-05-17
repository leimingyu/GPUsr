%% Direction and Velocity Plots Hyperlink demo
% Each of the following links brings up an example of one of MATLAB's basic
% direction and velocity plots. The purpose of these examples is to show how
% the matlab: command can be used inside a published M-file to create a menu
% of MATLAB commands.

%% To use this file
% 
% * Save the dvplots_hyperlink_demo.m file.
% * Open it and click the PUBLISH button or use the PUBLISH function from
% the command line
% * Open the resulting dvplots_hyperlink_demo.html file in the MATLAB web
% browser.
% * Try clicking on the various links
%

%% The plot types 
% <html>
% Click one of the following links to bring up an example of that plot
% type.
% <ul>
% <li><a href="matlab:t = 0:.01:2*pi;x = cos(2*t).*(cos(t).^2);y = sin(2*t).*(sin(t).^2);comet(x,y);">comet</a> 2-D comet plot</li>
% <li><a href="matlab:t = -10*pi:pi/250:10*pi;comet3((cos(2*t).^2).*sin(t),(sin(2*t).^2).*cos(t),t);">comet3</a> 3-D comet</li>
% <li><a href="matlab:Z = eig(randn(20,20));compass(Z);">plotcompass</a> Plot arrows emanating from origin</li>
% <li><a href="matlab:theta = (-90:10:90)*pi/180;r = 2*ones(size(theta));[u,v] = pol2cart(theta,r);feather(u,v);">feather</a> Plot velocity vectors</li>
% <li><a href="matlab:[X,Y] = meshgrid(-2:.2:2);Z = X.*exp(-X.^2 - Y.^2);[DX,DY] = gradient(Z,.2,.2);contour(X,Y,Z);hold on;quiver(X,Y,DX,DY);colormap hsv;hold off">quiver</a> Quiver or velocity plot</li>
% <li><a href="matlab:[X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);Z = X.* exp(-X.^2 - Y.^2);[U,V,W] = surfnorm(X,Y,Z);quiver3(X,Y,Z,U,V,W,0.5);hold on;surf(X,Y,Z);colormap hsv;view(-35,45);axis ([-2 2 -1 1 -.6 .6]);hold off">quiver3</a> 3-D quiver or velocity plotDiscrete Data Plots</li>
% </ul></html>