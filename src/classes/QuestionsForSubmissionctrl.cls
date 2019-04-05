public class QuestionsForSubmissionctrl {
   
  
   public String sQuestionText{get;set;}
   public String sAnswerText{get;set;}
   public String sAnswerComment{get;set;}
   public QuestionAnswerObj oData;
   public List<QuestionAnswerObj.QuestionObj> lstDataVal{get; set;}
   
   public QuestionAnswerObj getoData(){return oData;}
   
    public void setoData(QuestionAnswerObj oData)
    {
        if(oData <> null)
        {
        this.oData = oData;
        System.debug('this.oData:::'+ oData.questionsList);
        lstDataVal = oData.questionsList;
        }
    } 
   
   public QuestionsForSubmissionctrl(String sQuestionText, String sAnswerText, String sAnswerComment)
   {
       this.sQuestionText = sQuestionText;
       this.sAnswerText = sAnswerText;
       this.sAnswerComment = sAnswerComment;
   }
   
   public QuestionsForSubmissionctrl()
   {
       lstDataVal = new List<QuestionAnswerObj.QuestionObj>();
   }
   
   
    
}