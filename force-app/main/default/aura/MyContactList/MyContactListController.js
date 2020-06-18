/*({
	myAction : function(component, event, helper) { 
        var action = component.get("c.getContact");
action.setCallback(this, function(data) {
component.set("v.Contact", data.getReturnValue());
    
   
});
$A.enqueueAction(action);

        
	}, 
    navigateTocontact : function(component,event,helper) {  
        
        var newvar =  component.get("v.Contact.Id").Id;
        alert(newvar);
         
    
    goToDetailPage : function(component,event,helper) {  
        var smval= component.get('v.Contact.Id');
        alert(smval);
   
} 
})*/

({
doInit : function(component, event, helper) {
// Retrieve contacts during component initialization
helper.loadContacts(component);
},
handleSelect : function(component, event, helper) {
var contacts = component.get("v.contacts");
var contactList = component.get("v.contactList");
//Get the selected option: "Referral", "Social Media", or "All"
var selected = event.getSource().get("v.value");
var filter = [];
for (var i=0; i<contactList.length; i++){
var c = contactList[i];
if (selected != "All"){
if(c.LeadSource == selected) {
filter[i] = c;
}

}
else {
filter = contactList;
}
}
//Set the filtered list of contacts based on the selected option
component.set("v.contacts", filter);
helper.updateTotal(component);
}
})