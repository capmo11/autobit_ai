package javaApi;
import java.util.HashMap;

public class Main {
    public static void main(String args[]) {
		Api_Client api = new Api_Client("48ed52284b93c9fb404410ca9912f1d2","f88914b372cf6e903ee40eb9720a23c1");
	
		HashMap<String, String> rgParams = new HashMap<String, String>();
		//rgParams.put("order_currency", "BTC");
		//rgParams.put("apiKey", "48ed52284b93c9fb404410ca9912f1d2".replaceAll(" ",""));		
		//rgParams.put("secretKey", "f88914b372cf6e903ee40eb9720a23c1".replaceAll(" ",""));
		/*내 정보 보기*/
		//rgParams.put("order_currency", "BTC");
		//rgParams.put("payment_currency", "KRW");
		
		System.out.println(args[0]);
		System.out.println(args[1]);
		
		String buySellParam = "";
		String CoinTarget = args[1];
		
		if ( args[0].equals("buy") ) {
			buySellParam = "/trade/market_buy";
		}else {
			buySellParam = "/trade/market_sell";
		}
		
		rgParams.put("units", "0.1");
		rgParams.put("currency", CoinTarget);
		
		//  https://api.bithumb.com/info/account?apiKey=48ed52284b93c9fb404410ca9912f1d2&secretKey=f88914b372cf6e903ee40eb9720a23c1&currency=BTC
		
		try {
			/*내 정보 보기*/
			/*	String result = api.callApi("/info/balance", rgParams);
		    System.out.println(result);*/
			String result = api.callApi(buySellParam, rgParams);
		    System.out.println(result);
			
		} catch (Exception e) {
		    e.printStackTrace();
		}
		
    }
}

