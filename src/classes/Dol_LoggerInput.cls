public class Dol_LoggerInput {
    public Exception e { get ; set; }
    public String errorType { get; set; }
    public String SourcePackage { get; set; }
    public String sObjectId { get; set; }
    public String sObjectName { get; set; }
    public String className { get; set; }
    public String functionalityImpacted { get; set; }
    public String additionalDetails { get; set; }
    public String additionalDetails2 { get; set; }

    public static Dol_LoggerInput getDolLoggerForInfo(String details, String functionalityName, String cn ){
        Dol_LoggerInput log = new Dol_LoggerInput();
        log.errorType = 'INFO';
        log.additionalDetails = details;
        log.functionalityImpacted = functionalityName;
        log.className = cn;
        return log;
    }

    public static Dol_LoggerInput getDolLoggerForError(String details, String functionalityName, String cn){
        Dol_LoggerInput log = new Dol_LoggerInput();
        log.errorType = 'ERROR';
        log.additionalDetails = details;
        log.functionalityImpacted = functionalityName;
        log.className = cn;
        return log;
    }

}