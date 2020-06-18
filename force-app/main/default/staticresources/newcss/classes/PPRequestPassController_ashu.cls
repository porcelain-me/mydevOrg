@isTest                                                 //dummy class
public class PPRequestPassController_ashu{

    public PPRequestPassController_ashu() {

    }

public PR_Request__c request {get; set;}
public List<property_Detail__c> itemProperties {get; set;}
public Integer totalBoxes {get; set;}
public Integer totalPallets {get; set;}
public Integer totalItems {get; set;}


public pagereference UpdateRequest(){
    String rID = ApexPages.currentPage().getParameters().get('ID');
    List<PR_Request__c> rPP = PP_Util.getPPSingleRecord(rID);
    if(rPP !=null && rPP.size() > 0) {
        rPP[0].IsPassGenerated__c=true;
        rPP[0].PassGeneratedDate__c=system.today();
        rPP[0].PassGeneratedBy__c = userinfo.getUserId();
    }
    update rPP;        
    return null;
    }
    
    public PPRequestPassController_ashu(ApexPages.StandardController controller) {
    
        
        totalBoxes=0;
        totalItems=0;
        totalPallets=0;
        
        String requestId=ApexPages.currentPage().getParameters().get('Id');
        if(requestId != null && requestId.trim() !=''){
            List<PR_Request__c> requestList = PP_Util.getPPRequestDetails(requestId);
            if(requestList != null && requestList.size() > 0){
                request = requestList[0];
                itemProperties = PP_Util.getPPropertyDetail(request.id); 
                for(property_Detail__c co : itemProperties){
                    if( co.Boxes__c != null  &&   co.Boxes__c != '') {
                        totalBoxes = totalBoxes + Integer.valueof(co.Boxes__c);
                    }
                    if( co.Items__c != null  &&   co.Items__c != '') {
                        totalItems = totalItems + Integer.valueof(co.Items__c);
                    }
                    if( co.Pallets__c!= null  &&   co.Pallets__c != '') {
                        totalPallets = totalPallets + Integer.valueof(co.Pallets__c);
                    } 
                }
            }
        }
    }
}