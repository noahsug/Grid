package gridgame.entity.moving
{
import gridgame.entity.Entity;

import org.flixel.FlxPoint;
import org.flixel.FlxU;

public class SimpleFollowMovementBehavior extends MovementBehavior
{
	private var _target:Entity;
	private var _direciton: FlxPoint = new FlxPoint();	
	
	public function SimpleFollowMovementBehavior(entity:MovingEntity)
	{
		super(entity);
	}
	
	public function setTarget(target:Entity):void
	{
		_target = target;
	}
	
	public override function update():void
	{		
		_entity.angle = FlxU.getAngle(_entity.midpoint, _target.midpoint);
		FlxU.rotatePoint(_speed, 0, 0, 0, _entity.angle - 90, _entity.velocity);
	}
	
	private function getDirection():void
	{		
		var dif :Number = _entity.midpoint.x - _target.midpoint.x;		
		if (dif > (_target.width + _entity.width) / 2)
			_direciton.x = -1;
		else if (dif < -(_target.width + _entity.width) / 2)
			_direciton.x = 1;
		else
			_direciton.x = 0;
		
		dif = _entity.midpoint.y - _target.midpoint.y;		
		if (dif > (_target.height + _entity.height) / 2)
			_direciton.x = -1;
		else if (dif < -(_target.height + _entity.height) / 2)
			_direciton.x = 1;
		else
			_direciton.x = 0;
	}
}
}