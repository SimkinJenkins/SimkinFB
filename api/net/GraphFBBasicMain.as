package net {

	import com.core.BasicMain;
	import com.core.system.System;
	import com.facebook.graph.Facebook;
	import com.interfaces.IClient;
	import com.ui.AlertEvent;
	import com.ui.controllers.SiteAlertManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
	import net.core.EtniaFacebookGraph;
	import net.events.EtniaFacebookConnectLoginEvent;


	public class GraphFBBasicMain extends BasicMain implements IClient {

		protected var _facebook:EtniaFacebookConnect;
		protected var _timeout:Timer;
		protected var _serviceTestMode:Boolean = false;

		public function GraphFBBasicMain($url:String="./swf/v1_0/config/localURLSData.xml") {
			super($url);
		}

		override protected function onGraphicsLoaded($event:Event):void {
			super.onGraphicsLoaded($event);
			initFBConnection();
		}

		protected function initFBConnection():void {
			if((new LocalConnection()).domain == "localhost") {
				EtniaFacebookGraph.getInstance().appID = "150333455063449";//"263107520380920");
				_facebook = new EtniaFacebookConnect(EtniaFacebookGraph.getInstance().appID);
				if(_serviceTestMode) {
					EtniaFacebookGraph.getInstance().userData = {first_name:"Simkin", gender:"male", hometown:{}, id:"100000293224144",
																last_name:"Jerkin", link:"http://www.facebook.com/profile.php?id=100000293224144",
																locale:"es_LA", name:"Simkin Jerkin", timezone:-6, updated_time:"2011-10-24T22:19:14+0000",
																verified:true, work:[]};
					_facebook.fbUserData = EtniaFacebookGraph.getInstance().userData;
					onLoginSuccess(null);
					return;
				}
				addListener(_facebook, EtniaFacebookConnectLoginEvent.USER_LOGIN_SUCCES, onLoginSuccess);
				sendLogin();
				createTimer();
			} else {
				if(System.loaderInfoRoot.parameters.app_id) {
					EtniaFacebookGraph.getInstance().appID = System.loaderInfoRoot.parameters.app_id;
					_facebook = new EtniaFacebookConnect(System.loaderInfoRoot.parameters.app_id, System.loaderInfoRoot.parameters.access_token);
					addListener(_facebook, EtniaFacebookConnectLoginEvent.USER_LOGIN_SUCCES, onLoginSuccess);
					sendLogin();
					createTimer();
				}
			}
		}

		protected function createTimer():void {
			_timeout = new Timer(10000, 1);
			addListener(_timeout, TimerEvent.TIMER, onLoginTimerComplete);
			_timeout.start();
		}

		protected function destructTimer():void {
			if(_timeout) {
				addListener(_timeout, TimerEvent.TIMER_COMPLETE, onLoginTimerComplete, false);
				_timeout.stop();
				_timeout = null;
			}
		}

		protected function onLoginTimerComplete($event:TimerEvent):void {
			SiteAlertManager.getInstance().showAlert("No se ha obtenido sesión de Facebook. Presiona OK para intentar otra vez.", ["OK"], onLoginAlertClose);
		}

		protected function onLoginAlertClose($event:AlertEvent):void {
			sendLogin();
			createTimer();
		}

		protected function sendLogin():void {
			_facebook.facebookLogin(new Array(_facebook.USER_PHOTOS, _facebook.FRIENDS_PHOTOS));
		}

		protected function onLoginSuccess($event:EtniaFacebookConnectLoginEvent):void {
			destructTimer();
			SiteAlertManager.getInstance().closeAlert();
			if(!EtniaFacebookGraph.getInstance().userData) {
				EtniaFacebookGraph.getInstance().userData = _facebook.dataObject;
			}
			transactionComplete();
		}
		
		protected function transactionComplete():void{
			trace("Login de Facebook exitoso");
		}
	}
}