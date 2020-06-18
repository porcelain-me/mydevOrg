global class GP_WebServiceHelper {
    webservice static string requestToBeDelegate(Id employeeId, String loginId){		

		/*//Check to see if employee has Parking Pass system access
		if(loginId != null || !''.equals(loginId)) {
			return 'This employee has access to the Parking Pass system.  Please initiate delegation through normal approval process';
		}*/

		//Find the running user's employee record for delegation assignment
		List<Employee__c> currentUserEmployee = DG_DataUtil.getEmployeeForUser(Userinfo.getUserId());
		if(currentUserEmployee.isEmpty()) {
			return 'Error: No employee record found for the current user';
		}

		//Check for existing delegation records
        List<Employee_Delegate__c> empDelegates = [Select Delegate__c, Status__c, Employee__c, Delegate__r.user__c, Employee__r.Name From Employee_Delegate__c 
                                 WHERE application__c = 'Global Parking' and employee__c = :employeeId and delegate__r.user__c = :Userinfo.getUserId()];
		if(empDelegates.isEmpty()) {
			Employee_Delegate__c delegate = new Employee_Delegate__c();
			delegate.application__c = 'Global Parking';
			delegate.delegate__c = currentUserEmployee[0].Id;
			delegate.Employee__c = employeeId;
			delegate.Status__c = 'Submitted';
			insert delegate;
		}
		else {
			for(Employee_Delegate__c delegate : empDelegates) {
				if('Approved'.equals(delegate.Status__c)) {
					return 'You are already a delegate for this employee';
				}
				else if('Submitted'.equals(delegate.Status__c)) {
					return 'A request has already been submitted.  Please check on the status with your Global Parking Administrator';
				}
			}
			Employee_Delegate__c delegate = empDelegates[0];
			delegate.Status__c = 'Submitted';
			update delegate;
		}

        return 'The delegate request has been submitted';
    }
}