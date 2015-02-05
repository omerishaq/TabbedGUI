function [] = create_View ()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global view;

%
% tab 1
%

view.tab1.edit_user = 0;
view.tab1.button_save = 0;
view.tab1.popup_mode = 0;

%
% tab 2
%

view.tab2.edit_file = 0;
view.tab2.button_select = 0;
view.tab2.button_red = 0;
view.tab2.button_green = 0;
view.tab2.text_progress = 0;
view.tab2.axes_main = 0;
view.tab2.axes_red_left = 0;
view.tab2.axes_green_right = 0;
view.tab2.slider = 0;

%
% size of the different tabs
%

view.position = [   324 200 872 504;...
                    124 200 1172 804;...
                    84 200 800 600];

%
% tab 3
%
                
view.tab3.edit_file = 0;
view.tab3.button_select = 0;
view.tab3.popup_mode = 0;
view.tab3.popup_threshold = 0;
view.tab3.panel_before = 0;
view.tab3.panel_after = 0;
view.tab3.axis_before_spots = 0;
view.tab3.axis_before_image = 0;
view.tab3.axis_after_spots = 0;
view.tab3.axis_after_image = 0;
view.tab3.radio_displays = 0;

%
% place holder for tab 4
%


end

