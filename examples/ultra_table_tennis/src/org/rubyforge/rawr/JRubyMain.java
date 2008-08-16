/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.rubyforge.rawr;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.util.ArrayList;
import org.jruby.Ruby;
import org.jruby.RubyInstanceConfig;
import org.jruby.javasupport.JavaEmbedUtils;
    
/**
 *
 * @author logan
 */
public class JRubyMain {
    public static void startJRubyApp(String[] args) {
        RubyInstanceConfig config = new RubyInstanceConfig();
        config.setArgv(new String[0]);
        
        Ruby runtime = JavaEmbedUtils.initialize(new ArrayList(0));
        boolean use_defaults = false;

        ArrayList<String> lines = new ArrayList<String>();
        try
        {
            DataInputStream dis = new DataInputStream(new BufferedInputStream(Main.class.getClassLoader().getResourceAsStream("run_configuration")));

            while(dis.available() != 0)
            {
                lines.add(dis.readLine());
            }
            dis = null;
        }
        catch(IOException e)
        {
            System.err.println("Error loading run configuration file 'run_configuration', using configuration defaults");
            use_defaults = true;
        }

        if(use_defaults)
        {
            runtime.evalScriptlet("require 'java'\n" + 
                    "$: << 'src'\n" +
                    "begin\n" +
                    "require 'src/main'\n" +
                    "rescue LoadError => e\n" +
                    "warn \"Error starting the application\"\n" +
                    "warn e\n" + 
                    "end"
                    );
        }
        else
        {
            if(3 == lines.size())
            {
                System.setProperty("java.library.path",lines.get(2));
            }

            if(2 <= lines.size())
            {
                runtime.evalScriptlet("require 'java'\n" +
                        "$: << '" + lines.get(0) + "'\n" +
                        "begin\n" +
                        "require '" + lines.get(0) + "/" + lines.get(1) + "'\n" +
                        "rescue LoadError => e\n" +
                        "warn \"Error starting the application\"\n" +
                        "warn e\n" + 
                        "end"
                        );
            }
            else
            {
                System.err.println("Incorrect format for file 'run_configuration'");
            }
        }
    }
}
