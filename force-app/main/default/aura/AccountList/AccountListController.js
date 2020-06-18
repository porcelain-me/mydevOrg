({
doInit : function(component, event, helper) {
// Retrieve contacts during component initialization
helper.loadAccounts(component);
},
handleSelect : function(component, event, helper) {
var Accounts = component.get("v.Accounts");
var AccountList = component.get("v.AccountList");
//Get the selected option: "Referral", "Social Media", or "All"
var selected = event.getSource().get("v.value");
var filter = [];
for (var i=0; i<AccountList.length; i++){
var c = AccountList[i];
if (selected != "All"){
if(c.LeadSource == selected) {
filter[i] = c;
}}
else {
filter = AccountList;
}
}
//Set the filtered list of contacts based on the selected option
component.set("v.accounts", filter);
helper.updateTotal(component);
}
})