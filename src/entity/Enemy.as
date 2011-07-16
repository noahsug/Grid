package entity
{
	import org.flixel.*;
	
	public class Enemy extends Entity
	{
		[Embed(source="./assets/enemy.png")] private var EntityImg:Class;
		
		private static const DistanceToPathTimeRelationship:Number = .05;
		private static const DistanceToPathTimeDampener:int = 5;
		private static const Speed:Number = 5;
		
		private var _updatePathTimer:Number = 0;
		private var _target:Entity;
		
		public function Enemy()
		{
			super(EntityImg);
		}
		
		public function followTarget(target:Entity):void
		{
			_target = target;
		}				
		
		public override function update():void
		{
			handleMovement();			
			super.update();
		}
		
		private function handleMovement():void
		{
			if (_updatePathTimer <= 0) 
			{
				updatePath();
				_updatePathTimer = (path.nodes.length + DistanceToPathTimeDampener) * DistanceToPathTimeRelationship;
			}
			else
			{
				_updatePathTimer -= FlxG.elapsed;
			}
		}
		
		private function updatePath():void
		{
			velocity.x = velocity.y = 0;
			if (_target == null) return;
			
			path = _level.findPath(position, _target.position);
			if (path == null) path = new FlxPath(new Array(position));
			followPath(path, Speed, PATH_FORWARD, true);
		}
	}
}