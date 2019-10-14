@isTest
public class LnP_CommonHeader_AC_Test {
    
    public static testmethod void LnP_CommonHeader_Constructor(){
        
        Test.startTest();
        Lnp_CommonHeader_AC.getLabel();
        Lnp_CommonHeader_AC.getContactUserInfo();
        Lnp_CommonHeader_AC.isValidCommunityUser();
        Test.stopTest();
    }
    
    @isTest
    public static void testSavefile(){
        String base64Str = EncodingUtil.base64Encode(Blob.valueOf('Test Content'));
        try{
            Lnp_CommonHeader_AC.saveChunk('Test File', base64Str,'PDF', '');
        }catch(Exception ex){}
    }
    
   

}