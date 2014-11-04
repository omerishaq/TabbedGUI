function [hTabGroup] = create_GUI(settings)

global view;

% create the tabbed interface
f = figure('MenuBar','None','Name','Spot Detector', 'NumberTitle', 'off', 'Resize', 'off', 'Position', view.position(1,:));       % create a figure without the default menu
hTabGroup = uitabgroup('SelectionChangedFcn',@select_Tab); 
drawnow;    % create a tab group

% create the first tab
create_GUI_tab1( settings, hTabGroup);
create_GUI_tab2( settings, hTabGroup);
create_GUI_tab3( settings, hTabGroup);

tab4 = uitab(hTabGroup, 'title','Graphs');


end

function select_Tab(hObject, event, handles)

    global view;
    column = find_TabPosition(hObject);
    set(gcf, 'Position', view.position(column,:));
  
end

