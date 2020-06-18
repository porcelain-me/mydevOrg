public class myFirstClass {


        @future
      public static void myFirstMethod()
      {
        system.debug('Hello team');
        String str = 'Aniket';
        Integer count  = 1;
        Boolean Checkbox = True;
        Date lastday = system.today();
        Datetime currentvalue = system.now();
        Decimal dec = 1.6;
        Double valueofPie = 3.1456789;
        Id accountId = '0016F00001xoSSs';
        Long veryhugenumber = 123456554484164998L;
        //Account acc = new Account();
          //Enum weather = {'Summer', 'winter','Spring'};  
        
        List<String> idList = new list<String>();    //unordered collection Not unique
        Map<Integer, String> nameMap = new Map<Integer, String>();    //collection with ey value pairs
        Set<Integer> numberSet = new Set<Integer>();     // ordered collection with unique values
          
         /* for ( String s : acc)
          {
             system.debug('hello'); 
          }*/
         idList.add('0016F00001xoSSsQAM');
         idList.add('2ndvalue');
         idList.add('12345678');
          system.debug('Print the list'+idList);
          system.debug('print only one index'+idList[2]);
          idList.size();
          idList.get(1); 
          idList.clear();
          system.debug('Value available in list'+idList.contains('2ndvalue')); 
          
          List<Account> acList = [Select id,Name, Phone from Account limit 15];
          system.debug('populate the list with query'+acList);
             Set<Id> strngSet =  new Set<Id>();
             //List<Id> acIdlst = new List<Id>();
          for(Account accc : acList){
              strngSet.add(accc.id);
          }
          system.debug('Set Values true or false: '+strngSet.isEmpty());
          if(strngSet.isEmpty()){
              System.debug('this is a not empty set '+strngSet);
          }
          else If( strngSet.size() > 5){
              system.debug('its big set with size as :'+strngSet.size());
          } 
          Else{
              system.debug('this is else block when noting is true');
              
          }
          
           //for loop types
          for(Integer i = 0; i<idList.size(); i++ ){
              contact ct = new Contact();
              ct.LastName = 'contactsviaApex'+i;
              system.debug('firsttyp of loop');
          }  
          
      }
   
    public void mysecondmethod(){
        
       //Map<Key,Value> mapName = new Map<Key, Value>();
        Map<Integer, String> exampleMap = new Map<Integer,String>();
        exampleMap.put(1,'Mumbai');
        exampleMap.put(2,'Delhi');
        exampleMap.put(3,'Chennai');
        exampleMap.put(4,'Kolkata');
        exampleMap.put(5,'Banglore');
        
        system.debug('Print the map'+exampleMap);
        if(exampleMap.containskey(7)){
           system.debug('yes it has that key'); 
        }
        else{
            system.debug(' no it dsnt have that key'); 
        }
        
        //integer mynumber = 4;
        //if(exampleMap.{
           
           
        //}
       /* strngSet.add('One');
        strngSet.add('Two');
        //strngSet.add('One'); */
        
        //system.debug('this is another instatnce method'+strngSet);
    }
    @future
    public static void futureExample(){
       List<Account> accToUpdate = new List<Account>();
        List<Account> acList = [Select id, Name from Account ];
        
        for(Account ac : acList){
            if(ac.Name !='Abc')
                ac.billingcity = 'Pune';
            accToUpdate.add(ac);
        }
          Update accToUpdate;
        
        
    }
}