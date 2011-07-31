package gridgame.entity.moving
{
	import gridgame.entity.Entity;
	import gridgame.level.Space;
	
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
			movementBehavior = new PathFollowMovementBehavior(this);
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
		
		public override function update():void
		{
			if (hitObject && ((PathFollowMovementBehavior) (movementBehavior)).stuckOnBlock) {
				var space:Space = getSpaceInFront();
				if (space && space.allowCollisions && space.block)
					space.block.hurt(10);//1 * FlxG.elapsed);
			}
			super.update();
		}
		
		public function followTarget(target:Entity):void
		{
			_target = target;
			((PathFollowMovementBehavior) (movementBehavior)).setTarget(_target);
		}
		
		protected override function get maxHealth():Number { return MaxHealth; }
	}
}