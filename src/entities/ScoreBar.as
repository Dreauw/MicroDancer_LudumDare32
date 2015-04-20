package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.FP;
	import utils.SyParticle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class ScoreBar extends Entity
	{
		private var back:Image;
		private var front:Image;
		private var widthGoal:Number;
		
		public function ScoreBar() {
			super(0, 0);
			back = new Image(Assets.SCORE_BAR, new Rectangle(0, 0, 80, 10));
			front = new Image(Assets.SCORE_BAR, new Rectangle(0, 10, 72, 4));
			
			back.scrollX = front.scrollX = 0;
			front.x = 4;
			front.y = 3;
			
			this.x = ((FP.screen.width / FP.screen.scale) - back.width) / 2;
			this.y = 3;
			addGraphic(back);
			addGraphic(front);
			setBarLevel(0, false);
		}
		
		
		private function setGraphicBarLevel(level:Number):void {
			front.clipRect.width = level / 100 * front.width;
			front.updateBuffer(true);
		}
		
		public function getBarLevel():Number {
			return (front.clipRect.width / front.width * 100);
		}
		
		public function setBarLevel(level:Number, smooth:Boolean = true):void {
			if (!this.visible) return;
			
			if (smooth) {
				widthGoal = level;
			} else {
				setGraphicBarLevel(level);
				widthGoal = level;
			}
		}
		
		override public function update():void {
			super.update();
			var actual:Number = getBarLevel();
			var diff:Number = widthGoal - actual;
			if (Math.abs(diff) > 1) {
				setGraphicBarLevel(actual + (FP.elapsed * 10 * diff));
			}
		}
		
		
		public function explose():void {
			var nbColors:int = 14;
			var subPart:int = front.width / nbColors;
			
			for (var i:int = 0; i < nbColors; ++i) {
				SyParticle.emit("p" + i, FP.camera.x + this.x + 6 + subPart * i, this.y + 8, 5);
			}
			
			setBarLevel(0, false);
		}
		
	}

}