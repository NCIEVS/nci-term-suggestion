<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>
<%
  String action = HTTPUtils.cleanXSS((String) request.getParameter("action"));
  String version = null;
  if (action == null) {
      version = BaseRequest.getVersion(request);
  } 
  System.out.println("(*) index.jsp version= " + version);
  
  String queryString = request.getQueryString();
%>  
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>NCI Term Form</title>
  </head>
  <body>
  
<%     
  if (queryString != null && (queryString.indexOf("style") != -1 || queryString.indexOf("alert") != -1)) {
%>       
<h2>
<center>Server Error</center>
</h2>
      	<center><b>The server encountered an unexpected condition that prevented it from fulfilling the request.</b></center>
<%      
  } else {
%>  
  
    <% if (version == null || version.compareToIgnoreCase("") == 0 || version.compareToIgnoreCase("null") == 0 || version.compareToIgnoreCase("Default") == 0) { 
    %>
       <jsp:forward page="/pages/main/suggestion.jsf"/>
      <% } else if (version != null && version.compareToIgnoreCase("CDISC") == 0) { 
      
      %>
           <jsp:forward page="/pages/main/suggestion_cdisc.jsf"/>
      <% } else { 
      %>
           <jsp:forward page="/pages/main/suggestion.jsf?version=cadsr"/>
    <% } %>
    
<% } %>    
    
  </body>
</html>
