global class WebServiceTest {
webservice static void fetchQuery()
{
    List<Employee__c> i =[Select ID, name from Employee__c];
    
    System.debug('a--'+i);
}
}