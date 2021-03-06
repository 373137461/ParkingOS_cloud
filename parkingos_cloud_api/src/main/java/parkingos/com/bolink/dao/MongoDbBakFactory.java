package parkingos.com.bolink.dao;

import com.mongodb.*;
import org.apache.log4j.Logger;

import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;


public class MongoDbBakFactory {

	private static Logger logger = Logger.getLogger(MongoDbBakFactory.class);

	private HashMap<String, DB> mongodbmap = new HashMap<String, DB>();
	private MongoDbBakFactory() {
	}

	public static MongoDbBakFactory getInstance() {
		return MongoDBFactoryHolder.INSTANCE;
	}

	private static class MongoDBFactoryHolder {

		private static final MongoDbBakFactory INSTANCE = new MongoDbBakFactory();
	}

	private static MongoClient mongoClient = null;
	static {
		try {
			List<ServerAddress> list=Arrays.asList(new ServerAddress("yun.zldmongodb.com",27017));
			mongoClient = new MongoClient(list);
			mongoClient.setReadPreference(ReadPreference.secondaryPreferred());
			MongoOptions mongoOptions = mongoClient.getMongoOptions();
			mongoOptions.setConnectionsPerHost(500);
			mongoOptions.setConnectTimeout(3000);
			mongoOptions.setThreadsAllowedToBlockForConnectionMultiplier(2);
 			logger.info("oldmongodb init over...");
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} 
	}

	public DB getMongoDBBuilder(String dbName) {
		DB db = null;
		if(dbName !=null && !"".equals(dbName)) {
			db  = mongodbmap.get(dbName);
			if(db == null) {
				db = buildMongoDb(dbName);
			}
		}
		return db;
	}

	private synchronized DB buildMongoDb(String dbName) {
		DB db = mongodbmap.get(dbName);
		if(db == null) {
			db = mongoClient.getDB(dbName);
			mongodbmap.put(dbName, db);
		}
		return db;
	}
}
