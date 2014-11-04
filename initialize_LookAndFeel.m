function [] = initialize_LookAndFeel()

    lafs = javax.swing.UIManager.getInstalledLookAndFeels;
    javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsLookAndFeel')

end

