package com.kboctopus.sns;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class SnsExtension implements FREExtension 
{
	private SnsContext _cnt;
	
	@Override
	public FREContext createContext(String arg0) 
	{
		return cnt();
	}

	@Override
	public void dispose() 
	{
		if(_cnt != null)
		{
			_cnt.dispose();
		}
	}

	@Override
	public void initialize() 
	{
		cnt();
	}
	
	
	private SnsContext cnt()
	{
		if(_cnt == null)
		{
			Log.d("SnsExtension", "SnsContext Create");
			_cnt = new SnsContext();
		}
		return _cnt;
	}

}
