public class WV_ElectionsWrapper{ 
        public string SchemeId{get; set;}  
        public string SchemeName{get; set;}
        public string SchemeDescription{get; set;}        
        public string SchemeDescriptionWithoutEnrolment {get; set;}
        public string SchemeDescriptionWithEnrolment{get; set;}
        public boolean showmoreLinkWithoutEnrolment {get; set;}
        public boolean showmoreLinkWithEnrolment {get; set;}        
        public string SourceId{get; set;}        
        public string SourceName  {get; set;}
        public decimal SourceOrder{get; set;}  
        public string DeferralId  {get; set;} 
        public string DeferralName  {get; set;} 
        public string TemplateName {get; set;}   
        public string schemeCurrency  {get; set;}
        public string schemeCurrency_Code {get; set;}
        public string TemplateId {get; set;}          
        public boolean isNew  {get; set;}
        public boolean showLastEnrolments {get; set;}
        public boolean isAllOpenEnrolment {get; set;}
        public boolean showInCalender {get; set;}
        public boolean isElected  {get; set;}
        public string RecentYear {get; set;}
        public string PastYear{get; set;}        
        public List<WV_EnrolmentResponses> currentYearEnrolments {get; set;}  
        public List<WV_EnrolmentResponses> pastYearEnrolments {get; set;}     
        
        public WV_ElectionsWrapper(){
            this.showLastEnrolments =false;
            this.isAllOpenEnrolment =true;
            this.showInCalender=true;
            this.isElected =false;
            this.RecentYear='';
            this.PastYear='';
            this.showmoreLinkWithoutEnrolment=false;
            this.showmoreLinkWithEnrolment=false;            
        }
}