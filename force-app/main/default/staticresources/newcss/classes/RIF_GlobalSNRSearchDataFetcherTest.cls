@isTest
public class RIF_GlobalSNRSearchDataFetcherTest {

    public static testMethod void test_getTotalRecords(){
        String oneOffRecId,projectRecId;
        String theEntitlements = ' (Super_Division__c IN (\'10910\',\'98100\',\'10300\',\'10200\',\'10100\')) ';
        Schema.DescribeSObjectResult snrObj = Severance_and_Release__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> recTypes = snrObj.getRecordTypeInfos();
        if(recTypes != null && !recTypes.isEmpty()){
            for( Schema.RecordTypeInfo recInfo : recTypes){
                if(String.valueOf(recInfo.getName()).equalsIgnoreCase('One Off Termination')){
                    oneOffRecId = recInfo.getRecordTypeId();
                }
                else{
                    projectRecId = recInfo.getRecordTypeId();
                }
            }
        }
        Date createdFrom = Date.newInstance(2017, 01, 01);
        Date createdTo = Date.newInstance(2017, 12, 31);
        Date date1 = Date.newInstance(2017, 01, 01);
        Date date2 = Date.newInstance(2017, 01, 01);
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, oneOffRecId, 'TEST', createdFrom, createdTo, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', 'TEST', null, createdTo, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', 'TEST', createdFrom, null, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, '', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', 'TEST', date1, date2, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', 'TEST', null, null, '', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', createdFrom, null, '', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, createdTo, '', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, 'EMP00', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, '', 'EMP', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, '', '', 'USER', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, '', '', '', 'ACTIVE', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', null, null, '', '', '', '', 'USER');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', date1, date2, '', '', '', '', '');
        RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, '', '', createdFrom, createdTo, '', '', '', '', '');
    }
    
    public static testMethod void test_getAllSNRRecords(){
        String oneOffRecId,projectRecId;
        Integer REC_INDEX = 10;
        Integer REC_OFFSET = 0;
        String theEntitlements = ' (Super_Division__c IN (\'10910\',\'98100\',\'10300\',\'10200\',\'10100\')) ';
        Schema.DescribeSObjectResult snrObj = Severance_and_Release__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> recTypes = snrObj.getRecordTypeInfos();
        if(recTypes != null && !recTypes.isEmpty()){
            for( Schema.RecordTypeInfo recInfo : recTypes){
                if(String.valueOf(recInfo.getName()).equalsIgnoreCase('One Off Termination')){
                    oneOffRecId = recInfo.getRecordTypeId();
                }
                else{
                    projectRecId = recInfo.getRecordTypeId();
                }
            }
        }
        Date createdFrom = Date.newInstance(2017, 01, 01);
        Date createdTo = Date.newInstance(2017, 12, 31);
        Date date1 = Date.newInstance(2017, 01, 01);
        Date date2 = Date.newInstance(2017, 01, 01);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, oneOffRecId, 'TEST', createdFrom, createdTo, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, projectRecId, 'TEST', createdFrom, null, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, projectRecId, '', null, null, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, projectRecId, 'TEST', date1, date2, 'EMP00', 'EMP', 'USER', 'ACTIVE', 'USER', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', 'TEST', null, null, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', createdFrom, null, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, createdTo, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, 'EMP00', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, '', 'EMP', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, '', '', 'USER', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, '', '', '', 'ACTIVE', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, '', '', '', '', 'USER', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', date1, date2, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', createdFrom, createdTo, '', '', '', '', '', REC_OFFSET, REC_INDEX);
        RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, '', '', null, null, '', '', '', '', '', REC_OFFSET, REC_INDEX);
    }
    
}