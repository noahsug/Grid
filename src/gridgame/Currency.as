package gridgame
{
import gridgame.entity.block.Supplier;
import gridgame.entity.block.Turret;
import gridgame.entity.block.Wall;

public class Currency
{
	private var _value:int;
	private var _isDirty:Boolean;
	
	public function Currency()
	{
		_value = 0;
		_isDirty = true;
	}
	
	public function get isDirty():Boolean { return _isDirty; }
	public function set isDirty(b:Boolean):void { _isDirty = b; }
	
	public function get value():int { return _value; }
	public function set value(value:int):void
	{
		if (_value != value) _isDirty = true;
		_value = value;
	}
	
	public function canAfford(Block:Class):Boolean
	{
		return _value >= getCost(Block);
	}
	
	public function buy(Block:Class):void
	{
		value -= getCost(Block);
	}
	
	private function getCost(Block:Class):int
	{
		if (Block == Wall) return 2;
		if (Block == Turret) return 3; // 5
		if (Block == Supplier) return 5; // 10
		return 0;
	}
}
}