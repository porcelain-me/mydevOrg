global class CustomIterable 
   implements Iterator<Reference_Letter_Request__c>{ 

   List<Reference_Letter_Request__c> accs {get; set;} 
   Integer i {get; set;} 

   public CustomIterable(){ 
       accs = 
       [SELECT Id, Name FROM Reference_Letter_Request__c limit 300]; 
       i = 0; 
   }   

   global boolean hasNext(){ 
       if(i >= accs.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global Reference_Letter_Request__c next(){ 
       // 8 is an arbitrary        // constant in this example       // that represents the        // maximum size of the list.       
       if(i == 100){return null;} 
       i++; 
       return accs[i-1]; 
   } 
}