package net.interalia.teleton.iu.controllers {

	import com.adobe.images.PNGEncoder;
	import com.adobe.net.URI;
	import com.etnia.core.config.URLManager;
	import com.etnia.net.EtniaDataSender;
	import com.etnia.net.EtniaLoaderEvent;
	import com.etnia.net.EtniaServerResponse;
	import com.etnia.utils.GraphicUtils;
	import com.facebook.graph.Facebook;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import net.interalia.etnia.ui.controllers.EtniaTransactionController;

	public class SPUploadFBPhoto extends EtniaTransactionController {

		public static const SEND_IMAGE_COMPLETE:String = "sendImageCompleted";	

		public function SPUploadFBPhoto($container:Sprite) {
			super($container);
		}

		public function sendImage($image:DisplayObject):void {
//			sendSaveBitmapData(URLManager.getInstance().getPath("sendImageService") + "?access=" + encodeURIComponent(Facebook.getSession().accessToken), $image, sendImageCompleted);
		}

		protected function sendImageCompleted($event:Event):void {
			var data:EtniaServerResponse = EtniaDataSender.getJSONServerResponse(($event.target as URLLoader).data);
			dispatchEvent(new EtniaLoaderEvent(SEND_IMAGE_COMPLETE, "", 0, 0, 0, null, data));
		}

		protected function sendSaveBitmapData($url:String, $do:DisplayObject, $complete:Function):void {
           var request:URLRequest = new URLRequest($url);
           request.data = PNGEncoder.encode(GraphicUtils.getBitmapData($do));
			request.method = URLRequestMethod.POST;
           var loader:URLLoader = new URLLoader();
           createURLLoaderListeners(loader, true, $complete);
           loader.load(request);
      	}

		protected function createURLLoaderListeners($loader:URLLoader, $create:Boolean = true, $complete:Function = null):void {
			if($loader) {
				addListener($loader, Event.COMPLETE, $complete, $create);
			}
		}

	}

}