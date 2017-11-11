package{
	
import flash.display.MovieClip;
import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;
import flash.display.Stage; 
import flash.display.Sprite;
import flash.display.StageAlign; 
import flash.display.StageScaleMode; 
import flash.display.StageDisplayState;
import flash.events.Event; 	
import flash.events.MouseEvent;
import flash.events.StatusEvent;
import flash.external.*;
import flash.media.*;
import flash.display.*;
import 	flash.geom.Point;
import 	flash.display.BitmapData;
import flash.net.FileReference;
import flash.text.TextField;
import flash.utils.ByteArray;
import mx.utils.Base64Encoder;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.filters.BitmapFilterQuality; 
import flash.filters.GlowFilter; 
import flash.display.Sprite; 
import flash.events.ActivityEvent;

	public class Main extends Sprite
	{
		private var idCamara:int= new int(0);
		private var camara:Camera;
		private var vid:Video;
		private var referencia:FileReference=new FileReference();
		private var base:Base64Encoder = new Base64Encoder();
		private var camaraActiva:Boolean=false;
		private var camSelected:uint=0;//Camara default
		private var movCam:uint=50;//Cantidad de movimiento considerada como activo
		private var timeCam:uint=3000;//tiempo en el que se deve detectar el movimiento captado
		private var widthCam:int=1280;//ancho de lacamara
		private var heightCam:int=720; //alto de la camara
		private var fpsCam:uint=30;//velocidad de la camara
		private var logsVerbose:uint=1;//Activa Trace de Logs
		private var autophoto:uint=0;
		
		public function Main():void
		{
			if(Camera.names.length > 0) 
			{
				autoConfig();
				ExternalInterface.call("flashReady", true);
				initConfigExt();
				addListeners();
				addListenersExt();
				readyCamera();
			}
			else{
				myTrace("Camaras no conectadas");
				ExternalInterface.call("receiveMessage", "Camaras no conectadas");
			}
		}
		public function autoConfig():void{
			var keyStr:String;
			var valueStr:String;
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;   //set the paramObj variable to the parameters property of the LoaderInfo object
			for (keyStr in paramObj) 
			{
				valueStr = String(paramObj[keyStr]);
				
				if(keyStr=="camSelected"){
					camSelected=int(valueStr);
				};//Camara default
				if(keyStr=="movCam"){
					movCam=int(valueStr);
				};//Camara default
				//Cantidad de movimiento considerada como activo
				if(keyStr=="timeCam"){
					timeCam=int(valueStr);
				};//tiempo en el que se deve detectar el movimiento captado
				if(keyStr=="widthCam"){
					widthCam=int(valueStr);
				};//ancho de lacamara
				if(keyStr=="heightCam"){
					heightCam=int(valueStr);
				};//alto de la camara
				if(keyStr=="fpsCam"){
					fpsCam=int(valueStr);
				};//velocidad de la camara
				if(keyStr=="logsVerbose"){
					logsVerbose=int(valueStr);
				};
				if(keyStr=="autophoto"){
					autophoto=int(valueStr);
				};
				myTrace("\t" + keyStr + ":\t" + valueStr + "\n");  
			}
		}

		public function addListeners()
		{
			//myTrace("Iniciando Listeners Botones");
			//botones.capturaImagen.addEventListener(MouseEvent.CLICK,saveImage);
			//botones.stopCam.addEventListener(MouseEvent.CLICK,stopCam);
			//botones.changeCam.addEventListener(MouseEvent.CLICK,changeCam);
			//botones.inicia.addEventListener(MouseEvent.CLICK,initConfig);
		}
	
		public function addListenersExt():void
		{ 
			//myTrace("Iniciando Listeners Externos" + "_saveImage" +"_stopCam" + "_changeCam");			
			ExternalInterface.addCallback("_saveImage", saveImageExt);
			ExternalInterface.addCallback("_setConfig", setConfigs);
			ExternalInterface.addCallback("_initCam", initConfigExt);
			ExternalInterface.addCallback("_stopCam", stopCamExt);
			ExternalInterface.addCallback("_changeCam", changeCamExt);
		}

		public function setConfigs(camSelectedX:uint,movCamX:uint,timeCamX:uint,widthCamX:uint,heightCamX:uint,fpsCamX:uint,logsVerboseX:uint,autophotoX:uint)
		{
			camSelected=camSelectedX;//Camara default
			movCam=movCamX;//Cantidad de movimiento considerada como activo
			timeCam=timeCamX;//tiempo en el que se deve detectar el movimiento captado
			widthCam=widthCamX;//ancho de lacamara
			heightCam=heightCamX; //alto de la camara
			fpsCam=fpsCamX;//velocidad de la camara
			logsVerbose=logsVerboseX//Activa Trace de Logs
			autophoto=autophotoX;
			myTrace("camSelected:"+camSelected+" movCam:"+movCam+" timeCam:"+timeCam+" widthCam:"+widthCam+" heightCam"+heightCam+" fpsCam:"+fpsCam+" logsVerbose:"+logsVerbose+" autophoto:"+autophoto);
			initConfigExt();
			}
		
		private function activateHandler(event:Event):void
		{
           // myTrace("activateHandler" + event);
        }
		
		 private function resize(){
			 vid.scaleX=stage.stageWidth/widthCam;
			vid.scaleY=stage.stageHeight/heightCam;
			 
			 myTrace("scaleX=" + stage.stageWidth+"-"+widthCam +" = "+ vid.scaleX);
			myTrace( "scaleY=" + stage.stageHeight+"-"+heightCam+"="+vid.scaleY);
		  
			vid.width = stage.stageWidth; 
            vid.height = stage.stageHeight;
			myTrace("vid.height:"+vid.height+" vid.width:"+vid.width);
			addChildAt(vid, 0);
			}
		/***Listener Para detectar un evento de resize***/
        private function resizeHandler(event:Event):void 
		{
			resize();
		}
		
	public function initConfig(event:Event):void
	{
		initConfigExt();
	}
		
		
		
		/***Inicializo la camra***/
		public function initConfigExt():void
		{
			myTrace("Cofiguro Video");
			vid= new Video(widthCam,heightCam);
		    camara = Camera.getCamera( String(camSelected) );			
			camara.setMode(widthCam,heightCam,fpsCam);
			camara.setMotionLevel(movCam, timeCam);
			if(autophoto==1)
            camara.addEventListener(ActivityEvent.ACTIVITY, activityHandlerCam);
			camaraActiva=true;
			myTrace("Camara:"+ camara.name+"  heightCam:"+heightCam+"  widthCam:"+widthCam+"  Activa:"+camaraActiva+"  AnchoCam:"+camara.width + "  AlturaCam:" + camara.height+"  Fotogramas:"+camara.fps+"  Ancho de Banda:"+camara.bandwidth);
			vid.attachCamera(null);	
			vid.attachCamera(camara);	
			resize();
			
			/**Resize Configs***/
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.ACTIVATE, activateHandler);
            stage.addEventListener(Event.RESIZE, resizeHandler);
		}
	
	/***Listener para campturar la imagen cuando no hay movimiento***/
		private function activityHandlerCam(e:ActivityEvent):void
		{
			if (e.activating == true){
				myTrace("Digitalizando");
			}else{
				if(camaraActiva && autophoto==1){
					myTrace("Enfocado Toma fOTO");
					saveImageExt();
					ExternalInterface.call("captureAuto", "true");
				}
			}    
		}
		
		
	public function myTrace(str:String):void
	{
		if(logsVerbose==1){
			trace(str);
			ExternalInterface.call("console.log",str);
		}
		}
		
	 public function readyCamera() : Boolean
	{
		var resp:Boolean;		
		if(this.camara==null){
				initConfigExt();
		}
		else{
			if(this.camara.muted){
				myTrace("Solicitando Permisos");
				Security.showSettings(SecurityPanel.PRIVACY);
		   }
		}
		return resp;
	}
		
	
 	public function stopCam(event:Event):void{
		stopCamExt();
	}

    public function stopCamExt():void{
		camaraActiva=false;
		vid.attachCamera(null);	
			
	}

	
	/**Funcion que utiliza el boton interno para invocar el cambio de camar**/
	public function changeCam(event:MouseEvent):void
	{
	changeCamExt();
	}
	
	/**Funcion para intercambiar las camaras***/
	public function changeCamExt():void{
		myTrace("Total Camaras"+Camera.names.length + " Camera Actual"+ Camera.getCamera(String(camSelected)).name);
		if(Camera.names.length==1){
	    	ExternalInterface.call("receiveMessage", "Solo se detecto una Camara");
		}
		else{
			stopCamExt();
			if(Camera.names.length-1>0 && camSelected<Camera.names.length-1){
		    	camSelected = camSelected+1;
				initConfigExt();
				myTrace("Camara Seleccionada:"+Camera.getCamera(String(camSelected)).name);
			}
			else{
	    		camSelected=0;
				myTrace("Camara Principal:"+ Camera.getCamera(String(camSelected)).name);
				initConfigExt();
			}
		}
		readyCamera();
	}
	
	

	/**Guarda la imagen en Archivo**/
	public function saveImage(event:MouseEvent):void
	{	
		
		if(this.camara.muted){
			myTrace("Solicito Permisos");
			readyCamera();
		}else if(camaraActiva){
			saveImageExt();
    		var bitmapData:BitmapData=new BitmapData(widthCam, heightCam);
			bitmapData.draw(vid);  
			var byteArray:ByteArray ;
			//var jpgEncoder:JPGEncoder = new JPGEncoder(100);
			//byteArray= jpgEncoder.encode(bitmapData);
			byteArray = PNGEncoder.encode(bitmapData);			
			var strBase:String;
			base.encodeBytes(byteArray,0,byteArray.length);
			strBase=base.toString();
			myTrace("Tamaño :"+ (strBase.length/1024)/1024+ "MB");
			var fileReference:FileReference=new FileReference();
		    fileReference.save(byteArray, ".png");	
			stopCamExt();
		}else{
			myTrace("Camara inactiva");
		}
		
	}

	/**Prepara y envia la imagen en base64 al Front javascript***/
	public function saveImageExt():void
	{
		if(this.camara.muted){
			myTrace("Solicito Permisos");
			readyCamera();
		}else if(camaraActiva){
    		var bitmapData:BitmapData=new BitmapData(widthCam, heightCam);
			bitmapData.draw(vid);  
			var byteArray:ByteArray ;
			//var jpgEncoder:JPGEncoder = new JPGEncoder(100);
			//byteArray= jpgEncoder.encode(bitmapData);
			byteArray = PNGEncoder.encode(bitmapData);			
			var strBase:String;
			base.insertNewLines=false;
			base.encodeBytes(byteArray,0,byteArray.length);
			strBase=base.toString();
			myTrace("Tamaño :"+ (strBase.length/1024)/1024+ "MB");
			ExternalInterface.call("receiveImage", strBase);
			stopCamExt();
		}else{
			myTrace("Camara inactiva");
		}
	}



	} //fin clase
	
} //fin pakage
