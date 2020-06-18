@isTest
public class savingsgeneralaccwrapperTest {
    
    
    public static testmethod void testwrapper(){
        
           savingsgeneralaccwrapper testWrap = new  savingsgeneralaccwrapper(); 
           testWrap.Id = '0011j00000Xcri1AAB';
           testWrap.MeetingOf = 'test';
           testWrap.MeetingHeldAt = 'test';
           testWrap.MeetingDate = system.today();
           testWrap.Extractsigneddate = system.today();
           testWrap.Totalnumofaccountstobeopened = 10; 
           testWrap.Requirednumberofsignatoriestoopencloseaccounts = 10;
           testWrap.Requirednumofsignatoriestogiveinstructions = 10;
           testWrap.SourceofFundssavings = 'test';
           testWrap.CommentsonexplanationgivenforSourceoffunds ='test';

       }

}