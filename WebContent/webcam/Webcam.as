package 
{
    import com.adobe.images.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.utils.*;

    public class Webcam extends Sprite
    {
        private var video:Video;
        private var video_width:int;
        private var video_height:int;
        private var dest_width:int;
        private var dest_height:int;
        private var camera:Camera;
        private var bmpdata:BitmapData;
        private var jpeg_quality:int;
        private var image_format:String;
        private var fps:int;
        private var flip_horiz:Boolean;

        public function Webcam()
        {
            Security.allowDomain("*");
            var _loc_1:* = LoaderInfo(this.root.loaderInfo).parameters;
            this.video_width = Math.floor(_loc_1.width);
            this.video_height = Math.floor(_loc_1.height);
            this.dest_width = Math.floor(_loc_1.dest_width);
            this.dest_height = Math.floor(_loc_1.dest_height);
            this.jpeg_quality = Math.floor(_loc_1.jpeg_quality);
            this.image_format = _loc_1.image_format;
            this.fps = Math.floor(_loc_1.fps);
            this.flip_horiz = _loc_1.flip_horiz == "true";
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.stageWidth = Math.max(this.video_width, this.dest_width);
            stage.stageHeight = Math.max(this.video_height, this.dest_height);
            if (_loc_1.new_user)
            {
                Security.showSettings(SecurityPanel.PRIVACY);
            }
            var _loc_2:int = -1;
            var _loc_3:* = 0;
            var _loc_4:* = Camera.names.length;
            while (_loc_3 < _loc_4)
            {
                
                if (Camera.names[_loc_3] == "USB Video Class Video")
                {
                    _loc_2 = _loc_3;
                    _loc_3 = _loc_4;
                }
                _loc_3 = _loc_3 + 1;
            }
            if (_loc_2 > -1)
            {
                this.camera = Camera.getCamera(String(_loc_2));
            }
            else
            {
                this.camera = Camera.getCamera();
            }
            if (this.camera != null)
            {
                this.camera.addEventListener(ActivityEvent.ACTIVITY, this.activityHandler);
                this.camera.addEventListener(StatusEvent.STATUS, this.handleCameraStatus, false, 0, true);
                this.video = new Video(Math.max(this.video_width, this.dest_width), Math.max(this.video_height, this.dest_height));
                this.video.attachCamera(this.camera);
                addChild(this.video);
                if (this.video_width < this.dest_width && this.video_height < this.dest_height)
                {
                    this.video.scaleX = this.video_width / this.dest_width;
                    this.video.scaleY = this.video_height / this.dest_height;
                }
                if (this.flip_horiz)
                {
                    this.video.scaleX = this.video.scaleX * -1;
                    this.video.x = this.video.width + this.video.x;
                }
                this.camera.setQuality(0, 100);
                this.camera.setKeyFrameInterval(10);
                this.camera.setMode(Math.max(this.video_width, this.dest_width), Math.max(this.video_height, this.dest_height), this.fps);
                this.camera.setMotionLevel(1);
                ExternalInterface.addCallback("_snap", this.snap);
                ExternalInterface.addCallback("_configure", this.configure);
                ExternalInterface.addCallback("_releaseCamera", this.releaseCamera);
                ExternalInterface.call("Webcam.flashNotify", "flashLoadComplete", true);
            }
            else
            {
                trace("You need a camera.");
                ExternalInterface.call("Webcam.flashNotify", "error", "No camera was detected.");
            }
            return;
        }// end function

        public function configure(param1:String = "camera")
        {
            Security.showSettings(param1);
            return;
        }// end function

        private function activityHandler(event:ActivityEvent) : void
        {
            trace("activityHandler: " + event);
            ExternalInterface.call("Webcam.flashNotify", "cameraLive", true);
            this.camera.setMotionLevel(100);
            return;
        }// end function

        private function handleCameraStatus(event:StatusEvent) : void
        {
            switch(event.code)
            {
                case "Camera.Muted":
                {
                    trace("Camera not allowed");
                    ExternalInterface.call("Webcam.flashNotify", "error", "Access to camera denied");
                    break;
                }
                case "Camera.Unmuted":
                {
                    trace("Camera allowed");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function snap()
        {
            var _loc_1:ByteArray = null;
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:JPGEncoder = null;
            trace("in snap(), drawing to bitmap");
            this.bmpdata = new BitmapData(Math.max(this.video_width, this.dest_width), Math.max(this.video_height, this.dest_height));
            this.bmpdata.draw(this.video);
            if (this.video_width > this.dest_width && this.video_height > this.dest_height)
            {
                _loc_4 = new BitmapData(this.dest_width, this.dest_height);
                _loc_5 = new Matrix();
                _loc_5.scale(this.dest_width / this.video_width, this.dest_height / this.video_height);
                _loc_4.draw(this.bmpdata, _loc_5, null, null, null, true);
                this.bmpdata = _loc_4;
            }
            trace("converting to " + this.image_format);
            if (this.image_format == "png")
            {
                _loc_1 = PNGEncoder.encode(this.bmpdata);
            }
            else
            {
                _loc_6 = new JPGEncoder(this.jpeg_quality);
                _loc_1 = _loc_6.encode(this.bmpdata);
            }
            trace("raw image length: " + _loc_1.length);
            var _loc_2:* = new Base64Encoder();
            _loc_2.encodeBytes(_loc_1);
            var _loc_3:* = _loc_2.toString();
            trace("b64 string length: " + _loc_3.length);
            return _loc_3;
        }// end function

        public function releaseCamera()
        {
            trace("in releaseCamera(), turn off camera");
            this.video.attachCamera(null);
            this.video.clear();
            this.camera = null;
            removeChild(this.video);
            return;
        }// end function

    }
}
