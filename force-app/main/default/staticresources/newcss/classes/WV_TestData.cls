public class WV_TestData {
    public static Input_Controls_Mapping__c  WV_insertControls(string TempId,string name,string type,string visibility,boolean req){
        
        Input_Controls_Mapping__c control=new Input_Controls_Mapping__c(name=name,Input_Control_Type__c=type,Waiver_Template__c=TempId,Required__c=req,Control_Visibility__c=visibility);
        insert control;       
        return control;
    
    }
}