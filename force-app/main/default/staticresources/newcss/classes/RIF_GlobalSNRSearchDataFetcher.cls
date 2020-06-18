/** This class will perform the query on SNR object,
as this is 'with sharing' only the records that are accessable to the user will be returned **/
public with sharing class RIF_GlobalSNRSearchDataFetcher {
    public static List<Severance_and_Release__c> snrReturnList = new List<Severance_and_Release__c>();
    public static String queryStr = 'SELECT Id, Name, Employee__c, Employee__r.Name, Employee__r.Emp_Id__c, Project__c, Project__r.Name, Project__r.Status__c,'
        + ' RecordTypeId, CreatedById, CreatedBy.Name, Project__r.Owner.Name ' 
        + ' FROM Severance_and_release__c';
    public static String queryCountStr = 'SELECT count()' 
        + ' FROM Severance_and_release__c';
    public static String conditions = '';
    public static String finalQuery = '';
    public static Integer totalRows = 0;
    
    // this method will retrieve all the SNR records that are applicable to the logged in user
    public static List<Severance_and_Release__c> getAllSNRRecords(String allEntitlements, String recType, String projectName, Date createdFrom, Date createdTo, String empMSID, String empName, String prjtOwnerName, String status, String createdByName, Integer offset, Integer resultSize){
        finalQuery = '';
        // CONDITION 1 --- project/SNR type check (One-Off OR Project based)
        if(!String.isBlank(recType)){
            conditions = ' WHERE RecordTypeId = : recType';
        }
        // CONDITION 2 --- project name
        if(!String.isBlank(projectName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Name LIKE \'%' +  projectName + '%\'';
            }
            else{
                conditions = ' WHERE Project__r.Name LIKE \'%' +  projectName + '%\'';
            }
        }
        // CONDITION 3 --- created date range
        // 20-Nov-17 : Added checks to show results for only 'From' OR 'To' dates
        // 1. we have BOTH the dates
        if(createdFrom != null && createdTo != null){
            // ALM#1988 : check if the dates are same
            if(createdFrom.isSameDay(createdTo)){
                createdTo =  createdFrom.addDays(1);
                if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                    conditions = conditions + ' AND CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                }
                else{
                    conditions = ' WHERE CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                } 
            }
            else{
                // we will add an extra day as the actual date format will be e.g.- '2017-09-14 00:00:00',
            	// due to this we will not get the records created on that day
                createdTo = createdTo.addDays(1);
                if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                    conditions = conditions + ' AND CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                }
                else{
                    conditions = ' WHERE CreatedDate > : createdFrom  AND CreatedDate < : createdTo';
                }
            }
        }
        // 2. we have ONLY 'Created From'
        else if(createdFrom != null && createdTo == null){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedDate > : createdFrom';
            }
            else{
                conditions = ' WHERE CreatedDate > : createdFrom';
            }
        }
        // 3. we have ONLY 'Created To'
        else if(createdFrom == null && createdTo != null){
            // we will add an extra day as the actual date format will be e.g.- '2017-09-14 00:00:00',
            // due to this we will not get the records created on that day
            createdTo = createdTo.addDays(1);
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedDate < : createdTo';
            }
            else{
                conditions = ' WHERE CreatedDate < : createdTo';
            }
        }
        // CONDITION 4 --- employee MSID
        if(!String.isBlank(empMSID)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Employee__r.Emp_Id__c LIKE \'%' + empMSID + '%\'';
            }
            else{
                conditions = ' WHERE Employee__r.Emp_Id__c LIKE \'%' + empMSID + '%\'';
            }
        }
        // CONDITION 5 --- employee name
        if(!String.isBlank(empName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Employee__r.Name LIKE \'%' + empName + '%\'';
            }
            else{
                conditions = ' WHERE Employee__r.Name LIKE \'%' + empName + '%\'';
            }
        }
        // CONDITION 6 --- project owner name
        if(!String.isBlank(prjtOwnerName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Owner.Name LIKE \'%' + prjtOwnerName + '%\'';
            }
            else{
                conditions = ' WHERE Project__r.Owner.Name LIKE \'%' + prjtOwnerName + '%\'';
            }
        }
        // CONDITION 7 --- project status
        if(!String.isBlank(status) && !status.equalsIgnoreCase('None')){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Status__c =: status';
            }
            else{
                conditions = ' WHERE Project__r.Status__c =: status';
            }
        }
        // CONDITION 8 --- created by name
        if(!String.isBlank(createdByName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedBy.Name LIKE \'%' + createdByName + '%\'';
            }
            else{
                conditions = ' WHERE CreatedBy.Name LIKE \'%' + createdByName + '%\'';
            }
        }
        // add the entitlements to the query 
        if(!String.isBlank(conditions) && conditions.contains('WHERE')){
            conditions = conditions + ' AND ' + allEntitlements + ' LIMIT ' + resultSize + ' OFFSET ' + offset ;
        }
        else{
            conditions = ' WHERE ' + allEntitlements + ' LIMIT ' + resultSize + ' OFFSET ' + offset ;
        }

        // add all the conditions
        finalQuery = queryStr + conditions;
        system.debug(' -- finalQuery -- ' + finalQuery);
        snrReturnList = Database.query(finalQuery);
        conditions = '';
        return snrReturnList;
    }
    
    // this method will get the total number of records for the main query
    public static Integer getTotalRecords(String allEntitlements, String recType, String projectName, Date createdFrom, Date createdTo, String empMSID, String empName, String prjtOwnerName, String status, String createdByName){
        finalQuery = '';
        // CONDITION 1 --- project/SNR type check (One-Off OR Project based)
        if(!String.isBlank(recType)){
            conditions = ' WHERE RecordTypeId = : recType';
        }
        // CONDITION 2 --- project name
        if(!String.isBlank(projectName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Name LIKE \'%' +  projectName + '%\'';
            }
            else{
                conditions = ' WHERE Project__r.Name LIKE \'%' +  projectName + '%\'';
            }
        }
        // CONDITION 3 --- created date range
        // 20-Nov-17 : Added checks to show results for only 'From' OR 'To' dates
        if(createdFrom != null && createdTo != null){
            // ALM#1988 : check if the dates are same
            if(createdFrom.isSameDay(createdTo)){
                createdTo =  createdFrom.addDays(1);
                if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                    conditions = conditions + ' AND CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                }
                else{
                    conditions = ' WHERE CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                } 
            }
            else{
                // we will add an extra day as the actual date format will be e.g.- '2017-09-14 00:00:00',
            	// due to this we will not get the records created on that day
           	 	createdTo = createdTo.addDays(1);
                if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                    conditions = conditions + ' AND CreatedDate > : createdFrom AND CreatedDate < : createdTo';
                }
                else{
                    conditions = ' WHERE CreatedDate > : createdFrom  AND CreatedDate < : createdTo';
                }
            }
        }
        // 2. we have ONLY 'Created From'
        else if(createdFrom != null && createdTo == null){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedDate > : createdFrom';
            }
            else{
                conditions = ' WHERE CreatedDate > : createdFrom';
            }
        }
        // 3. we have ONLY 'Created To'
        else if(createdFrom == null && createdTo != null){
            // we will add an extra day as the actual date format will be e.g.- '2017-09-14 00:00:00',
            // due to this we will not get the records created on that day
            createdTo = createdTo.addDays(1);
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedDate < : createdTo';
            }
            else{
                conditions = ' WHERE CreatedDate < : createdTo';
            }
        }
        // CONDITION 4 --- employee MSID
        if(!String.isBlank(empMSID)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Employee__r.Emp_Id__c LIKE \'%' + empMSID + '%\'';
            }
            else{
                conditions = ' WHERE Employee__r.Emp_Id__c LIKE \'%' + empMSID + '%\'';
            }
        }
        // CONDITION 5 --- employee name
        if(!String.isBlank(empName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Employee__r.Name LIKE \'%' + empName + '%\'';
            }
            else{
                conditions = ' WHERE Employee__r.Name LIKE \'%' + empName + '%\'';
            }
        }
        // CONDITION 6 --- project owner name
        if(!String.isBlank(prjtOwnerName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Owner.Name LIKE \'%' + prjtOwnerName + '%\'';
            }
            else{
                conditions = ' WHERE Project__r.Owner.Name LIKE \'%' + prjtOwnerName + '%\'';
            }
        }
        // CONDITION 7 --- project status
        if(!String.isBlank(status) && !status.equalsIgnoreCase('None')){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND Project__r.Status__c =: status';
            }
            else{
                conditions = ' WHERE Project__r.Status__c =: status';
            }
        }
        // CONDITION 8 --- created by name
        if(!String.isBlank(createdByName)){
            if(!String.isBlank(conditions) && conditions.contains('WHERE')){
                conditions = conditions + ' AND CreatedBy.Name LIKE \'%' + createdByName + '%\'';
            }
            else{
                conditions = ' WHERE CreatedBy.Name LIKE \'%' + createdByName + '%\'';
            }
        }
        // add the entitlements to the query 
        if(!String.isBlank(conditions) && conditions.contains('WHERE')){
            conditions = conditions + ' AND ' + allEntitlements;
        }
        else{
            conditions = ' WHERE ' + allEntitlements;
        }

        // add all the conditions
        finalQuery = queryCountStr + conditions;
        system.debug(' -- finalQuery COUNT -- ' + finalQuery);
        totalRows = Database.countQuery(finalQuery);
        conditions = '';
        return totalRows;
    }
}