@istest(SeeAllData=false)

public class WV_Test_WV_EnrolmentPeriodController{
    
    public testmethod static void Testmethod01(){    
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='t6est', Last_Name__c='terr',Email__c='test@gmail.com',Empl_Class_Job__c='A',Status__c='Active');
        insert employee;
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR');
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;
        
        PageReference pg=new PageReference('/apex/WV_Schemes?retURL=test');
        Test.setCurrentPage(pg);
        Scheme__c Sch=new Scheme__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(Sch);        
        
        WV_schemeExtension Ext=new WV_schemeExtension(sc);        
        Ext.schemeObj.name='Test';
        Ext.schemeObj.abacus__c='No';
        Ext.schemeObj.Term__c ='Fixed';
        Ext.schemeObj.source__c =source.Id;
        Ext.schemeObj.deferral__c =def.Id;
        Ext.schemeObj.description__c='test';
        Ext.isAbacusEnabled=false;
        Ext.schemeObj.scheme_Currency__c=currencys.Id;
        
        Ext.displayAbacusCheck();
        Ext.save();    
        
        List<Scheme__c> schemes=[select id,name from Scheme__c limit 1];
        system.debug('***********schemes'+schemes);
        system.assert(schemes!=null,'No Schemes created to process');
        system.assert(schemes.size()>0,'No schemes createed to process');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01);
        
        WV_EnrolmentPeriodController enrol022=new WV_EnrolmentPeriodController();
        enrol022.enrolNew(); 
        enrol022.selectedEnrolment.name='test';
        enrol022.selectedEnrolment.Start_Date__c = system.now();
        enrol022.selectedEnrolment.end_Date__c = system.now().addminutes(30);
        enrol022.enrolSave();
        
        List<Enrollment_Period__c> enrollist00=[select id,name,Override_Scheme__c,Start_Date__c,end_Date__c from Enrollment_Period__c where Override_Scheme__c=:schemes[0].Id];
        system.assert(enrollist00!=null,'No Enrolment period created to process');
        /*system.assert(enrollist00.size()>0,'No Enrolment period created to process');
        
        Election__c Election=new Election__c(Employee__c=employee.Id,Related_Enrolment__c=enrollist00[0].Id,Scheme__c=schemes[0].Id);
        insert Election; 
        
        PageReference schDetail12=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id+'&enrolIds='+enrollist00[0].Id);
        Test.setCurrentPage(schDetail12); 
        
        WV_EnrolmentPeriodController enrol003=new WV_EnrolmentPeriodController();
        enrol003.enrolAction();
        enrol003.selectedEnrolment.Start_Date__c =system.now().addminutes(10);
        enrol003.enrolSave();    
        
        List<Enrollment_Period__c> enrollistss=[select id,name,Override_Scheme__c,Start_Date__c,end_Date__c from Enrollment_Period__c where Override_Scheme__c=:schemes[0].Id];    
        system.assert(enrollistss!=null,'No Enrolment period created to process');
        system.assert(enrollistss.size()>0,'No Enrolment period created to process');
        delete enrollistss;
        
        WV_EnrolmentPeriodController enrol=new WV_EnrolmentPeriodController();
        enrol.enrolNew(); 
        enrol.selectedEnrolment.name=null;
        enrol.selectedEnrolment.Start_Date__c = null;
        enrol.selectedEnrolment.end_Date__c =null;
        enrol.enrolSave();
        
        enrol.selectedEnrolment.name='test';
        enrol.selectedEnrolment.Start_Date__c = system.now().addminutes(-5);
        enrol.selectedEnrolment.end_Date__c =system.now().addminutes(10);
        enrol.enrolSave();
        
        enrol.selectedEnrolment.Start_Date__c = system.now();
        enrol.selectedEnrolment.end_Date__c = system.now().addminutes(-5);
        enrol.enrolSave();
        
        enrol.selectedEnrolment.Start_Date__c = system.now();
        enrol.selectedEnrolment.end_Date__c = system.now().addminutes(10);
        enrol.enrolSave();
        
        enrol.enrolNew(); 
        enrol.selectedEnrolment.name='test';
        enrol.selectedEnrolment.Start_Date__c = system.now().addminutes(3);
        enrol.selectedEnrolment.end_Date__c = system.now().addminutes(7);
        enrol.enrolSave();
        
        enrol.enrolNew(); 
        enrol.selectedEnrolment.name='test';
        enrol.selectedEnrolment.Start_Date__c = system.now().addminutes(20);
        enrol.selectedEnrolment.end_Date__c = system.now().addminutes(50);
        enrol.enrolSave();
        
        enrol.enrolNew(); 
        enrol.selectedEnrolment.name='test';
        enrol.selectedEnrolment.Start_Date__c = system.now().addminutes(15);
        enrol.selectedEnrolment.end_Date__c = system.now().addminutes(25);
        enrol.enrolSave();
        
        List<Enrollment_Period__c> enrollist=[select id,name,Override_Scheme__c from Enrollment_Period__c where Override_Scheme__c=:schemes[0].Id];
        system.assert(enrollist!=null,'No Enrolment period created to process');
        system.assert(enrollist.size()>0,'No Enrolment period created to process');
        
        PageReference schDetail11=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id+'&enrolIds='+enrollist[0].Id);
        Test.setCurrentPage(schDetail11); 
        
        WV_EnrolmentPeriodController enrol01=new WV_EnrolmentPeriodController();
        enrol01.enrolAction();                
        enrol01.enrolBack();
        
        enrol01.enrolAction();
        enrol01.selectedEnrolment.end_date__c=system.now().addminutes(-5);
        enrol01.enrolSave();  
        
        WV_EnrolmentPeriodController enrol02=new WV_EnrolmentPeriodController();
        enrol02.enrolAction();                
        enrol02.enrolSave();*/         
    }        
}