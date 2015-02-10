function [ output_args ] = create_GUI_tab4 ( settings, hTabGroup )

global view;
global model;

tab4 = uitab(hTabGroup, 'title','Data Export');                     % create the tab title
position = view.position(4,:);  

ui_text1 = uicontrol(tab4, 'Style', 'pushbutton', 'String', 'Export Data',...
    'Position', [120 200 150 25],'HorizontalAlignment','left', 'Callback', @execute_export);

end

function execute_export(source, callbackdata)


end

