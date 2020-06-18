@isTest(SeeAllData = false)
private class DocuSignAPITest {
    private static User sysUser;
    private static testmethod void testDocusignAPI(){
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.startTest();
            DocuSignAPI.AuthoritativeCopyExportDocuments aced = new DocuSignAPI.AuthoritativeCopyExportDocuments();
            DocuSignAPI.GetFolderListResponse_element gflr = new DocuSignAPI.GetFolderListResponse_element();
            DocuSignAPI.ExportAuthoritativeCopyResponse_element eacr = new DocuSignAPI.ExportAuthoritativeCopyResponse_element();
            DocuSignAPI.GetAccountSettingsList_element gasl = new DocuSignAPI.GetAccountSettingsList_element();
            DocuSignAPI.ArrayOfRecipientCorrectionStatus aorcs = new DocuSignAPI.ArrayOfRecipientCorrectionStatus();
            DocuSignAPI.Reminders rem = new DocuSignAPI.Reminders();
            DocuSignAPI.ArrayOfInlineTemplate aoit = new DocuSignAPI.ArrayOfInlineTemplate();
            DocuSignAPI.BrandRequestItem bri = new DocuSignAPI.BrandRequestItem();
            DocuSignAPI.RecipientEsignList resl = new DocuSignAPI.RecipientEsignList();
            DocuSignAPI.BrandResults br = new DocuSignAPI.BrandResults();
            DocuSignAPI.AuthoritativeCopyExportStatus aces = new DocuSignAPI.AuthoritativeCopyExportStatus();
            DocuSignAPI.DeleteEnvelopesResponse_element der = new DocuSignAPI.DeleteEnvelopesResponse_element();
            DocuSignAPI.SynchEnvelopeResponse_element ser = new DocuSignAPI.SynchEnvelopeResponse_element();            
            DocuSignAPI.ArrayOfFolderItem aofi = new DocuSignAPI.ArrayOfFolderItem();
            DocuSignAPI.EnvelopeStatus envStatus = new DocuSignAPI.EnvelopeStatus();
            DocuSignAPI.CreateEnvelopeResponse_element cer = new DocuSignAPI.CreateEnvelopeResponse_element();
            DocuSignAPI.EventResult er = new DocuSignAPI.EventResult();
            DocuSignAPI.RecipientCorrectionStatus rcs = new DocuSignAPI.RecipientCorrectionStatus();
            DocuSignAPI.SSN4Information ssn4 = new DocuSignAPI.SSN4Information();
            DocuSignAPI.Expirations expire = new DocuSignAPI.Expirations();
            DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element rrfpdf = new DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element();
            DocuSignAPI.DocuSignEnvelopeInformation dsei = new DocuSignAPI.DocuSignEnvelopeInformation();
            DocuSignAPI.RequestStatusesResponse_element rsr = new DocuSignAPI.RequestStatusesResponse_element();
            DocuSignAPI.RecipientCorrectionCorrectedCaptiveInfo rccci = new DocuSignAPI.RecipientCorrectionCorrectedCaptiveInfo();
            DocuSignAPI.FolderItem folderItem = new DocuSignAPI.FolderItem();
            DocuSignAPI.CreateAccountBrandsResponse_element cabr = new DocuSignAPI.CreateAccountBrandsResponse_element();
            DocuSignAPI.ArrayOfConnectFailure aocf = new DocuSignAPI.ArrayOfConnectFailure();
            DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element gsidscfr = new DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element();
            DocuSignAPI.ArrayOfMatchBox aomb = new DocuSignAPI.ArrayOfMatchBox();
            DocuSignAPI.TransferEnvelopeStatus tes = new DocuSignAPI.TransferEnvelopeStatus();
            DocuSignAPI.ArrayOfDocumentStatus aods = new DocuSignAPI.ArrayOfDocumentStatus();
            DocuSignAPI.ArrayOfEnvelopeStatusCode aoesc = new DocuSignAPI.ArrayOfEnvelopeStatusCode();
            DocuSignAPI.RecipientList rl = new DocuSignAPI.RecipientList();
            DocuSignAPI.IDCheckInformation idci = new DocuSignAPI.IDCheckInformation();
            DocuSignAPI.ServerTemplate serverTemp = new DocuSignAPI.ServerTemplate();
            DocuSignAPI.IDCheckInformationInput idscii = new DocuSignAPI.IDCheckInformationInput();
            DocuSignAPI.PDFOptions pdfopt = new DocuSignAPI.PDFOptions();
            DocuSignAPI.RequestTemplateListResponse_element rtlr = new DocuSignAPI.RequestTemplateListResponse_element();
            DocuSignAPI.ArrayOfRecipient aor = new DocuSignAPI.ArrayOfRecipient();
            DocuSignAPI.AddressBookPhoneNumber abpn = new DocuSignAPI.AddressBookPhoneNumber();
            DocuSignAPI.MoveEnvelopesArg mea = new DocuSignAPI.MoveEnvelopesArg();
            DocuSignAPI.ArrayOfFolder aof = new DocuSignAPI.ArrayOfFolder();
            DocuSignAPI.EnvelopeAuditEventsResponse_element eaer = new DocuSignAPI.EnvelopeAuditEventsResponse_element();            
            DocuSignAPI.MatchBox mb = new DocuSignAPI.MatchBox();
            DocuSignAPI.UserInfo ui = new DocuSignAPI.UserInfo();
            DocuSignAPI.VoidEnvelopeStatus ves = new DocuSignAPI.VoidEnvelopeStatus();
            DocuSignAPI.RecipientSignatureInfo rsi = new DocuSignAPI.RecipientSignatureInfo();
            DocuSignAPI.ArrayOfTemplateReferenceFieldDataDataValue aotrfdav = new DocuSignAPI.ArrayOfTemplateReferenceFieldDataDataValue();
            DocuSignAPI.SSN9Information sssn9 = new DocuSignAPI.SSN9Information();
            DocuSignAPI.AvailableFolders af = new DocuSignAPI.AvailableFolders();
            DocuSignAPI.FormDataXfdfField fdxf = new DocuSignAPI.FormDataXfdfField();
            DocuSignAPI.TemplateReference tr = new DocuSignAPI.TemplateReference();
            DocuSignAPI.GetRecipientListResponse_element grlr = new DocuSignAPI.GetRecipientListResponse_element();
            DocuSignAPI.ArrayOfAttachment aoa = new DocuSignAPI.ArrayOfAttachment();
            DocuSignAPI.RequestEnvelopeWithDocumentFieldsResponse_element rewdfr = new DocuSignAPI.RequestEnvelopeWithDocumentFieldsResponse_element();
            DocuSignAPI.ArrayOfDocumentPDF aodpdf = new DocuSignAPI.ArrayOfDocumentPDF();
            DocuSignAPI.MoveEnvelopesResponse_element mer = new DocuSignAPI.MoveEnvelopesResponse_element();
            DocuSignAPI.BrandDefinitions d = new DocuSignAPI.BrandDefinitions();
            DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element ceftafr = new DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element();
            DocuSignAPI.EnvelopeAuditEventsResult_element envaer = new DocuSignAPI.EnvelopeAuditEventsResult_element();
            DocuSignAPI.InlineTemplate intem = new DocuSignAPI.InlineTemplate();
            DocuSignAPI.ArrayOfSAMLAttribute aosamla = new DocuSignAPI.ArrayOfSAMLAttribute();
            DocuSignAPI.UploadTemplateResponse_element utr = new DocuSignAPI.UploadTemplateResponse_element();
            DocuSignAPI.PublishConnectFailuresResult pcfr = new DocuSignAPI.PublishConnectFailuresResult();
            DocuSignAPI.DeleteAccountBrandsResponse_element dabr = new DocuSignAPI.DeleteAccountBrandsResponse_element();
            DocuSignAPI.EnvelopeStatusChangeFilter escf = new DocuSignAPI.EnvelopeStatusChangeFilter();
            DocuSignAPI.FilteredEnvelopeStatusChanges fesc = new DocuSignAPI.FilteredEnvelopeStatusChanges();
            DocuSignAPI.CustomField customfield = new DocuSignAPI.CustomField();
            DocuSignAPI.SaveTemplateResponse_element str = new DocuSignAPI.SaveTemplateResponse_element();
            DocuSignAPI.ArrayOfTemplateReferenceRoleAssignment aotrra = new DocuSignAPI.ArrayOfTemplateReferenceRoleAssignment();
            DocuSignAPI.ArrayOfBrandRequestItem aobri = new DocuSignAPI.ArrayOfBrandRequestItem();
            DocuSignAPI.ArrayOfTabStatus aots = new DocuSignAPI.ArrayOfTabStatus();
            DocuSignAPI.GetAddressBookItemsResponse_element gabir = new DocuSignAPI.GetAddressBookItemsResponse_element();
            DocuSignAPI.AccountSetting accset = new DocuSignAPI.AccountSetting();
            DocuSignAPI.AddressInformationInput aii = new DocuSignAPI.AddressInformationInput();
            DocuSignAPI.TemplateReferenceRoleAssignment trra = new DocuSignAPI.TemplateReferenceRoleAssignment();
            DocuSignAPI.AccountMembershipFeaturesList amfl = new DocuSignAPI.AccountMembershipFeaturesList();
            DocuSignAPI.ArrayOfEnvelopeEvent aoee = new DocuSignAPI.ArrayOfEnvelopeEvent();
            DocuSignAPI.AccountSettingsList asl = new DocuSignAPI.AccountSettingsList();
            DocuSignAPI.PublishConnectFailuresFilter pcff = new DocuSignAPI.PublishConnectFailuresFilter();
            
            DocuSignAPI.TransferEnvelopeResponse_element ter = new DocuSignAPI.TransferEnvelopeResponse_element();
            DocuSignAPI.SendEnvelopeResponse_element seres = new DocuSignAPI.SendEnvelopeResponse_element();
            DocuSignAPI.SSN4InformationInput ssn4ii = new DocuSignAPI.SSN4InformationInput();
            DocuSignAPI.RequestTemplateResponse_element rtr = new DocuSignAPI.RequestTemplateResponse_element();
            DocuSignAPI.RequestStatus_element rs = new DocuSignAPI.RequestStatus_element();
            DocuSignAPI.ArrayOfServerTemplate aost = new DocuSignAPI.ArrayOfServerTemplate();
            DocuSignAPI.UploadTemplate_element ute = new DocuSignAPI.UploadTemplate_element();
            DocuSignAPI.ConnectFailuresFilter cffele = new DocuSignAPI.ConnectFailuresFilter();
            DocuSignAPI.RequestDocumentPDFsResponse_element rdpdfrel = new DocuSignAPI.RequestDocumentPDFsResponse_element();
            DocuSignAPI.EnvelopePDF epdf = new DocuSignAPI.EnvelopePDF();
            DocuSignAPI.RequestPDFNoWaterMarkResponse_element rpdfnwmr = new DocuSignAPI.RequestPDFNoWaterMarkResponse_element();
            DocuSignAPI.FormData formData = new DocuSignAPI.FormData();
            DocuSignAPI.RequestPDF_element ppdf = new DocuSignAPI.RequestPDF_element();
            DocuSignAPI.ArrayOfAddressBookItem1 aoasi = new DocuSignAPI.ArrayOfAddressBookItem1();
            DocuSignAPI.TabStatus tab = new DocuSignAPI.TabStatus();//1349-52
            
            DocuSignAPI.FilteredEnvelopeStatuses fess = new DocuSignAPI.FilteredEnvelopeStatuses();
            DocuSignAPI.FoldersFilter ff = new DocuSignAPI.FoldersFilter();
            DocuSignAPI.EnvelopeEvent ee = new DocuSignAPI.EnvelopeEvent();
            DocuSignAPI.SaveTemplateResult stempr = new DocuSignAPI.SaveTemplateResult();
            DocuSignAPI.PDFMetaDataTemplate pdfmdt = new DocuSignAPI.PDFMetaDataTemplate();
            DocuSignAPI.RequestPDFResponse_element rpr = new DocuSignAPI.RequestPDFResponse_element();
            DocuSignAPI.FolderFilter ffileter = new DocuSignAPI.FolderFilter();
            DocuSignAPI.RequestTemplateListWithDocumentFieldsResponse_element rtlwdfr = new DocuSignAPI.RequestTemplateListWithDocumentFieldsResponse_element();
            DocuSignAPI.RecipientEvent re = new DocuSignAPI.RecipientEvent();
            DocuSignAPI.CreateAndSendEnvelopeResponse_element caser = new DocuSignAPI.CreateAndSendEnvelopeResponse_element();
            DocuSignAPI.RequestTemplateWithDocumentFieldsResponse_element rtwdfr = new DocuSignAPI.RequestTemplateWithDocumentFieldsResponse_element();
            DocuSignAPI.ArrayOfPositiveInteger aopi = new DocuSignAPI.ArrayOfPositiveInteger();
            DocuSignAPI.RequestStatusCodesResponse_element rscr = new DocuSignAPI.RequestStatusCodesResponse_element();
            DocuSignAPI.ArrayOfTemplateReference aotre = new DocuSignAPI.ArrayOfTemplateReference();
            DocuSignAPI.Attachment attach = new DocuSignAPI.Attachment();
            DocuSignAPI.UpdateAddressBookResult uabr = new DocuSignAPI.UpdateAddressBookResult();
            DocuSignAPI.SSN9InformationInput ssn9ii = new DocuSignAPI.SSN9InformationInput();
            DocuSignAPI.RequestEnvelopeResponse_element rer = new DocuSignAPI.RequestEnvelopeResponse_element();
            DocuSignAPI.TemplateReferenceFieldDataDataValue trfddv = new DocuSignAPI.TemplateReferenceFieldDataDataValue();
            DocuSignAPI.AddressBookRemoveItem abri = new DocuSignAPI.AddressBookRemoveItem();
            DocuSignAPI.RecipientPhoneAuthentication rpa = new DocuSignAPI.RecipientPhoneAuthentication();
            DocuSignAPI.ArrayOfRecipientEvent aore = new DocuSignAPI.ArrayOfRecipientEvent();
            DocuSignAPI.AddressBookItem reqenv = new DocuSignAPI.AddressBookItem();
            DocuSignAPI.RecipientStatusEsignAgreementInformation rseai = new DocuSignAPI.RecipientStatusEsignAgreementInformation();
            DocuSignAPI.GetConnectFailuresResponse_element gcfr = new DocuSignAPI.GetConnectFailuresResponse_element();
            DocuSignAPI.SAMLAttribute samla = new DocuSignAPI.SAMLAttribute();
            DocuSignAPI.CompositeTemplate ct = new DocuSignAPI.CompositeTemplate();
            DocuSignAPI.FolderResults fr = new DocuSignAPI.FolderResults();
            DocuSignAPI.PurgeDocumentsResponse_element pdr = new DocuSignAPI.PurgeDocumentsResponse_element();
            DocuSignAPI.EnvelopeSettings es = new DocuSignAPI.EnvelopeSettings();
            DocuSignAPI.DOBInformationInput dii = new DocuSignAPI.DOBInformationInput();
            DocuSignAPI.DocumentPDF dp = new DocuSignAPI.DocumentPDF();
            DocuSignAPI.RequestDocumentPDFsExResponse_element rdper = new DocuSignAPI.RequestDocumentPDFsExResponse_element();
            DocuSignAPI.ArrayOfEnvelopeTemplate aoet = new DocuSignAPI.ArrayOfEnvelopeTemplate();
            DocuSignAPI.DocumentPDFs dps = new DocuSignAPI.DocumentPDFs();
            DocuSignAPI.ArrayOfDocumentField aodf = new DocuSignAPI.ArrayOfDocumentField();
            DocuSignAPI.DocumentField df = new DocuSignAPI.DocumentField();
            DocuSignAPI.TemplateReferenceFieldData trfd = new DocuSignAPI.TemplateReferenceFieldData();
            DocuSignAPI.FormDataXfdf fdx = new DocuSignAPI.FormDataXfdf();
            DocuSignAPI.Notification noti = new DocuSignAPI.Notification();
            DocuSignAPI.RequestCorrectTokenResponse_element rctr = new DocuSignAPI.RequestCorrectTokenResponse_element();
            DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element aacer = new DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element();
            DocuSignAPI.VoidEnvelopeResponse_element ver = new DocuSignAPI.VoidEnvelopeResponse_element();
            DocuSignAPI.RequestRecipientTokenAuthenticationAssertion rrtaa = new DocuSignAPI.RequestRecipientTokenAuthenticationAssertion();
            DocuSignAPI.RequestPDFsWithOptionsResponse_element rpwor = new DocuSignAPI.RequestPDFsWithOptionsResponse_element();
            DocuSignAPI.CorrectAndResendEnvelopeResponse_element carer = new DocuSignAPI.CorrectAndResendEnvelopeResponse_element();
            DocuSignAPI.PDFsOptions po = new DocuSignAPI.PDFsOptions();
            DocuSignAPI.GetAccountBrandsResponse_element gabr = new DocuSignAPI.GetAccountBrandsResponse_element();
            DocuSignAPI.GetAccountSettingsListResponse_element galsr = new DocuSignAPI.GetAccountSettingsListResponse_element();
            DocuSignAPI.RecipientCaptiveInfo rci = new DocuSignAPI.RecipientCaptiveInfo();
            DocuSignAPI.ArrayOfAddressBookRemoveItem aoabri = new DocuSignAPI.ArrayOfAddressBookRemoveItem();
            DocuSignAPI.ArrayOfBrandResultItem aobritem = new DocuSignAPI.ArrayOfBrandResultItem();
            DocuSignAPI.RequestPDFWithCertResponse_element rpwcr = new DocuSignAPI.RequestPDFWithCertResponse_element();
            DocuSignAPI.DOBInformation dobi = new DocuSignAPI.DOBInformation();
            DocuSignAPI.GetStatusInDocuSignConnectFormat_element gsidscf = new DocuSignAPI.GetStatusInDocuSignConnectFormat_element();
            DocuSignAPI.RequestStatusesWithDocumentFieldsResponse_element rswdfr = new DocuSignAPI.RequestStatusesWithDocumentFieldsResponse_element();
            DocuSignAPI.RecipientSAMLAuthentication rsa = new DocuSignAPI.RecipientSAMLAuthentication();
            DocuSignAPI.RequestRecipientTokenClientURLs rrtcu = new DocuSignAPI.RequestRecipientTokenClientURLs();
            DocuSignAPI.SynchEnvelopeStatus ses = new DocuSignAPI.SynchEnvelopeStatus();
            DocuSignAPI.GetRecipientEsignListResponse_element grelr = new DocuSignAPI.GetRecipientEsignListResponse_element();
            DocuSignAPI.RecipientStatus recsts = new DocuSignAPI.RecipientStatus();
            DocuSignAPI.RequestStatusWithDocumentFieldsResponse_element rswithdfr = new DocuSignAPI.RequestStatusWithDocumentFieldsResponse_element();
            DocuSignAPI.RequestSenderTokenResponse_element rstr = new DocuSignAPI.RequestSenderTokenResponse_element();
            DocuSignAPI.RequestRecipientFaxTokenResponse_element ttftr = new DocuSignAPI.RequestRecipientFaxTokenResponse_element();
            DocuSignAPI.RecipientCorrection recc = new DocuSignAPI.RecipientCorrection();
            DocuSignAPI.RequestPDFWithOptionsResponse_element rpdfwor = new DocuSignAPI.RequestPDFWithOptionsResponse_element();
            DocuSignAPI.RecipientEsign recer = new DocuSignAPI.RecipientEsign();
            DocuSignAPI.RequestStatusesExResponse_element reser = new DocuSignAPI.RequestStatusesExResponse_element();
            DocuSignAPI.ArrayOfEnvelopeStatusChange aoesch = new DocuSignAPI.ArrayOfEnvelopeStatusChange();
            DocuSignAPI.Envelope env = new DocuSignAPI.Envelope();
            DocuSignAPI.EnvelopeTemplates et = new DocuSignAPI.EnvelopeTemplates();
            DocuSignAPI.EnvelopeStatusFilterBeginDateTime esfbdt = new DocuSignAPI.EnvelopeStatusFilterBeginDateTime();
            DocuSignAPI.PingResponse_element pr = new DocuSignAPI.PingResponse_element();
            DocuSignAPI.ArrayOfTab aotv = new DocuSignAPI.ArrayOfTab();
            DocuSignAPI.VaultingOptions vo = new DocuSignAPI.VaultingOptions();
            DocuSignAPI.RemoveAddressBookItemsResponse_element drabires = new DocuSignAPI.RemoveAddressBookItemsResponse_element();
            DocuSignAPI.AddressInformation addinfo = new DocuSignAPI.AddressInformation();
            DocuSignAPI.AnchorTab aat = new DocuSignAPI.AnchorTab();
            DocuSignAPI.VaultingDetails cd = new DocuSignAPI.VaultingDetails();
            DocuSignAPI.GetAuthenticationTokenResponse_element gatr = new DocuSignAPI.GetAuthenticationTokenResponse_element();
            DocuSignAPI.RequestRecipientTokenResponse_element rrtr = new DocuSignAPI.RequestRecipientTokenResponse_element();
            DocuSignAPI.ArrayOfAddressBookItem aoabi = new DocuSignAPI.ArrayOfAddressBookItem();
            DocuSignAPI.EnvelopeInformation ei = new DocuSignAPI.EnvelopeInformation();
            DocuSignAPI.ArrayOfCustomField aofcf = new DocuSignAPI.ArrayOfCustomField();
            DocuSignAPI.ArrayOfEnvelopeStatus aoers = new DocuSignAPI.ArrayOfEnvelopeStatus();
            DocuSignAPI.ConnectFailure cf = new DocuSignAPI.ConnectFailure();
            DocuSignAPI.RequestCertificateResponse_element rcr = new DocuSignAPI.RequestCertificateResponse_element();
            DocuSignAPI.RecipientEmailNotification ren = new DocuSignAPI.RecipientEmailNotification();
            DocuSignAPI.DeleteEnvelopesArg dea = new DocuSignAPI.DeleteEnvelopesArg();
            DocuSignAPI.ErrorDetails ed = new DocuSignAPI.ErrorDetails();
            DocuSignAPI.BrandResultItem bresulti = new DocuSignAPI.BrandResultItem();
            DocuSignAPI.EnvelopeTemplate etemp = new DocuSignAPI.EnvelopeTemplate();
            DocuSignAPI.DocumentStatus ds = new DocuSignAPI.DocumentStatus();
            DocuSignAPI.RequestRecipientFaxPDFResponse_element rrfpdfr = new DocuSignAPI.RequestRecipientFaxPDFResponse_element();
            DocuSignAPI.Tab rectab = new DocuSignAPI.Tab();
            DocuSignAPI.PublishConnectFailuresResponse_element pcfailr = new DocuSignAPI.PublishConnectFailuresResponse_element();
            DocuSignAPI.ArrayOfRecipient1 aor1 = new DocuSignAPI.ArrayOfRecipient1();
            DocuSignAPI.Recipient docRec = new DocuSignAPI.Recipient();
            DocuSignAPI.ArrayOfFormDataXfdfField aofdxf = new DocuSignAPI.ArrayOfFormDataXfdfField();
            DocuSignAPI.RequestTemplatesResponse_element rtre = new DocuSignAPI.RequestTemplatesResponse_element();
            DocuSignAPI.ArrayOfRecipientEsign arrayore = new DocuSignAPI.ArrayOfRecipientEsign();
            DocuSignAPI.UpdateAddressBookItemsResponse_element uabookir = new DocuSignAPI.UpdateAddressBookItemsResponse_element();
            DocuSignAPI.ArrayOfString aos = new DocuSignAPI.ArrayOfString();
            DocuSignAPI.EnvelopeStatusFilter esf = new DocuSignAPI.EnvelopeStatusFilter();
            DocuSignAPI.CorrectionStatus csf = new DocuSignAPI.CorrectionStatus();
            DocuSignAPI.ArrayOfDocument aod = new DocuSignAPI.ArrayOfDocument();
            DocuSignAPI.PurgeDocumentStatus pds = new DocuSignAPI.PurgeDocumentStatus();
            DocuSignAPI.EnvelopeTemplateDefinition etd = new DocuSignAPI.EnvelopeTemplateDefinition();
            DocuSignAPI.RequestStatusExResponse_element rser = new DocuSignAPI.RequestStatusExResponse_element();
            DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element ceftr = new DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element();
            DocuSignAPI.BrandDeleteRequest bdr = new DocuSignAPI.BrandDeleteRequest();
            DocuSignAPI.ArrayOfString3 aos3 = new DocuSignAPI.ArrayOfString3();
            DocuSignAPI.ArrayOfString4 aos4 = new DocuSignAPI.ArrayOfString4();
            DocuSignAPI.ArrayOfString1 aos1 = new DocuSignAPI.ArrayOfString1();
            DocuSignAPI.ArrayOfString2 aos2 = new DocuSignAPI.ArrayOfString2();
            DocuSignAPI.ArrayOfString5 aos5 = new DocuSignAPI.ArrayOfString5();
            DocuSignAPI.AuthenticationStatus auths = new DocuSignAPI.AuthenticationStatus();
            DocuSignAPI.ArrayOfCompositeTemplate aoct = new DocuSignAPI.ArrayOfCompositeTemplate();
            DocuSignAPI.GetAccountBrands_element gabe = new DocuSignAPI.GetAccountBrands_element();
            DocuSignAPI.Correction c = new DocuSignAPI.Correction();
            DocuSignAPI.RequestStatusChangesResponse_element rstscr = new DocuSignAPI.RequestStatusChangesResponse_element();
            DocuSignAPI.Document doc = new DocuSignAPI.Document();
            DocuSignAPI.EventNotification en = new DocuSignAPI.EventNotification();
            DocuSignAPI.Folder fol = new DocuSignAPI.Folder();
            DocuSignAPI.RequestStatusResponse_element rstsr = new DocuSignAPI.RequestStatusResponse_element();
            DocuSignAPI.EnvelopeStatusChange eschange = new DocuSignAPI.EnvelopeStatusChange();
            DocuSignAPI.FolderTypeInfo fti = new DocuSignAPI.FolderTypeInfo();
            DocuSignAPI.ArrayOfPublishConnectFailuresResult aopcfre = new DocuSignAPI.ArrayOfPublishConnectFailuresResult();
            DocuSignAPI.GetAccountMembershipFeaturesListResponse_element gamflr = new DocuSignAPI.GetAccountMembershipFeaturesListResponse_element();
            DocuSignAPI.ArrayOfRecipientStatus aorsts = new DocuSignAPI.ArrayOfRecipientStatus();
            DocuSignAPI.GetFolderItemsResponse_element gfires = new DocuSignAPI.GetFolderItemsResponse_element();
            DocuSignAPI.RecipientSMSAuthentication rsmsaao = new DocuSignAPI.RecipientSMSAuthentication();
            DocuSignAPI.ArrayOfRecipientCorrection aoorc = new DocuSignAPI.ArrayOfRecipientCorrection();
            
            //class
            DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
            try{
            	dsApiSend.GetAccountSettingsList(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusEx(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetAddressBookItems(null);
            }catch(Exception ex){}
            try{
                dsApiSend.PublishConnectFailures(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetStatusInDocuSignConnectFormat(null);
            }catch(Exception ex){}
            try{
                dsApiSend.PurgeDocuments(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestPDF(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestPDFWithCert(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.VoidEnvelope(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusesEx(null);
            }catch(Exception ex){}
            try{
                dsApiSend.TransferEnvelope(null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.ExportAuthoritativeCopy(null);
            }catch(Exception ex){}
            try{
                dsApiSend.CreateEnvelopeFromTemplatesAndForms(null, null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestTemplateList(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.GetRecipientEsignList(null, null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.CreateEnvelope(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestTemplateListWithDocumentFields(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestTemplates(null, false);
            }catch(Exception ex){}
            
            try{
                dsApiSend.SynchEnvelope(null, null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestTemplateWithDocumentFields(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatus(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestSenderToken(null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.AcknowledgeAuthoritativeCopyExport(null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetConnectFailures(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RemoveAddressBookItems(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatuses(null);
            }catch(Exception ex){}
            try{
                dsApiSend.Ping();
            }catch(Exception ex){}
            try{
                dsApiSend.DeleteAccountBrands(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestDocumentPDFs(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusWithDocumentFields(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestEnvelopeWithDocumentFields(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.CreateAccountBrands(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetRecipientList(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusChanges(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestRecipientFaxPDF(null,null, null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusesWithDocumentFields(null);
            }catch(Exception ex){}
            try{
                dsApiSend.DeleteEnvelopes(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetAuthenticationToken(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestPDFNoWaterMark(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestRecipientToken(null,null, null, null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.UpdateAddressBookItems(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.EnvelopeAuditEvents(null);
            }catch(Exception ex){}
            try{
                dsApiSend.SaveTemplate(null);
            }catch(Exception ex){}
            try{
                dsApiSend.CreateAndSendEnvelope(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestDocumentPDFsEx(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestPDFWithOptions(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.UploadTemplate(null, null, false);
            }catch(Exception ex){}
            
            try{
                dsApiSend.MoveEnvelopes(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestPDFsWithOptions(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestCertificate(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestCorrectToken(null, false, null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestEnvelope(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestStatusCodes(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetAccountMembershipFeaturesList(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetFolderList(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestRecipientFaxToken(null, null, null, null, null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.CreateEnvelopeFromTemplates(null, null, null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.CorrectAndResendEnvelope(null);
            }catch(Exception ex){}
            try{
                dsApiSend.SendEnvelope(null, null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetFolderItems(null);
            }catch(Exception ex){}
            try{
                dsApiSend.GetAccountBrands(null);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestTemplate(null, false);
            }catch(Exception ex){}
            try{
                dsApiSend.RequestDocumentPDFsRecipientsView(null, null, null);
            }catch(Exception ex){}
            Test.stopTest();
        }
    }
}