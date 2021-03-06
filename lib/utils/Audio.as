package utils 
{
	import net.flashpunk.Sfx;
	import as3sfxr.SfxrSynth;
	import org.si.sion.SiONDriver;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Audio  {
		private static var sfx : Sfx;
		private static var synth:Object = { };
		private static var stopped:Boolean = false;
		private static var muted:Boolean = false;
		private static var sionDriver:SiONDriver;

		static public function playMusic(file : Class, loop : Boolean = true):void {
			if (sfx) sfx.stop();
			sfx = new Sfx(file);
			loop ? sfx.loop() : sfx.play()
			if (stopped) sfx.stop();
		}

		static public function registerSound(str:String, settings:String, cache:Boolean = true):void {
			if (synth[str]) return;
			var tmp:SfxrSynth = new SfxrSynth;
			tmp.params.setSettingsString(settings);
			if (cache) tmp.cacheSound();
			synth[str] = tmp;
		}

		static public function playSound(str:String):void {
			if (stopped) return;
			if (synth[str]) synth[str].play();
		}

		static public function stop():void {
			if (sfx) sfx.stop()
			if (sionDriver) sionDriver.volume = 0;
			stopped = true;
		}

		static public function resume():void {
			if (muted) return;
			if (sfx) sfx.resume();
			if (sionDriver) sionDriver.volume = 1;
			stopped = false;
		}
		
		static public function mute():void {
			muted = !muted;
			(stopped) ? resume() : stop()
		}
		
		
		static public function getDriver():SiONDriver {
			if (sionDriver == null) {
				sionDriver = new SiONDriver();
			}
			return sionDriver;
		}

	}

}