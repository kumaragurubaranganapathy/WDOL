/**
* Name: DeactivateUserHelper
* Type: Class
* Description: Helper class to deactive users
* Date:        Developer/Company                 	Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/23/2018   Srikanth Kottam/Deloitte           Initial Creation
**/
public class DeactivateUserHelper {
	/**
      * @Method name   : updateUser
      * @Description   : Updates users 
      * @Return Type   : None
      * @Parameter     : Trigger.new
    **/
    @future
    public static void updateUser(Set<Id> contactIds){
        List<User> user = [Select Id, ContactID from User where contactId in :contactIds];
        system.debug('Users List>>>>>>>>'+user);
        if(user.size() > 0){
            for(User u : user){
                u.IsActive = false;
                u.IsPortalEnabled = false;
            }
            try{
                Update user;
            }
            catch(Exception e){
                system.debug('Caught Exception while deactivating user: '+ e);
            }
        }
    }
}