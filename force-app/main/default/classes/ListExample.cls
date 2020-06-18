/*public with sharing class CollectionExample {
    public static void Listmethod{
    List<String> mylist = new List<String>();
    mylist.addAll('me','you','he','his');
    for(i=0;i<mylist.size(),i++){
    system.debug('list is'+i); 
     }
}
}*/
public class ListExample {
        public void listMethod(){
        List<String> list1 = new List<String>();
        list1.add('Vijay');
        list1.add('Esh');
        list1.add('Bhavs');
        list1.add('Serry');
            for( String str: list1){
                    System.debug('The elements are:'+ str);
            }
    }
}