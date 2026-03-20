/*    */ package com.myflashlab.admob;
/*    */ 
/*    */ import com.adobe.fre.FREContext;
/*    */ import com.adobe.fre.FREFunction;
/*    */ import java.util.HashMap;
/*    */ import java.util.Map;
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ public class MyContext
/*    */   extends FREContext
/*    */ {
/*    */   protected HashMap<String, FREFunction> functionMap;
/*    */   
/*    */   public void dispose() {
/* 17 */     this.functionMap = null;
/*    */   }
/*    */ 
/*    */   
/*    */   public Map<String, FREFunction> getFunctions() {
/* 22 */     this.functionMap = new HashMap<>();
/* 23 */     this.functionMap.put("command", new AirCommand());
/*    */     
/* 25 */     return this.functionMap;
/*    */   }
/*    */ }


/* Location:              C:\Users\esdeb\Desktop\classes.jar!\com\myflashlab\admob\MyContext.class
 * Java compiler version: 8 (52.0)
 * JD-Core Version:       1.1.3
 */