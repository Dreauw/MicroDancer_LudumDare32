package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Conveyor extends Entity
	{
		private var uppperPart:Backdrop;
		private var middlePart:Backdrop;
		private var lowerPart:Backdrop;
		
		public function Conveyor() 
		{
			super(0, 0);
			uppperPart = new Backdrop(Assets.CONVEYOR_TOP, true, false);
			middlePart = new Backdrop(Assets.CONVEYOR_MID, true, false);
			lowerPart = new Backdrop(Assets.CONVEYOR_BOT, true, false);
			uppperPart.scrollX = 0;
			middlePart.scrollX = 0;
			lowerPart.scrollX = -0.5;
			middlePart.y = uppperPart.height;
			lowerPart.y = middlePart.height + uppperPart.height;
			
			this.y = FP.screen.height / FP.screen.scale - uppperPart.height - lowerPart.height - middlePart.height;
			
			addGraphic(uppperPart);
			addGraphic(middlePart);
			addGraphic(lowerPart);
			this.layer = 1;
		}
		
	}

}