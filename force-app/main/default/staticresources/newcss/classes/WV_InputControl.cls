public class WV_InputControl{
        public string recordtype{get; set;} 
        public string RecordId{get; set;} 
        public string name{get; set;} 
        public boolean IsMandatory{get; set;}   
        public boolean UserInputStatus{get; set;}
        public string ValueType{get; set;}    
        public decimal maxlimit{get; set;}   
        public decimal minlimit{get; set;}  
        public decimal Custom_maxlimit{get; set;}   
        public decimal Custom_minlimit{get; set;}
        public decimal maxlimit_Validation{get; set;}   
        public decimal minlimit_Validation{get; set;}  
        public string IsMandatory_Validation{get; set;}   
        public list<selectoption> AvailableList{get; set;}      
        public WV_MultiListPopupWrapper multilistWrapper {get; set;}
        public string Error {get; set;}
        public boolean showCurrency {get; set;}
        public string sum {get; set;}                
        public string enteredValue{get; set;}  
        public string SelectedList{get; set;} 
        public List<Response__c> Response_New{get; set;}
        public Boolean isCreated{get; set;}
        public string controllingField {get; set;}
        public string mappedParentChildFields {get; set;}
        public string orderNumber {get; set;}
        public string DefaultValueType{get; set;}
        public string listType {get; set;}
        public string Code {get; set;}
        public boolean flagCheck {get; set;}
        
        public WV_InputControl(){
            this.Response_New=new List<Response__c>();
            this.isCreated=false;
            this.Error =null;
            this.showCurrency =false;
            this.IsMandatory_Validation='false';
            this.maxlimit_Validation=0;
            this.minlimit_Validation=0;
            this.Code='';
            this.flagCheck=false;
        }
}