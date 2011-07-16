package 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	[SWF(width="640", height="480", backgroundColor="#111111")]
	[Frame(factoryClass="Preloader")]
	
	public class Grid extends FlxGame
	{
		public function Grid()
		{					
			super(320, 240, PlayState, 2);
			forceDebugger = true;
			//FlxG.visualDebug = true;
		}
	}
}