public class CheckRecursive {
	

public Static boolean PreventRecursive = true; 

public Static Boolean runOnce(){

    if(PreventRecursive){
    	
     	PreventRecursive =false;
     	return true;
     	
    }else{   	
        return PreventRecursive;
    }

}

}