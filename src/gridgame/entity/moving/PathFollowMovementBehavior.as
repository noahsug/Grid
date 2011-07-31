package gridgame.entity.moving
{
import gridgame.entity.Entity;
import gridgame.level.Level;

import org.flixel.*;

public class PathFollowMovementBehavior extends MovementBehavior
{	
	private static const DistanceToPathTimeRelationship:Number = .01;
	private static const DistanceToPathTimeDampener:Number = .3;

	private var _updatePathTimer:Number = 0;
	private var _target:Entity;
	private var _simpleMovementBehavior: SimpleFollowMovementBehavior;
	
	public function PathFollowMovementBehavior(entity:MovingEntity)
	{
		super(entity);
		_simpleMovementBehavior = new SimpleFollowMovementBehavior(entity);
	}

	public function get stuckOnBlock(): Boolean { return _entity.path == null; }
	
	public function setTarget(target:Entity):void
	{
		_target = target;
		_simpleMovementBehavior.setTarget(_target);
	}
	
	public override function setSpeed(speed:Number):void
	{
		super.setSpeed(speed);
		_simpleMovementBehavior.setSpeed(speed);
	}
	
	public override function setLevel(level:Level):void
	{
		super.setLevel(level);
		_simpleMovementBehavior.setLevel(level);
	}
	
	public override function update():void
	{		
		if (_updatePathTimer <= 0 || (_entity.pathSpeed == 0 && _entity.path)) 
		{
			updatePath();
			if (_entity.path == null)
				_updatePathTimer = 1;
			else
				_updatePathTimer = DistanceToPathTimeDampener + FlxU.getDistance(_entity.midpoint, _target.midpoint) * DistanceToPathTimeRelationship;
		}
		else
		{
			_updatePathTimer -= FlxG.elapsed;
		}
		
		if (_entity.path == null)
		{
			_simpleMovementBehavior.update();
		}
	}		
	
	private function updatePath():void
	{
		_entity.velocity.x = _entity.velocity.y = 0;
		if (_target == null) return;
		
		_entity.path = _level.findPath(_entity.midpoint, _target.midpoint);
		if (_entity.path != null) { 
			_entity.followPath(_entity.path, _speed, FlxObject.PATH_FORWARD, true);
		}
	}
}
}