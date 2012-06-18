package net.ui.controllers {

	import com.adobe.images.PNGEncoder;
	import com.adobe.net.URI;
	import com.core.config.URLManager;
	import com.dynamicflash.util.Base64;
	import com.facebook.graph.Facebook;
	import com.net.BasicLoaderEvent;
	import com.net.DataSender;
	import com.net.ServerResponse;
	import com.ui.controllers.TransactionController;
	import com.utils.GraphicUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import net.core.EtniaFacebookGraph;

	public class UploadFBPhoto extends TransactionController {

		public static const SEND_IMAGE_COMPLETE:String = "sendImageCompleted";	

		public function UploadFBPhoto($container:Sprite) {
			super($container);
		}

		public function sendImage($image:DisplayObject, $text:String = ""):void {
			sendSaveBitmapData(URLManager.getInstance().getPath("uploadPhotoDir") + EtniaFacebookGraph.getInstance().userData.id + "/" + "?access=" + Base64.encode(Facebook.getInstance().accessToken), $image, sendImageCompleted);
//			sendSaveBitmapData(URLManager.getInstance().getPath("uploadPhotoDir") + "678766103" + "/", $image, sendImageCompleted);
		}

		protected function sendImageCompleted($event:Event):void {
			var data:ServerResponse = DataSender.getJSONServerResponse(($event.target as URLLoader).data);
			dispatchEvent(new BasicLoaderEvent(SEND_IMAGE_COMPLETE, "", 0, 0, 0, null, data));
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