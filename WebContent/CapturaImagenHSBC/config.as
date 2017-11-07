package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    public class config extends Sprite {

        public function config() {
			trace("inizializo");
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.ACTIVATE, activateHandler);
            stage.addEventListener(Event.RESIZE, resizeHandler);
        }

        private function activateHandler(event:Event):void {
            trace("activateHandler: " + event);
        }

        private function resizeHandler(event:Event):void {
            trace("resizeHandler: " + event);
            trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
        }
    }
}