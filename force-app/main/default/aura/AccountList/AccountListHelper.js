({
loadAccounts : function(cmp) {
// Load all contact data
var action = cmp.get("c.getAccounts");
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS") {
cmp.set("v.Accounts", response.getReturnValue());
cmp.set("v.AccountList", response.getReturnValue());
//this.updateTotal(cmp);
}
// Display toast message to indicate load status
var toastEvent = $A.get("e.force:showToast");
if (state === 'SUCCESS'){
toastEvent.setParams({
"title": "Success!",
"message": " Accounts have been loaded successfully."
});
}
else {
toastEvent.setParams({
"title": "Error!",
"message": " Something has gone wrong."
});
}
toastEvent.fire();
});
$A.enqueueAction(action);
},

}
})