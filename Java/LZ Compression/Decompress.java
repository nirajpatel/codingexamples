//Niraj Patel, Anesh Patel

import java.util.LinkedList;

public class Decompress {
	public static void main(String[] args) throws Exception {
 		IO.Decompressor infile = new IO.Decompressor(args[1]);
		IO.pair x = infile.decode();
		LinkedList<String> list = new LinkedList<String>();
		String s = "" + x.extension;
		
		while(x.valid){
			if(!list.contains(s)){
				list.add(s);
				infile.append(s);
				x = infile.decode();
				s = "" + x.extension;
			}
			else{
				x = infile.decode();
				s = s + x.extension;
			}

		}
		
		infile.done();
	}

}
