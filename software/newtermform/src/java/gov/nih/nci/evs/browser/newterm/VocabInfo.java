package gov.nih.nci.evs.browser.newterm;

import gov.nih.nci.evs.browser.utils.Utils;

import java.util.*;

public class VocabInfo {
    private static final String DELIM = ";";
    private String _name = "";
    private String _url = "";
    private ArrayList<String> _emails = new ArrayList<String>();

    public void setName(String name) { _name = name; }
    public String getName() { return _name; }
    public void setUrl(String url) { _url = url; }
    public String getUrl() { return _url; }
    public void addEmail(String email) {
        if (! _emails.contains(email)) _emails.add(email); 
    }
    public ArrayList<String> getEmails() { return _emails; }
    public boolean isEmpty() {
        return _name.length() <= 0 && _url.length() <= 0 && _emails.size() <= 0;
    }

    public static VocabInfo parse(String text) {
        if (text == null || text.trim().length() <= 0 || 
            text.startsWith("@") || text.startsWith("${"))
            return null;
        
        StringTokenizer tokenizer = new StringTokenizer(text, DELIM, true);
        VocabInfo info = new VocabInfo();
        int i=0;
        while (tokenizer.hasMoreTokens()) {
            String token = tokenizer.nextToken().trim();
            if (token.equals(DELIM))
                { ++i; continue; }
            if (i == 0)
                info.setName(token);
            else if (i == 1)
                info.setUrl(token);
            else if (token.length() > 0)
                info.addEmail(token);
        }
        return ! info.isEmpty() ? info : null;
    }
    
    private static void debug(String text) {
        System.out.println("DEBUG: " + text);
    }

    public static void debug(VocabInfo list) {
        debug("* Name: " + list.getName());
        debug("  * Url: " + list.getUrl());
        ArrayList<String> emails = list.getEmails();
        Iterator<String> iterator = emails.iterator();
        while (iterator.hasNext()) {
            String email = iterator.next();
            debug("  * Email: " + email);
        }
    }
    
    public static void debug(List<VocabInfo> list) {
        Iterator<VocabInfo> iterator = list.iterator();
        debug(Utils.SEPARATOR);
        debug("List of vocabularies:");
        while (iterator.hasNext())
            debug(iterator.next());
    }

    public static void main(String[] args) {
        String[] values = new String[] {
            "NCI Thesaurus ; http://ncit-qa.nci.nih.gov/; ncicb@pop.nci.nih.gov; NCIThesaurus@mail.nih.gov",
            "; http://ncit-qa.nci.nih.gov/; ncicb@pop.nci.nih.gov; NCIThesaurus@mail.nih.gov",
            "  ;  ;  ncicb@pop.nci.nih.gov;NCIThesaurus@mail.nih.gov",
            " ; ; ncicb@pop.nci.nih.gov;NCIThesaurus@mail.nih.gov",
            ";;ncicb@pop.nci.nih.gov;NCIThesaurus@mail.nih.gov",
            ";;ncicb@pop.nci.nih.gov;NCIThesaurus@mail.nih.gov; ncicb@pop.nci.nih.gov",
            "   ",
        };
        for (int i=0; i<values.length; ++i) {
            debug("----------------------------------------");
            String value = values[i];
            debug("Value: \"" + value + "\"");
            VocabInfo vocab = VocabInfo.parse(value);
            debug(vocab);
            debug("");
        }
    }
}
