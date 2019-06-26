@IsTest
public class HTTPRestResponse_Test {

    @IsTest
    public static void test(){
        HTTPRestResponse response = HTTPRestResponse.getInstance();
        response.geterrorMsgs();
        response.getLogs();
        response.getStatusCode();
        response.setStatusCode(200);
        response.addErrorMsg('test');
        response.addLog('DSD');
        List<String> errList = new List<String>();
        errList.add('zdfsfsdf');
        errList.add('dasdfasf');
        response.addLog(errList);
               
    }
}