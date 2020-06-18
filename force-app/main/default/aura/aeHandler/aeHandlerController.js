({
	    doInit : function(component, event, helper) {
	    alert('Hello there Init');	
	    },
    
    
        handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("message");

        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        cmp.set("v.numEvents", numEventsHandled);
        
            //calling Init on App Event
        var a = cmp.get('c.doInit');
        $A.enqueueAction(a);
            
    },
    

})