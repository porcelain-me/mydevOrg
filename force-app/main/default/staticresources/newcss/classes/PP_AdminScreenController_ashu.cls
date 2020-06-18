@isTest                                                 //dummy class
public class PP_AdminScreenController_ashu {

    public List<Row> rows { get; set; }
    public String selectedValue { get; set; }
         
    public PP_AdminScreenController_ashu () {
        rows = new List<Row>();
        /*
        rows.add(new Row('v0', 'Manage New Request Dropdowns'));
        rows.add(new Row('va', 'Property Type Dropdown'));
        rows.add(new Row('vb', 'Unit Type Dropdown'));
        rows.add(new Row('vc', 'To Dropdown'));
        rows.add(new Row('vd', 'Property Owner Dropdown'));*/

       // rows.add(new Row('v0', 'Manage Approver List'));
        //rows.add(new Row('ve', 'EDC Approver List'));
        //rows.add(new Row('vf', 'Property Services Approver List'));
        rows.add(new Row('vz', 'CSIT Enhancement Request (e.g Manage Approvers, Manage New Request fields, etc)'));
       
        rows.add(new Row('vg', 'Buildings In-Scope'));
       /* rows.add(new Row('v0', 'Miscellaneous'));
        rows.add(new Row('vh', 'Equipment Receipt Confirm (mailgroup)'));*/
        rows.add(new Row('vi', 'Run Report'));
        

    }
    public String errorMessage{get;set;}
    public PageReference selectFunction() {
        System.debug('SFDC: ' + selectedValue);
        string returnURL = null;
        if(selectedValue != null && selectedValue != '')
        {
            if(selectedValue == 'va')
                returnURL = '/apex/PP_ManageDropDownList?tab=ProType';
            if(selectedValue == 'vb')
                returnURL = '/apex/PP_ManageDropDownList?tab=UniType';
            if(selectedValue == 'vc')
                returnURL = '/apex/PP_ManageDropDownList?tab=To';
            if(selectedValue == 'vd')
                returnURL = '/apex/PP_ManageDropDownList?tab=Owner';
            if(selectedValue == 've')
                returnURL = '/apex/PP_approvalList';
            if(selectedValue == 'vf')
                returnURL = '/apex/PP_approvalList';
            if(selectedValue == 'vi')
                returnURL = '/apex/pp_AdhocReport';
           if(selectedValue == 'vg')
                returnURL = '/apex/PP_ManageDropDownList?tab=Building';
           if(selectedValue == 'vz')
                returnURL = 'http://sswebapp-na.ms.com/apexit/requests/fcgi-bin/dispatcher/intake/form';
               
                 
        
                
        }
        
        else
        {
            errorMessage=' Please select an Admin Function to proceed.';
            return null;
        }
        
        
        PageReference pr = new PageReference(returnURL);
        pr.setRedirect(true);

        return pr;
        
    } 
 
 
    public class Row {
        public String Value { get; set; }
        public String Label { get; set; }
        public Boolean isChecked { get; set; }
        
        public Row(String Value, String Label) {
            this.Value = Value;
            this.Label = Label;
        } 
    }
}