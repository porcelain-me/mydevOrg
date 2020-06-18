@istest(SeeAllData=false)

public class WV_Test_WV_HeaderpageController{

    public testmethod static void Testmethod01(){     
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='t6est', Last_Name__c='terr',Email__c='test@gmail.com',Empl_Class_Job__c='A',Status__c='Active');
        insert employee;
        
        User loggedinUser;
        List<Profile> profilename=[select id,name from profile where name='All MS Employee'];
        system.assert(profilename!=null,'ALL MS Employee profile is not there.');
        system.assertEquals(profilename.size(),1,'ALL MS Employee profile is not there.');
        
        List<User> validUser=[select id, name, firstname, lastname, email,Emp_Id__c,profileId,isactive,CreatedDate  from user where profileid=:profilename[0].id AND Emp_Id__c!=null AND isactive=true limit 1];
        system.assert(validUser!=null,'No Active user found in ALL MS Employee profile.');
        system.assertEquals(validUser.size(),1,'No Active user found in ALL MS Employee profile.');
        
        employee.emp_Id__c=validUser[0].emp_Id__c;
        update employee;
        loggedinUser=validUser[0];
        system.debug('**********'+loggedinUser);
        
        PageReference homepages=new PageReference('/apex/WV_Homepage?uid='+loggedinUser.Id);
        Test.setCurrentPage(homepages); 
        
        WV_HeaderpageController headerpage=new WV_HeaderpageController();
        headerpage.sendErrorEmail();
        
        PageReference homepages01=new PageReference('/apex/WV_Moreinfo');
        Test.setCurrentPage(homepages01);       
        WV_HeaderpageController headerpage01=new WV_HeaderpageController();
        headerpage01.sendErrorEmail();
    } 
}