@isTest
public class LnP_AllBoardLabels_Test {
    
    public static testmethod void LnP_AllBoardLabelsConstructor1()
    {
        Map<String,String> labelmap = new Map<String,String>();
        List<String> Board = new List<String>();
        Board.add('Cosmetology and Barber Board');
        Board.add('Architects Board');
        Board.add('Board of Pharmacy');
        Board.add('Board of Dietetics/Nutrition');
        Board.add('Real Estate');
        Board.add('Dental Board');
        Board.add('Funeral Services');
        Board.add('Board of Electrical Examiners');
        Board.add('Geology');
        Board.add('Manufactured Home Installation');
        Board.add('Optometry');
        Board.add('Occupational Therapy');
        Board.add('Landscape Architecture');
        Board.add('Massage Bodywork');
        Board.add('Liquor License');
        Board.add('Notary Public');

            Test.startTest();
            for(String s:Board){
                labelmap = LnP_AllBoardsLabels.fetchBoardLabel(s);
            }
            system.assert( labelmap.size() > 0!= null ) ;
            
            Test.stopTest();
        }

    }