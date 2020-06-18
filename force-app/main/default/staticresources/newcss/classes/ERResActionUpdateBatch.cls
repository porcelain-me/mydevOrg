global class ERResActionUpdateBatch implements Database.Batchable<sObject>{
    
    private final String query = 'Select Id,Name,Resolution_Action__c from Case__c';
    
     public ERResActionUpdateBatch (){ 
     }                                            //Constructor
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    List<Case__c> caseNewRes = new List<Case__c>();
    
    global void execute(Database.BatchableContext BC, List<Case__c> casesList){
        
        for(Case__c caserecstoUpdate : [Select id, name,Resolution_Action__c  FROM Case__c Where recordtypeid in (Select Id From RecordType where sobjecttype = 'Case__C' and name in ('Compliance'))]) {
            System.debug('@@@@@@@@'+caserecstoUpdate .Resolution_Action__c);
            
            if(caserecstoUpdate .Resolution_Action__c != null){
            
            If(caserecstoUpdate .Resolution_Action__c == 'Continued Monitoring'){
                caserecstoUpdate .Resolution_Action__c = 'Other';
                caserecstoUpdate .Description__c= 'CONTINUING MONITORING';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Discipline/Comp Impacted'){
                caserecstoUpdate .Resolution_Action__c = 'Written Warning';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Dismissal w/ Notice/Demotion'){
                caserecstoUpdate .Resolution_Action__c = 'Dismissal with Notice';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Fines/Penalties'){
                caserecstoUpdate .Resolution_Action__c = 'Other';
                caserecstoUpdate .Required_to_pay_fine_penalty__c = 'Yes';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Lawyer\'s Letter'){
                caserecstoUpdate .Resolution_Action__c = 'Letter of Education';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Letter of Admonition'){
                caserecstoUpdate .Resolution_Action__c = 'Written Warning';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Letter of Reprimand'){
                caserecstoUpdate .Resolution_Action__c = 'Written Warning';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Not Applicable'){
                caserecstoUpdate .Resolution_Action__c = 'No Action Required';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Oral Reprimand'){
                caserecstoUpdate .Resolution_Action__c = 'Verbal Warning';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='RecordedVerbalWarning-LCD Only'){
                caserecstoUpdate .Resolution_Action__c = 'Recorded Verbal Warning';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Release Agreement Signed'){
                caserecstoUpdate .Resolution_Action__c = 'Other';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Required Compliance Training'){
                caserecstoUpdate .Resolution_Action__c = 'Other';
                caserecstoUpdate .Remedial_training_coaching__c = 'Yes';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Suspension'){
                caserecstoUpdate .Resolution_Action__c = 'Written Warning - Suspension';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Termination - Gross Misconduct'){
                caserecstoUpdate .Resolution_Action__c = 'Termination - Gross Misconduct (Excl. U.S.)';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Termination - Mutual Consent'){
                caserecstoUpdate .Resolution_Action__c = 'Termination - Involuntary';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Trading Restriction'){
                caserecstoUpdate .Resolution_Action__c = 'Written Warning';
                caserecstoUpdate .Other_limitations_on_activities__c= 'Yes';
            
            }else if(caserecstoUpdate .Resolution_Action__c =='Training/Counseling'){
                caserecstoUpdate .Resolution_Action__c = 'Other';
                caserecstoUpdate .Remedial_training_coaching__c = 'Yes';
            }
            
           }
            caseNewRes .add(caserecstoUpdate);
     }
     try{
     
     if(caseNewRes != null && caseNewRes .size()>0){
            update caseNewRes ;
        }
     }
     catch(Exception ex){
         System.debug('EXCEPTION:'+ex);
         
     }
    }
        
    
    global void finish(Database.BatchableContext BC){
    }
}