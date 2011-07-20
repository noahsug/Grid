package gridgame.entity.moving
{
import gridgame.entity.Entity;

import org.flixel.*;

public class FollowMovementBehavior extends MovementBehavior
{	
	private static const DistanceToPathTimeRelationship:Number = .01;
	private static const DistanceToPathTimeDampener:Number = .3;

	private var _updatePathTimer:Number = 0;
	private var _target:Entity;
	
	public function FollowMovementBehavior(entity:MovingEntity)
	{
		super(entity);
	}
	
	public function setTarget(target:Entity):void
	{
		_target = target;
	}
	
	public override function update():void
	{		
		if (_updatePathTimer <= 0 || _entity.pathSpeed == 0) 
		{
			updatePath();			
			_updatePathTimer = DistanceToPathTimeDampener + FlxU.getDistance(_entity.midpoint, _target.midpoint) * DistanceToPathTimeRelationship;
		}
		else
		{
			_updatePathTimer -= FlxG.elapsed;
		}
	}		
	
	private function updatePath():void
	{
		_entity.velocity.x = _entity.velocity.y = 0;
		if (_target == null) return;
		
		_entity.path = _level.findPath(_entity.midpoint, _target.midpoint);
		if (_entity.path == null) _entity.path = new FlxPath(new Array(_entity.midpoint));		
		_entity.followPath(_entity.path, _speed, FlxObject.PATH_FORWARD, true);
	}
}
}