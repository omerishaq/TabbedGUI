function [ output_args ] = create_GUI_tab1( settings, hTabGroup)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

global view;
global model;

tab1_X_offset = 150;
tab1_Y_offset = -100;
tab1 = uitab(hTabGroup, 'title','Mode');            % add first tab

ui_text = uicontrol(tab1, 'Style', 'text', 'String', 'Specify user name', 'Position', [0+tab1_X_offset 400+tab1_Y_offset 150 25],'HorizontalAlignment','left');
ui_edit_user = uicontrol(tab1, 'Style', 'edit', 'Position', [155+tab1_X_offset 400+tab1_Y_offset settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
view.tab1.edit_user = ui_edit_user;
align([ui_text ui_edit_user],'None','Middle');

ui_button_user = uicontrol(tab1, 'Style','pushbutton', 'String','Save','Position',[185+tab1_X_offset 370+tab1_Y_offset, settings.active.button_lengthX, settings.active.button_lengthY], 'Callback', @save_User);
align([ui_button_user ui_edit_user],'Right','None');
view.tab1.button_save = ui_button_user;

ui_text = uicontrol(tab1, 'Style', 'text', 'String', 'Select image mode', 'Position', [0+tab1_X_offset 310+tab1_Y_offset 150 25], 'HorizontalAlignment','left');
popup = uicontrol(tab1, 'Style', 'popup', 'String', {'   ','Single image','Multiple Image'}, 'Position', [155+tab1_X_offset 310+tab1_Y_offset settings.active.popup_lengthX settings.active.popup_lengthY], 'Callback', {@save_Popup, hTabGroup});    
align([ui_text popup],'None','Middle');
align([ui_button_user popup], 'Right','None')
view.tab1.popup_mode = popup;

Records = load(model.strings.resultsfilename);
Records = Records.Records;

for i = 1:length(Records)
    CellArray{i} = getfield(Records(i), 'user');
end
CellArray = unique(CellArray)';

cnames = {'User names'};
t = uitable('Parent', tab1,'Data',CellArray,'ColumnWidth',{215},'Position', [550 50 300 400], 'ColumnName',cnames);



end

function save_User(hObject, event, handles)
    global model
    global view

    if model.flag.debug == 1; disp('inside tab1 edit button'); end
    if isempty(view.tab1.edit_user); 
        msgbox('Please enter user name','Warning','modal');
    else
        model.strings.username = view.tab1.edit_user.String;
        assert(~isempty(model.strings.username));
        if model.flag.debug == 1; disp(model.strings.username); end
        view.tab1.edit_user.Enable = 'off';
        view.tab1.button_save.Enable = 'off';
    end 
    
end

function save_Popup(hObject, event, handles)
    global model
    
    if model.flag.debug == 1; disp('inside tab1 popup'); end
    if isempty(model.strings.username); 
        msgbox('Please save user name before selecting mode','Warning','modal'); 
        hObject.Value = 1;
    else
        if hObject.Value == 2;
            handles.SelectedTab = handles.Children(2);
        elseif hObject.Value == 3;
            handles.SelectedTab = handles.Children(3);
        end
    end 
    
    
end





