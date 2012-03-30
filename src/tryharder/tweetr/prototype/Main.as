package tryharder.tweetr.prototype 
{
	import com.swfjunkie.tweetr.events.TweetEvent;
	import com.swfjunkie.tweetr.oauth.events.OAuthEvent;
	import com.swfjunkie.tweetr.oauth.OAuth;
	import com.swfjunkie.tweetr.Tweetr;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Robin Wilding
	 */
	public class Main extends Sprite 
	{
        private var _tweetr:Tweetr;
        private var _oauth:OAuth;
        private var _htmlLoader:HTMLLoader;
		private var _outputText:TextField;
		
		public function Main() 
		{
			stage.scaleMode = "noScale";
            stage.align = "TL";
            
			drawTemporaryOutput();
			
            _tweetr = new Tweetr();
            
            _oauth = new OAuth();
            _oauth.consumerKey = "XXXXXXXXXXXXXXXXXXXXX";
            _oauth.consumerSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            _oauth.callbackURL = "http://www.tryharder.org.uk/";
            _oauth.pinlessAuth = true;
            
            _oauth.addEventListener(OAuthEvent.COMPLETE, handleOAuthEvent);
            _oauth.addEventListener(OAuthEvent.ERROR, handleOAuthEvent);
            
            trace("Creating OAuth Authorization Window.");
            
            _htmlLoader = HTMLLoader.createRootWindow(true, null, true, new Rectangle(50, 50, 780, 500));
            _htmlLoader.stage.nativeWindow.alwaysInFront = true;
            _oauth.htmlLoader = _htmlLoader;
            _oauth.getAuthorizationRequest();
        }
        
		/**
		 * private functions
		 */
		 
        private function handleOAuthEvent(event:OAuthEvent):void
        {
            trace("OauthEvent." + event.type.toLocaleUpperCase());
			
            if (event.type == OAuthEvent.COMPLETE)
            {
                _htmlLoader.stage.nativeWindow.close();
                _tweetr.oAuth = _oauth;
                
                trace("Authorization Successful!");
                trace(_oauth.toString());
				
				loadTimeline();
            }
        }
		
		private function loadTimeline():void 
		{
			_tweetr.addEventListener(TweetEvent.COMPLETE, handleTimelineLoad);
            _tweetr.addEventListener(TweetEvent.FAILED, handleTimelineFail);
			_tweetr.getHomeTimeLine();
		}
		
		private function handleTimelineLoad(e:TweetEvent):void 
		{
			trace( "timeline load success");
			var data:XML = new XML(String(e.data));
			for (var i:int = 0; i < data.status.length(); i++) 
			{
				var status:XML = data.status[i] as XML;
				_outputText.appendText(status.user.name + " : " + status.text + "\n");
				
			}
		}
		
		private function handleTimelineFail(e:TweetEvent):void 
		{
			trace( "timeline load fail");
		}
		 
		private function drawTemporaryOutput():void 
		{
			_outputText = new TextField();
			_outputText.border = true;
			_outputText.x = 10;
			_outputText.y = 10;
			_outputText.width = stage.stageWidth - 20;
			_outputText.height = stage.stageHeight - 20;
			
			addChild(_outputText);
		}
		
	}

}