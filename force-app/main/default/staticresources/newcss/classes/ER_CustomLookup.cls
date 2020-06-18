public with sharing class ER_CustomLookup {      
    public String fieldTypeForSelectedField {get;set;}     
    public list<PhoneNumberDetail> listOfLookupsElement {get;set;}
    public String objectName {get;set;}
    public String fieldName {get;set;}
    public String lkval{get;set;}
    public String searchByName{get;set;}
    public String searchByPhone{get;set;}
    public boolean isChecked {get;set;}
    public String phoneNumberPassToTextBox {get;set;}
    public String phoneNamePassToHdn {get;set;}
    Public boolean isCountryCodeAlreadyExist{get; set;}
    public boolean isAllSelectCheckBox {get;set;}
    /*Controller*/
    public ER_CustomLookup(){
        listOfLookupsElement = new list<PhoneNumberDetail>();        
        objectName = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('oN'));
        fieldName = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fN'));
        lkval = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('val'));
        isAllSelectCheckBox = false;
        if(String.IsBlank(lkval)){
        searchByPhone = '';
        }else{
        searchByPhone = lkval;
        }
        searchByName ='';
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        getlistOfLookupsElement();
   }
   /*to get list of lookup element*/
   public void getlistOfLookupsElement(){
        try{ 
            listOfLookupsElement = new list<PhoneNumberDetail>();
            String byName = '\'%'+String.escapeSingleQuotes(searchByName) + '%\'';
            String byPhone = '\'%'+String.escapeSingleQuotes(searchByPhone) + '%\'';
            
           String query ='SELECT Name,'+fieldName+' FROM '+objectName +' WHERE  name Like '+byName +' AND  '+fieldName + ' Like '+byPhone;
            String CountryCode = null; 
            list<SObject> s = Database.query(query);
            boolean isCountryCodeAlreadyExist;  
            for(sObject sObj:s){ 
                CountryCode = null; 
                isCountryCodeAlreadyExist = false;    
                if(sObj.get(fieldName) != null && sObj.get('Name') != null){
                    listOfLookupsElement.add(new PhoneNumberDetail(String.valueOf(sObj.get('Name')),CountryCode,String.valueOf(sObj.get(fieldName)),false,isCountryCodeAlreadyExist));                     
                }
            }    
           
        }catch(Exception ex){
             apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parameter is not defined, Please contact your Administrator!'));
        }       
    }
    /*Search event*/
    public void onSearch(){
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        isAllSelectCheckBox = false;
        listOfLookupsElement = new list<PhoneNumberDetail>();
        String byName = '\'%'+String.escapeSingleQuotes(searchByName) + '%\'';
        String byPhone = '\'%'+String.escapeSingleQuotes(searchByPhone) + '%\'';
        String CountryCode = null;
        boolean isCountryCodeAlreadyExist;
        try{
            String query ='SELECT Name,'+fieldName+' FROM '+objectName +' WHERE  name Like '+byName +' AND  '+fieldName + ' Like '+byPhone;
            list<SObject> s = Database.query(query); 
            for(sObject sObj:s){
                CountryCode = null;
                isCountryCodeAlreadyExist = false;   
                if(sObj.get(fieldName) != null && sObj.get('Name') != null){
                    
                    listOfLookupsElement.add(new PhoneNumberDetail(String.valueOf(sObj.get('Name')),CountryCode,String.valueOf(sObj.get(fieldName)),false,isCountryCodeAlreadyExist));                     
                }
            } 
        }catch(Exception ex){
            apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Illegal Search parameter!'));
        }       
    }
    /*Event for check box checked*/
    public void onCheck(){
        phoneNumberPassToTextBox = '';
        phoneNamePassToHdn  = '';
        for(PhoneNumberDetail pn:listOfLookupsElement){
            if(pn.isChecked){
                                         
                        phoneNumberPassToTextBox += pn.sObjectPhone;
                        phoneNamePassToHdn += pn.sObjectNameField;
                   }
               }
            }
    
   
    
    /*P2l Detail wrapper*/
    public class PhoneNumberDetail{
        public boolean isChecked {get;set;}
        public string sObjectNameField {get;set;}
        public string sObjectPhone {get;set;}
        public string countryCode {get;set;}
        public boolean isCountryCodeExist {get;set;}
        public PhoneNumberDetail(string sObjectNameField,string countryCode,string sObjectPhone,boolean isChecked,boolean isCountryCodeExist ){
            this.sObjectNameField = sObjectNameField;
            this.sObjectPhone = sObjectPhone ;
            this.countryCode  = countryCode ;
            this.isChecked = isChecked ;
            this.isCountryCodeExist = isCountryCodeExist;
        }        
    }     

}