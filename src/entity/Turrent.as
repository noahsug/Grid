package entity
{

public class Turrent extends Entity
{
	[Embed(source="./assests/turrent.png")] private var TurrentImg:Class;
	
	public function Turrent()
	{
		super(TurrentImg);
	}
	
	public function update()
	{
		
	}
}
}