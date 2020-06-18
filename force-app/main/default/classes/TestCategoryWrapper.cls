@IsTest
public class TestCategoryWrapper {
    
    public static testMethod void  testMe() {
        CategoryWrapper cw = new CategoryWrapper();
        System.assertEquals(cw.checked,false);

        CategoryWrapper cw2 = new CategoryWrapper(new Position__c(name='Test1'));
        System.assertEquals(cw2.cat.name,'Test1');
        System.assertEquals(cw2.checked,false);

    }

}