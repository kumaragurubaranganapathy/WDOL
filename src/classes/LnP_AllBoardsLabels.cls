public class LnP_AllBoardsLabels {
    public static Map<String, String> fetchBoardLabel(String board){
        Map<String, String> labelMap = new Map<String, String>();
        if(board == 'Notary Public') {
            labelMap.put('Eligible_Not_Pub',System.Label.Eligible_Not_Pub);
        }
        else if(board=='Cosmetology and Barber Board'){
            labelMap.put('Personal_Info_1',System.Label.Personal_Info_1);
            labelMap.put('LnP_Personal_Info_2',System.Label.LnP_Personal_Info_2);
            labelMap.put('LnP_Personal_Info_3',System.Label.LnP_Personal_Info_3);
            labelMap.put('LnP_BnC_Question_1',System.Label.LnP_BnC_Question_1); 
            labelMap.put('LnP_BnC_Question_2',System.Label.LnP_BnC_Question_2); 
            labelMap.put('LnP_BnC_Question_3',System.Label.LnP_BnC_Question_3); 
            labelMap.put('LnP_BnC_Question_4',System.Label.LnP_BnC_Question_4); 
            labelMap.put('LnP_BnC_Question_5',System.Label.LnP_BnC_Question_5);
            labelMap.put('LnP_BnC_Question_6',System.Label.LnP_BnC_Question_6);
            labelMap.put('LnP_Elg_Ques_1',System.Label.LnP_Elg_Ques_1);
            labelMap.put('LnP_Elg_Ques_2',System.Label.LnP_Elg_Ques_2);
            labelMap.put('LnP_Elg_Ques_3',System.Label.LnP_Elg_Ques_3);
            labelMap.put('LnP_Elg_Ques_4',System.Label.LnP_Elg_Ques_4);
            labelMap.put('LnP_Elg_Ques_5',System.Label.LnP_Elg_Ques_5);
            labelMap.put('LnP_Elg_Cosmetologist_Instructor_Ques_1',System.Label.LnP_Elg_Cosmetologist_Instructor_Ques_1);
            labelMap.put('LnP_Elg_Aesthetician_Ques_1',System.Label.LnP_Elg_Aesthetician_Ques_1);
            labelMap.put('LnP_Elg_Aesthetics_Instructor_Ques_1',System.Label.LnP_Elg_Aesthetics_Instructor_Ques_1);  
            labelMap.put('LnP_Elg_Aesthetics_Instructor_Ques_2',System.Label.LnP_Elg_Aesthetics_Instructor_Ques_2);
            labelMap.put('LnP_Elg_Nail_Technician_Ques_1',System.Label.LnP_Elg_Nail_Technician_Ques_1);
            labelMap.put('LnP_Elg_Nail_Technician_Instructor_Ques_1',System.Label.LnP_Elg_Nail_Technician_Instructor_Ques_1);  
            labelMap.put('LnP_Elg_Master_Barber_Ques_1',System.Label.LnP_Elg_Master_Barber_Ques_1);
            labelMap.put('LnP_Elg_Barber_Ques_1',System.Label.LnP_Elg_Barber_Ques_1);
            labelMap.put('LnP_Elg_Barber_Instructor_Ques_1',System.Label.LnP_Elg_Barber_Instructor_Ques_1);
            labelMap.put('LnP_Elg_Electrologist_Ques_1',System.Label.LnP_Elg_Electrologist_Ques_1);
            labelMap.put('LnP_Elg_Electrologist_Instructor_Ques_1',System.Label.LnP_Elg_Electrologist_Instructor_Ques_1);
        }else if(board=='Architects Board'){
            labelMap.put('LnP_ARC_Ques_1',System.Label.LnP_ARC_Ques_1);
            labelMap.put('LnP_ARC_Ques_2',System.Label.LnP_ARC_Ques_2);
            labelMap.put('LnP_ARC_Ques_3',System.Label.LnP_ARC_Ques_3);
            labelMap.put('LnP_ARC_Ques_4',System.Label.LnP_ARC_Ques_4);
            labelMap.put('LnP_ARC_Ques_5',System.Label.LnP_ARC_Ques_5);
            labelMap.put('LnP_ARC_Ques_6',System.Label.LnP_ARC_Ques_6);
            labelMap.put('LnP_ARC_Ques_7',System.Label.LnP_ARC_Ques_7);
            labelMap.put('LnP_ARC_Ques_8',System.Label.LnP_ARC_Ques_8);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_1',System.Label.LnP_Elg_Licensed_Architect_Ques_1);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_2',System.Label.LnP_Elg_Licensed_Architect_Ques_2);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_3',System.Label.LnP_Elg_Licensed_Architect_Ques_3);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_4',System.Label.LnP_Elg_Licensed_Architect_Ques_4);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_5',System.Label.LnP_Elg_Licensed_Architect_Ques_5);
            labelMap.put('LnP_Elg_Licensed_Architect_Ques_6',System.Label.LnP_Elg_Licensed_Architect_Ques_6);
            labelMap.put('LnP_ARC_Ques_10',System.Label.LnP_ARC_Ques_10);
            labelMap.put('LnP_ARC_Ques_11',System.Label.LnP_ARC_Ques_11);
            labelMap.put('LnP_ARC_Ques_12',System.Label.LnP_ARC_Ques_12);     
            labelMap.put('LnP_ARC_Ques_13',System.Label.LnP_ARC_Ques_13);     
            labelMap.put('LnP_ARC_Ques_14',System.Label.LnP_ARC_Ques_14);     
            labelMap.put('LnP_ARC_Ques_15',System.Label.LnP_ARC_Ques_15);     
            labelMap.put('LnP_ARC_Ques_16',System.Label.LnP_ARC_Ques_16);     
            labelMap.put('LnP_ARC_Ques_17',System.Label.LnP_ARC_Ques_17);   
            labelMap.put('LnP_ARC_Renewal_Ques_1',System.Label.LnP_ARC_Renewal_Ques_1);
            labelMap.put('LnP_ARC_Renewal_Ques_2',System.Label.LnP_ARC_Renewal_Ques_2);
            labelMap.put('LnP_ARC_Renewal_Ques_3',System.Label.LnP_ARC_Renewal_Ques_3);
            labelMap.put('LnP_Edu_Name',System.Label.LnP_Edu_Name);     
            labelMap.put('LnP_Edu_From',System.Label.LnP_Edu_From);     
            labelMap.put('LnP_Edu_To',System.Label.LnP_Edu_To);     
            labelMap.put('LnP_Edu_Degree_Earned',System.Label.LnP_Edu_Degree_Earned);     
            labelMap.put('LnP_Licensure_Ques',System.Label.LnP_Licensure_Ques);     
            labelMap.put('LnP_Licensure_Ques1',System.Label.LnP_Licensure_Ques1);  
            //Added new
            labelMap.put('LnP_ARC_Ques_18',System.Label.LnP_ARC_Ques_18); 
            labelMap.put('LnP_ARC_Ques_19',System.Label.LnP_ARC_Ques_19); 
            labelMap.put('LnP_ARC_Ques_20',System.Label.LnP_ARC_Ques_20); 
            labelMap.put('LnP_ARC_Ques_21',System.Label.LnP_ARC_Ques_21); 
            labelMap.put('LnP_ARC_Ques_23',System.Label.LnP_ARC_Ques_23); 
        }      
        else if(board=='Board of Pharmacy'){
            labelMap.put('LnP_Pharma_Ques_1',System.Label.LnP_Pharma_Ques_1);
            labelMap.put('LnP_Pharma_Ques_2',System.Label.LnP_Pharma_Ques_2);
            labelMap.put('LnP_Pharma_Ques_3',System.Label.LnP_Pharma_Ques_3);
            labelMap.put('LnP_Pharma_Ques_4',System.Label.LnP_Pharma_Ques_4);
            labelMap.put('LnP_Pharma_Ques_5',System.Label.LnP_Pharma_Ques_5);
            labelMap.put('LnP_Pharma_Ques_6',System.Label.LnP_Pharma_Ques_6);
            labelMap.put('LnP_Pharma_Ques_7',System.Label.LnP_Pharma_Ques_7);
            labelMap.put('LnP_Pharma_Ques_8',System.Label.LnP_Pharma_Ques_8);
            labelMap.put('LnP_Pharma_Ques_9',System.Label.LnP_Pharma_Ques_9);
            labelMap.put('LnP_Pharma_Ques_10',System.Label.LnP_Pharma_Ques_10);
            labelMap.put('LnP_Pharma_Ques_11',System.Label.LnP_Pharma_Ques_11);
            labelMap.put('LnP_Pharma_Ques_12',System.Label.LnP_Pharma_Ques_12);
            /*labelMap.put('LnP_Elg_Ques_1',System.Label.LnP_Elg_Ques_1);
labelMap.put('LnP_Elg_Ques_2',System.Label.LnP_Elg_Ques_2);
labelMap.put('LnP_Elg_Ques_3',System.Label.LnP_Elg_Ques_3);
labelMap.put('LnP_Elg_Ques_4',System.Label.LnP_Elg_Ques_4);
labelMap.put('LnP_Elg_Ques_5',System.Label.LnP_Elg_Ques_5);*/
            labelMap.put('LnP_Elg_Pharmacist_Ques_1',System.Label.LnP_Elg_Pharmacist_Ques_1);
            labelMap.put('LnP_Elg_Pharmacist_Ques_2',System.Label.LnP_Elg_Pharmacist_Ques_2);
            labelMap.put('LnP_Elg_Pharmacist_Ques_3',System.Label.LnP_Elg_Pharmacist_Ques_3);
            labelMap.put('LnP_Elg_Pharmacist_Ques_4',System.Label.LnP_Elg_Pharmacist_Ques_4);
            labelMap.put('LnP_Elg_Pharmacist_Ques_5',System.Label.LnP_Elg_Pharmacist_Ques_5);
            labelMap.put('LnP_Elg_Pharmacy_Intern_Ques_1',System.Label.LnP_Elg_Pharmacy_Intern_Ques_1);
            labelMap.put('LnP_Elg_Pharmacy_Intern_Ques_2',System.Label.LnP_Elg_Pharmacy_Intern_Ques_2);
        }
        else if(board=='Board of Dietetics/Nutrition'){
            labelMap.put('LnP_DnN_Elg_Question1',System.Label.LnP_DnN_Elg_Question1);
            labelMap.put('LnP_DnN_Elg_Question2',System.Label.LnP_DnN_Elg_Question2);
            labelMap.put('LnP_DnN_Elg_Question3',System.Label.LnP_DnN_Elg_Question3);
        }
        else if(board=='Real Estate'){
            labelMap.put('LnP_RealEstate_Elg_Question1',System.Label.LnP_RealEstate_Elg_Question1);
            labelMap.put('LnP_RealEstate_Elg_Question2',System.Label.LnP_RealEstate_Elg_Question2);
        }
        else if(board=='Dental Board'){
            labelMap.put('LnP_Elg_Dental_Hygenist_Ques_1',System.Label.LnP_Elg_Dental_Hygenist_Ques_1);
        }
        else if(board=='Funeral Services'){
            labelMap.put('LnP_Elg_Funeral_Establishment_Ques_1',System.Label.LnP_Elg_Funeral_Establishment_Ques_1);
            labelMap.put('LnP_Elg_Funeral_Establishment_Ques_2',System.Label.LnP_Elg_Funeral_Establishment_Ques_2);
            labelMap.put('LnP_Elg_Crematory_Establishment_Ques_1',System.Label.LnP_Elg_Crematory_Establishment_Ques_1);
            labelMap.put('LnP_Elg_Crematory_Establishment_Ques_2',System.Label.LnP_Elg_Crematory_Establishment_Ques_2);
            labelMap.put('LnP_Elg_Funeral_Director_Ques_1',System.Label.LnP_Elg_Funeral_Director_Ques_1);
            labelMap.put('LnP_Elg_Funeral_Director_Ques_2',System.Label.LnP_Elg_Funeral_Director_Ques_2);
        }
        else if(board=='Board of Electrical Examiners'){
            labelMap.put('LnP_Elg_Electrical_Ques_1',System.Label.LnP_Elg_Electrical_Ques_1);
            labelMap.put('LnP_Elg_Journeyperson_Electrician_Ques_1',System.Label.LnP_Elg_Journeyperson_Electrician_Ques_1);
            labelMap.put('LnP_Elg_Journeyperson_Electrician_Ques_2',System.Label.LnP_Elg_Journeyperson_Electrician_Ques_2);
        }
        else if(board=='Geology'){
            labelMap.put('LnP_Elg_Geologist_Ques_1',System.Label.LnP_Elg_Geologist_Ques_1);
        }
        else if(board=='Manufactured Home Installation'){
            labelMap.put('LnP_Elg_Home_Installer_Ques_1',System.Label.LnP_Elg_Home_Installer_Ques_1);
        }
        else if(board=='Optometry'){
            labelMap.put('LnP_Elg_Optometry_Ques_1',System.Label.LnP_Elg_Optometry_Ques_1);
        }
        else if(board=='Occupational Therapy'){
            labelMap.put('LnP_Elg_Occupational_Therapy_Ques_1',System.Label.LnP_Elg_Occupational_Therapy_Ques_1);
        }
        else if(board=='Landscape Architecture'){
            labelMap.put('LnP_Elg_Electrical_Ques_1',System.Label.LnP_Elg_Electrical_Ques_1);
            labelMap.put('LnP_Elg_Certificate_of_Authorization_Land_Arch_Ques_1',System.Label.LnP_Elg_Certificate_of_Authorization_Land_Arch_Ques_1);
            labelMap.put('LnP_Elg_Certificate_of_Authorization_Land_Arch_Ques_2',System.Label.LnP_Elg_Certificate_of_Authorization_Land_Arch_Ques_2);
        }
        else if(board=='Massage Bodywork'){
            labelMap.put('LnP_Elg_Certified_Massage_Technician_Ques_1',System.Label.LnP_Elg_Certified_Massage_Technician_Ques_1);
            labelMap.put('LnP_Elg_Certified_Massage_Technician_Ques_2',System.Label.LnP_Elg_Certified_Massage_Technician_Ques_2);
            labelMap.put('LnP_Elg_Licensed_Massage_Therapist_Ques_1',System.Label.LnP_Elg_Licensed_Massage_Therapist_Ques_1);
            labelMap.put('LnP_Elg_Licensed_Massage_Therapist_Ques_2',System.Label.LnP_Elg_Licensed_Massage_Therapist_Ques_2);
            labelMap.put('LnP_Elg_Licensed_Massage_Therapist_Ques_3',System.Label.LnP_Elg_Licensed_Massage_Therapist_Ques_3);
        }
        else if(board=='Liquor License'){
            labelMap.put('Invoice_Date',System.Label.Invoice_Date);
            labelMap.put('Invoice_Number',System.Label.Invoice_Number);
            labelMap.put('OLCC_License_Number',System.Label.OLCC_License_Number);
            labelMap.put('Purchased_or_Received_From_Name',System.Label.Purchased_or_Received_From_Name);
            labelMap.put('Malt_Bevarage_Cider_Barrels',System.Label.Malt_Bevarage_Cider_Barrels);
            labelMap.put('Supplier_Manufacturer',System.Label.Supplier_Manufacturer);
            labelMap.put('State_or_Country_of_Origin',System.Label.State_or_Country_of_Origin);
            labelMap.put('Invoice_Date',System.Label.Invoice_Date);
            labelMap.put('Date_of_Receipt',System.Label.Date_of_Receipt);
            labelMap.put('OLCC_CERA_Number',System.Label.OLCC_CERA_Number);
            labelMap.put('NUMBER_OF_CASES',System.Label.NUMBER_OF_CASES); 
            labelMap.put('GALLONS_RECEIVED',System.Label.GALLONS_RECEIVED);
            labelMap.put('WINE_14_Under',System.Label.WINE_14_Under);
            labelMap.put('Wine_Over_14',System.Label.Wine_Over_14);
            labelMap.put('Malt_Beverages_Cider_Barrels',System.Label.Malt_Beverages_Cider_Barrels);
            labelMap.put('Wine_Gallons_14',System.Label.Wine_Gallons_14);
            labelMap.put('Under_Wine_Gallons_Over_14',System.Label.Under_Wine_Gallons_Over_14);
            labelMap.put('Export_Date',System.Label.Export_Date);
            labelMap.put('Export_Document_Number',System.Label.Export_Document_Number);
            labelMap.put('Exported_To_Name_State',System.Label.Exported_To_Name_State);
            labelMap.put('Malt_Cider_Beverage_Barrels',System.Label.Malt_Cider_Beverage_Barrels);
        }
        labelMap.put('LnP_Reciprocity',System.Label.LnP_Reciprocity);
        return labelMap;
    }
    
}