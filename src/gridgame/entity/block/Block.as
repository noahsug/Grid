package gridgame.entity.block
{
import gridgame.entity.Entity;

import org.flixel.FlxEmitter;

public class Block extends Entity
{
	public function Block(Img:Class=null)
	{		
		super(Img);
	}
	
	protected override function get maxHealth():Number { return 2; }
	
	public override function hurt(Damage:Number):void
	{
		health -= Damage;
		if (health <= 0)
		{
			_level.getClosestSpace(midpoint).removeBlock();
		}
	}
}
}