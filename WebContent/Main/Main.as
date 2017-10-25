package{
    import fl.events.ColorPickerEvent;
	import flash.events.MouseEvent;
    import flash.display.MovieClip;
    import flash.external.ExternalInterface;
    public class Main extends MovieClip {
        public function Main() {
			 trace( "Yep, it's working" );
            cp.addEventListener(ColorPickerEvent.CHANGE, colorChange);
			change.addEventListener(MouseEvent.CLICK, pruebaMain);
        }
         
        public function colorChange(event:ColorPickerEvent):void {
			trace("InicioCOLORCHANGE");
			ExternalInterface.call("console.log", "YourString");
            ExternalInterface.call("receiveColor", event.target.hexValue);  //calls receiveColor(event.target.hexValue) in the javascript
        }
		 public function pruebaMain(event:MouseEvent):void {
			trace("InicioCOLORCHANGE");
			ExternalInterface.call("console.log", "YourString");
        }
    }
}