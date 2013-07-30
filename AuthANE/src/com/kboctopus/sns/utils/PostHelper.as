package com.kboctopus.sns.utils
{
	import flash.utils.*;
	
	public class PostHelper extends Object
	{
		private static var _boundary:String = "";
		
		public function PostHelper()
		{
			return;
		}
		
		public static function getBoundary() : String
		{
			var i:int = 0;
			if (_boundary.length == 0)
			{
				i = 0;
				while (i < 32)
				{
					
					_boundary = _boundary + String.fromCharCode(int(97 + Math.random() * 25));
					i++;
				}
			}
			return _boundary;
		} 
		/**
		 * 封装发送参数 
		 * @param name
		 * @param params
		 * @param photoByte
		 * @param fileData
		 * @param type
		 * @param fileName
		 * @return 
		 * 
		 */		
		public static function getPostData(name:String, params:Object = null,photoByte:ByteArray=null,fileData:String = "Filedata",type:String = "image/jpg", fileName:String = "filename") : ByteArray
		{
			var byteArray:ByteArray = sameParase(name,params,photoByte,fileData,type,fileName);

			byteArray = LINEBREAK(byteArray);
			byteArray = BOUNDARY(byteArray);
			byteArray = DOUBLEDASH(byteArray);
			return byteArray;
		}
		/**
		 * 腾讯微博封装发送参数  
		 * @param name
		 * @param params
		 * @param photoByte
		 * @param fileData
		 * @param type
		 * @param fileName
		 * @return 
		 * 
		 */		
		public static function getPostDataForTencent(name:String, params:Object = null,photoByte:ByteArray=null,fileData:String = "Filedata",type:String = "image/jpg", fileName:String = "filename") : ByteArray
		{
			var i:int = 0;
			var contentStr:String = null;
			//获取与其他分享或上传封装参数相同部分
			var byteArray:ByteArray = sameParase(name,params,photoByte,fileData,type,fileName);
			//在写不同部分
			byteArray = LINEBREAK(byteArray);
			byteArray = LINEBREAK(byteArray);
			byteArray = BOUNDARY(byteArray);
			byteArray = LINEBREAK(byteArray);
			contentStr = "Content-Disposition: form-data; name=\"Upload\"";
			i = 0;
			while (i < contentStr.length)
			{
				
				byteArray.writeByte(contentStr.charCodeAt(i));
				i++;
			}
			byteArray = LINEBREAK(byteArray);
			byteArray = LINEBREAK(byteArray);
			contentStr = "Submit Query";
			i = 0;
			while (i < contentStr.length)
			{
				
				byteArray.writeByte(contentStr.charCodeAt(i));
				i++;
			}
			byteArray = LINEBREAK(byteArray);
			byteArray = BOUNDARY(byteArray);
			byteArray = DOUBLEDASH(byteArray);
			return byteArray;
		}
		
		private static function sameParase(name:String, params:Object = null,photoByte:ByteArray=null,fileData:String = "Filedata",type:String = "image/jpg", fileName:String = "filename"):ByteArray
		{
			var i:int = 0;
			var contentStr:String = null;
			var key:String = null;
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.BIG_ENDIAN;
			if (params == null)
			{
				params = new Object();
			}
			if(name != "" && name != null)
			{
				params[fileName] = name;
			}
			for (key in params)
			{
				
				byteArray = BOUNDARY(byteArray);
				byteArray = LINEBREAK(byteArray);
				contentStr = "Content-Disposition: form-data; name=\"" + key + "\"";
				i = 0;
				while (i < contentStr.length)
				{
					
					byteArray.writeByte(contentStr.charCodeAt(i));
					i++;
				}
				byteArray = LINEBREAK(byteArray);
				byteArray = LINEBREAK(byteArray);
				byteArray.writeUTFBytes(params[key]);
				byteArray = LINEBREAK(byteArray);
			}
			if(photoByte != null && photoByte.length!= 0)
			{
				byteArray = BOUNDARY(byteArray);
				byteArray = LINEBREAK(byteArray);
				contentStr = "Content-Disposition: form-data; name=\"" + fileData + "\"; " + fileName + "=\"";
				i = 0;
				while (i < contentStr.length)
				{
					
					byteArray.writeByte(contentStr.charCodeAt(i));
					i++;
				}
				byteArray.writeUTFBytes(name);
				byteArray = QUOTATIONMARK(byteArray);
				byteArray = LINEBREAK(byteArray);
				contentStr = "Content-Type: " + type;
				i = 0;
				while (i < contentStr.length)
				{
					
					byteArray.writeByte(contentStr.charCodeAt(i));
					i++;
				}
				byteArray = LINEBREAK(byteArray);
				byteArray = LINEBREAK(byteArray);
				byteArray.writeBytes(photoByte, 0, photoByte.length);
			}
			
			return byteArray;
		}
		
		private static function BOUNDARY(byteArray:ByteArray) : ByteArray
		{
			var length:int = getBoundary().length;
			byteArray = DOUBLEDASH(byteArray);
			var i:int = 0;
			while (i < length)
			{
				
				byteArray.writeByte(_boundary.charCodeAt(i));
				i++;
			}
			return byteArray;
		}
		
		private static function LINEBREAK(byteArray:ByteArray) : ByteArray
		{
			byteArray.writeShort(3338);
			return byteArray;
		}
		
		private static function QUOTATIONMARK(byteArray:ByteArray) : ByteArray
		{
			byteArray.writeByte(34);
			return byteArray;
		}
		
		private static function DOUBLEDASH(byteArray:ByteArray) : ByteArray
		{
			byteArray.writeShort(11565);
			return byteArray;
		}
		
	}
}
