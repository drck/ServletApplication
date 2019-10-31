package 
{
	import flash.display.*;
	import flash.utils.Timer;
	import flash.utils.getTimer
	import flash.display.MovieClip;
	import flash.media.Microphone;
	import flash.system.Security;
	import org.bytearray.micrecorder.*;
	import org.bytearray.micrecorder.events.RecordingEvent;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.as3wavsound.WavSound;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.events.SampleDataEvent;
	import flash.events.Event;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import fl.controls.Button;
    import flash.text.TextField;
	import flash.external.*;
	import mx.utils.Base64Encoder;
	import flash.system.SecurityPanel;
	import flash.media.*;
	import flash.utils.ByteArray;

	public class MainSwf extends Sprite
	{
		private var mic:Microphone;
		private var waveEncoder:WaveEncoder = new WaveEncoder();
		private var base:Base64Encoder = new Base64Encoder();
		private var recorder:MicRecorder = new MicRecorder(waveEncoder);
		private var recBar:RecBar = new RecBar();
		private var recorded:WavSound;
		private var date = new Date();
		private var strAudio:String;
		private var recorded_once:Boolean = false;
		private var recording:Boolean = false;
		private var playing:Boolean = false;
		private var tiempo:uint = 0; 
		private var time:uint = 0; 
		private var minutos:uint = 0;
		private var segundos:uint = 0;
		private const MIN_LENGTH:uint=100;
		private var temporizador:Timer = new Timer(1000, 0);
		private var micSelect:uint=0;
		private var level_log:Boolean=true;
		private var xvol:Number=1;
		public var xgain:uint=50;
		private var xrate:Number=11;
		private var xnoise:Number=-15;
		private var xLogVerbose:Number=0;
		
		public function MainSwf():void
		{  
			recBar.status.text = "Iniciando Microfono..";
			autoConfig();
			addListenersPrin();
			//addListeners();
			addListenersExt();
			recBar.status.text = "Listo";
			addChild(recBar);
			isReadyExt();
		}
		
		public function autoConfig():void{
	
			var keyStr:String;
			var valueStr:String;
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;   //set the paramObj variable to the parameters property of the LoaderInfo object
			for (keyStr in paramObj) 
			{
				valueStr = String(paramObj[keyStr]);
				
				if(keyStr=="xvol"){
					xvol=int(valueStr);
				};//Volumen de reproduccion de audio
				if(keyStr=="xgain"){
					xgain=int(valueStr);
				};//Ganancia del microfono 50 default 100 amplificado
				if(keyStr=="xrate"){
					xrate=int(valueStr);
				};//Calidad de grabacion
				if(keyStr=="xnoise"){
					xnoise=int(valueStr);
				};//Reduccion de ruido
				if(keyStr=="xLogVerbose"){
					xLogVerbose=int(valueStr);
				};//Activar logs
				myTrace("\t" + keyStr + ":\t" + valueStr + "\n");  
			}
		}

		/***Inicializa los eventos de los 
		Botones par poder invocar las funciones
		Apartir de el objeto botones que esta en la biblioteca
		public function addListeners():void
		{   
		    botones.btn_ready.addEventListener(MouseEvent.MOUSE_UP, isReady);
			botones.btn_record.addEventListener(MouseEvent.MOUSE_UP, startRecording);
			botones.btn_stop_record.addEventListener(MouseEvent.MOUSE_UP, stopRecording);			
			botones.btn_play.addEventListener(MouseEvent.MOUSE_UP, startPlaying);
			botones.btn_stop_play.addEventListener(MouseEvent.MOUSE_UP, stopPlaying);
			botones.btn_changeMic.addEventListener(MouseEvent.MOUSE_UP,changeMicrophone);
			botones.btn_changeMic.addEventListener(MouseEvent.MOUSE_UP,changeMicrophone);
			botones.btn_save.addEventListener(MouseEvent.MOUSE_UP,saveRecording);
			
			
			
		}**/
		
		public function addListenersPrin():void
		{   
			recorder.addEventListener(RecordingEvent.RECORDING, disp_recording);
			recorder.addEventListener(Event.COMPLETE, recordComplete);
		}
		/*****
		Inicializa las llamadas deafuera del swf y define aque funcion
		invoka cada uno de los eventos externos****/
		public function addListenersExt():void
		{ 
			ExternalInterface.addCallback("_isReady", isReadyExt);
		    ExternalInterface.addCallback("_startRecord", startRecordingExt);
			ExternalInterface.addCallback("_stopRecord", stopRecordingExt);
			ExternalInterface.addCallback("_startPlaying", startPlayingExt);
			ExternalInterface.addCallback("_stopPlaying", stopPlayingExt);
			ExternalInterface.addCallback("_saveRecording", saveRecordingExt);
			ExternalInterface.addCallback("_changeMic", changeMicrophoneExt);
			ExternalInterface.addCallback("_setValues", setValuesExt);

		}
		

		public function setValuesExt(yvol:Number,ygain:Number,yrate:Number, ynoise:Number,logVerbose:Number):void 
		{ 
		this.xvol=yvol;
		this.xgain=ygain;
		this.xrate=yrate;
		this.xnoise=ynoise;
		this.xLogVerbose=logVerbose;
		myTrace("Valores Recividos Volumen:"+ yvol+" Ganancia:"+ygain+" Rate:"+yrate+" Noise:"+ynoise);
		myTrace("Valores Recividos Volumen:"+ xvol+" Ganancia:"+xgain+" Rate:"+xrate+" Noise:"+xnoise);
		}

		/***
		Metodo interno que ejecuta
		la funcion de grabado****/
		public function startRecording(e:MouseEvent):void
		{
		   startRecordingExt();
		}
		
		/***
		Inicia la grabacion
		del audio***/
		public function startRecordingExt():void
		{
			
			myTrace("startRecordingExt()");
			if (mic != null && !playing && !mic.muted)
			{
				if(!recording){
			    recBar.status.text = "Grabando..";
			    myTrace("Inicio Grabacion");
				recording = true;
				recorder.record();
			    
				}
			}else
			{
				ExternalInterface.call("objectNoReady", "true");
				myTrace("Microfono no Disponible Solicitando permisos de nuevo");
				isReadyExt();
			}
		
		}
		
		/**Metodo utilizado por el boton
		que ejecuta detener la grabacion***/
		public function stopRecording(e:MouseEvent):void
		{
			stopRecordingExt();
		}
    
 		/***Metodo para detener la grabacion****/
		public function stopRecordingExt():void
		{
			myTrace("stopRecordingExt");
			if(recording){
			myTrace("Deteniendo Grabacion");
			recBar.status.text = "Listo";
			recorder.stop();
			mic.setLoopBack(false);
			}
			else
				{
			recBar.status.text = "No hay Grabacion en curso";	
			}
			
			}

		/***Metodo que ejecuta el boton reproducir***/
		public function startPlaying(e:Event):void
		{
			startPlayingExt();
		}
		/***Metodo para reproducir el audio grabado***/
		public function startPlayingExt():void
		{
			myTrace("startPlayingExt()  recorded_once:" + recorded_once +" recording: "+ !recording);
			if(recorded_once && !recording ){
			if(!playing)
			{
				myTrace("Inicio Reproducion de Audio");
				recBar.status.text = "Listo";			
				playing = true;
				tiempo=1;
				time=Math.round(recorded.length/1000);
				temporizador=new Timer(1000,Math.round(recorded.length/1000));
				temporizador.addEventListener(TimerEvent.TIMER, disp_playing);
				temporizador.start();
				/**Controla el volumen de reproduccion**/
				var trans:SoundTransform; 
				trans = new SoundTransform(this.xvol, 0); 
				recorded.play(0,1,trans);
				
			}
		   }
			else
			{
				recBar.status.text = "No hay audio grabado";			
			}
		}
		
		/**Funcion que invoka el boton
		que invoka detener la reproduccion***/
		public function stopPlaying(e:Event):void
		{
			stopPlayingExt();
		}
		
		/***Funcion para detener la 
		reproduccion***/
		public function stopPlayingExt():void
		{
			myTrace("stopPlayingExt()");
			if(playing){
			myTrace("Deteniendo reproduccion");
			recBar.status.text = "Listo";
			playing = false;
		    temporizador.stop();
			recorded.stop();	
			}
			else{
			recBar.status.text = "No hay Reproduccion en curso";
			}
		}
		/**Funcion que invoka la
		creacion del audio***/
		public function saveRecording(e:Event):void
		{
			saveRecordingExt();
		}
		/***Funcion que inicia la creacion de Audio
		***/
		public function saveRecordingExt():String
		{
			myTrace("saveRecordingExt()");
			if(!recording && recorded_once && recorded.length > MIN_LENGTH)
			{
				myTrace("Iniciando creacion de audio en Base64");
				 base= new Base64Encoder();
				 base.insertNewLines=false;
				 //var byteArray:ByteArray=recorder.output;
				 var byteArray:ByteArray=waveEncoder.encode(recorder.output,2,16,11000);
				 base.encodeBytes(byteArray,0,byteArray.length);
			     strAudio= base.toString()
				 myTrace("Tamaño..." + strAudio.length);
				
				var fileReference:FileReference=new FileReference();
				fileReference.save (recorder.output, "recordedfile.wav");
				
			}
			else
			{
				strAudio="";
				recBar.status.text = "Audio no capturado.";
			}
			
		/***Funcion para transferir el audio a Javascript***/
        ExternalInterface.call("receiveAudio", strAudio);
		return strAudio;
			
		}
		
		/**Funcion para que prepara el
		audio almacenado para ser reproducido***/
		public function recordComplete(e:Event):void
		{
			myTrace("Grabacion Terminada");
			recording = false;
			recorded = new WavSound( recorder.output );
			myTrace("Grabado:" +recorded.length);
			if(recorded.length > MIN_LENGTH)
			{
				recorded_once = true;
			}
		}
		
		/* ----SETTINGS AUDIO ------ */
		
		/**Funcion que utiliza el boton solicitar el acceso al microfono***/
		public function isReady(e:MouseEvent):void
		{
			
			isReadyExt();
			setValuesExt(1,10,8,-15,0);
		}
		
		/**Funcion que solicita acceso al microfono**/
		public function isReadyExt():void
		{
			myTrace("isReadyExt()");
            if ( Microphone.names.length > 0)
            {
                myTrace("Microfonos Encontrados");
				if(this.mic==null)
					{
						myTrace("Inicializa Microfono");
						configureMicrophone(0);
						   ExternalInterface.call("objectReady", "true");
					}else{
						myTrace("Microfono Listo");
						 if(this.mic.muted){
				            myTrace("Microfonodo muted");
					        Security.showSettings(SecurityPanel.PRIVACY);
						    ExternalInterface.call("objectReady", "true");
				           }else{			
						   recBar.status.text = "Listo";
						   ExternalInterface.call("objectReady", "true");

							}
						}
            }
			else{
				recBar.status.text="No hay microfonos conectados";
			}
			
		}	
		
        /**Funcion para el
		boton cambier microfono***/
		public function changeMicrophone(e:MouseEvent):void
		{
			changeMicrophoneExt();
				
		}
		/***Funcion para 
		intercambier microfonos***/
		public function changeMicrophoneExt():void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
				myTrace("Position:" + i+". NameMicrophone: "+micros[i]);
				}
			if(micSelect>0 && micSelect<micros.length){
				micSelect++;
				}else{
				micSelect=0;
				}
			    myTrace("Microfono Seleccionado"+ micros[micSelect]);
             //Microphone.getMicrophone(micSelect);		
			 configureMicrophone(micSelect);
		}
		
        private function configureMicrophone(idMicrophone:uint) : void
        {
			//Inicializo microfono
			myTrace("configureMicrpfone");
			//var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			//options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			//options.autoGain=true;
			//options.echoPath = 128;
			//options.nonLinearProcessing = true;
			//mic.enhancedOptions=options;
			mic = Microphone.getMicrophone(idMicrophone);
			mic.setSilenceLevel(0, 2000);
			mic.codec = SoundCodec.NELLYMOSER;
			mic.encodeQuality = 7;
			mic.framesPerPacket = 1;
			mic.gain = this.xgain;
			mic.rate=this.xrate;
			mic.noiseSuppressionLevel=this.xnoise;
			mic.setLoopBack(false);
			mic.setUseEchoSuppression(true);  
     
			var micDetails: String = "Microfono" + mic.name + '\n'; 
			micDetails += "Gain:" + mic.gain + '\n'; 
			micDetails += "Rate:" + mic.rate + "kHz" + '\n'; 
			micDetails += "Silenciado:" + mic.muted + '\n'; 
			micDetails += "Nivel de silencio:" + mic.silenceLevel + '\n'; 
			micDetails += "Silence timeout:" + mic.silenceTimeout + '\n'; 
			micDetails += "Supresión de eco:" + mic.useEchoSuppression ; 
			myTrace (micDetails); 	
			if(mic.muted){
				
				Security.showSettings(SecurityPanel.PRIVACY);
				}
            return;
			
        }// end function		
		
		 private function setConfigsMicrophone() : void
        {
			//Inicializo microfono
			//mic.setSilenceLevel(0, 2000);
			//mic.codec = SoundCodec.NELLYMOSER;
			//mic.encodeQuality = 7;
			//mic.framesPerPacket = 1;
			mic.gain = this.xgain;
			//mic.rate=this.xrate;
			mic.noiseSuppressionLevel=this.xnoise;
			//mic.setLoopBack(false);
			//mic.setUseEchoSuppression(true);  
            return;
			
        }// end function
		
		/* --- DISPLAY FUNCTIONS --- */
		
		
		/***Muestra el contador de grabacion***/
		private function disp_recording(e:RecordingEvent):void
		{
		    setConfigsMicrophone();
	        createTimer(e.time/1000);
		}
		
		/***Muestra el contador de reproduccion***/
		private function disp_playing(event:TimerEvent):void
		{
			var currentTime:int = tiempo;
			createTimer(tiempo);
			if(time==currentTime){
				myTrace("AccionPara detener elboton");
				stopPlayingExt();
				ExternalInterface.call("detenerReproduccion", "true");

				}
			tiempo++;
		}
		
		
		/***Muestra el contador segun el tiempo***/
		public function createTimer(tiempo:int):void{
			minutos	=Math.floor(tiempo/60);
			segundos=Math.floor(tiempo-(minutos*60));
				
			var str:String="";
			 if (String(minutos).length == 1)
			{
				str = "00:0" + String(minutos);
			} else if(String(minutos).length == 2)
			{
				str = "00:" + String(minutos);
			}else
			{
				str = "00:00";
			}
			if (String(segundos).length == 1)
			{
				str = str + ":0" + segundos;
			}
			else if (String(segundos).length == 2)
			{
				str = str + ":" + segundos;
			}
				recBar.counter.text = str;
			}
		
		/**Muestra los logs**/
		public function myTrace(str:String){
			if(this.xLogVerbose==1){
			ExternalInterface.call("console.log",str);
			trace(str);
			}
			}
		
	} //fin de classe
	
} //fin de package