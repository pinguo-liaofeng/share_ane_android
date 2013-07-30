package com.kboctopus.sns.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.kboctopus.sns.service.ISNSService;
import com.kboctopus.sns.service.SNSServiceFactory;

public class InitConfigFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) 
	{
		String platForm = "";
		String appId = "";
		String appKey = "";
		String appSecret = "";
		String redirectUri = "";
		
		try {
			platForm = arg1[0].getAsString();
			appId = arg1[1].getAsString();
			appKey = arg1[2].getAsString();
			appSecret = arg1[3].getAsString();
			redirectUri = arg1[4].getAsString();
		} catch (IllegalStateException e) 
		{
			e.printStackTrace();
		} catch (FRETypeMismatchException e) 
		{
			e.printStackTrace();
		} catch (FREInvalidObjectException e) 
		{
			e.printStackTrace();
		} catch (FREWrongThreadException e) 
		{
			e.printStackTrace();
		}
		
		ISNSService service = SNSServiceFactory.getService(platForm);
		if(service != null)
		{
			service.init(appId, appKey, appSecret, redirectUri);
		}
		
		return null;
	}

}
