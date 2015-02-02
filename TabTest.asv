% INSERT COPYRIGHT INFORMATION HERE
% INSERT COPYRIGHT INFORMATION HERE
% INSERT COPYRIGHT INFORMATION HERE
% INSERT COPYRIGHT INFORMATION HERE

% Insert the script which is to be run at this step to create a database file.

% The entry function for the application.
function TabTest ()

clearvars
close all
clc

% perform all initializations in this block and create the GUIs
initialize_Application();

create_Model();
create_View();

settings = initialize_Settings();       % initialize the settings
hTabGroup = create_GUI(settings);       % create the GUI
initialize_GUI(hTabGroup);              % initialize the GUI
initialize_LookAndFeel();               % initialize the look and feel

end




