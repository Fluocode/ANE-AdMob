/*    */ package com.myflashlab.admob;
/*    */ 
/*    */ import com.adobe.fre.FREContext;
/*    */ import com.adobe.fre.FREExtension;
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ public class MyExtension
/*    */   implements FREExtension
/*    */ {
/*    */   public static FREContext AS3_CONTEXT;
/*    */   
/*    */   public FREContext createContext(String $contextType) {
/* 16 */     AS3_CONTEXT = new MyContext();
/*    */     
/* 18 */     return AS3_CONTEXT;
/*    */   }
/*    */   
/*    */   public void dispose() {
/* 22 */     AS3_CONTEXT.dispose();
/* 23 */     AS3_CONTEXT = null;
/*    */   }
/*    */   
/*    */   public void initialize() {}
/*    */ }


/* Location:              C:\Users\esdeb\Desktop\classes.jar!\com\myflashlab\admob\MyExtension.class
 * Java compiler version: 8 (52.0)
 * JD-Core Version:       1.1.3
 */