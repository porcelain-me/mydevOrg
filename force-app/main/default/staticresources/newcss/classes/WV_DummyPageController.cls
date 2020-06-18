public class WV_DummyPageController {
    public scheme__C scm{get; set;}
    public WV_DummyPageController(){
       scm=new scheme__C();     
    }
    
    public PageReference save1(){
        system.debug('******************'+scm.Test__c);
        return null;
    }
}