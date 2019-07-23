/************************************************************************************************************
** Name             : HTTPRestResponse
** Description   : Apex class to capture logs , errors for Endpoint
** Version          : 1.0
**-------------------------------------------------------------------------------------------------------------------------------
** Revision History:
**---------------------------
** [Laltu Banerjee]: Created
*************************************************************************************************************/
public class HTTPRestResponse {
    
    private static final HTTPRestResponse instance = new HTTPRestResponse();
    private List<String> errorMsgs = new List<String>();
    private Integer statusCode;
    private List<String> logs = new List<String>();
    
    private HTTPRestResponse(){
        
    }
    
    public static HTTPRestResponse getInstance(){
    	return instance;
    }
    
    public String geterrorMsgs(){
        return String.join(this.errorMsgs, ' || ') ;
    }
    public String getLogs(){
        return String.join(this.logs, ' || ');
    }
    public Integer getStatusCode(){
        return this.statusCode;
    }
    
    public void setStatusCode(Integer statusCode){
        this.statusCode = statusCode;
    }
    
    public void addErrorMsg(String msg){
        this.errorMsgs.add(msg);
    }
    
    public void addLog(String log){
        this.logs.add(log);
    }
    
    public void addLog(List<String> log){
        if(log != null && log.size() > 0 )
        	this.logs.addAll(log);
    }
    
    public void addLog(List<Database.Error> dbErrors){
        if(dbErrors != null && dbErrors.size() > 0 ){
            this.logs.add('DB Error ');
            for(Database.Error error : dbErrors ){
                this.logs.add(error.message);
            }
        }
    }

}