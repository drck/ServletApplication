package 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
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
	import flash.events.SampleDataEvent;
	import flash.events.Event;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import fl.controls.Button;
    import flash.text.TextField;
	import flash.external.*;
	import mx.utils.Base64Encoder;
	import flash.system.SecurityPanel;
	import flash.media.*;

	public class MainSwf extends Sprite
	{
        public static const MICROPHONE_ALLOWED:String = "microphone_allowed";	
		private static const READY:String = "ready";
		private var mic:Microphone;
		private var waveEncoder:WaveEncoder = new WaveEncoder();
		private var base:Base64Encoder = new Base64Encoder();
		private var recorder:MicRecorder = new MicRecorder(waveEncoder);
		private var recBar:RecBar = new RecBar();
		private var tween:Tween;
		private var fileReference:FileReference = new FileReference();
		private var recorded:WavSound;
		private var date = new Date();
		private var strAudio:String;
		private var recorded_once:Boolean = false;
		private var recording:Boolean = false;
		private var playing:Boolean = false;
		private var rec_title:TextField = new TextField();
		private var title_format:TextFormat;
		private const MIN_LENGTH:uint = 1000;
		//private var empezar_btn:Button = new Button();
		//private var detener_btn:Button = new Button();
		//private var reiniciar_btn:Button = new Button();
		//private var recButton = new btn_r();
		//private var playButton = new btn_p();
		//private var saveButton = new btn_d();
		//private var vu_meter = new vumeter();
		private var tiempo:uint = 0; 
		private var time:uint = 0; 
		private var minutos:uint = 0;
		private var segundos:uint = 0;
		//esta variable cuenta el tiempo
		/*creamos una variable de tipo Timer.
		Intervalo 100 milisegundo = 1 décima de segundo.
		0 para indicar ilimitado número de veces*/
		private var temporizador:Timer = new Timer(1000, 0);
		//private var  temporizador:Timer  =  new Timer(500, 0) ;
		var hora_txt:TextField = new TextField();
		
		
		public function MainSwf():void
		{  
		
			recBar.status.text = "Iniciando Microfono..";
			addListeners();
			addListenersExt();
			recBar.status.text = "Listo2";
			addChild(recBar);
			readyMic(SecurityPanel.PRIVACY);

			
			
		}

		public function addListeners():void
		{   
			botones.btn_ready.addEventListener(MouseEvent.MOUSE_UP, isReady);
			botones.btn_record.addEventListener(MouseEvent.MOUSE_UP, startRecording);
			botones.btn_stop_record.addEventListener(MouseEvent.MOUSE_UP, stopRecording);			
			botones.btn_play.addEventListener(MouseEvent.MOUSE_UP, startPlaying);
			botones.btn_stop_play.addEventListener(MouseEvent.MOUSE_UP, stopPlaying);

			recorder.addEventListener(RecordingEvent.RECORDING, disp_recording);
			recorder.addEventListener(Event.COMPLETE, recordComplete);
		}
		public function addListenersExt():void
		{ 
			ExternalInterface.addCallback("_charger", chargerExt);
		    ExternalInterface.addCallback("_startRecord", startRecordingExt);
			ExternalInterface.addCallback("_stopRecord", stopRecordingExt);
			ExternalInterface.addCallback("_startPlaying", startPlayingExt);
			ExternalInterface.addCallback("_stopPlaying", stopPlayingExt);
			ExternalInterface.addCallback("_saveRecording", saveRecordingExt);
			ExternalInterface.addCallback("_changeMicrophone", changeMicrophoneExt);
			ExternalInterface.addCallback("_changeSound", changeSoundExt);
			
		}
		

		
		public function startRecording(e:MouseEvent):void
		{
		   startRecordingExt();
		}
		
		public function startRecordingExt():void
		{
			
		
			trace("startRecording");
			if (mic != null && !playing && !mic.muted)
			{
				
				if(!recording){
			    recBar.status.text = "Grabando..";
				trace("Inicia Grabado");
				recording = true;
				recorder.record();
			    
				}
			}else
			{
			    recBar.status.text = "Microfono no disponible..";
				readyMic(SecurityPanel.DEFAULT);
			}
		
		}
		
		

		public function stopRecording(e:MouseEvent):void
		{
			stopRecordingExt();
		}
    
		public function stopRecordingExt():void
		{
			if(recording){
			recBar.status.text = "Listo";
			recorder.stop();
			mic.setLoopBack(false);
			}
			else
				{
			recBar.status.text = "No hay Grabacion en curso";	
			}
			
			}

	
		public function recordComplete(e:Event):void
		{
			trace("Grabacion Terminada");
			recording = false;
			recorded = new WavSound( recorder.output );
			
			if(recorded.length > MIN_LENGTH)
			{
				recorded_once = true;
				//playButton.gotoAndStop(1);
				//saveButton.gotoAndStop(1);
			}
		}
		
		public function startPlaying(e:Event):void
		{
			startPlayingExt();
		}
		
		public function startPlayingExt():void
		{
			if(recorded_once && !recording ){
			if(!playing)
			{
				recBar.status.text = "Listo";			
				playing = true;
				tiempo=1;
				time=Math.round(recorded.length/1000);
				temporizador=new Timer(1000,Math.round(recorded.length/1000));
				temporizador.addEventListener(TimerEvent.TIMER, disp_playing);
				temporizador.start();
				var trans:SoundTransform; 
				trans = new SoundTransform(0.50, 0); 
				trans.volume
				recorded.play(0,1,trans);

			}
		   }
			else
			{
				recBar.status.text = "No hay audio grabado";			
			}
		}
		
		public function stopPlaying(e:Event):void
		{
			stopPlayingExt();
		}
		public function stopPlayingExt():void
		{
			trace("playingsss"+playing);
			if(playing){
			recBar.status.text = "Listo";
			playing = false;
			trace("tempStop");
		    temporizador.stop();
			recorded.stop();	
			}
			else{
			recBar.status.text = "No hay Reproduccion en curso";
			}
		}
		
		public function saveRecording(e:Event):void
		{
			saveRecordingExt();
		}
		
		public function saveRecordingExt():String
		{
			if(!recording && recorded_once && recorded.length > MIN_LENGTH)
			{
				 base= new Base64Encoder();
				 base.encodeBytes(recorder.output,0,recorder.output.length);
			     strAudio= base.toString()
			}
			else
			{
				strAudio="";
				recBar.status.text = "Audio no capturado.";
			}
			
		ExternalInterface.call("console.log", "tamaño..." + strAudio.length);
        ExternalInterface.call("receiveAudio", strAudio);
		return strAudio;
			
		}
		
		/* ----SETTINGS AUDIO ------ */
		
		public function isReady(e:MouseEvent):void
		{
			trace("isReady");
			this.readyMic(SecurityPanel.PRIVACY);
		}
		public function isReadyExt():void
		{
			trace("isReady");
			this.readyMic(SecurityPanel.PRIVACY);
		}	
		
		public function chargerExt():void
		{
			this.readyMic(SecurityPanel.PRIVACY);
			addChild(recBar);
		}
		public function changeMicrophoneExt():void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
				trace("Position:" + i+". Name: "+micros[i]);
				ExternalInterface.call("console.log", "Position:" + i+". Name: "+micros[i]);
				}
				
		}
		public function changeMicrophone(e:MouseEvent):void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
			trace("Position:" + i+". Name: "+micros[i]);

				ExternalInterface.call("console.log", "Position:" + i +". Name: "+micros[i]);
				}
				
		}
		
		public function changeSoundExt(value:String):void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
				ExternalInterface.call("console.log", "Position:" + i+". Name: "+micros[i]);
				}
				
		}
		public function changeSound(value:String):void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
				ExternalInterface.call("console.log", "Position:" + i+". Name: "+micros[i]);
				}
				
		}
		/* --- DISPLAY FUNCTIONS --- */
		
		private function disp_recording(e:RecordingEvent):void
		{
			
			/*
			var currentTime:int = Math.floor((e.time/1000));
			recBar.counter.text = "00:"+currentTime;

			if (String(currentTime).length == 1)
			{
				recBar.counter.text = "00:00:0" + currentTime;
			}
			else if (String(currentTime).length == 2)
			{
				recBar.counter.text = "00:00:" + currentTime;
			}
			else if (String(currentTime).length == 3)
			{
				recBar.counter.text = "00:0" + String(currentTime).substr(0,1)+":"+String(currentTime).substr(1,3);
			}
			*/
			minutos	=Math.floor((e.time/1000)/60);
			
			segundos=Math.floor((e.time/1000)-(minutos*60));
				
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
		
		private function disp_playing(event:TimerEvent):void
		{
			
			var currentTime:int = tiempo;
			/*
			recBar.counter.text = "00:" + currentTime;

			if (String(currentTime).length == 1)
			{
				recBar.counter.text = "00:00:0" + currentTime;
			}
			else if (String(currentTime).length == 2)
			{
				recBar.counter.text = "00:00:" + currentTime;
			}
			else if (String(currentTime).length == 3)
			{
				recBar.counter.text = "00:0" + String(currentTime).substr(0,1)+":"+String(currentTime).substr(1,3);
			}
			*/
			minutos	=Math.floor((tiempo)/60);
			
			segundos=Math.floor((tiempo)-(minutos*60));
				
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
			if(time==currentTime){
				trace("Deteniendo");
				stopPlayingExt();
				ExternalInterface.call("detenerReproduccion", "true");
				trace("Deteniendo Boton");

				}
			tiempo++;
		}
		
		 public function readyMic(nivel:String) : void
        {
            if (this.isMicrophoneAccessible())
            {
               if(this.mic.muted){
				   trace("Microfonodo muted");
					Security.showSettings(nivel);
				} 
            }
			
			
            return;
        }// end function
		
		 private function isMicrophoneAccessible() : Boolean
        {
			trace("isMicrophoneAccesible: "+ this.isMicrophoneConnected());
            if (this.isMicrophoneConnected())
            {
                trace("Microfonos Encontrados");
				if(this.mic==null)
					{
						trace("Inicializa Microfono");
						configureMicrophone();
					}else{
						trace("Microfono Listo");
						}
				return true;
            }else{
				recBar.status.text="No hay microfonos conectados";
			    return false;
			}
        }// end function

        private function isMicrophoneConnected() : Boolean
        {
            return Microphone.names.length > 0;
        }// end function


        private function configureMicrophone() : void
        {
			//Inicializo microfono
			trace("configureMicrpfone");
			
			//mic=Microphone.getMicrophone();
		    //mic.gain = 0;
			//mic.setLoopBack(false);
			//mic.rate=8;
			//mic.noiseSuppressionLevel=-30;
			//mic.setUseEchoSuppression(true);
			//recBar.status.text = "Audio GAIN=0 RATE=8 NOISE=-30";
			
			var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			options.autoGain=true;
			options.echoPath = 128;
			options.nonLinearProcessing = true;
			mic = Microphone.getMicrophone();
			mic.enhancedOptions.autoGain=true;
			mic.setSilenceLevel(0, 2000);
			mic.codec = SoundCodec.NELLYMOSER;
			mic.encodeQuality = 7;
			mic.framesPerPacket = 1;
			mic.gain = 1;
			mic.rate=8;
            trace(mic.enhancedOptions.autoGain);
			mic.setUseEchoSuppression(true);  
			
			mic.addEventListener (ActivityEvent.ACTIVITY, this.onMicActivity); 
			mic.addEventListener (StatusEvent.STATUS, this.onMicStatus); 
     
			var micDetails: String = "Nombre del dispositivo de entrada de sonido:" + mic.name + '\ n'; 
			micDetails += "Gain:" + mic.gain + '\ n'; 
			micDetails += "Rate:" + mic.rate + "kHz" + '\ n'; 
			micDetails += "Silenciado:" + mic.muted + '\ n'; 
			micDetails += "Nivel de silencio:" + mic.silenceLevel + '\ n'; 
			micDetails += "Silence timeout:" + mic.silenceTimeout + '\ n'; 
			micDetails += "Supresión de eco:" + mic.useEchoSuppression + '\ n'; 
			trace (micDetails); 	
			
            return;
			
        }// end function		
		
		function onMicActivity (event: ActivityEvent): void 
		{ 
			trace ("activating =" + event.activating + ", activityLevel =" +  
			mic.activityLevel); 
		} 
 
		function onMicStatus (event: StatusEvent): void 
		{ 
			trace ("estado: nivel =" + event.level + ", código =" + event.code); 
		}

	} //fin de classe
	
} //fin de package