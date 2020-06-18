@isTest
public class TestVerifyDate {

   
    
    @isTest static void testcheckdates(){
         Date d1 = System.today();
    date d2 = d1.addDays(29);
    date d3 = d1.addDays(31);
        date d4 = VerifyDate.SetEndOfMonthDate(d1);
        date test1 = VerifyDate.CheckDates(d1,d2);
        system.assertEquals(d2, test1);
        
        
      date test2 = VerifyDate.CheckDates(d1,d3);
        system.assertEquals(d4, test2);
    }
}