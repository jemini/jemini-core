package org.rubyforge.rawr;

public class Main
{
    @SuppressWarnings("deprecation") // for the DataInputStream.readLine() call
    public static void main(String[] args) throws Exception
    {   
        JRubyMain.startJRubyApp(args);
    }
}
