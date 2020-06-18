@istest(SeeAllData=true)

public class WV_Test_WV_ChangeAdminsController{
    
    public testmethod static void Testmethod01(){
        WV_ChangeAdminsController changeadmin=new WV_ChangeAdminsController();
        changeadmin.sendErrorEmail();
        changeadmin.search();  
        changeadmin.searchText='test';
        changeadmin.search();        
                    
        List<Profile> profilename=[select id,name from profile where name='All MS Employee'];
        system.assert(profilename!=null,'ALL MS Employee profile is not there.');
        system.assertEquals(profilename.size(),1,'ALL MS Employee profile is not there.');
        
        List<User> validUser=[select id, name, firstname, lastname, email,Emp_Id__c,profileId,isactive,CreatedDate  from user where profileid=:profilename[0].id AND Emp_Id__c!=null AND isactive=true limit 1];
        system.assert(validUser!=null,'No Active user found in ALL MS Employee profile.');
        system.assertEquals(validUser.size(),1,'No Active user found in ALL MS Employee profile.');
            
        PageReference manageaccess=new PageReference('/apex/WV_ChangeAdmins');
        Test.setCurrentPage(manageaccess); 

        WV_ChangeAdminsController changeadmins=new WV_ChangeAdminsController();
        changeadmins.searchText='test';
        changeadmins.search();
        changeadmins.searchText=validUser[0].email;
        changeadmins.search();
        
        Map<Id,Permissionset> adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Scheme_Admin']);
        Map<Id,Permissionset> adminPermissionSetsBiz=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin']);
        Map<Id,Permissionset> adminPermissionSetsHRSC=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_HRSC_admin']);

        List<permissionsetAssignment> permissions=[select id,assigneeid,permissionsetid from permissionsetAssignment where assigneeid=:validUser[0].Id AND (permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset())];
        if(permissions != null && permissions.size() > 0){
            delete permissions;
        }
        
        WV_ChangeAdminsController changeadmins01=new WV_ChangeAdminsController();
        changeadmins01.searchText=validUser[0].email;    
        changeadmins01.search();                                        
        changeadmins01.userid=validUser[0].Id;
        changeadmins01.AssignPermission();
        
        changeadmins01.userid=validUser[0].Id;   
        changeadmins01.DeassignPermission();
        
        changeadmins01.userid=validUser[0].Id;
        changeadmins01.AssignPermissionBiz();
        
        changeadmins01.userid=validUser[0].Id;
        changeadmins01.DeassignPermissionBiz();
        
        changeadmins01.userid=validUser[0].Id;
        changeadmins01.AssignPermissionHRSC();
        
        changeadmins01.userid=validUser[0].Id;
        changeadmins01.DeassignPermissionHRSC();
        
        WV_ChangeAdminsController changeadmins02=new WV_ChangeAdminsController();
        
        List<permissionsetAssignment> permissions1=[select id,assigneeid,permissionsetid from permissionsetAssignment where assigneeid=:validUser[0].Id AND (permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset())];
        if(permissions1 != null && permissions1.size() > 0){
            delete permissions1;
        }
        
        validUser[0].isactive=false;
        update validUser[0];
        
        WV_ChangeAdminsController changeadmins03=new WV_ChangeAdminsController();
        changeadmins03.searchText=validUser[0].email;    
        changeadmins03.search();                                                
        changeadmins03.userid=validUser[0].Id;
        changeadmins03.AssignPermission();
    }
}