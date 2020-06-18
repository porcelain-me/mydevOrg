({
  handleOnload : function(component, event, helper) {
    var recUi = event.getParam("recordUi");
    console.log('Value of RecordUI:  '+JSON.stringify(recUi));
    console.log('here');
    console.assert(null === recUi.record.id);

    console.assert(null === recUi.record.fields["Account"].displayValue);
    console.assert(null === recUi.record.fields["Account"].value);

    console.assert("Account" === recUi.objectInfos["Account"].label);
  },
    
  handleOnSubmit : function(component, event, helper) {
    //event.preventDefault();
    //var fields = event.getParam("fields");
    //fields["AccountId"] = component.get("v.parentId");
    //component.find("form").submit(fields);
     component.find('EmailHtml').focus();
     /*console.log('Global Id is '+component.getGlobalId('EmailId'));
       var globalId = component.getGlobalId('EmailId');
       var el =  document.getElementById('input-187');
       console.log('DOM Id is'+el);  
      el.focus();
      
    setTimeout(function(){ 
    component.find("EmailId").focus();
    }, 1000);
    */  
  },
    
  handleOnSuccess : function(component, event, helper) {
    var record = event.getParam("response");
    component.find("notificationsLibrary").showToast({
        "title": "Saved",
        "message": "{0} saved for {1}",
        "messageData": [
            {
                url: '/' + record.id,
                label: record.fields.FirstName.value + ' ' + record.fields.LastName.value
            },
            {
                url: '/' + record.fields.AccountId.value,
                label: record.fields.Account.displayValue
            }
        ]
    });
  },
    
    afterRender: function (cmp, helper) {
    //this.superAfterRender();
   var element = cmp.find("EmailId").getElement();
   element.focus();
}
    
    
})