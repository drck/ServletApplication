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
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import fl.controls.Button;
    import flash.text.TextField;
	import flash.external.*;
	import mx.utils.Base64Encoder;

	public class Main extends Sprite
	{
		private var mic:Microphone;
		private var waveEncoder:WaveEncoder = new WaveEncoder();
		private var base:Base64Encoder = new Base64Encoder();
		private var recorder:MicRecorder = new MicRecorder(waveEncoder);
		private var recBar:RecBar = new RecBar();
		private var tween:Tween;
		private var fileReference:FileReference = new FileReference();
		private var recorded:WavSound;
		private var date = new Date();
		
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
		//esta variable cuenta el tiempo
		/*creamos una variable de tipo Timer.
		Intervalo 100 milisegundo = 1 décima de segundo.
		0 para indicar ilimitado número de veces*/
		private var temporizador:Timer = new Timer(1000, 0);
		//private var  temporizador:Timer  =  new Timer(500, 0) ;
		var hora_txt:TextField = new TextField();		  
		
			//Inicializo microfono
			mic = Microphone.getMicrophone();
			mic.setSilenceLevel(0);
			mic.gain = 100;
			mic.setLoopBack(false);
			mic.setUseEchoSuppression(true);
			Security.showSettings('2');

			addListeners();
			addListenersExt();

			recBar.width = 300;
			recBar.height = 40;
			recBar.y=80;
			addChild(recBar);		
		
		
		public function addListeners():void
		{   //btn_stop.addEventListener(MouseEvent.MOUSE_UP, stopRecording);
			//btn_record.addEventListener(MouseEvent.MOUSE_UP, startRecording);
			//btn_play.addEventListener(MouseEvent.MOUSE_UP, startPlaying);
			btn_save.addEventListener(MouseEvent.MOUSE_UP, saveRecording);
			//btn_microphone.addEventListener(MouseEvent.MOUSE_UP, changeMicrophone);
			recorder.addEventListener(RecordingEvent.RECORDING, disp_recording);
			recorder.addEventListener(Event.COMPLETE, recordComplete);
			  
		}
		public function addListenersExt():void
		{ 
		   ExternalInterface.addCallback("_startRecord", startRecordingExt);
			ExternalInterface.addCallback("_stopRecord", stopRecordingExt);
			ExternalInterface.addCallback("_startPlaying", startPlayingExt);
			ExternalInterface.addCallback("_stopPlaying", stopPlayingExt);
			ExternalInterface.addCallback("_saveRecording", saveRecordingExt);
			ExternalInterface.addCallback("_changeMicrophone", changeMicrophoneExt);
			ExternalInterface.addCallback("_changeSound", changeSoundExt);
			
		}



		/* --- PROCESSING FUNCTIONS --- */
		
		public function startRecordingExt():void
		{
		
			if (mic != null && !playing)
			{
				
				recording = true;
				 
				recorder.record();
				}
		}

		/* --- PROCESSING FUNCTIONS --- */
		
		public function startRecording(e:MouseEvent):void
		{
		
			if (mic != null && !playing)
			{
				
				recording = true;
				 
				recorder.record();
				}
		}

public function stopRecordingExt():void
		{
			recorder.stop();

			mic.setLoopBack(false);
			}

		public function stopRecording(e:MouseEvent):void
		{
			recorder.stop();

			mic.setLoopBack(false);
				}

		public function recordComplete(e:Event):void
		{
			recording = false;
			recorded = new WavSound( recorder.output );
			
			if(recorded.length > MIN_LENGTH)
			{
				recorded_once = true;
				
			}
		}
		
		public function startPlaying(e:Event):void
		{
			
			if(recorded_once && !playing && !recording)
			{
				trace("reproduciendo" + recorded.length);
				
				playing = true;
				tiempo=1;
				var temporizador:Timer=new Timer(1000,Math.round(recorded.length/1000));
				temporizador.addEventListener(TimerEvent.TIMER, disp_playing);
				temporizador.start();
				recorded.play();
							
				setTimeout(stopPlaying, recorded.length, new MouseEvent(MouseEvent.MOUSE_UP));	
			}
		}
		public function startPlayingExt():void
		{
			
			if(recorded_once && !playing && !recording)
			{
				trace("reproduciendo" + recorded.length);
				
				playing = true;
				tiempo=1;
				var temporizador:Timer=new Timer(1000,Math.round(recorded.length/1000));
				temporizador.addEventListener(TimerEvent.TIMER, disp_playing);
				temporizador.start();
				recorded.play();
							
				setTimeout(stopPlaying, recorded.length, new MouseEvent(MouseEvent.MOUSE_UP));	
			}
		}
		public function changeMicrophoneExt(value:String):void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
				ExternalInterface.call("console.log", "Position:" + i+". Name: "+micros[i]);
				}
				
		}
		public function changeMicrophone(e:MouseEvent):void
		{
			var micros:Array = Microphone.names;
			for(var i = 0; i < micros.length; i++){
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
		public function stopPlayingExt():void
		{
			
			playing = false;
			recorded.stop();
			

		}
		public function stopPlaying(e:Event):void
		{
			playing = false;
			recorded.stop();
		
		}
		
		public function saveRecording(e:Event):void
		{
			if(!recording && recorded_once && recorded.length > MIN_LENGTH)
			{
				var file_name:String;
				
				if(date.getMonth() < 10)
					file_name = '0' + date.getMonth() + '-';
				else
					file_name = date.getMonth() + '-';
					
				if(date.getDate() < 10)
					file_name += '0' + date.getDate() + '-' + date.getFullYear();
				else
					file_name += date.getDate() + '-' + date.getFullYear();				
				
				
				file_name = 'e-Client ' +
							file_name
							+ '_' +
							date.getHours()
							+'.'+
							date.getMinutes();
			    var strBase:String;
				 base.encodeBytes(recorder.output,0,recorder.output.length);
				trace(base.toString());
				fileReference.save(recorder.output, file_name + '.wav');
			}
		}
		public function saveRecordingExt():String
		{
			if(!recording && recorded_once && recorded.length > MIN_LENGTH)
			{
				var file_name:String;
				
				if(date.getMonth() < 10)
					file_name = '0' + date.getMonth() + '-';
				else
					file_name = date.getMonth() + '-';
					
				if(date.getDate() < 10)
					file_name += '0' + date.getDate() + '-' + date.getFullYear();
				else
					file_name += date.getDate() + '-' + date.getFullYear();				
				
				
				file_name = 'e-Client ' +
							file_name
							+ '_' +
							date.getHours()
							+'.'+
							date.getMinutes();
              var strBase:String;
				 base.encodeBytes(recorder.output,0,recorder.output.length);
			  
			}
			return base.toString();
		}
		
		
		/* --- DISPLAY FUNCTIONS --- */
		
		private function disp_recording(e:RecordingEvent):void
		{
			
			var currentTime:int = Math.floor(e.time / 1000);

			recBar.counter.text = String(currentTime);

			if (String(currentTime).length == 1)
			{
				recBar.counter.text = "00:0" + currentTime;
			}
			else if (String(currentTime).length == 2)
			{
				recBar.counter.text = "00:" + currentTime;
			}
		}
		
		private function disp_playing(event:TimerEvent):void
		{
			var currentTime:int = tiempo;

			recBar.counter.text = String(currentTime);

			if (String(currentTime).length == 1)
			{
				recBar.counter.text = "00:0" + currentTime;
			}
			else if (String(currentTime).length == 2)
			{
				recBar.counter.text = "00:" + currentTime;
			}
			tiempo++;
		}
		

	} //fin de classe
	
} //fin de package