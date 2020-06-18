({
    packItem: function(component, event, helper) {
        var a = component.get("v.item", True)
        a.Packed__c = True;
        component.set("v.item",a);
        var btnClicked = event.getSource();         // the button
         btnClicked.set("v.disabled",true);
    }
})