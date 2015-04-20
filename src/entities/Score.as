package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Score extends Entity
	{
		private var text:Text;
		private var score:uint = 0;
		
		public function Score() {
			super(0, 0);
			text = new Text(score.toString(), 0, 0, {outlineColor:0x222222, outlineSize:2, size:8});
			text.scrollX = 0;
			
			this.layer = 10;
		
			this.graphic = text;
			this.x = ((FP.screen.width / FP.screen.scale) - text.width) / 2;
			this.y = 14;
		}
		
		public function add(toAdd:int) : void {
			score += toAdd;
			text.text = score.toString();
			this.x = ((FP.screen.width / FP.screen.scale) - text.width) / 2;
		}
		
		public function getValue(): uint {
			return score;
		}
		
	}

}