public class LnP_ApplyForLicenseWrapper {
    public String sectionName;
    public String recordType;
    public List<MapLabelToFields> labelFieldsMap = new List<MapLabelToFields>();
    public String icon;
    public String subheader;    
    public String sobjectType;
    public Integer currentTab;
    public Integer tabIndex;
    public Boolean sectionError;
    public string accountId;
    public string contactId;
    public string personalInfoObjectName;
    public string fieldsList;
    public string mandatorySubsection;
    public string fieldJson;
    public class MapLabelToFields{
        public String label;
        public String labelId;
        public Boolean uploadFile;
        public Boolean acknowledge;
        public Boolean acknowledgeResponse;
        public String value;
        public String questionSection;
        public String fieldAPIName;
        public String fieldObjName ;
        public String questionSectionClass;
        public String questionSectionDetail;
        public List<String> multiValues = new List<String>();
        public Boolean hasChild;
        public Boolean isChild;
        public Boolean renderedOnUi;
        public String conditionalAnswer;
        public String fieldType;
        public Id parentQuestionId;
        public String submissionDetails;
        public String answerId;
        public String messageTriggerResponse;
        public String message;
        public String regex;
        public String helptext;
        public String errormsg;
        public String endorsementType;
        public String minValue;
        public String maxValue;
        public String warningMessages;
        public Boolean isMandatoryQues;
        public List<String> fieldValueOptions;
        public List<MapRadioButtons> radioValueOptions = new List<MapRadioButtons>();
        public Boolean isGenericSub;
        public Boolean isMandatorySub;
        public Decimal orderBy;
        public List<MapRadioButtons> educationDetailsMap = new List<MapRadioButtons>();    
       public String validationCriteria;
    }
    
    public class MapRadioButtons{
        public String label;
        public String value;
    }
}