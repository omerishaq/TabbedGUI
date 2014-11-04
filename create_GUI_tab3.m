function [ output_args ] = create_GUI_tab3 ( settings, hTabGroup )

global view;
global model;

tab3 = uitab(hTabGroup, 'title','View Spots');                  % create the tab title
position = view.position(3,:);                                  % read the position at index 3 

% code for adding the three controls and registering them in the view.
ui_text = uicontrol(tab3, 'Style', 'text', 'String', 'Specify file name','Position', [50 position(4)-100 settings.active.popup_lengthX+50 settings.active.popup_lengthY],'HorizontalAlignment','left');
ui_edit = uicontrol(tab3, 'Style', 'edit','Position', [270 position(4)-100 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
ui_button = uicontrol(tab3, 'Style', 'pushbutton', 'String', 'Specify file name','Position', [270 position(4)-130 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left', 'Callback', @select_DataFile);

view.tab3.edit_file = ui_edit;
view.tab3.button_select = ui_button;

% code for adding the drop down
ui_text = uicontrol(tab3, 'Style', 'text', 'String', 'Select signals for display','Position', [50 position(4)-190 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
ui_popup = uicontrol(tab3, 'Style', 'popup', 'String', {'   ','All signals','Only annotated spots'}, 'Position', [270 position(4)-190 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
view.tab3.popup_mode = ui_popup;

% code for adding the drop down for specifying the foreground-background threshold.
ui_text = uicontrol(tab3, 'Style', 'text', 'String', 'Select foreground threshold (%)','Position', [50 position(4)-250 settings.active.popup_lengthX+50 settings.active.popup_lengthY],'HorizontalAlignment','left');
ui_popup = uicontrol(tab3, 'Style', 'popup', 'String', {'   ','0.5','0.6','0.7','0.8'}, 'Position', [270 position(4)-250 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
view.tab3.popup_threshold = ui_popup;

% code for adding the two pannels
p1 = uipanel(tab3, 'Title', 'Before annotation','Position', [.03 .03 .45 .65]);
p2 = uipanel(tab3, 'Title', 'After annotation','Position', [.49 .03 .45 .65]);
view.tab3.panel_before = p1;
view.tab3.panel_after = p2;

% code for adding the four axes to the panels.
% the first two axes display the spots before and after the manual annotation
% The next two axes display the spots before and after the manual annotation displayed on the image itself
a1  = axes('Parent', p1, 'Position',  [.30 .05 0.65 0.9], 'Box', 'off');
hold on; if model.flag.debug == 0; axis off; end;
a11 = axes('Parent', p1, 'Position',  [.02 .05 0.26 0.9], 'Box', 'off');
hold on; if model.flag.debug == 0; axis off; end; 

a2  = axes('Parent', p2, 'Position',  [.30 .05 0.65 0.9], 'Box', 'off');
hold on; if model.flag.debug == 0; axis off; end;
a22 = axes('Parent', p2, 'Position',  [.02 .05 0.26 0.9], 'Box', 'off');
hold on; if model.flag.debug == 0; axis off; end; 

% register the axes to the view.tab3
view.tab3.axis_before_image     =   a1;
view.tab3.axis_before_spots     =   a11;
view.tab3.axis_after_image      =   a2;
view.tab3.axis_after_spots      =   a22;

end

function select_DataFile(hObject, event, handles)

    global model;
    global view;
    
    [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.png');
    model.tab3.strings.imgfilename = FILENAME;
    model.tab3.strings.imgfilepath = PATHNAME;

    model.tab3.image.input = imread([model.tab3.strings.imgfilepath model.tab3.strings.imgfilename]);
    set(view.tab3.edit_file,'String',[model.tab3.strings.imgfilename]);
    
    tempfilename = model.tab3.strings.imgfilename(1:end-4);
    model.tab3.struct.f_data = csvread([ model.tab3.strings.imgfilepath tempfilename '.csv'], 1, 0);
    
    % code comes here for loading all the data and making it work.
    %
    % this is important - there are multiple things which need to be done
    % one - load the image, already done in the line above
    % two - load the original data from the 'thunder storm' already done above
    % third - load the data from the results file, augmented to the data file if required.

    Records = load(model.strings.resultsfilename);
    Records = Records.Records;
    ilength = length(Records);
    
end
