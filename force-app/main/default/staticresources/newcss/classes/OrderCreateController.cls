public class OrderCreateController {

     public String requestorName{get;set;}
     public String LoggedInUser { get; set; }
     Id loggedInUserId = UserInfo.getUserId();
     Id loggedInProfileId = UserInfo.getProfileId();
     public Foods_Product__c unit1 {get;set;}
     public Foods_Product__c unit2 {get;set;}
     public Foods_Product__c unit3 {get;set;}
     List<foods_product__c> foodsunit1 ;
     List<foods_product__c> foodsunit2 ;
     List<foods_product__c> foodsunit3 ;
     public Boolean unit1Count{get;set;}
     public Boolean unit2Count{get;set;}
     public Boolean unit3Count{get;set;}
     public String region {get;set;}
     public String cafe{get;set;}

       
       public List<SelectOption> getregions() {
       List<selectOption> regi = new List<selectOption>();
       regi .add(new selectOption('None', '- Select -'));
       regi .add(new selectOption('PUN', 'Pune'));
       regi .add(new selectOption('BLR', 'Bangalore'));
             return regi ;
    }
       
       public List<SelectOption> getcafes(){
       List<selectOption> cafet= new List<selectOption>();  
       if(region =='PUN'){
           cafet.add(new selectOption('U1', 'Unit 1'));
           cafet.add(new selectOption('U2', 'Unit 2'));
           cafet.add(new selectOption('U3', 'Unit 3'));
             }
       if(region =='BLR'){
           cafet.add(new selectOption('INBLR', 'IN Bangalore'));
           cafet.add(new selectOption('INBLRSEZ', 'Bangalore SEZ'));           
             }   
             
             return cafet;   
       }
     
    
    public OrderCreateController(ApexPages.StandardController controller) {
        requestorName = UserInfo.getName();

    }
    
    public void SaveOrder(){
        
    }


    public void CancelOrder(){
        
    }
    
    
    
    public List<foods_product__c> unit1List() {
    foodsunit1 = [Select Food_Name__c, Region__c , Location__c , Price__c  from  foods_product__c where Active__c = True AND  Location__c=:'Unit 1' AND Region__c =:'Pune' LIMIT 5];
    return foodsunit1 ;
    
    }
    
   
    public List<foods_product__c> unit2List() {
    foodsunit2 = [Select Food_Name__c, Region__c , Location__c , Price__c  from  foods_product__c where Active__c = True AND  Location__c=:'Unit 2' AND Region__c =:'Pune' LIMIT 5];
    return foodsunit2 ;
    
    }
     public List<foods_product__c> unit3List() {
        foodsunit3 = [Select Food_Name__c, Region__c , Location__c , Price__c  from  foods_product__c where Active__c = True AND  Location__c=:'Unit 3' AND Region__c =:'Pune' LIMIT 5];
        return foodsunit3 ;
    
    }
    



}