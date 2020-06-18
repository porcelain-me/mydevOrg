public class Testclass {
    public Abacus__c temp {get; set;}
    public Testclass(ApexPages.StandardController controller) {
        this.temp= (Abacus__c)controller.getRecord();
    }

}