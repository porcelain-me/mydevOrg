({
goToRecord : function(component, event, helper) {
// Fire the event to navigate to the contact record
var sObjectEvent = $A.get("e.force:navigateToSObject");
sObjectEvent.setParams({
"recordId": component.get("v.account.Id")
})
sObjectEvent.fire();
}
})