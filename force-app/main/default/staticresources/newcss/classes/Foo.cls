global class Foo implements iterable<Reference_Letter_Request__c>{
   global Iterator<Reference_Letter_Request__c> Iterator(){
      return new CustomIterable();
   }
}