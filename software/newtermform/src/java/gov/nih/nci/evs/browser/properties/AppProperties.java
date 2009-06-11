package gov.nih.nci.evs.browser.properties;

import java.util.HashMap;

import org.apache.log4j.Logger;

public class AppProperties {
    private static final String PROPERTY_FILE = "NewTermFormPropertiesFile";
    private static final String DEBUG_ON = "DEBUG_ON";
    private static final String MAIL_SMTP_SERVER = "MAIL_SMTP_SERVER";
    private static final String NCICB_CONTACT_URL = "NCICB_CONTACT_URL";
    private static final String BUILD_INFO = "NEWTERMFORM_BUILD_INFO";

    private static AppProperties _appProperties = null;
    private Logger _log = Logger.getLogger(AppProperties.class);
    private HashMap<String, String> _configurableItemMap;
    private String _buildInfo = null;

    private AppProperties() { // Singleton Pattern
        loadProperties();
    }

    public static AppProperties getInstance() throws Exception {
        if (_appProperties == null)
            _appProperties = new AppProperties();
        return _appProperties;
    }

    private void loadProperties() {
        synchronized (AppProperties.class) {
            String propertyFile = System.getProperty(PROPERTY_FILE);
            _log.info("AppProperties File Location= " + propertyFile);
            
            PropertyFileParser parser = new PropertyFileParser(propertyFile);
            parser.run();
            _configurableItemMap = parser.getConfigurableItemMap();
        }
    }

    private String getProperty(String key) {
        String value = (String) _configurableItemMap.get(key);
        if (value == null)
            return null;
        if (value.compareToIgnoreCase("null") == 0)
            return null;
        return value;
    }

    public String getBuildInfo() {
        if (_buildInfo != null)
            return _buildInfo;
        try {
            _buildInfo = getProperty(AppProperties.BUILD_INFO);
            if (_buildInfo == null)
                _buildInfo = "null";
        } catch (Exception ex) {
            _buildInfo = ex.getMessage();
        }

        System.out.println("getBuildInfo returns " + _buildInfo);
        return _buildInfo;
    }
    
    public boolean getDebugOn() {
        return Boolean.parseBoolean(getProperty(DEBUG_ON));
    }
    
    public String getContactUrl() {
        return getProperty(NCICB_CONTACT_URL);
    }
    
    public String getMailSmtpServer() {
        return getProperty(MAIL_SMTP_SERVER);
    }
}