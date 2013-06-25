import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class StrMatch {

	private static int q = 33;
	private static int base = 256;
	private static long dm;


	public static void main(String[] args) throws IOException {
		String file = readFileAsString(args[1]).replaceAll("\r\n", "\n");
		//String file = readFileAsString(args[1]);
		String patterns = readFileAsString(args[0]).replaceAll("\r\n", "\n");
		//String patterns = readFileAsString(args[0]);
		//File output = new File(args[2]);

		Pattern p = Pattern.compile("\\&(.*?)\\&",Pattern.DOTALL);
		Matcher matcher = p.matcher(patterns);
		while(matcher.find())
		{
			String nextPattern = matcher.group(1);
			
			
			if(rabinKarp(nextPattern, file) == true)
				System.out.println("RK MATCHED: " + nextPattern);
			else
				System.out.println("RK FAILED: " + nextPattern);
			
			if(KMP(nextPattern, file))
				System.out.println("KMP MATCHED: " + nextPattern);
			else
				System.out.println("KMP FAILED: " + nextPattern);
		}
		
	}

	public static int[] prefixFunc(String pattern)
    {
        int m = pattern.length();
        int prefix[] = new int[m];
        prefix[1] = 0;
        int temp = 0;
        for(int q = 2; q < m; q++)
        {
            while(temp > 0 && pattern.charAt(temp+1) != pattern.charAt(q))
            {
                temp = prefix[temp];
            }
            if(pattern.charAt(temp + 1) == pattern.charAt(q))
                temp++;
            prefix[q] = temp;
        }
        return prefix;
    }

    public static boolean KMP(String pattern, String document)
    {
        int[] prefix = prefixFunc(pattern);
        int documentLength = document.length();
        int patternLength = pattern.length();
        int charsMatched = 0;
        int i = 0;
        while(i < documentLength)
        {   
            while(charsMatched > 0 && pattern.charAt(charsMatched) != document.charAt(i))
            {
                charsMatched = prefix[charsMatched];
            }

            if(pattern.charAt(charsMatched) == document.charAt(i))
            {
                charsMatched++;
            }
            if(charsMatched == patternLength){
                return true;
            }
            i++;
        }
        return false;
    }

    
	public static boolean rabinKarp(String pattern, String document){
		int documentLength = document.length();
		int patternLength = pattern.length();
		
		hashInit(patternLength);
		int patternHash = hash(pattern, patternLength);
		int documentHash = hash(document, patternLength);
        
		for(int i = 0; i <= documentLength-patternLength; i++) {	        
			if(patternHash == documentHash){
				return true;
			}
			
		    documentHash = hashNext(document.substring(i, i+patternLength), patternLength, documentHash);
		}

		return false;
	}
	
	public static void hashInit(int patternLength){
		  dm = 1;
		  
		  for (int i = 0; i < patternLength; i++)
			  dm = (dm * base) % q ;
	}


	public static int hash(String input, int n){
		int hashValue = 0;

		for(int i = 0; i < n; i++){
			hashValue = (base * hashValue + input.charAt(i)) % q;
		}

		return hashValue;
	}
	
	public static int hashNext(String input, int patternLength, int hashValue){
		  return (int) ((hashValue - (input.charAt(0)*(Math.pow(10, patternLength-1))%q *10) + input.charAt(patternLength-1)) % q);
		}


	private static String readFileAsString(String filePath) throws IOException {
		StringBuffer fileData = new StringBuffer();
		BufferedReader reader = new BufferedReader(new FileReader(filePath));
		char[] buf = new char[1024];
		int numRead=0;
		
		while((numRead=reader.read(buf)) != -1){
			String readData = String.valueOf(buf, 0, numRead);
			fileData.append(readData);
		}
		
		reader.close();
		
		return fileData.toString();
	}

}
