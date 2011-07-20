package gridgame.entity
{
	import gridgame.level.Level;
	
	import org.flixel.*;
	
	public /*abstract*/ class Entity extends FlxSprite
	{		
		private static const DefaultMaxHealth:int = 10;
		private var _midpoint:FlxPoint = new FlxPoint();
		private var _hitObject:FlxObject;
		
		
		public function Entity(img:Class=null)
		{
			super(0, 0, img);
			health = maxHealth;
		}
		
		public static function levelHit(entity:Entity, block:FlxObject): void
		{
			entity.levelHit(block);
		}
		
		public override function update(): void
		{
			super.update();
			_hitObject = null;
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
		
		public function get hitObject():FlxObject {
			return _hitObject;
		}
		
		protected function get maxHealth():Number { return DefaultMaxHealth; }
		
		protected function levelHit(block:FlxObject):void
		{
			_hitObject = block;			
		}
	}
}