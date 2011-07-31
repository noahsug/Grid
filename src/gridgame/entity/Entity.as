package gridgame.entity
{
	import gridgame.level.Level;
	
	import org.flixel.*;
	
	public /*abstract*/ class Entity extends FlxSprite
	{		
		private static const DefaultMaxHealth:int = 10;
		private var _midpoint:FlxPoint = new FlxPoint();				
		protected var _level:Level;
		
		public function Entity(img:Class=null)
		{
			super(0, 0, img);
			health = maxHealth;
		}
		
		public override function update(): void
		{
			super.update();			
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

		public function set position(p:FlxPoint):void
		{
			setPosition(p.x, p.y);
		}
				
		public function get midpoint():FlxPoint
		{
			return getMidpoint(_midpoint);
		}
		
		public override function revive():void {
			health = maxHealth;
			super.revive();
		}
						
		protected function get maxHealth():Number { return DefaultMaxHealth; }
	}
}