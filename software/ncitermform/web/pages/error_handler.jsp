<%@ page import="gov.nih.nci.evs.common.*" %>
<html lang="en" xmlns:c="http://java.sun.com/jsp/jstl/core"> 
<head>
<script src="//assets.adobedtm.com/f1bfa9f7170c81b1a9a9ecdcc6c5215ee0b03c84/satelliteLib-4b219b82c4737db0e1797b6c511cf10c802c95cb.js"></script>
  <title>Error Handling</title>
</head>
  <body>
	<%
      String errorMsg = EVSConstants.ERROR_MESSAGE;
      String message = (String) request.getSession().getAttribute(errorMsg); 
    %>
	<b><%=message%></b>
<script type="text/javascript">_satellite.pageBottom();</script>
  </body>
</html>        
