function hFig = setFigureSize( varargin )
%Set figures for A4 size printing
%   Detailed explanation goes here
    if nargin < 1
        hFig = findobj('type','figure');
    else
        hFig = varargin{1};
    end
    Y = 20.984;X = 29.6774;
    xMargin = 1;               %# left/right margins from page borders
    yMargin = 1;               %# bottom/top margins from page borders
    xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
    ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
    set(hFig, 'PaperUnits','centimeters')
    set(hFig, 'PaperSize',[X Y])
    set(hFig, 'PaperPosition',[xMargin yMargin xSize ySize])
    set(hFig, 'PaperOrientation','Portrait')

end

