package gridgame.entity
{
	import org.flixel.*;
	import gridgame.level.Level;
	
	public /*abstract*/ class Entity extends FlxSprite
	{
		protected var _level:Level;		
		private var _position:FlxPoint = new FlxPoint();
		private var _tilePosition:FlxPoint = new FlxPoint();
		
		public function Entity(img:Class=null)
		{
			super(0, 0, img);
		}
		
		public function setLevel(level:Level):void
		{
			_level = level;
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x + (Level.TileSize - width) / 2;
			this.y = y + (Level.TileSize - height) / 2;			
		}
		
		public function get position():FlxPoint
		{
			return getMidpoint(_position);
		}
	}
}