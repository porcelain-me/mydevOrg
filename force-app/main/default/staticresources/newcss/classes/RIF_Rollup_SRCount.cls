public class RIF_Rollup_SRCount {

 

    public void updateCount(set<string> SRCount){

         

        if(SRCount == null){    

            return;

        }

         

        if(SRCount.size() == 0){

            return;

        }

         

        list<Severance_And_Release__c> SRList = new list<Severance_And_Release__c>([Select ID,Project_Level__c,WARN__c

                    From Severance_And_Release__c

                    Where Project_Level__c = :SRCount]);

     

             

        integer totalCount;
        integer totalCountWarn;
        map<string, integer> ParameterToSR = new map<string, integer>();
        map<string, integer> ParameterToSR_Warn = new map<string, integer>();        

        for(Severance_And_Release__c SR : SRList){

            if(ParameterToSR.containsKey(SR.Project_Level__c)){

                totalCount = ParameterToSR.get(SR.Project_Level__c);

            }
            else{

                totalCount = 0;
                

            }
            if(ParameterToSR_Warn.containsKey(SR.Project_Level__c) && SR.WARN__c==true){

                totalCountWarn = ParameterToSR_Warn.get(SR.Project_Level__c);

            }
            else{

                
                totalCountWarn = 0;

            }

            totalCount += 1;  
            totalCountWarn += 1;    

            ParameterToSR.put(SR.Project_Level__c, totalCount);
            ParameterToSR_Warn.put(SR.Project_Level__c, totalCountWarn);

        } 

         

        list<Project_Level__c> CountUpdateList = new list<Project_Level__c>();

        Project_Level__c projLevelTemp;
        

        for(string projLevelID : ParameterToSR.keySet()){

            projLevelTemp= new Project_Level__c();

            projLevelTemp.ID = projLevelID ; 

            projLevelTemp.S_R_Count__c= ParameterToSR.get(projLevelID );
            projLevelTemp.S_R_Warn_Count__c= ParameterToSR_Warn.get(projLevelID );

            CountUpdateList.add(projLevelTemp);

        }
        

        if(CountUpdateList.size() > 0){

            update CountUpdateList;

        }

    }

}