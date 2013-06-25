import java.util.LinkedList;


public class test {
	public static void main(String[] args) throws Exception{
		IO.Compressor outfile = new IO.Compressor(args[0]);
		Trie tree = new Trie();
		boolean done = false;
		int counter = 0;
		int idx = 0;
		String temp = "";
		char[] str = outfile.giveArray();

		while(!done){			
			if(tree.searchEntries(temp) == 0){
				tree.addChild(idx, temp);
				temp = "" + str[counter];
				idx = 0;
			}
			
			else{
				idx = tree.getIndex(temp);
				temp+=str[counter];
			}
			
			if(str[counter] == '#'){
				tree.addChild(idx, temp);
				done=true;
			}
			counter++;
		}
		
		LinkedList<TrieNode> dictionary = tree.getDictionary();
		
		for(int i = 0; i< dictionary.size();i++){
			String s = dictionary.get(i).getValue();
			if(s.length()!= 0){
				char c = s.charAt(s.length()-1);
				outfile.encode(dictionary.get(i).getTrans(), c);
			}
		}
		
		outfile.done();
	}
}
