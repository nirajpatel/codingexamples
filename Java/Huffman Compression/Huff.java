import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

public class Huff {
	int NUMB_BITS = 8;
	
	TreeMap<Integer, Integer> freqMap;
    private int numChars; 

	public static void main(String[] args) throws IOException{
		String file = "/Applications/Eclipse/Workspace/Huffman/src/test.txt";
		frequency(file);
	}
	
	public static void frequency(String file) throws IOException{
		private TreeMap<Integer, Integer> countFreq(BitInputStream inFile) throws IOException { 
	        freqMap = new TreeMap<Integer, Integer>(); 
	          
	        int inbits; 
	          
	        //read input file letter by letter 
	        while ((inbits = inFile.readBits(NUMB_BITS)) != -1) { 
	              
	            if (freqMap.containsKey(inbits)) { 
	                int freq = freqMap.get(inbits); 
	                numChars++; 
	                freqMap.put(inbits, ++freq); 
	            } else { 
	                freqMap.put(inbits, 1); 
	                numChars++; 
	            } 
	        } 
	          
	        freqMap.put(PSEUDO_EOF, 1); 
	        inFile.close(); 
	          
	        return freqMap; 
}
