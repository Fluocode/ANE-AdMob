package com.myflashlab.admob;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class MyContext extends FREContext {
  protected HashMap<String, FREFunction> functionMap;
  
  public void dispose() {
    this.functionMap = null;
  }
  
  public Map<String, FREFunction> getFunctions() {
    this.functionMap = new HashMap<>();
    this.functionMap.put("command", new AirCommand());
    return this.functionMap;
  }
}

