public class WV_SchemeWrapper {
    public string SchemeId{get; set;}
    public string name{get; set;}
    public string Description{get; set;}
    public string Source{get; set;}
    public string SourceId {get; set;}
    public boolean Source_Status{get; set;}
    public string Deferral{get; set;}
    public boolean Deferral_Status{get; set;}
    public string TemplateId{get; set;}  
    public string schemeCurrency {get; set;}
    public boolean schemeCurrency_Status {get; set;}
    public string schemeCurrency_Code {get; set;}
    public string Abacus{get; set;}
    public Decimal Abacus_Value {get; set;}
    public string ErrorMessage{get; set;}
    public boolean IsSubmittedByUser{get; set;}
    public List<WV_InputControl> InputControlsList{get; set;}
    public Boolean isCreated{get; set;}
    public Boolean isModified{get; set;}
    public string lastmodifiedBy {get; set;}
    public datetime lastmodifiedDate {get; set;}
    public datetime enrolmentLastdate{get; set;}    
    public string enrolmentLastdate_Month{get; set;}
    public string enrolmentLastdate_Day{get; set;}
    public string enrolmentLastdate_TimeandZone{get; set;}    
    public string enrolmentId {get; set;}
    public string relatedYear {get; set;}    
    public boolean showMultiListSection {get; set;}
    public boolean isMultiListSumbitted {get; set;}
    public boolean isNew {get; set;}
    
    public WV_SchemeWrapper (){
        this.IsSubmittedByUser=false;
        this.isCreated=false;
        this.isModified=false;
        this.showMultiListSection =false;
        this.isMultiListSumbitted =false;
    }

}