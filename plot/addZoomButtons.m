function addZoomButtons(FH)
%Add only Zoom out & in buttons
%http://www.mathworks.com/matlabcentral/answers/100561-how-do-i-customize-a-figure-toolbar-by-removing-certain-buttons
%See also /MATLAB/test/GUI_test/toolbar_hide.m
set(FH,'toolbar','figure');
h_all = findall(FH);
str_tool = {'Print Figure','Save Figure','Open File', 'New Figure',...
    'Edit Plot','Rotate 3D','Data Cursor','Brush/Select Data',...
    'Link Plot','Insert Colorbar','Insert Legend','Hide Plot Tools','Show Plot Tools and Dock Figure'};
for n=1:length(str_tool)
   b = findall(h_all,'ToolTipString',str_tool{n});
   set(b,'Visible','Off');
end
