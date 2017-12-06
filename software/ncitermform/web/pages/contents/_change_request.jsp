<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>
<script type="text/javascript" src="<%= FormUtils.getJSPath(request) %>/utils.js"></script>



<script language="javascript" type="text/javascript"> 
function closeWindow() { 
	document.getElementById('btn').onclose(); 
} 
</script> 


<%!
  // List of attribute name(s):
  private static final String MESSAGE = FormRequest.MESSAGE;
  private static final String WARNINGS = FormRequest.WARNINGS;%>
<%

  // List of attribute name(s):
  String OTHER = SuggestionRequest.OTHER;
  String VOCABULARY = SuggestionRequest.VOCABULARY;
  String TERM = SuggestionRequest.TERM;
  String SYNONYMS = SuggestionRequest.SYNONYMS;
  String NEAREST_CODE = SuggestionRequest.NEAREST_CODE;
  String DEFINITION = SuggestionRequest.DEFINITION;
  String CADSR_SOURCE = SuggestionRequest.CADSR_SOURCE;
  String CADSR_TYPE = SuggestionRequest.CADSR_TYPE;
  String PROJECT = SuggestionRequest.PROJECT;
  String REASON = SuggestionRequest.REASON;

  String NAME = SuggestionCDISCRequest.NAME;
  String PHONE_NUMBER = SuggestionCDISCRequest.PHONE_NUMBER;
  String ORGANIZATION = SuggestionCDISCRequest.ORGANIZATION;
  String CDISC_REQUEST_TYPE = SuggestionCDISCRequest.CDISC_REQUEST_TYPE;
  String CDISC_CODES = SuggestionCDISCRequest.CDISC_CODES;
 
  
  // Attribute(s):
  String message = HTTPUtils.getJspAttributeString(request, MESSAGE, false, true);
  String warnings = HTTPUtils.getJspAttributeString(request, WARNINGS, false, true);
%>
<div class="texttitle-blue">Change Request:</div><br/>
<%
  String msg = message;
  if (msg != null && msg.length() > 0) {
%>
    <div class="msgColor">
<%
    String[] list = StringUtils.toStrings(msg, "\n", false, false);
    for (int i=0; i<list.length; ++i) {
      String text = list[i];
      text = StringUtils.toHtml(text); // For leading spaces (indentation)
%>
      <%=text%><br/>
<%
    }
%>
   </div><br/>
<%
    }
%>
<%
  msg = warnings;
  if (msg != null && msg.length() > 0) {
%>
    <div class="warningMsgColor">
<%
    String[] list = StringUtils.toStrings(msg, "\n", false, false);
    for (int i=0; i<list.length; ++i) {
      String text = list[i];
      text = StringUtils.toHtml(text); // For leading spaces (indentation)
%>
      <%=text%><br/>
<%
    }
%>
   </div><br/>
<%
  }

String version = BaseRequest.getVersion(request);
  
  
request.getSession().removeAttribute("retry");
request.getSession().removeAttribute(OTHER);
request.getSession().removeAttribute(VOCABULARY);
request.getSession().removeAttribute(TERM);
request.getSession().removeAttribute(SYNONYMS);
request.getSession().removeAttribute(DEFINITION);
request.getSession().removeAttribute(NEAREST_CODE);
request.getSession().removeAttribute(CADSR_SOURCE);
request.getSession().removeAttribute(CADSR_TYPE);
request.getSession().removeAttribute(REASON);
request.getSession().removeAttribute(PROJECT);
request.getSession().removeAttribute(WARNINGS);  
  
request.getSession().removeAttribute("retry_cdisc");  
request.getSession().removeAttribute(NAME); 
request.getSession().removeAttribute(PHONE_NUMBER);  
request.getSession().removeAttribute(ORGANIZATION);  
request.getSession().removeAttribute(CDISC_REQUEST_TYPE);  
request.getSession().removeAttribute(CDISC_CODES);  

  
%>

<p>
You may click <a href="<%= request.getContextPath() %>/redirect?version=<%=version%>">here</a> to suggest a new term or suggest a modification to one, 
or close the browser window to exit this application.
<p/>



