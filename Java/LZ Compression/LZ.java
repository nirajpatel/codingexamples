
public class LZ {
	public static void main(String[] args) throws Exception
	{
		IO.Compressor x = new IO.Compressor("/Applications/Eclipse/Workspace/LZ/src/input.txt");
		char[] array = x.giveArray();
		
		for(int i = 0; i < array.length; i++)
		{
			x.encode(i, array[i]);
		}
		
		array = x.giveArray();

		
	}
	
}
