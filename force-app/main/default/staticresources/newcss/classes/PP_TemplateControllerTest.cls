@isTest (SeeAllData = false) 
public class PP_TemplateControllerTest {
    
    public static testmethod void PPUtilTest(){
    User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
            PP_TemplateController TC = new PP_TemplateController ();
            TC.outputString='Serial No,Asset Tag,Description'; 
            system.assertEquals('Serial No,Asset Tag,Description', TC.outputString);
             Test.stoptest(); 
         }
    }
}