<html lang="en" xmlns:c="http://java.sun.com/jsp/jstl/core"> 
<head>
<script src="//assets.adobedtm.com/f1bfa9f7170c81b1a9a9ecdcc6c5215ee0b03c84/satelliteLib-4b219b82c4737db0e1797b6c511cf10c802c95cb.js"></script>
  <title>Suggestion CDISC</title>
</head>
 <body>
 
<%
System.out.println("forward page: template.jsp");
System.out.println("content_title: Term Suggestion");
System.out.println("content_quickLink: quickLink_cdisc.jsp");
System.out.println("content_page: _suggestion_cdisc.jsp");
%>

 
  <jsp:forward page="/pages/templates/template.jsp">
    <jsp:param name="content_title" value="Term Suggestion"/>
    <jsp:param name="content_quickLink" value="/pages/contents/quickLink_cdisc.jsp"/>
    <jsp:param name="content_page" value="/pages/contents/_suggestion_cdisc.jsp"/>
  </jsp:forward>
<script type="text/javascript">_satellite.pageBottom();</script>
 </body>
</html>
