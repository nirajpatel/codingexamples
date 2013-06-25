//Niraj Patel, Anesh Patel

import java.util.LinkedList;


public class TrieNode {

	private int index;
	private int transNum;
	private String value;
	private LinkedList<TrieNode> children;
	
	public TrieNode(int idx, int trans, String val){
		index = idx;
		value = val;
		transNum = trans;
		children = new LinkedList<TrieNode>();
	}
	
	public TrieNode(){
		index = 0;
		value = "";
		children = new LinkedList<TrieNode>();
	}
	
	public int getIndex(){
		return index;
	}
	
	public int getTrans(){
		return transNum;
	}
	
	public String getValue(){
		return value;
	}
}
