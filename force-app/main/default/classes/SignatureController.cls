public class SignatureController {

    @AuraEnabled
    public static void saveSignature(String signatureBody){
       Attachment a = new Attachment();
        a.ParentId = '0016F00001xoSSs'; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
    }
}