package gridgame.entity.moving
{
	import gridgame.entity.Entity;
	
	import org.flixel.*;
	
	public class Enemy extends MovingEntity
	{
		[Embed(source="./assets/enemy.png")] private var EntityImg:Class;				
		
		private static const Speed:Number = 30;
		private static const MaxHealth:Number = 20;
				
		private var _target:Entity;
		
		public function Enemy()
		{
			super(EntityImg);
			movementBehavior = new FollowMovementBehavior(this);
			movementBehavior.setSpeed(Speed);			
		}
								
		public static function targetHit(enemy:Enemy, target:Entity):void
		{
			if (target.alive)
			{
				target.kill();
				enemy.angle = FlxU.getAngle(enemy.midpoint, target.midpoint);				
				enemy.freeze(100);
			}			
		}
		
		public function followTarget(target:Entity):void
		{
			_target = target;
			((FollowMovementBehavior) (movementBehavior)).setTarget(_target);
		}				

		public override function update():void
		{
			super.update();
		}
		
		protected override function get maxHealth():Number { return MaxHealth; }
	}
}