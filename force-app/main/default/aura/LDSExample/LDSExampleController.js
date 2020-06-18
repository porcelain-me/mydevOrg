({
	doInit : function(component, event, helper) {
	alert('Hello there');	
	},
    
    
    
    anotherMethod : function(component, event, helper){
    var a = component.get('c.doInit');
        $A.enqueueAction(a);
   }
})