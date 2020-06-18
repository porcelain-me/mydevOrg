// 12/06/2011 RJ: ORIGINAL CREATED
//                For CM_JSDebugger Component
//
public class CM_JSDebugger {
	public boolean isDebugOn{get;set;}
  public CM_JSDebugger(){
  	isDebugOn = false;
  	string debugParameter = ApexPages.currentPage().getParameters().get('isDebug') == null ? ApexPages.currentPage().getParameters().get('IsDebug') : ApexPages.currentPage().getParameters().get('isDebug');
  	
  	if(debugParameter <> null && boolean.valueOf(debugParameter)){
  		isDebugOn = true;
  	}
  }
}