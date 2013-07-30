package com.kboctopus.sns.service
{
	import com.kboctopus.sns.utils.PostHelper;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class SinaService extends BaseService
	{
		public function SinaService()
		{
			super();
		}
		
		
		override public function share(content:String, img:ByteArray, result:Function, error:Function):void
		{
			super.share(content, img, result, error);
			
			var name:String = "1.jpg";
			
			//封装参数
			var params:Object = {access_token:this.token, status:encodeURIComponent(content)};
			var url:String = "https://upload.api.weibo.com/2/statuses/upload.json";
			
			//封装request
			var request:URLRequest = new URLRequest();
			request.url = url;
			request.contentType = "multipart/form-data; boundary=" + PostHelper.getBoundary();
			request.method = URLRequestMethod.POST;
			request.data = PostHelper.getPostData(name, params, img, "pic");
			
			this.upldr.load(request);
		}
	}
}