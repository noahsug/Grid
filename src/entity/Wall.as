package entity
{
public class Wall extends Entity
{
	[Embed(source="./assets/wall.png")] private var WallImg:Class;
	
	public function Wall()
	{
		super(WallImg);
	}		
}
}