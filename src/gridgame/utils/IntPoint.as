package gridgame.utils
{
public class IntPoint
{
	public var x:int;
	public var y:int;
	
	public function IntPoint(x:int=0, y:int=0)
	{
		this.x = x;
		this.y = y;
	}
	
	public function toString():String
	{
		return "("+x+", "+y+")";
	}
}
}