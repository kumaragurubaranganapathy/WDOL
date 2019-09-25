public class SOD_Autocomplete_Wrapper {
    
    public class Suggestions {
        //@AuraEnabled
        public String text;
        //@AuraEnabled
        public String street_line;
        //@AuraEnabled
        public String city;
        //@AuraEnabled
        public String state;
        
    }
    //@AuraEnabled
    public List<Suggestions> suggestions;
    
    public static SOD_Autocomplete_Wrapper parse(String json) {
        return (SOD_Autocomplete_Wrapper) System.JSON.deserialize(json, SOD_Autocomplete_Wrapper.class);
    }
}