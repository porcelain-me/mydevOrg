@isTest (SeeAllData = false) 
public class PP_AdminScreenControllerTest {
   public String selectedValue { get; set; } 
   public  PP_AdminScreenControllerTest()
   {      
   }

      static testmethod void PPRecord()
      {
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         	{ 

                PP_AdminScreenController PPadmin = new PP_AdminScreenController();                
                for(Integer i=1;i<=10;i++){
                PPadmin.selectedValue = getSelectedValue(i);
                PPadmin.selectFunction();               
                }
                
            }
         Test.stopTest();  
          
      }    
    static String getSelectedValue(Integer num){
        String val = '';
        if(num == 1){ val='va';}
        else if(num == 2){ val='vb';}
        else if(num == 3){ val='vc';}
        else if(num == 4){ val='vd';}
        else if(num == 5){ val='ve';}
        else if(num == 6){ val='vf';}
        else if(num == 7){ val='vi';}
        else if(num == 8){ val='vg';}
        else if(num == 9){ val='vz';}
        else if(num == 10){ val='';}
        return val;
    }    
    
}