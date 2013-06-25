//Niraj Patel, Anesh Patel
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Comp {

	public static void main(String[] args) throws Exception {
		if(args[0].charAt(0) == 'c'){
			Compress.main(args);
		}
		else{
			Decompress.main(args);
		}
	}
}