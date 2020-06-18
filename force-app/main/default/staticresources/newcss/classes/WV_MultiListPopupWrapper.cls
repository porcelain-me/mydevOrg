public class WV_MultiListPopupWrapper{
     public string name{get; set;}
     public string error{get; set;}
     public List<WV_multiListWrapper> MultiListWrapperList {get; set;}
     public string multiListDescription {get; set;}     
     public boolean multiListPercentageValidation {get; set;}  
     public string listsize {get; set;}
     
     public WV_MultiListPopupWrapper(){
         this.listsize='0';
     }
}