//Niraj Patel, Anesh Patel

import java.util.LinkedList;

public class Trie {
	
	private TrieNode root;
	private int index;
	private LinkedList<TrieNode> dictionary;
	
	public Trie(){
		root = new TrieNode();
		dictionary = new LinkedList<TrieNode>();
		dictionary.add(root);
		index++;
	}
	
	public int getIndex(String s){
		for(int i = 0; i < dictionary.size(); i++)
			if(dictionary.get(i).getValue().equals(s))
				return i;

		return 0;
	}
	
	public int searchEntries(String s){
		for(TrieNode t : dictionary){
			if(t.getValue().equals(s)){
				return 1;
			}
		}
		return 0;
	}
	
	public LinkedList<TrieNode> getDictionary(){
		return dictionary;
	}
	
	public int addChild(int idx, String val){
		TrieNode temp = new TrieNode(dictionary.size(), idx, val);
		dictionary.add(temp);
		return 1;
	}
}
