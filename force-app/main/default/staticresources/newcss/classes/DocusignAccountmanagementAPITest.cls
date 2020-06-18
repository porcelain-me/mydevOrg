@isTest(SeeAllData = false)
private class DocusignAccountmanagementAPITest {
	private static User sysUser;
    private static testmethod void testDocusignAccMgmt(){
    	sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
	    	Test.startTest();
	    	
	    	DocusignAccountmanagementAPI.ArrayOfMember aom = new DocusignAccountmanagementAPI.ArrayOfMember();
	    	DocusignAccountmanagementAPI.UpdateAccountSettingsResult_element upsr = new DocusignAccountmanagementAPI.UpdateAccountSettingsResult_element();
	    	DocusignAccountmanagementAPI.CheckAccountMemberResult_element camr = new DocusignAccountmanagementAPI.CheckAccountMemberResult_element();
	    	DocusignAccountmanagementAPI.GetUserProfileResult_element gupr = new DocusignAccountmanagementAPI.GetUserProfileResult_element();
	    	DocusignAccountmanagementAPI.UpdateMemberSettings_element ums = new DocusignAccountmanagementAPI.UpdateMemberSettings_element();
	    	DocusignAccountmanagementAPI.ArrayOfSeatDiscount asd = new DocusignAccountmanagementAPI.ArrayOfSeatDiscount();
	    	DocusignAccountmanagementAPI.GetMembershipSummaryResult_element gmsr = new DocusignAccountmanagementAPI.GetMembershipSummaryResult_element();
	    	DocusignAccountmanagementAPI.ArrayOfPlanGroupPlan apgp = new DocusignAccountmanagementAPI.ArrayOfPlanGroupPlan();
	    	DocusignAccountmanagementAPI.SetUserProfileResponse_element supr = new DocusignAccountmanagementAPI.SetUserProfileResponse_element();
	    	DocusignAccountmanagementAPI.GetUserProfileImage_element gupi = new DocusignAccountmanagementAPI.GetUserProfileImage_element();
	    	DocusignAccountmanagementAPI.VerifySeatEligibility_element vse = new DocusignAccountmanagementAPI.VerifySeatEligibility_element();
	    	DocusignAccountmanagementAPI.GetDistributorSeatAllotment_element gdsa = new DocusignAccountmanagementAPI.GetDistributorSeatAllotment_element();
	    	DocusignAccountmanagementAPI.NewAccountResponse_element nar = new DocusignAccountmanagementAPI.NewAccountResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanTypeResponse_element gptr = new DocusignAccountmanagementAPI.GetPlanTypeResponse_element();
	    	DocusignAccountmanagementAPI.GetSignaturesArg gsa = new DocusignAccountmanagementAPI.GetSignaturesArg();
	    	DocusignAccountmanagementAPI.AuthenticationMethod am = new DocusignAccountmanagementAPI.AuthenticationMethod();
	    	DocusignAccountmanagementAPI.CloseMembersResult_element cmr = new DocusignAccountmanagementAPI.CloseMembersResult_element();
	    	DocusignAccountmanagementAPI.GetMemberSettingsResult_element gmsre = new DocusignAccountmanagementAPI.GetMemberSettingsResult_element();
	    	DocusignAccountmanagementAPI.IncrementAccountSeatsResponse_element iasr = new DocusignAccountmanagementAPI.IncrementAccountSeatsResponse_element();
	    	DocusignAccountmanagementAPI.GetAccountDistributorCode_element gadc = new DocusignAccountmanagementAPI.GetAccountDistributorCode_element();
	    	DocusignAccountmanagementAPI.ArrayOfSignature aos = new DocusignAccountmanagementAPI.ArrayOfSignature();
	    	DocusignAccountmanagementAPI.GetPlanType_element gpt = new DocusignAccountmanagementAPI.GetPlanType_element();
	    	DocusignAccountmanagementAPI.UpdateAccountSettingsResponse_element uasr = new DocusignAccountmanagementAPI.UpdateAccountSettingsResponse_element();
	    	DocusignAccountmanagementAPI.SetSignatureImagesArg ssia = new DocusignAccountmanagementAPI.SetSignatureImagesArg();
	    	DocusignAccountmanagementAPI.GetMemberSettingsResponse_element gmsres = new DocusignAccountmanagementAPI.GetMemberSettingsResponse_element();    	
	    	DocusignAccountmanagementAPI.GetAccountInformationResponse_element gaire = new DocusignAccountmanagementAPI.GetAccountInformationResponse_element();
	    	DocusignAccountmanagementAPI.GetEncryptedPassword_element gep = new DocusignAccountmanagementAPI.GetEncryptedPassword_element();
	    	DocusignAccountmanagementAPI.ArrayOfGroup aog = new DocusignAccountmanagementAPI.ArrayOfGroup();
	    	DocusignAccountmanagementAPI.VerifySeatEligibilityResponse_element vser = new DocusignAccountmanagementAPI.VerifySeatEligibilityResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanGroupInformationResponse_element gpgir = new DocusignAccountmanagementAPI.GetPlanGroupInformationResponse_element();
	    	DocusignAccountmanagementAPI.AddMembersToAccountResponse_element amtar = new DocusignAccountmanagementAPI.AddMembersToAccountResponse_element();
	    	DocusignAccountmanagementAPI.GetSignaturesResponse_element gsr = new DocusignAccountmanagementAPI.GetSignaturesResponse_element();
	    	DocusignAccountmanagementAPI.SetSignatureImages_element ssi = new DocusignAccountmanagementAPI.SetSignatureImages_element();    	
	    	DocusignAccountmanagementAPI.GetAccountSettingsResult_element gasr = new DocusignAccountmanagementAPI.GetAccountSettingsResult_element();
	    	DocusignAccountmanagementAPI.Plan plan = new DocusignAccountmanagementAPI.Plan();
	    	DocusignAccountmanagementAPI.Member member = new DocusignAccountmanagementAPI.Member();
	    	DocusignAccountmanagementAPI.GetAccountDistributorCodeResponse_element gadcr = new DocusignAccountmanagementAPI.GetAccountDistributorCodeResponse_element();
	    	DocusignAccountmanagementAPI.ResendAccountActivationResult_element raar = new DocusignAccountmanagementAPI.ResendAccountActivationResult_element();    	
	    	DocusignAccountmanagementAPI.MemberSettings ms = new DocusignAccountmanagementAPI.MemberSettings();
	    	DocusignAccountmanagementAPI.CloseSignatureResult_element csr = new DocusignAccountmanagementAPI.CloseSignatureResult_element();
	    	DocusignAccountmanagementAPI.UpdateMemberSettingsResult_element umsr = new DocusignAccountmanagementAPI.UpdateMemberSettingsResult_element();
	    	DocusignAccountmanagementAPI.CloseSignatureResponse_element csres = new DocusignAccountmanagementAPI.CloseSignatureResponse_element();
	    	DocusignAccountmanagementAPI.SetUserProfileImageResult_element supir = new DocusignAccountmanagementAPI.SetUserProfileImageResult_element();
	    	DocusignAccountmanagementAPI.ChangeAccountPricePlanResult_element cappr = new DocusignAccountmanagementAPI.ChangeAccountPricePlanResult_element();
	    	DocusignAccountmanagementAPI.VerifySeatEligibilityInfo vsei = new DocusignAccountmanagementAPI.VerifySeatEligibilityInfo();
	    	DocusignAccountmanagementAPI.GetMemberSettings_element gms = new DocusignAccountmanagementAPI.GetMemberSettings_element();
	    	DocusignAccountmanagementAPI.Group_x groupx = new DocusignAccountmanagementAPI.Group_x();
	    	DocusignAccountmanagementAPI.UpdateMemberSettingsResponse_element umsres = new DocusignAccountmanagementAPI.UpdateMemberSettingsResponse_element();
	    	DocusignAccountmanagementAPI.SetUserProfileResult_element supres = new DocusignAccountmanagementAPI.SetUserProfileResult_element();
	    	DocusignAccountmanagementAPI.NewAccountResult_element nares = new DocusignAccountmanagementAPI.NewAccountResult_element();
	    	DocusignAccountmanagementAPI.NewSocialAccountResult_element nsar = new DocusignAccountmanagementAPI.NewSocialAccountResult_element();    	
	    	DocusignAccountmanagementAPI.Image image = new DocusignAccountmanagementAPI.Image();
	    	DocusignAccountmanagementAPI.GetPlanGroupInformation_element gpgijkres = new DocusignAccountmanagementAPI.GetPlanGroupInformation_element();
	    	DocusignAccountmanagementAPI.ActivateSalesforceInstanceResult_element asir = new DocusignAccountmanagementAPI.ActivateSalesforceInstanceResult_element();
	    	DocusignAccountmanagementAPI.GetPlanPricingInformationResult_element gpgiresult = new DocusignAccountmanagementAPI.GetPlanPricingInformationResult_element();
	    	DocusignAccountmanagementAPI.UpgradeRecipientAccountResponse_element uparres = new DocusignAccountmanagementAPI.UpgradeRecipientAccountResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanPricingInformationResponse_element gppir = new DocusignAccountmanagementAPI.GetPlanPricingInformationResponse_element();
	    	DocusignAccountmanagementAPI.SetConnectCredentialsResponse_element sccr = new DocusignAccountmanagementAPI.SetConnectCredentialsResponse_element();
	    	DocusignAccountmanagementAPI.ActivateSalesforceInstanceResponse_element asiresele = new DocusignAccountmanagementAPI.ActivateSalesforceInstanceResponse_element();
	    	DocusignAccountmanagementAPI.UserProfileImage upi = new DocusignAccountmanagementAPI.UserProfileImage();    	
	    	DocusignAccountmanagementAPI.AddMembersToAccountResult_element amtarelem = new DocusignAccountmanagementAPI.AddMembersToAccountResult_element();
	    	DocusignAccountmanagementAPI.PingResponse_element pingRes = new DocusignAccountmanagementAPI.PingResponse_element();
	    	DocusignAccountmanagementAPI.IncrementAccountSeatsResult_element iasrelem = new DocusignAccountmanagementAPI.IncrementAccountSeatsResult_element();
	    	DocusignAccountmanagementAPI.GetConnectCredentialsResult_element gccr = new DocusignAccountmanagementAPI.GetConnectCredentialsResult_element();
	    	DocusignAccountmanagementAPI.SetUserProfile_element sup = new DocusignAccountmanagementAPI.SetUserProfile_element();
	    	DocusignAccountmanagementAPI.AddressInformation addin = new DocusignAccountmanagementAPI.AddressInformation();    	
	    	DocusignAccountmanagementAPI.GetPlanTypeResult_element gptrelem = new DocusignAccountmanagementAPI.GetPlanTypeResult_element();
	    	DocusignAccountmanagementAPI.UserProfile userProfile = new DocusignAccountmanagementAPI.UserProfile();
	    	DocusignAccountmanagementAPI.GetAccountSettingsResponse_element gasrelem = new DocusignAccountmanagementAPI.GetAccountSettingsResponse_element();
	    	DocusignAccountmanagementAPI.GetDistributorSeatAllotmentResponse_element gdsar = new DocusignAccountmanagementAPI.GetDistributorSeatAllotmentResponse_element();
	    	DocusignAccountmanagementAPI.SetSignatureImagesResult_element ssir = new DocusignAccountmanagementAPI.SetSignatureImagesResult_element();
	    	DocusignAccountmanagementAPI.GetUserProfileImageResponse_element gupir = new DocusignAccountmanagementAPI.GetUserProfileImageResponse_element();
	    	DocusignAccountmanagementAPI.GetAccountDistributorCodeResult_element gadcrelem = new DocusignAccountmanagementAPI.GetAccountDistributorCodeResult_element();
	    	DocusignAccountmanagementAPI.IncrementAccountSeatsInfo iasi = new DocusignAccountmanagementAPI.IncrementAccountSeatsInfo();
	    	DocusignAccountmanagementAPI.NewSocialAccount_element nsa = new DocusignAccountmanagementAPI.NewSocialAccount_element();
	    	DocusignAccountmanagementAPI.GetSignaturesResult_element gsrelem = new DocusignAccountmanagementAPI.GetSignaturesResult_element();
	    	DocusignAccountmanagementAPI.GetProvisioningInformationResponse_element gpirelem = new DocusignAccountmanagementAPI.GetProvisioningInformationResponse_element();
	    	DocusignAccountmanagementAPI.IncrementAccountSeats_element iaselem = new DocusignAccountmanagementAPI.IncrementAccountSeats_element();    	
	    	DocusignAccountmanagementAPI.SetUserProfileImage_element supielem = new DocusignAccountmanagementAPI.SetUserProfileImage_element();
	    	DocusignAccountmanagementAPI.GetProvisioningInformationResult_element gpijkelem = new DocusignAccountmanagementAPI.GetProvisioningInformationResult_element();
	    	DocusignAccountmanagementAPI.ChangePasswordArg cparg = new DocusignAccountmanagementAPI.ChangePasswordArg();
	    	DocusignAccountmanagementAPI.GetPlanDetailsInfo getPlan = new DocusignAccountmanagementAPI.GetPlanDetailsInfo();
	    	DocusignAccountmanagementAPI.ArrayOfMemberResult aomr = new DocusignAccountmanagementAPI.ArrayOfMemberResult();
	    	DocusignAccountmanagementAPI.SetConnectCredentialsResult_element sccrelem = new DocusignAccountmanagementAPI.SetConnectCredentialsResult_element();
	    	DocusignAccountmanagementAPI.ResendAccountActivation_element raa = new DocusignAccountmanagementAPI.ResendAccountActivation_element();
	    	DocusignAccountmanagementAPI.GetUserProfile_element getUserProfile = new DocusignAccountmanagementAPI.GetUserProfile_element();
	    	DocusignAccountmanagementAPI.SeatDiscount sealDisc = new DocusignAccountmanagementAPI.SeatDiscount();
	    	DocusignAccountmanagementAPI.ArrayOfAuthenticationMethod aoam = new DocusignAccountmanagementAPI.ArrayOfAuthenticationMethod();
	    	DocusignAccountmanagementAPI.ArrayOfString aosjk = new DocusignAccountmanagementAPI.ArrayOfString();
	    	DocusignAccountmanagementAPI.GetSuccessorPlanInformationResult_element gspir = new DocusignAccountmanagementAPI.GetSuccessorPlanInformationResult_element();
	    	DocusignAccountmanagementAPI.AddEnvelopeCurrencyResult_element aecr = new DocusignAccountmanagementAPI.AddEnvelopeCurrencyResult_element();
	    	DocusignAccountmanagementAPI.InitializeClientAccount_element ica = new DocusignAccountmanagementAPI.InitializeClientAccount_element();    	
	    	DocusignAccountmanagementAPI.GetConnectCredentialsResponse_element gccrelem = new DocusignAccountmanagementAPI.GetConnectCredentialsResponse_element();
	    	DocusignAccountmanagementAPI.SetSignatureImagesResponse_element ssirjkelem = new DocusignAccountmanagementAPI.SetSignatureImagesResponse_element();
	    	DocusignAccountmanagementAPI.AuthenticateMemberExResponse_element amerjkElem = new DocusignAccountmanagementAPI.AuthenticateMemberExResponse_element();
	    	DocusignAccountmanagementAPI.GetMembershipSummaryResponse_element gmsrjkelm = new DocusignAccountmanagementAPI.GetMembershipSummaryResponse_element();
	    	DocusignAccountmanagementAPI.AuthenticateMemberExResult_element amer = new DocusignAccountmanagementAPI.AuthenticateMemberExResult_element();    	
	    	DocusignAccountmanagementAPI.VerifySeatEligibilityResult_element vserjkelem = new DocusignAccountmanagementAPI.VerifySeatEligibilityResult_element();
	    	DocusignAccountmanagementAPI.ArrayOfMembershipSummary amosjk = new DocusignAccountmanagementAPI.ArrayOfMembershipSummary();
	    	DocusignAccountmanagementAPI.ResendAccountActivationResponse_element raarjkelem = new DocusignAccountmanagementAPI.ResendAccountActivationResponse_element();
	    	DocusignAccountmanagementAPI.ChangePasswordResult_element cprelm = new DocusignAccountmanagementAPI.ChangePasswordResult_element();
	    	DocusignAccountmanagementAPI.UpgradeRecipientAccountResult_element urar = new DocusignAccountmanagementAPI.UpgradeRecipientAccountResult_element();
	    	DocusignAccountmanagementAPI.GetPlanDetailsResponse_element gpdr = new DocusignAccountmanagementAPI.GetPlanDetailsResponse_element();
	    	DocusignAccountmanagementAPI.GetSuccessorPlanInformationResponse_element gspirspir = new DocusignAccountmanagementAPI.GetSuccessorPlanInformationResponse_element();
	    	DocusignAccountmanagementAPI.PlanGroupPlan planGroupPlan = new DocusignAccountmanagementAPI.PlanGroupPlan();
	    	DocusignAccountmanagementAPI.CloseMembersResponse_element cmrElem = new DocusignAccountmanagementAPI.CloseMembersResponse_element();
	    	DocusignAccountmanagementAPI.AccountSettings accountSettings = new DocusignAccountmanagementAPI.AccountSettings();
	    	DocusignAccountmanagementAPI.MemberResult memResult = new DocusignAccountmanagementAPI.MemberResult();    	
	    	DocusignAccountmanagementAPI.GetEncryptedPasswordResponse_element geprelme = new DocusignAccountmanagementAPI.GetEncryptedPasswordResponse_element();
	    	DocusignAccountmanagementAPI.GetConnectCredentials_element gccelem = new DocusignAccountmanagementAPI.GetConnectCredentials_element();
	    	DocusignAccountmanagementAPI.CloseSignature_element cselem = new DocusignAccountmanagementAPI.CloseSignature_element();
	    	DocusignAccountmanagementAPI.CheckAccountMember_element camelem = new DocusignAccountmanagementAPI.CheckAccountMember_element();
	    	DocusignAccountmanagementAPI.GetDistributorSeatAllotmentResult_element gdsarelem = new DocusignAccountmanagementAPI.GetDistributorSeatAllotmentResult_element();
	    	DocusignAccountmanagementAPI.ReferralInformation refInfo = new DocusignAccountmanagementAPI.ReferralInformation();
	    	DocusignAccountmanagementAPI.ActivateSalesforceInstance_element acsieme = new DocusignAccountmanagementAPI.ActivateSalesforceInstance_element();
	    	DocusignAccountmanagementAPI.ChangeAccountPricePlanResponse_element capprelem = new DocusignAccountmanagementAPI.ChangeAccountPricePlanResponse_element();
	    	DocusignAccountmanagementAPI.CheckAccountMemberResponse_element camrelem = new DocusignAccountmanagementAPI.CheckAccountMemberResponse_element();
	    	DocusignAccountmanagementAPI.Ping_element pingelem = new DocusignAccountmanagementAPI.Ping_element();
	    	DocusignAccountmanagementAPI.AuthenticateMemberEx_element ameelem = new DocusignAccountmanagementAPI.AuthenticateMemberEx_element();
	    	DocusignAccountmanagementAPI.Signature sign = new DocusignAccountmanagementAPI.Signature();
	    	DocusignAccountmanagementAPI.AuthenticateMemberResult_element amrelem = new DocusignAccountmanagementAPI.AuthenticateMemberResult_element();
	    	DocusignAccountmanagementAPI.ChangeAccountPricePlan_element cappelem = new DocusignAccountmanagementAPI.ChangeAccountPricePlan_element();    	
	    	DocusignAccountmanagementAPI.RequestError reqError = new DocusignAccountmanagementAPI.RequestError();
	    	DocusignAccountmanagementAPI.CreditCardInformation ccInfo = new DocusignAccountmanagementAPI.CreditCardInformation();
	    	DocusignAccountmanagementAPI.NewSocialAccountResponse_element nsarelem = new DocusignAccountmanagementAPI.NewSocialAccountResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanPricingInformation_element gppifoElem = new DocusignAccountmanagementAPI.GetPlanPricingInformation_element();
	    	DocusignAccountmanagementAPI.SetUserProfileImageResponse_element supirelem = new DocusignAccountmanagementAPI.SetUserProfileImageResponse_element();
	    	DocusignAccountmanagementAPI.MembershipSummary mssumm = new DocusignAccountmanagementAPI.MembershipSummary();
	    	DocusignAccountmanagementAPI.AddEnvelopeCurrency_element aecelem = new DocusignAccountmanagementAPI.AddEnvelopeCurrency_element();
	    	DocusignAccountmanagementAPI.GetAccountInformationResult_element gairelem = new DocusignAccountmanagementAPI.GetAccountInformationResult_element();    	
	    	DocusignAccountmanagementAPI.GetEncryptedPasswordResult_element geprelem = new DocusignAccountmanagementAPI.GetEncryptedPasswordResult_element();
	    	DocusignAccountmanagementAPI.AddEnvelopeCurrencyResponse_element aecrjkelem = new DocusignAccountmanagementAPI.AddEnvelopeCurrencyResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanDetailsResult_element gpdrelem = new DocusignAccountmanagementAPI.GetPlanDetailsResult_element();
	    	DocusignAccountmanagementAPI.GetUserProfileImageResult_element gupirelem = new DocusignAccountmanagementAPI.GetUserProfileImageResult_element();
	    	DocusignAccountmanagementAPI.GetUserProfileResponse_element guprlem = new DocusignAccountmanagementAPI.GetUserProfileResponse_element();
	    	DocusignAccountmanagementAPI.ArrayOfPlanGroup aopgelem = new DocusignAccountmanagementAPI.ArrayOfPlanGroup();
	    	DocusignAccountmanagementAPI.InitializeClientAccountResponse_element icarelem = new DocusignAccountmanagementAPI.InitializeClientAccountResponse_element();
	    	DocusignAccountmanagementAPI.UsageHistory usageHistory = new DocusignAccountmanagementAPI.UsageHistory();
	    	DocusignAccountmanagementAPI.PlanGroup planGroup = new DocusignAccountmanagementAPI.PlanGroup();
	    	DocusignAccountmanagementAPI.ChangePasswordResponse_element cpreser = new DocusignAccountmanagementAPI.ChangePasswordResponse_element();
	    	DocusignAccountmanagementAPI.GetPlanGroupInformationResult_element gpgiresujjlt = new DocusignAccountmanagementAPI.GetPlanGroupInformationResult_element();
	    	DocusignAccountmanagementAPI.InitializeClientAccountResult_element initClient = new DocusignAccountmanagementAPI.InitializeClientAccountResult_element();
	    	DocusignAccountmanagementAPI.AuthenticateMemberResponse_element authMem = new DocusignAccountmanagementAPI.AuthenticateMemberResponse_element();    	  
	    	DocusignAccountmanagementAPI.ArrayOfPlan aopjk = new DocusignAccountmanagementAPI.ArrayOfPlan();
	    	//class
	    	DocusignAccountmanagementAPI.AccountManagementServiceSoap dsApiSend = new DocusignAccountmanagementAPI.AccountManagementServiceSoap();
	    	try{
	    		dsApiSend.SetUserProfileImage(null);
	    	}catch(Exception ex){    		
	    	}
	    	try{
	            dsApiSend.AddEnvelopeCurrency(null, 0, 0, null, null, null, null, null, 0.0, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.ActivateSalesforceInstance(null, null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.CheckAccountMember(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetProvisioningInformation(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.SetUserProfile(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.UpgradeRecipientAccount(null, null, null, null, null, null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.UpdateAccountSettings(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.VerifySeatEligibility(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.ChangePassword(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetPlanGroupInformation(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.InitializeClientAccount(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.SetConnectCredentials(null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.CloseMembers(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.NewSocialAccount(null, null, null, null, null, null, null, null, null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetAccountSettings(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.AddMembersToAccount(null, null);
	        }catch(Exception ex){           
	        }        
	        try{
	            dsApiSend.ResendAccountActivation(null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.SetSignatureImages(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetMemberSettings(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetUserProfile(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetUserProfileImage();
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetMembershipSummary(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetConnectCredentials(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetPlanDetails(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetPlanPricingInformation(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.NewAccount(null, null, null, null, null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.AuthenticateMember(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetAccountDistributorCode(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.CloseSignature(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.ChangeAccountPricePlan(null, null, null, null, null, null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.IncrementAccountSeats(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetAccountInformation(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.UpdateMemberSettings(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.Ping();
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetDistributorSeatAllotment(null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetSuccessorPlanInformation(null, null, null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetSignatures(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetPlanType(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.AuthenticateMemberEx(null);
	        }catch(Exception ex){           
	        }
	        try{
	            dsApiSend.GetEncryptedPassword();
	        }catch(Exception ex){           
	        }        
	    	Test.stopTest();
        }
    }
}