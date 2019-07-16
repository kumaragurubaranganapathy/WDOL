public class CryptoUtility {
    
    public static String getEncryptedString(String algoName,
                                          String privateKey,
                                          String initializationVector,
                                          String inputForEncryption){
        Blob key = EncodingUtil.base64Decode(privateKey);
        Blob initVector = Blob.valueOf(initializationVector);
        Blob input = Blob.valueOf(inputForEncryption);
        Blob encryptedData = Crypto.encrypt(algoName, key, initVector, input);
        return EncodingUtil.base64Encode(encryptedData);                        
    }
    
    public static String getDecryptedString(String algoName,
                                          String privateKey,
                                          String initializationVector,
                                          String inputForDecryption){
        Blob key = EncodingUtil.base64Decode(privateKey);
        Blob initVector = Blob.valueOf(initializationVector);
        Blob encryptedData = EncodingUtil.base64Decode(inputForDecryption);
        Blob decryptedData = Crypto.decrypt(algoName, key, initVector, encryptedData);
        return decryptedData.toString();                         
    }
    
}