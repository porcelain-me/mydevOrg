@istest(SeeAllData=true)

public class WV_Test_WV_ReportsController{

    public testmethod static void Testmethod01(){  
          
        List<Profile> profilename=[select id,name from profile where name='All MS Employee'];
        system.assert(profilename!=null,'ALL MS Employee profile is not there.');
        system.assertEquals(profilename.size(),1,'ALL MS Employee profile is not there.');
        
        List<User> validUser=[select id, name, firstname, lastname, email,Emp_Id__c,profileId,isactive,CreatedDate  from user where profileid=:profilename[0].id AND Emp_Id__c!=null AND isactive=true limit 1];
        system.assert(validUser!=null,'No Active user found in ALL MS Employee profile.');
        system.assertEquals(validUser.size(),1,'No Active user found in ALL MS Employee profile.');
        
        Map<Id,Permissionset> adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Scheme_Admin']);
        Map<Id,Permissionset> adminPermissionSetsBiz=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin']);
        Map<Id,Permissionset> adminPermissionSetsHRSC=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_HRSC_admin']);

        List<permissionsetAssignment> permissions=[select id,assigneeid,permissionsetid from permissionsetAssignment where assigneeid=:validUser[0].Id AND (permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset())];
        if(permissions != null && permissions.size() > 0){
            system.runAs(validUser[0]){
                WV_ReportsController reports=new WV_ReportsController();
                reports.schemeID='All';                            
                reports.UpdateSchemeinLinks();
                reports.getEnrolments();
                reports.UpdateEnrolmentinLinks();
                reports.sendErrorEmail();
            }
            delete permissions;
        }
        system.assert(adminPermissionSetsBiz != null,'No Biz admin permission set persent');
        system.assert(adminPermissionSetsBiz.keyset() != null,'No Biz admin permission set persent');
        system.assert(adminPermissionSetsBiz.keyset().size()>0,'No Biz admin permission set persent');
        
        system.assert(adminPermissionSets!= null,'No Scheme admin permission set persent');
        system.assert(adminPermissionSets.keyset() != null,'No Scheme admin permission set persent');
        system.assert(adminPermissionSets.keyset().size()>0,'No Scheme admin permission set persent');
        
        system.assert(adminPermissionSetsHRSC != null,'No HRSC admin permission set persent');
        system.assert(adminPermissionSetsHRSC.keyset() != null,'No HRSC admin permission set persent');
        system.assert(adminPermissionSetsHRSC.keyset().size()>0,'No HRSC admin permission set persent');
        
        Id setId=adminPermissionSetsBiz.values()[0].Id;
        permissionsetAssignment p=new permissionsetAssignment(assigneeid=validUser[0].Id,permissionsetid=setId);
        insert p;
        system.runAs(validUser[0]){
            WV_ReportsController reports01=new WV_ReportsController();
            reports01.schemeID='All';                            
            reports01.UpdateSchemeinLinks();
            reports01.getEnrolments();
            reports01.UpdateEnrolmentinLinks();
            reports01.sendErrorEmail();
        }
        
        List<permissionsetAssignment> permissions01=[select id,assigneeid,permissionsetid from permissionsetAssignment where assigneeid=:validUser[0].Id AND (permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset() OR permissionsetid IN:adminPermissionSets.keyset())];
        delete permissions01;
        
        Id setId01=adminPermissionSets.values()[0].Id;
        permissionsetAssignment p1=new permissionsetAssignment(assigneeid=validUser[0].Id,permissionsetid=setId01);
        insert p1;
        system.runAs(validUser[0]){
            WV_ReportsController reports02=new WV_ReportsController();
            reports02.schemeID='All';                          
            reports02.UpdateSchemeinLinks();
            reports02.getEnrolments();
            reports02.UpdateEnrolmentinLinks();
            reports02.sendErrorEmail();
        }        
    }
}