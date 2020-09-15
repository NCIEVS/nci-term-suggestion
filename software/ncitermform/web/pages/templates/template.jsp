<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>
<%@ page import="gov.nih.nci.evs.browser.common.*" %>

Constants.SECURITY_KEY

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
  String basePath = FormUtils.getBasePath(request);
 
  String imagesPath = FormUtils.getImagesPath(request);
  String cssPath = FormUtils.getCSSPath(request);
  String content_title = HTTPUtils.cleanXSS((String) request.getParameter("content_title"));
  if (content_title == null || content_title.trim().length() <= 0)
      content_title = "Suggest New Term";
  String content_quickLink = HTTPUtils.cleanXSS((String) request.getParameter("content_quickLink"));
  if (content_quickLink == null)
      content_quickLink = "";
      
  String content_page = HTTPUtils.cleanXSS((String) request.getParameter("content_page"));
  
  String buildDate = AppProperties.getInstance().getBuildDate();
  String application_version = AppProperties.getInstance().getAppVersion();
  String anthill_build_tag_built = AppProperties.getInstance().getAnthillBuildTagBuilt();  
  //String version = (String) 
  //  request.getSession().getAttribute(FormRequest.VERSION);
  
  String version = null;
  Object version_obj = request.getSession().getAttribute(FormRequest.VERSION);
  
  if (version == null) {
      version = "Default";
  } else {
      version = version_obj.toString();
  }
  
  String logoUrl = basePath + "/" + BaseRequest.getUrlParameter(version);
%>
<!--
   Build info: <%=buildDate%>
 Version info: <%=application_version%>
          Tag: <%=anthill_build_tag_built%>
  -->
<html lang="en" xmlns:c="http://java.sun.com/jsp/jstl/core"> 

<script src="//assets.adobedtm.com/f1bfa9f7170c81b1a9a9ecdcc6c5215ee0b03c84/satelliteLib-4b219b82c4737db0e1797b6c511cf10c802c95cb.js"></script>
<script src='https://www.google.com/recaptcha/api.js'></script>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%=content_title%></title>
    <link rel="stylesheet" type="text/css" href="<%=cssPath%>/styleSheet.css" />
    <link rel="shortcut icon" href="<%=basePath%>/favicon.ico" type="image/x-icon" />
    
    
    <script>

    function getContextPath() {
	return "<%=request.getContextPath()%>";
    }

    function loadAudio() {
        var path = getContextPath() + "/audio.wav?bogus=";
        document.getElementById("audioCaptcha").src = path + new Date().getTime();
        document.getElementById("audioSupport").innerHTML = document.createElement('audio').canPlayType("audio/wav");
    }


    function verifyRecaptcha0() {
        // User has to check reCAPTCHA
        var response = grecaptcha.getResponse();
        if(response == '') {
            alert("Please complete the I'm-not-a-robot widget before submitting your entry.");
            return false;
        }
    }
        

function verifyRecaptcha() {
    var response = grecaptcha.getResponse();
    $.ajax({
        type: "POST",
        url: 'https://www.google.com/recaptcha/api/siteverify',
        data: {"secret" : "<%=Constants.SITE_KEY%>", "response" : response},
        contentType: 'application/x-www-form-urlencoded',
        success: function(data) { 
           //console.log(data); 
           //alert("pass");
           
            String redirectURL = request.getContextPath() + "/redirect?action='contactus";
            response.sendRedirect(redirectURL);
           
		if(data.response == '') {
		    alert("Please complete the I'm-not-a-robot widget before submitting your entry.");
		    return false;
		}
               
        }
    });
}

        
    </script>    
    
    
  </head>
  <body>
  
    <f:view>
    <!-- Begin Skip Top Navigation -->
      <a href="#evs-content" class="hideLink" accesskey="1" title="Skip repetitive navigation links">skip navigation links</A>
    <!-- End Skip Top Navigation -->      
  
    <jsp:include page="/pages/templates/header.jsp" />
    <div class="center-page_960">
      <jsp:include page="/pages/templates/sub_header.jsp" />
      <div class="mainbox-top"><img src="<%=imagesPath%>/mainbox-top.gif"
        width="941" height="5" alt="Mainbox Top" /></div>
      <div id="main-area_960">
        <div class="bannerarea_960">
          <a href="<%=logoUrl%>"><img src="<%=imagesPath%>/banner.gif"
            alt="Suggest Term Logo" border="0"/></a>
        </div>
        <div class="bluebar_960">
          <% if (content_quickLink.length() > 0) { %>
            <jsp:include page="<%=content_quickLink%>" />
          <% } %>
        </div>
        
        
        <div class="pagecontent">
          <a name="evs-content" id="evs-content"></a>
          
          <jsp:include page="<%=content_page%>" />
          <jsp:include page="/pages/templates/footer.jsp" />
        </div>
      </div>
      <div class="mainbox-bottom"><img src="<%=imagesPath%>/mainbox-bottom.gif"
        width="941" height="5" alt="Mainbox Bottom" /></div>
    </div>
<script type="text/javascript">_satellite.pageBottom();</script>
  </body>
  <br>
</html>
