// Date : 21/2/2019
// This class converts the JSON response and 
// returns the keywords for the search functionality


public class ImageInfo {

	public List<ParsedResults> ParsedResults;
	public Integer OCRExitCode;
	public Boolean IsErroredOnProcessing;
	public String ProcessingTimeInMilliseconds;
	public String SearchablePDFURL;

	public class ParsedResults {
		public TextOverlay TextOverlay;
		public String TextOrientation;
		public Integer FileParseExitCode;
		public String ParsedText;
		public String ErrorMessage;
		public String ErrorDetails;
	}

	public class TextOverlay {
		public List<Lines> Lines;
		public Boolean HasOverlay;
		public String Message;
        
	}

	public class Lines {
	}

	
	public static ImageInfo parse(String json) {
        system.debug('the json' +json);
		return (ImageInfo) System.JSON.deserialize(json, ImageInfo.class);
		
        
	}
}