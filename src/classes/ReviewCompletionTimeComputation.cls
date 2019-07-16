public class ReviewCompletionTimeComputation {
    
    public Decimal ReviewCompletionTimeComputation(MUSW__Review__c reviewRecord){
        Decimal completionDurationHours = -1.0;
        List<Holiday> holidays = [SELECT Id, Name, ActivityDate FROM Holiday];
        //system.debug(' User Time Zone ID = '+UserInfo.getTimeZone().getID());
        //system.debug(' User Time Zone display name = '+UserInfo.getTimeZone().getDisplayName());
        //system.debug(' User Time Zone display name = '+UserInfo.getTimeZone().getDisplayName());
        
        
                //         List<answer__C> tempcredList = [select id,  renewal_application__r.credential__C, renewal_application__r.license__r.Application_Method__c from answer__C where Id=:tempAns.Id];   
                /*List<MUSW__Review__c> review = [SELECT Id, Start_Date__c, MUSW__Completed_DateTime__c
        FROM MUSW__Review__c
        WHERE Id =:reviewId];*/
        
            Integer holidaysBetweenStartAndEndDate = 0;
            //system.debug(' converted trigger start date = '+ reviewRecord.Start_Date__c.format('yyyy-MM-dd HH:mm:ss', 'CST'));
            /*The date comes in timezone other than user's time zone- converting it to be in local timezone*/
        	DateTime startDateTime = reviewRecord.Start_Date__c;
            DateTime completedDateTime = reviewRecord.MUSW__Completed_DateTime__c;
            String stringStartDateTime = startDateTime.format('yyyy-MM-dd HH:mm:ss', 'CST');
        	String stringCompletedDateTime = completedDateTime.format('yyyy-MM-dd HH:mm:ss', 'CST');
        	Datetime localStartDateTime = Datetime.valueOfGmt(stringStartDateTime);
        	Datetime localCompletedDateTime = Datetime.valueOfGmt(stringCompletedDateTime);
        	Date startDate = date.newinstance(localStartDateTime.year(), localStartDateTime.month(), localStartDateTime.day());
            Date completedDate = date.newinstance(localCompletedDateTime.year(), localCompletedDateTime.month(), localCompletedDateTime.day());
            
        	//old approach where the time was manually being decreased by 5 hours to counter the time conversion
        	//DateTime startDateTime_updated = datetime.newinstance(startDateTime.year(), startDateTime.month(), startDateTime.day(), startDateTime.hour()-5, startDateTime.minute(), startDateTime.second());
            //DateTime completedDateTime_updated = datetime.newinstance(completedDateTime.year(), completedDateTime.month(), completedDateTime.day(), completedDateTime.hour()-5, completedDateTime.minute(), completedDateTime.second());
            
            //System.debug('startDateTime '+startDateTime);
            //System.debug('completedDateTime '+completedDateTime);
            //System.debug('localStartDateTime '+localStartDateTime);
            //System.debug('localCompletedDateTime '+localCompletedDateTime);
            //System.debug('startDate '+startDate);
            //System.debug('completedDate '+completedDate);
            
            
            for(Holiday holi: holidays){
                if(startDate < holi.ActivityDate && holi.ActivityDate < completedDate){
                    //System.debug(holi);
                    holidaysBetweenStartAndEndDate = holidaysBetweenStartAndEndDate + 1;
                }
            }
            
            //Integer numberOfWeekendDays = 0;
            Integer numberOfHolidays = 0;
            Boolean sameDay = startDate.isSameDay(completedDate);
            //System.debug('sameDay '+sameDay);
            if(sameDay){
                Decimal completionTime = ((localCompletedDateTime.getTime())/1000/60);
                Decimal startTime = ((localStartDateTime.getTime())/1000/60);
                completionDurationHours = ((completionTime - startTime)/60).setScale(3);
                //System.debug('completionDurationHours '+completionDurationHours);
            }else{
                Integer totalNumberOfDays = startDate.daysBetween(completedDate);
                //System.debug('totalNumberOfDays '+totalNumberOfDays);
                //System.debug('totalNumberOfHolidays '+holidaysBetweenStartAndEndDate);
                
                Integer referenceDays = (date.newInstance(1985,6,24)).daysBetween(startDate);
                
                Double numberOfWeekendDays = 0;
                //System.debug('referenceDays '+referenceDays);
                Integer a = math.mod(referenceDays,7);
                Integer b = math.mod(totalNumberOfDays,7);
                //System.debug('a '+a);
                //System.debug('b '+b);
                Switch on (math.mod(referenceDays,7)){
                    when 0 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 1{
                                numberOfWeekendDays = 0;
                            }when 2{
                                numberOfWeekendDays = 0;
                            }when 3{
                                numberOfWeekendDays = 0;
                            }when 4{
                                numberOfWeekendDays = 0;
                            }when 5{
                                numberOfWeekendDays = 1;
                            }when 6{
                                numberOfWeekendDays = 2;
                            }when else{
                                numberOfWeekendDays = 0;
                            }
                            
                        }
                        
                    } when 1 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 0{
                                numberOfWeekendDays = 0;
                            }when 1{
                                numberOfWeekendDays = 0;
                            }when 2{
                                numberOfWeekendDays = 0;
                            }when 3{
                                numberOfWeekendDays = 0;
                            }when 4{
                                numberOfWeekendDays = 0;
                            }when 5{
                                numberOfWeekendDays = 2;
                            }when else{
                                numberOfWeekendDays = 2;
                            }
                            
                        }
                        
                    }when 2 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 0{
                                numberOfWeekendDays = 0;
                            }when 1{
                                numberOfWeekendDays = 0;
                            }when 2{
                                numberOfWeekendDays = 0;
                            }when 3{
                                numberOfWeekendDays = 1;
                            }when else{
                                numberOfWeekendDays = 2;
                            }
                            
                        }
                        
                    }when 3 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 0{
                                numberOfWeekendDays = 0;
                            }when 1{
                                numberOfWeekendDays = 0;
                            }when 2{
                                numberOfWeekendDays = 1;
                            }when else{
                                numberOfWeekendDays = 2;
                            }
                            
                        }
                        
                    }when 4 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 0{
                                numberOfWeekendDays = 0;
                            }when 1{
                                numberOfWeekendDays = 1;
                            }when else{
                                numberOfWeekendDays = 2;
                            }
                            
                        }
                        
                    }when 5 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 0{
                                numberOfWeekendDays = 1;
                            }when else{
                                numberOfWeekendDays = 2;
                            }
                            
                        }
                        
                    }when 6 {
                        Switch on (math.mod(totalNumberOfDays, 7)){
                            when 5{
                                numberOfWeekendDays = 2;
                            }when else{
                                numberOfWeekendDays = 1;
                            }
                            
                        }
                        
                    }when else {
                        numberOfWeekendDays =     999;
                    }
                }
                
                numberOfWeekendDays = numberOfWeekendDays + (math.floor(( totalNumberOfDays )/7)*2);
                //System.debug('totalNumberOfweekend days '+numberOfWeekendDays);
                Double hoursWorkedOnOtherDays = (totalNumberOfDays - 1 - numberOfWeekendDays - holidaysBetweenStartAndEndDate)*9;
                 /*standard working hours are 7.30 am to 4.30 pm*/
                //Setting the standard start time to 7.30 am
                //Setting the standard end time to 4.30 pm
                //IMPORTANT:have considered the time conversion as well
                DateTime standardStartDateEndTime = datetime.newInstance(localStartDateTime.year(), 
                                                                         localStartDateTime.month(), 
                                                                         localStartDateTime.day(), 
                                                                         11, 30, 0);
                DateTime standardCompletedDateStartTime = datetime.newInstance(localCompletedDateTime.year(), 
                                                                               localCompletedDateTime.month(), 
                                                                               localCompletedDateTime.day(), 
                                                                               2, 30, 0);
                Decimal startDayHours = ((standardStartDateEndTime.getTime())/1000/60) - ((localStartDateTime.getTime())/1000/60);
                Decimal completedDayHours = ((localCompletedDateTime.getTime())/1000/60) - ((standardCompletedDateStartTime.getTime())/1000/60);
                completionDurationHours = (hoursWorkedOnOtherDays + ((startDayHours + completedDayHours)/60)).setScale(3);
                /*
                System.debug('startDayHours '+startDayHours/60);
                System.debug('completedDayHours '+completedDayHours/60);
                System.debug('hoursWorkedOnOtherDays '+hoursWorkedOnOtherDays);
                System.debug('completionDurationHours '+completionDurationHours);
                System.debug('standardStartDateEndTime '+standardStartDateEndTime);
                System.debug('startDateTime '+ ((startDateTime.getTime())/1000/60));
                System.debug('standardStartDateEndTime '+ ((standardStartDateEndTime.getTime())/1000/60));
                System.debug('standardCompletedDateStartTime '+ ((standardCompletedDateStartTime.getTime())/1000/60));
                System.debug('completedDateTime '+ ((completedDateTime.getTime())/1000/60)) ;
                System.debug('standardCompletedDateStartTime '+standardCompletedDateStartTime);
                System.debug('completionDurationHours '+completionDurationHours);
                System.debug('minutes to hours '+completionDurationHours/60);
                */
            }
        
        return completionDurationHours;
    }
    
}