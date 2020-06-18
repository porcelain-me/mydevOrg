/******************************************************************************************************************************
 *
 *      @File           :       TestGPSIICampaignDataLoaderController.cls
 *      @Version        :       V1.0.0
 *      @Created        :       29th July 2016 by Sudarshan K.
 *      @Purpose        :       JIRA 4836
 *                                 Cover line of code for GPSIICampaignDataLoaderController, GPSCampaignCSVIterator and GPSCampaignDLBatch                  
 *                                                      
 *                                              
 *
 *      @Author         :       Capgemini (Sudarshan K)
 *      @Copyright      :       (c) Capgemini India Pvt. Ltd. 2016
 *
 *      @History        :  
 *
 ********************************************************************************************************************************/
@isTest
private class TestGPSIICampaignDataLoaderController {
    
    static testmethod void testNegativeCaseReadFile(){
        Test.startTest();
        iiCampaign__c camp = new iiCampaign__c(Campaign_Name__c = 'INDCamp1', Name = 'INDCAMP16', Active_Flag__c = true);
        insert camp;
        Team__c team = new Team__c(Name = 'Test Team1', TeamID__c = 'TestTeam16', Title__c = 'Test');
        insert team;
        
        String fileName = 'test.csv';
        String fileData = 'iiCampaign ID,Candidate Name,Campaign MSID Key,Team,Team ID,Team Name,Additional Text,Use Recommendations in Campaign\n'+
        camp.Id+',FName LName,INDCampTestTeam16,TestTeam16,TestTeam16,Test Team1,This is testing purpose only,yes\n'+
        'INDCamp16,FName LName,INDCampTestTeam16,TestTeam16,TestTeam16,Test Team1,This is testing purpose only,yes';
        
        GPSIICampaignDataLoaderController obj = new GPSIICampaignDataLoaderController();
        GPSIICampaignDataLoaderController.createObject('InvalidObjectName');
        obj.exportCSVTemplate();
        //Data Operation type not selected
        obj.ReadFile();
        obj.selectedUploadOption = 'Candidate_Information__c';
        //File data still not passed
        obj.ReadFile();
        obj.contentData = 'iiCampaign_ID__c,CandidateName,Campaign MSID Key,Team__c,Team ID,Team Name,Additional Text,Use Recommendations in Campaign';
        obj.nameFile = fileName;
        //Passed invalid header column names
        obj.ReadFile();
        obj.contentData = fileData;
        obj.ReadFile();
        Test.stopTest();
    }
    
    static testmethod void testPositiveCaseReadFile(){
        Test.startTest();
        T1C_CustomSettingsManager.createChatterSetting();
        T1C_CustomSettingsManager.setAllTriggerOn();
        iiCampaign__c camp = new iiCampaign__c(Campaign_Name__c = 'INDCamp1', Name = 'INDCAMP16', Active_Flag__c = true);
        insert camp;
        Team__c team = new Team__c(Name = 'Test Team1', TeamID__c = 'TestTeam16', Title__c = 'Test');
        insert team;
        
       /* Candidate_Information__c candInfo = new Candidate_Information__c(iiCampaign__c = camp.Id, Candidate_Name__c = 'Test1 Test2', MSID__c = 'test12', Team__c = team.Id, Team_ID__c = '4565', Team_Name__c = 'Test TeamSK', Additional_Text__c = 'Test Purpose', Use_Recommendations_in_Campaign__c = 'yes');
        insert candInfo;
        
        GPS_Campaign_Data_Loader__c gpsCDL = new GPS_Campaign_Data_Loader__c(Name = 'Test Operation type' + ' - '+ UserInfo.getName(), Batch_Status__c = 'Pending', Requested_User__c = UserInfo.getUserId());
    	insert gpsCDL; 
        
        String successString = 'iiCampaign ID","Candidate Name","Campaign MSID Key","Team","Team ID","Team Name","Additional Text","Use Recommendations in Campaign';
        String errorString = successString;
        
        List<Attachment> lstAttach = new List<Attachment>();
        lstAttach.add(new Attachment(ParentId = gpsCDL.Id, name = 'SuccessRecords.csv', body = Blob.valueOf(successString), contentType='application/vnd.ms-excel'));
        lstAttach.add(new Attachment(ParentId = gpsCDL.Id, name = 'FailedRecords.csv', body = Blob.valueOf(errorString), contentType='application/vnd.ms-excel'));
        
        insert lstAttach;*/
        
        String fileName = 'test.csv';
        
        String fileData = 'iiCampaign ID,Candidate Name,Campaign MSID Key,Team,Team ID,Team Name,Additional Text,Use Recommendations in Campaign\n'+
        camp.Id+',FName LName,INDCampTestTeam16,TestTeam16,TestTeam16,Test Team1,This is testing purpose only,yes\n'+
        'INDCamp16,FName LName,INDCampTestTeam16,TestTeam16,TestTeam16,Test Team1,This is testing purpose only,yes\n';
        
        GPSIICampaignDataLoaderController obj1 = new GPSIICampaignDataLoaderController();
        obj1.selectedUploadOption = 'Candidate_Information__c';
        obj1.nameFile = fileName;
        obj1.contentData = fileData;
        obj1.getDataLoaderOperationType();
        obj1.getformattoCSV();
        obj1.ReadFile();
        
        obj1.checkRecordsStatusInBatch();
        obj1.batchProcessCompletion();
                
        Test.stopTest();
    }
    
    static testmethod void testExclusion(){
    	Test.startTest();
    	
        T1C_CustomSettingsManager.setAllTriggerOn();
        
    	iiCampaign__c camp = new iiCampaign__c(Campaign_Name__c = 'INDCamp1', Name = 'INDCAMP16', Active_Flag__c = true);
        insert camp;
        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'tstTradName'; 
        acc1.Active_Flag__c = true;
        insert acc1;
        
        Exclusion__c exclusion = new Exclusion__c(iiCampaign__c = camp.Id, GPSAccount__c = acc1.Id, Exclusion__c = 'Contacts do not get email');
        insert exclusion;
        
        String fileName = 'testexclusion.csv';
        
        String fileData = 'iiCampaign,TN ID,Exclusion\n'+
        camp.Id+',tstTradingName,Contacts do not get email\n'+
        'INDCamp16,tstTradingName,Contacts do not get email\n';
        
        GPSIICampaignDataLoaderController obj = new GPSIICampaignDataLoaderController();
        obj.selectedUploadOption = 'Exclusion__c';
        obj.nameFile = fileName;
        obj.contentData = fileData;
    	obj.getDataLoaderOperationType();
        obj.getformattoCSV();
        obj.ReadFile();
        
        obj.checkRecordsStatusInBatch();
        obj.batchProcessCompletion();
       	
       	String strExclusion = exclusion.iiCampaign__c + '_' +exclusion.GPSAccount__c + '_' + exclusion.Exclusion__c;
       	GPSIICampaignDataLoaderController.excludeTargetListMembers(new set<Id>{camp.Id}, new set<Id>{acc1.Id}, new set<String>{strExclusion});
       	
    	Test.stopTest();
    }
    
    static testmethod void testDELFileForVR(){
        Test.startTest();
        
        T1C_CustomSettingsManager.createChatterSetting();
        T1C_CustomSettingsManager.setAllTriggerOn();
        
        iiCampaign__c camp = new iiCampaign__c(Campaign_Name__c = 'INDCamp1', Name = 'INDCAMP16', Active_Flag__c = true);
        insert camp;
        Team__c team = new Team__c(Name = 'Test Team1', TeamID__c = 'TestTeam16', Title__c = 'Test');
        insert team;
        
        Candidate_Information__c objCI = new Candidate_Information__c(iiCampaign__c = camp.Id, Candidate_Name__c = 'test test', MSID__c = 'tst123', Team__c = team.Id);
        insert objCI;
        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss'); 
        acc1.Active_Flag__c = true;
        insert acc1;
        
        GPSContact__c cnt = new GPSContact__c();
        cnt.firstName__c = 'fName';
        cnt.lastName__c = 'lName';
        cnt.GPSAccount__c = acc1.Id;
        cnt.Trading_Name_ID__c = acc1.Trading_Name_ID__c ;
        cnt.TN_Contact_Key__c = 'N12344444';
        cnt.CIS_Contact_ID__c = 'TN4545456';
        cnt.Active_Flag__c = true;
        cnt.Firmwide_Id__c = 'Test_1_2_3';
        cnt.TN_Contact_Key__c = 'TN123435K435';
        insert cnt;
        
        Voter_Recommendation__c objVR= new Voter_Recommendation__c(Candidate_Information__c = objCI.Id, GPSContact__c = cnt.Id, Unique_VR_Key__c = 'test4564', Why__c = 'testing purpose');
        insert objVR;
        
        String fileData2 = 'Id\n'+
            objVR.Id + '\n'+
            'abcdf\n';
            
        GPSIICampaignDataLoaderController obj3 = new GPSIICampaignDataLoaderController();
        obj3.selectedUploadOption = 'Voter_Recommendation__c_del';
        obj3.nameFile = 'TestVRDLfile.csv';
        obj3.contentData = fileData2;
        obj3.getformattoCSV();
        obj3.ReadFile();
        
        Test.stopTest();
    }
    
}