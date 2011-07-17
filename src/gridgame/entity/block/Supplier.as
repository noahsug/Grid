package gridgame.entity.block
{
import gridgame.Currency;

import org.flixel.FlxG;

public class Supplier extends Block
{
	[Embed(source="./assets/supplier.png")] private var SupplierImg:Class;
	
	private static const IncomeRate:Number = 2;
	
	private var _currency:Currency;
	private var _currencyTimer:Number;
	
	public function Supplier()
	{
		super(SupplierImg);
		_currencyTimer = 0;
	}
	
	public function setCurrency(currency:Currency):void
	{
		_currency = currency;
	}
	
	public override function update():void
	{
		_currencyTimer += FlxG.elapsed;
		if (_currencyTimer > IncomeRate)
		{
			_currency.value++;
			_currencyTimer = 0;
		}
	}
}
}