/**
* User Story: 108 - Promote user, to a business user, by creating an account on the portal
* Class Name: BusinessUserInProcess_CC
* Test Class Name: BusinessUserInProcess_CC_Test
* Description: This class serves as Custom Controller for BusinessUserInProces
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/01/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/
public class BusinessUserInProcess_CC {
	public String requestStatus {get; set;}
    
    public BusinessUserInProcess_CC(){
        requestStatus = 'Pending';
    }
    
    public void checkUserProfile(){
        User u = [Select Id, UserType From User where Id = :UserInfo.getUserId()];
        system.debug('User Check>>>>>>>'+u);
        if(u.UserType == 'PowerCustomerSuccess'){
            requestStatus = 'Complete';
        }
    }
}