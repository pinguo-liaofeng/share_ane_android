package com.kboctopus.sns.service;

import java.util.HashMap;

import com.adobe.fre.FREContext;


public class SNSServiceFactory 
{
	public static FREContext cnt = null;
	
	private static HashMap<String, ISNSService> map = new HashMap<String, ISNSService>();
	
	public static ISNSService getService(String name)
	{
		if(map.get(name) == null)
		{
			if(name.equals(TencentService.NAME))
			{
				map.put(name, new TencentService(cnt));
			}
			else if(name.equals(SinaService.NAME))
			{
				map.put(name, new SinaService(cnt));
			}
		}
		
		return map.get(name);
	}
}
