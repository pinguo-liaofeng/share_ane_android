package com.kboctopus.sns.service
{
	import com.adobe.crypto.MD5;
	import com.kboctopus.sns.utils.PostHelper;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class TencentService extends BaseService
	{
		private var openId:String;
		private var openKey:String;
		
		public function TencentService()
		{
			super();
		}
		
		
		
		
		override public function handlerAuthBack(result:String):void
		{
			var data:Array = result.split("|");
			this.token = data[0];
			this.openId = data[1];
			this.openKey = data[2];
		}
		
		
		
		
		override public function share(content:String, img:ByteArray, result:Function, error:Function):void
		{
			super.share(content, img, result, error);
			
			var ip:String = this.getIp();
			var date:Date = new Date();
			var name:String = "1.jpg";
			
			//封装参数
			var params:Object = {oauth_consumer_key:this.appKey,openid:this.openId, openkey:this.openKey,access_token:this.token,pf:"tapp",wbversion:1,oauth_version:"2.a",clientip:ip,content:content};
			params.sig = this.getSig(params);
			
			//封装request
			var request:URLRequest = new URLRequest();
			request.url = "https://open.t.qq.com/api/t/add_pic";
			request.contentType = "multipart/form-data; boundary=" + PostHelper.getBoundary();
			request.method = URLRequestMethod.POST;
			request.data = PostHelper.getPostDataForTencent(name, params, img, "pic");
			
			this.upldr.load(request);
		}
		
		
		
		
		
		
		
		/**
		 * 计算sig 
		 * @params 参数对象
		 * @return sig
		 */
		private function getSig(params:Object) : String
		{
			var str:String = null;
			var result:String = "";
			var array:Array = [];
			if (params)
			{
				for (str in params)
				{
					
					array.push(str + "=" + encodeURIComponent(params[str]));
				}
			}
			if (array.length > 0)
			{
				array.sort();
				result = MD5.hash(array.join("&"));
			}
			return result;
		}
		
		
		/**
		 * 获取本地IP地址
		 * @return ip地址
		 */
		private function getIp():String
		{
			return "127.0.0.1";
		}
	}
}