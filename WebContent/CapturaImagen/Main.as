package{
	
import flash.display.MovieClip;
import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;
import flash.display.Stage; 
import flash.display.StageAlign; 
import flash.display.StageScaleMode; 
import flash.display.StageDisplayState;
import flash.events.Event; 	
import flash.events.MouseEvent;
import flash.external.*;
import flash.media.*;
import 	flash.display.BitmapData;
import flash.net.FileReference;
import flash.text.TextField;
import flash.utils.ByteArray;
import mx.utils.Base64Encoder;

	

	 
public class Main extends MovieClip{

	private var idCamara:int= new int(0);
	private var camara:Camera= Camera.getCamera(String(Camera.names.length-1));
	private var vid:Video=new Video(stage.stageWidth,stage.stageHeight);
	private var referencia:FileReference=new FileReference();
	private var base:Base64Encoder = new Base64Encoder();

	trace("Inicia Camara");
	public function Main():void{
		addListeners();
		addListenersExt();
		trace("total de camaras" + Camera.names.length);
		ExternalInterface.call("console.log","total de camaras" + Camera.names.length);
		ExternalInterface.call("console.log","Ancho:"+camara.width + " Altura:" + camara.height+" Fotogramas:"+camara.fps+" Ancho de Banda:"+camara.bandwidth);
		if (Camera.names.length > 0) 
			{ 
				ExternalInterface.call("console.log","User has at least one camera installed."+Camera.names); 
				vid.rotation = 0;
				//vid.smoothing=true;
				camara.setQuality(0,0);	
				camara.setMode(1280,960,30)
				vid.attachCamera(camara);	
				//vid.attachCamera(null);
				//vid.x=	stage.stageWidth/2-vid.width/2;
				//vid.y=50;
				vid.x=0;
				vid.y=0;
				addChildAt(vid, 0);

			} 
		else 
			{ 
				ExternalInterface.call("console.log","User has no cameras installed."); 
			}
	}


	public function addListeners()
	{
		botones.capturaImagen.addEventListener(MouseEvent.CLICK,saveImage);
		botones.girar.addEventListener(MouseEvent.CLICK,girarCamara);
		botones.cambiar.addEventListener(MouseEvent.CLICK,cargaCamara);
		botones.inicia.addEventListener(MouseEvent.CLICK,iniciaPantalla);
		botones.resize.addEventListener(Event.RESIZE, resizeDisplay);

	}
	
	public function addListenersExt():void
		{ 
			ExternalInterface.addCallback("_saveImageExt", saveImageExt);
		    //ExternalInterface.addCallback("_startRecord", startRecordingExt);
			//ExternalInterface.addCallback("_stopRecord", stopRecordingExt);
			//ExternalInterface.addCallback("_startPlaying", startPlayingExt);
			
		}

	public function resizeDisplay(event:Event):void 
	{ 
		var swfStage:Stage = stage; 
		//swfStage.scaleMode = StageScaleMode.NO_SCALE; 
		swfStage.align = StageAlign.TOP_LEFT; 
		ExternalInterface.call("console.log","resize"+ swfStage.stageWidth+"-"+swfStage.stageHeight);
		vid=new Video(swfStage.stageWidth,swfStage.stageHeight);
		vid.scaleX = vid.scaleY; 
		addChildAt(vid, 0);
		ExternalInterface.call("console.log", "resize"+ swfStage.stageWidth+"-"+swfStage.stageHeight);     
    // Reposition the control bar. 
	}
 

public function iniciaPantalla(event:MouseEvent):void{
	ExternalInterface.call("console.log", "PantallaCompleta");
	//stage.scaleMode =StageScaleMode.NO_SCALE;
	stage.displayState=StageDisplayState.FULL_SCREEN; 
    vid=new Video(1280,508);
	
	addChildAt(vid, 0);
	ExternalInterface.call("console.log", "size"+stage.stageWidth+"-"+stage.stageHeight);

	}

public function cargaCamara(event:MouseEvent):void{
	ExternalInterface.call("console.log", "CargaCamara" + idCamara.toString());
	camara= Camera.getCamera(idCamara.toString(2));
	camara.setQuality(0,100);	
	//vid=new Video(320,240);
	//vid.smoothing=true;
	vid.attachCamera(camara);	
	//vid.x=	stage.stageWidth/2-vid.width/2;
	//vid.y=50;
    addChildAt(vid, 0);
	
	trace(String(idCamara));
	if(idCamara>0){
    idCamara=idCamara-1;
		}else{
		 idCamara=Camera.names.length-1;
			}
	}
	
public function girarCamara(event:MouseEvent):void
	{
	trace(idCamara.toString(2));
	camara= Camera.getCamera("0");
	camara.setQuality(0,100);	
	//vid=new Video(320,240);
	//vid.smoothing=true;
		
	vid.attachCamera(camara);
	
    addChildAt(vid, 0);
	idCamara=new int(1);
	}
	


public function saveImage(event:MouseEvent):void
{
	
	saveImageExt();
	/*var bitmapData:BitmapData=new BitmapData(vid.width, vid.height);
	bitmapData.draw(vid);  
	//
	var jpgEncoder:JPGEncoder = new JPGEncoder(100);
	var byteArray:ByteArray = jpgEncoder.encode(bitmapData);

	byteArray = PNGEncoder.encode(bitmapData);
	
	var fileReference:FileReference=new FileReference();
	fileReference.save(byteArray, ".jpg"); 	
	*/
}

public function saveImageExt():String
		{
		
    var bitmapData:BitmapData=new BitmapData(vid.width, vid.height);
	bitmapData.draw(vid);  
	//
	var jpgEncoder:JPGEncoder = new JPGEncoder(100);
	var byteArray:ByteArray = jpgEncoder.encode(bitmapData);
	//byteArray = PNGEncoder.encode(bitmapData);			
	var strBase:String;
	base.encodeBytes(byteArray,0,byteArray.length);
	strBase=base.toString();
	trace(strBase);
			
			
	ExternalInterface.call("console.log", "tamaño..." + strBase.length);
    ExternalInterface.call("receiveImage", strBase);
	return strBase;
	
		
		}
	} //fin clase
	
} //fin pakage
