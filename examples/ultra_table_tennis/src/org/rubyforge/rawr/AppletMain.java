package org.rubyforge.rawr;

import javax.swing.JApplet;

/**
 *
 * @author logan
 */
public class AppletMain extends JApplet {

    /**
     * Initialization method that will be called after the applet is loaded
     * into the browser.
     */
    public void init() {
        System.out.println("in Applet init");
        JRubyMain.startJRubyApp(new String[0]);
    }

    // TODO overwrite start(), stop() and destroy() methods
    @Override
    public void start() {
        System.out.println("in Applet start");
//        JRubyMain.startJRubyApp(new String[0]);
    }
}
