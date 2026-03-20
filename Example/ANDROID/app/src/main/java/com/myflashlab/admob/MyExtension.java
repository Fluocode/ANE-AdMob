package com.myflashlab.admob;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class MyExtension implements FREExtension {
  public static FREContext AS3_CONTEXT;
  
  public FREContext createContext(String $contextType) {
    AS3_CONTEXT = new MyContext();
    return AS3_CONTEXT;
  }
  
  public void dispose() {
    AS3_CONTEXT.dispose();
    AS3_CONTEXT = null;
  }
  
  public void initialize() {}
}

