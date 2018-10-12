<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>

<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="nl.captcha.Captcha" %>
<%@ page import="nl.captcha.audio.AudioCaptcha" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%

  String template_action = HTTPUtils.cleanXSS((String) request.getParameter("action"));
  String template_version = null;
  if (template_action == null) {
      template_version = BaseRequest.getVersion(request);
  } 
  System.out.println("(*) template_version= " + template_version);


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
  
System.out.println("content_page: " + content_page);  
    
  
  String buildDate = AppProperties.getInstance().getBuildDate();
  String application_version = AppProperties.getInstance().getAppVersion();
  String anthill_build_tag_built = AppProperties.getInstance().getAnthillBuildTagBuilt();  
  
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
<head>
<script src="//assets.adobedtm.com/f1bfa9f7170c81b1a9a9ecdcc6c5215ee0b03c84/satelliteLib-4b219b82c4737db0e1797b6c511cf10c802c95cb.js"></script>
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>NCI Term Form</title>

<link rel="stylesheet" type="text/css" href="<%=cssPath%>/styleSheet.css" />
<link rel="shortcut icon" href="<%=basePath%>/favicon.ico" type="image/x-icon" />

<script type="text/javascript" src="<%=FormUtils.getJSPath(request)%>/utils.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/jquery-ui.css">
<link href="<%= request.getContextPath() %>/css/sc.css" type="text/css" rel="stylesheet" /> 
<link href="<%= request.getContextPath() %>/css/ui-widget.css" type="text/css" rel="stylesheet" />
<script src="<%= request.getContextPath()%>/js/jquery-1.12.4.js"></script>
    
    
<style>    
#skip a
{ 
position:absolute; 
left:-10000px; 
top:auto; 
width:1px; 
height:1px; 
overflow:hidden;
} 
 
#skip a:focus 
{ 
position:static; 
width:auto; 
height:auto; 
} 
</style>
    
    <script>
    
	function displayVocabLinkInNewWindow(id) {
		var element = document.getElementById(id);
		var url = element.value;
		if (url != "")
			element.onclick=window.open(url);
		else
			alert("This vocabulary does not have\nan associated home page.");
	}    


	function openNewWindow(url) {
		window.open(url, '_blank', 'top=100, left=100, height=740, width=780, status=no, menubar=yes, resizable=yes, scrollbars=yes, toolbar=yes, location=no, directories=no');
	}
    
	function getContextPath() {
		return "<%=request.getContextPath()%>";
	}

	function loadAudio() {
		var path = getContextPath() + "/audio.wav?bogus=";
		document.getElementById("audioCaptcha").src = path + new Date().getTime();
		document.getElementById("audioSupport").innerHTML = document.createElement('audio').canPlayType("audio/wav");
	}

	function submitOnEnter(form, event) {
		if (event.which){
			if(event.which == 13) {
				window.submitForm('suggestion',1,{source:'submit'});
				return false;
			}
		} else {
			if(window.event.keyCode==13)
			{
				window.submitForm('suggestion',1,{source:'submit'});
				return false;
			}
		}
	}
	
    </script>
    <script>
	$( function() {
		var str = document.getElementById("cdisc_codes_str").value;
		var cdisc_codes = str.split(";");
		$( "#cdiscCodeList" ).autocomplete({
		source: cdisc_codes
		});
	} );
    </script>    
</head>
<body>
    <f:view>
    <!-- Begin Skip Top Navigation -->
      <div id="skip">
      <a href="#evs-content" class="skip-main" accesskey="1" title="Skip repetitive navigation links">skip navigation links</a>
      </div>
    <!-- End Skip Top Navigation -->      
  
<%
System.out.println( "header.jsp");
%>
  
  
    <jsp:include page="/pages/templates/header.jsp" />
    <div class="center-page_960">
    
    
<%
System.out.println( "sub_header.jsp");
%>    
    
    
      <jsp:include page="/pages/templates/sub_header.jsp" />
      <div class="mainbox-top"><img src="<%=imagesPath%>/mainbox-top.gif"
        width="941" height="5" alt="Mainbox Top" /></div>
      <div id="main-area_960">
        <div class="bannerarea_960">
          <a href="<%=logoUrl%>"><img src="<%=imagesPath%>/banner.gif"
            alt="Suggest Term Logo" border="0"/></a>
        </div>
        <div class="bluebar_960">
        
<%
System.out.println( "content_quickLink.jsp");
%>         
        
          <% if (content_quickLink.length() > 0) { %>
            <jsp:include page="<%=content_quickLink%>" />
          <% } %>
        </div>
        
        <div class="pagecontent">
          <a name="evs-content" id="evs-content" tabindex="0"></a>
          
<%
System.out.println( "content_page.jsp");
%>            
          
          
          <jsp:include page="<%=content_page%>" />
          
<%
System.out.println( "footer.jsp");
%>          
          
          
          <jsp:include page="/pages/templates/footer.jsp" />
        </div>
      </div>
      <div class="mainbox-bottom"><img src="<%=imagesPath%>/mainbox-bottom.gif"
        width="941" height="5" alt="Mainbox Bottom" /></div>
    </div>
    </f:view>    
<script type="text/javascript">_satellite.pageBottom();</script>
  </body>
</html>
