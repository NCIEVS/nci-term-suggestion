package gov.nih.nci.evs.browser.bean;

import java.util.*;

public class Prop {
    //-- Enum Modifiable -------------------------------------------------------
    public static enum Modifiable { 
        Definition, Synonym, Others;
        
        public static Modifiable valueOfOrDefault(String text) {
            try {
                String textStr = text.toLowerCase();
                for (Modifiable value : values()) {
                    String valueStr = value.name().toLowerCase();
                    if (valueStr.equals(textStr))
                        return value;
                }
                return Definition;
            } catch (Exception e) {
                return Definition;
            }
        }
    }
    
    public static String[] getProperties(Modifiable property) {
        ArrayList<String> list = new ArrayList<String>();
        if (property == Modifiable.Definition) {
            list.add("Definition: A liquid tissue; its major function is to transport oxygen throughout the body. It also supplies the tissues with nutrients, removes waste products, and contains various components of the immune system defending the body against infection. Several hormones also travel in the blood.");
            list.add("CDISC Definition: A liquid tissue with the primary function of transporting oxygen and carbon dioxide. It supplies the tissues with nutrients, removes waste products, and contains various components of the immune system defending the body against infection.");
            list.add("NCI-GLOSS Definition: Blood circulating throughout the body.");
        } else if (property == Modifiable.Synonym) {
            list.add("Term: Blood; Source: CTRM; Type: DN");      
            list.add("Term: BLOOD; Source: CDISC; Type: PT");  
            list.add("Term: Blood; Source: NCI; Type: PT");  
            list.add("Term: Blood; Source: CDISC; Type: SY");  
            list.add("Term: peripheral blood; Source: NCI-GLOSS; Type: PT; Code:    CDR0000046011");
            list.add("Term: Peripheral Blood; Source: CTRM; Type: SY");
            list.add("Term: Peripheral Blood; Source: NCI; Type: SY");  
            list.add("Term: Reticuloendothelial System, Blood; Source: CTRM; Type: SY");  
            list.add("Term: Reticuloendothelial System, Blood; Source: NCI; Type: SY");
        }
        return list.toArray(new String[list.size()]);
    }
    
    public static String getProperty(Modifiable property, int index) {
        String[] list = getProperties(property);
        if (index >= 0 && index < list.length)
            return list[index];
        return "";
    }

    //-- Enum Action -----------------------------------------------------------
    public static enum Action { 
        Add, Modify, Delete;
        
        public static ArrayList<String> names() {
            Action[] values = values();
            ArrayList<String> list = new ArrayList<String>();
            for (int i=0; i<values.length; ++i) {
                list.add(values[i].name());
            }
            return list;
        }

        public static Action valueOfOrDefault(String text) {
            try {
                return valueOf(text);
            } catch (Exception e) {
                return Add;
            }
        }
    }

    //-- Enum Version ------------------------------------------------------------
    public static enum Version {
        Default, CADSR;
        public static Version valueOfOrDefault(String text) {
            try {
                String textStr = text.toLowerCase();
                for (Version value : values()) {
                    String valueStr = value.name().toLowerCase();
                    if (valueStr.equals(textStr))
                        return value;
                }
                return Default;
            } catch (Exception e) {
                return Default;
            }
        }
    }
    
    //-- Enum CADSR ------------------------------------------------------------
    public static enum CADSR {
        None, CADSR_OC, CADSR_PROP, CADSR_REP, CADSR_VV;
        public static CADSR valueOfOrDefault(String text) {
            try {
                String textStr = text.toLowerCase();
                for (CADSR value : values()) {
                    String valueStr = value.name().toLowerCase();
                    if (valueStr.equals(textStr))
                        return value;
                }
                return None;
            } catch (Exception e) {
                return None;
            }
        }
    }
}