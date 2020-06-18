public class WV_ShowSchemeLastUpdatedDateController {
    public string selectedSchemeId;
    
    public WV_ShowSchemeLastUpdatedDateController (){
        selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');   
    }
    
    public string getLastupdatedBy(){
        try{
            List<Scheme__c > schemeList= [select id,Last_updated_by__c,Last_updated_by__r.name,Last_updated_date__c from Scheme__c where id=:selectedSchemeId];
            if(schemeList != null && schemeList.size() >0 && schemeList[0].Last_updated_date__c != null && schemeList[0].Last_updated_by__c != null){
                return schemeList[0].Last_updated_by__r.name+', '+schemeList[0].Last_updated_date__c.format();
            } 
        }  
        Catch(Exception e){
            system.debug('***Exception inside WV_ShowSchemeLastUpdatedDateController  class --> getLastupdatedBy()'+e.getmessage()+'-'+e.getlineNumber());
        }
        return '';     
    }
}