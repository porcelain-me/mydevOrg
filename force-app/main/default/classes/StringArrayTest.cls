/*public class StringArrayTest{
public static List<string> generateStringArray(Integer n){
list<string> arr = new list<string>();
for (Integer i= 0; i < n; i++){
  arr.add('Test'+i);
}
    system.debug('arr'+arr);
return arr;
 
}
}*/

public class StringArrayTest {
    
    public static List<String> generateStringArray(Integer n)
    {   
        List<String> myArray = new List<String>();
        If(n == NULL || n<0 ||(n != NULL && String.isBlank(String.valueOf(n)))){
            system.debug('enter some value');
        }
        else{
            for(Integer i=0;i<n;i++)
        {
           myArray.add('Test '+i);
           System.debug(myArray[i]);
        }}
        return myArray;
    }
}