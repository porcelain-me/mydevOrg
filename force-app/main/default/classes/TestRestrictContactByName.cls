@isTest
public class TestRestrictContactByName {

     @isTest static void TestInsertContact() {
        // Test data setup
        
        Contact con1 = new Contact(LastName='INVALIDNAME' );
         
         try{
             insert con1;
            }
         catch (DMLException ex){
       Boolean expectedExceptionThrown =  ex.getMessage().contains('The Last Name  is not allowed for DML') ? true : false;
          System.assertEquals(expectedExceptionThrown, true);
          }
         
             
 Contact con = new Contact(LastName='NotINVALIDNAME' );
         insert con;
Contact mycon =[SELECT Id, LastName
   FROM Contact WHERE Id = :con.Id];
mycon.LastName = 'INVALIDNAME';

Database.SaveResult SR =
  Database.update(mycon, false);
         
         System.assert(!SR.isSuccess());
         
     }


}