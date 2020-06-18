/**
 7/26/2012 UV: created this test class
 */
@isTest
private class TestEmployeeTeamSharing {
	static Integer LIST_SIZE = 10;
	static list<Research_Team__c> rtlist;
    static testMethod void testCase1() {
	   // Employee is inserted after creating Research Team
			Test.startTest();
    		TestClassUtilities.setAllTriggerOn();

            List<User> usrList = [select Emp_Id__c from User where Profile.Name = 'System Administrator' and IsActive = true and Emp_Id__c != null limit 2];
    		
    		//inserting research team
    		Set<String> teamIds = insertResearchTeam();
    		
    		//insert employees for research team
    		list<GPSEmployee__c> empList = insertEmployees(usrList,rtlist[0],true);
    		
    		//get inserted teams for research team    		
            List<Team__c> teamList = [Select Id from Team__c where TeamID__c in :teamIds];
            
    		System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
    		
    		List<Team__Share> tsList = [select id from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		System.assertEquals(empList.size(),tsList.size(),'Team share records should be equals to no of users');
    		
   			Test.stopTest();
    }
	
    	
    	static testMethod void testCase2() {
    		// Employee is made active after inserting research team
    		Test.startTest();
    		TestClassUtilities.setAllTriggerOn();

            List<User> usrList = [select Emp_Id__c from User where Profile.Name = 'System Administrator' and IsActive = true and Emp_Id__c != null limit 2];
    		
    		//inserting inactive employees for research team
    		list<GPSEmployee__c> empList = insertEmployees(usrList,null,false);
    		
    		//inserting research team
    		Set<String> teamIds = insertResearchTeam();
    		    		
            List<Team__c> teamList = [Select Id from Team__c where TeamID__c in :teamIds];
            
    		System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
    		
    		List<Team__Share> tsList = [select id from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because employees are not active
    		System.assertEquals(0,tsList.size(),'Team share records should be equals 0');
    		
    		//activating the employee
    		for(GPSEmployee__c emp : empList) {
    			emp.Active_Flag__c = true;
    			emp.Research_Team__c = rtList[1].Id;
    		}
    		update empList;
    		
    		tsList = [select id from Team__Share where parentId IN : teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		System.assertEquals(empList.size(),tsList.size(),'Team share records should be equals to no of employees');
    		Test.stopTest();
    		
    	}
    	static testMethod void testCase3() {
			// updating the research team associated with employee cause delete previously added team and create new team share.
			Test.startTest();
    		TestClassUtilities.setAllTriggerOn();

            List<User> usrList = [select Emp_Id__c from User where Profile.Name = 'System Administrator' and IsActive = true and Emp_Id__c != null limit 2];
    		//inserting research team
    		Set<String> teamIds = insertResearchTeam();
    		//inserting new employees
    		list<GPSEmployee__c> empList = insertEmployees(usrList,rtlist[0],true);
    		
    		    		
            List<Team__c> teamList = [Select Id from Team__c where TeamID__c in :teamIds];
            
    		System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
    		
    		List<Team__Share> tsList = [select id from Team__Share where parent.teamId__c = : rtlist[0].Team_id__c and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because employees are not active
    		System.assertEquals(usrList.size(),tsList.size(),'Team share records should be equals to no of users');
    		
    		for(GPSEmployee__c emp : empList) {
    			emp.Active_Flag__c = true;
    			emp.Research_Team__c = rtList[1].Id;
    		}
    		update empList;
    		
    		 tsList = [select id from Team__Share where parent.teamId__c = : rtlist[0].Team_id__c and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because research team is now not related to any employee
    		System.assertEquals(0,tsList.size(),'Team share records should be equals to no of users');
    		
    		tsList = [select id from Team__Share where parent.teamId__c = : rtlist[1].Team_id__c and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		System.assertEquals(usrList.size(),tsList.size(),'Team share records should be equals to no of users');
    		
   			Test.stopTest();
    }
    static testMethod void testCase4() {
			//updating employee and remove assigned research team
			Test.startTest();
    		TestClassUtilities.setAllTriggerOn();

            List<User> usrList = [select Emp_Id__c from User where Profile.Name = 'System Administrator' and IsActive = true and Emp_Id__c != null limit 2];
    		//inserting research team
    		Set<String> teamIds = insertResearchTeam();
    		//inserting new employees
    		list<GPSEmployee__c> empList = insertEmployees(usrList,rtlist[0],true);
    		
    		    		
            List<Team__c> teamList = [Select Id,isHidden__c from Team__c where TeamID__c in :teamIds];
            
    		System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
    		
    		List<Team__Share> tsList = [select id from Team__Share where parentId IN :teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because employees are not active
    		System.assertEquals(usrList.size(),tsList.size(),'Team share records should be equals to no of users');
    		
    		for(GPSEmployee__c emp : empList) {
    			emp.Active_Flag__c = true;
    			emp.Research_Team__c = null;
    		}
    		update empList;
    		
    		 tsList = [select id from Team__Share where parentId IN :teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because research team is now not related to any employee
    		System.assertEquals(0,tsList.size(),'Team share records should be equals to no of users');
    		
   			Test.stopTest();
    }
    
    static testMethod void testCase5() {
    	// updated reseach team and new research team has related inactive team associted. This should not create any new team share and
    	//should delete previously added team share
    	
    		Test.startTest();
    		TestClassUtilities.setAllTriggerOn();
			//Query User to avoid MIXED_DML_OPERATION Error
            List<User> usrList = [select Emp_Id__c from User where Profile.Name = 'System Administrator' and IsActive = true and Emp_Id__c != null limit 2];
    		//inserting research team
    		Set<String> teamIds = insertResearchTeam();
    		//inserting new employees
    		list<GPSEmployee__c> empList = insertEmployees(usrList,rtlist[0],true);
    		
    		    		
            List<Team__c> teamList = [Select Id,isHidden__c from Team__c where TeamID__c in :teamIds];
            
    		System.assertEquals(rtList.size(),teamList.size(),'Teams inserted should be equals to research Teams');
    		
    		List<Team__Share> tsList = [select id from Team__Share where parentId IN :teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because employees are not active
    		System.assertEquals(usrList.size(),tsList.size(),'Team share records should be equals to no of users');
    	
    		for(Team__c t : teamList) {
    			t.isHidden__c = true;
    		}
    		update teamList;
    		
    		
    		for(GPSEmployee__c emp : empList) {
    			emp.Research_Team__c = rtlist[1].Id;
    		}
    		update empList;
    		
    		 tsList = [select id from Team__Share where parentId IN :teamList and RowCause = :Schema.Team__Share.RowCause.Team_Share__c];
    		
    		// team share should be 0, because no active teams is associated with employee
    		System.assertEquals(0,tsList.size(),'Team share records should be equals to no of users');
    		
    }
    	static Set<String> insertResearchTeam() {
    		Set<String> teamIds = new Set<String>();
    		rtlist = new list<Research_Team__c>();
    		
            for(Integer i = 0; i < LIST_SIZE ; i++) {
                Research_Team__c rt = new Research_Team__c();
                rt.Team_Id__c = 'TestID_' + i;
                rt.Active_Flag__c = true;
                rt.Team_Status__c = 'Open';
                rt.Team_Function__c = 'Industry';
                rt.Name = 'Test_UV' + i;
                teamIds.add('TestID_' + i);
                rtList.add(rt); 
            }
            insert rtList;
            return teamIds;
    	}
    	
    	static list<GPSEmployee__c> insertEmployees(list<User> usrList, Research_Team__c rt, boolean activeFlag) {
    		list<GPSEmployee__c> empList = new List<GPSEmployee__c>();
    		
    		for(User duser : usrList) {
    			GPSEmployee__c emp = new GPSEmployee__c();
	    		emp.Name = 'Test Employee';
	    		emp.MS_ID__c = duser.Emp_Id__c;
	    		emp.User__c = dUser.Id;
	    		emp.Office_Title__c = 'Test Tittle';
	    		emp.Division__c = 'Test Div';
	    		//emp.Cost_Center_Desc__c = 'Desc-01';
	    		emp.Active_Flag__c = activeFlag;
	    		if(rt <> null)
	    		emp.Research_Team__c = rt.Id; 
	    		empList.add(emp);
    		}
    		insert empList;
    		return empList;
    	}
	
}