<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>

<%@ page import="nl.captcha.Captcha" %>
<%@ page import="nl.captcha.audio.AudioCaptcha" %>

<html>
<head>
<script src="//assets.adobedtm.com/f1bfa9f7170c81b1a9a9ecdcc6c5215ee0b03c84/satelliteLib-4b219b82c4737db0e1797b6c511cf10c802c95cb.js"></script>
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>NCI Term Form</title>

	<script type="text/javascript" src="<%=FormUtils.getJSPath(request)%>/utils.js"></script>
	<link href="<%= request.getContextPath() %>/css/sc.css" type="text/css" rel="stylesheet" />    

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
    
</head>

<%

  //Prop.Version versionSession = (Prop.Version) 
  //   request.getSession().getAttribute(FormRequest.VERSION);

    String versionSession = (String) request.getSession().getAttribute(FormRequest.VERSION);
    boolean audio_captcha_background_noise_on = true;
    String audio_captcha_str = "audio.wav";
    if (!AppProperties.isAudioCaptchaBackgroundNoiseOn()) {
        audio_captcha_background_noise_on = false;
        audio_captcha_str = "nci.audio.wav";
    }
    
    String captcha_option = "default";
    String alt_captcha_option = "audio";
    String opt = HTTPUtils.cleanXSS((String) request.getSession().getAttribute("captcha_option"));
    if (opt != null && opt.compareTo("audio") == 0) {
          captcha_option = "audio";
          alt_captcha_option = "default";
    }    

  Captcha captcha = (Captcha) request.getSession().getAttribute("captcha");
  AudioCaptcha ac = null;  
  
    String errorMsg = (String) request.getSession().getAttribute("errorMsg");
    if (errorMsg != null) {
        request.getSession().removeAttribute("errorMsg");
    }  
  
    String retry = (String) request.getSession().getAttribute("retry_cdisc");  

    if (retry != null && retry.compareTo("true") == 0) {
        request.getSession().removeAttribute("retry_cdisc");
    }
%>    

<body>


<%!
  // List of parameter name(s):
  private static final String DICTIONARY = "dictionary";
  private static final String CODE = "code";

  // List of attribute name(s):
  private static final String EMAIL = SuggestionCDISCRequest.EMAIL;
  private static final String NAME = SuggestionCDISCRequest.NAME;
  private static final String PHONE_NUMBER = SuggestionCDISCRequest.PHONE_NUMBER;
  private static final String ORGANIZATION = SuggestionCDISCRequest.ORGANIZATION;
  private static final String VOCABULARY = SuggestionCDISCRequest.VOCABULARY;
  private static final String CDISC_REQUEST_TYPE = SuggestionCDISCRequest.CDISC_REQUEST_TYPE;
  private static final String CDISC_CODES = SuggestionCDISCRequest.CDISC_CODES;
  private static final String TERM = SuggestionCDISCRequest.TERM;
  private static final String REASON = SuggestionCDISCRequest.REASON;
  private static final String WARNINGS = SuggestionCDISCRequest.WARNINGS;

  // List of label(s):
  private static final String EMAIL_LABEL = SuggestionCDISCRequest.EMAIL_LABEL;
  private static final String NAME_LABEL = SuggestionCDISCRequest.NAME_LABEL;
  private static final String PHONE_NUMBER_LABEL = SuggestionCDISCRequest.PHONE_NUMBER_LABEL;
  private static final String ORGANIZATION_LABEL = SuggestionCDISCRequest.ORGANIZATION_LABEL;
  private static final String VOCABULARY_LABEL = SuggestionCDISCRequest.VOCABULARY_LABEL;
  private static final String CDISC_REQUEST_TYPE_LABEL = SuggestionCDISCRequest.CDISC_REQUEST_TYPE_LABEL;
  private static final String CDISC_CODES_LABEL = SuggestionCDISCRequest.CDISC_CODES_LABEL;
  private static final String TERM_LABEL = SuggestionCDISCRequest.TERM_LABEL;
  private static final String REASON_LABEL = SuggestionCDISCRequest.REASON_LABEL;

  private static final String INPUT_ARGS =
    "class=\"textbody\" onFocus=\"active=true\" onBlur=\"active=false\"";
    // " onKeyPress=\"return ifenter(event,this.form)\"";
  private static final String LABEL_ARGS = "valign=\"top\"";
%>
<%
    // Member variable(s):
   
  String imagesPath = FormUtils.getImagesPath(request);
  String version = BaseRequest.getVersion(request);
  //SuggestionCDISCRequest.setupTestData();

  // Attribute(s):
  String email = (String) request.getSession().getAttribute(EMAIL);
  String name = (String) request.getSession().getAttribute(NAME);
  String phone_number = (String) request.getSession().getAttribute(PHONE_NUMBER);
  String organization = (String) request.getSession().getAttribute(ORGANIZATION);
  String vocabulary = (String) request.getSession().getAttribute(VOCABULARY);
  String cdisc_request_type = (String) request.getSession().getAttribute(CDISC_REQUEST_TYPE);
  String cdisc_codes = (String) request.getSession().getAttribute(CDISC_CODES);
  String term = (String) request.getSession().getAttribute(TERM);
 
  
  String reason = (String) request.getSession().getAttribute(REASON);
  String warnings = (String) request.getSession().getAttribute(WARNINGS);

  if (email == null || email.compareTo("null") == 0) email = "";
  if (name == null || name.compareTo("null") == 0) name = "";
  if (phone_number == null || phone_number.compareTo("null") == 0) phone_number = "";
  if (organization == null || organization.compareTo("null") == 0) organization = "";
  if (vocabulary == null || vocabulary.compareTo("null") == 0) vocabulary = "NCI Thesaurus";
  if (cdisc_request_type == null || cdisc_request_type.compareTo("null") == 0) cdisc_request_type = "";
  if (cdisc_codes == null || cdisc_codes.compareTo("null") == 0) cdisc_codes = "";
  if (term == null || term.compareTo("null") == 0) term = "";
  if (reason == null || reason.compareTo("null") == 0) reason = "";
  if (warnings == null || warnings.compareTo("null") == 0) warnings = "";

  boolean isWarnings = false;
  if (warnings != null && warnings.length() > 0) isWarnings = true;  

  String message = (String) request.getSession().getAttribute("message");
  //String retry = (String) request.getSession().getAttribute("retry_cdisc");  
  //request.getSession().removeAttribute("retry_cdisc");
  String pVocabulary = null;
  String newtermform =  HTTPUtils.cleanXSS((String) request.getParameter("newtermform"));
  if (newtermform == null || newtermform.compareTo("null") == 0) {
	  pVocabulary =  HTTPUtils.cleanXSS((String) request.getParameter(DICTIONARY));
  } else {
      pVocabulary = vocabulary;
  }
  if (pVocabulary == null) {
      pVocabulary = "NCI Thesaurus";
  }

  /*
  String pVocabulary = HTTPUtils.getJspParameter(request, VOCABULARY);
  if (pVocabulary == null || pVocabulary.length() <= 0) {
    // Note: This is how NCIt/TB and NCIm is passing in this value.  
    pVocabulary = HTTPUtils.getJspParameter(request, DICTIONARY);
  }
  */

  // Member variable(s):
  int i=0;
  String[] items = null;
  String selectedItem = null;
  String css = WebUtils.isUsingIE(request) ? "_IE" : "";
%>
<f:view>


<%
if (errorMsg != null) {
%>
<p class="textbodyred">&nbsp;<%=errorMsg%></p>
<%
}
%>

<h:form id="suggestion" styleClass="search-form" acceptcharset="UTF-8">
    <table class="newConceptDT">
      <!-- =================================================================== -->
<%      
          boolean form_completed = true;
          if (isWarnings) {
                  form_completed = false;
		  String[] wList = StringUtils.toStrings(warnings, "\n", false, false);
		  for (i=0; i<wList.length; ++i) {
		    String warning = wList[i];
		    warning = StringUtils.toHtml(warning); // For leading spaces (indentation)
			    if (i==0) {
		      %>
			      <tr>
				<td <%=LABEL_ARGS%>><b class="warningMsgColor">Warning:</b></td>
				<td><i class="warningMsgColor"><%=warning%></i></td>
			      </tr>
		      <%
			  } else {
		      %>
			      <tr>
				<td <%=LABEL_ARGS%>></td>
				<td><i class="warningMsgColor"><%=warning%></i></td>
			      </tr>
		      <%
			  }
		    }
	      %>
		  <tr><td><br/></td></tr>
      <%
          } 

          if (message != null && message.compareTo("null") != 0) {
              form_completed = false;
              request.getSession().removeAttribute("message");
      %>    
              <tr>
                <td></td>
                <td><i class="warningMsgColor"><%=message%></i></td>
              </tr> 

              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr> 
              
<%         
             
          }

    if (!form_completed) {
        request.getSession().setAttribute("retry_cdisc", "true");
              
%>
          
          <tr>
                <td></td>
                <td>

    
          <%
          
          String refresh = (String) request.getSession().getAttribute("refresh");
          boolean refresh_bool = false;
          if (refresh != null && refresh.compareTo("true") == 0) {
              refresh_bool = true;
          }
          request.getSession().removeAttribute("refresh");         

             if (refresh_bool) {
          %>
               <h:outputLink
                  value="/ncitermform/?version=cdisc">
                  <h:graphicImage value="/images/refresh.gif" alt="Refresh image"
                  style="border-width:0;" />
              </h:outputLink>            
          
          <%
              } else {
          %>    
                <h:outputLink
                  value="/ncitermform/?version=cdisc">
                  <h:graphicImage value="/images/tryagain.gif" alt="Try again"
                  style="border-width:0;" />
                </h:outputLink>                 
          <%    
              }

          %>
          

              </td>
              </tr> 
              
     <%     
          } else { 
          
request.getSession().removeAttribute("retry_cdisc");

      %>

      <!-- =================================================================== -->
      <tr><td class="newConceptSubheader" colspan="2">Contact Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=EMAIL%>"><%=EMAIL_LABEL%></LABEL>: <i class="warningMsgColor">*</i></td>
        <td colspan="2">
          <input type="text" id="<%=EMAIL%>" name="<%=EMAIL%>" value="<%=email%>" alt="<%=EMAIL%>"
          class="newConceptTF<%=css%>" <%=INPUT_ARGS%>>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=NAME%>"><%=NAME_LABEL%></LABEL>:</td>
        <td colspan="2">
          <input type="text" name="<%=NAME%>" value="<%=name%>" alt="<%=NAME%>"
          class="newConceptTF<%=css%>" <%=INPUT_ARGS%>>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=PHONE_NUMBER%>"><%=PHONE_NUMBER_LABEL%></LABEL>:</td>
        <td colspan="2">
          <input type="text" name="<%=PHONE_NUMBER%>" value="<%=phone_number%>" alt="<%=PHONE_NUMBER%>"
          class="newConceptTF<%=css%>" <%=INPUT_ARGS%>>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=ORGANIZATION%>"><%=ORGANIZATION_LABEL%></LABEL>:</td>
        <td colspan="2">
          <input type="text" name="<%=ORGANIZATION%>" value="<%=organization%>" alt="<%=ORGANIZATION%>"
          class="newConceptTF<%=css%>" <%=INPUT_ARGS%>>
        </td>
      </tr>

      <tr>
        <td></td>
        <td colspan="2" class="newConceptNotes"><b class="warningMsgColor">Privacy Notice: </b>
          For term submission purposes we request business contact information only, not personal information.
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;Your business email, and any other business contact information that you enter, will be stored in a publicly-accessible
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;web site in support of CDISC term submission tracking.  CDISC personnel may contact you.
        </td>
      </tr>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr>
        <td class="newConceptSubheader">Term Information:</td>
        <td>
Fill in the following fields as appropriate. 
For multiple term submissions, please click on and download the Excel file 
<a href="<%= request.getContextPath() %>/download?action=download" 
title="CDISC_Controlled_Terminology_Multiple_Term_Request_Spreadsheet">
CDISC Controlled Terminology Multiple Term Request Spreadsheet</a>  
and add on your name and request date to the end of the file name.  
Email this completed file to 
<a href="mailto:NciEvsCdiscHelp@mail.nih.gov?Subject=CDISC%20New%20Term%20Request" target="_top">
NciEvsCdiscHelp@mail.nih.gov</a>.
In addition, please submit a CDISC New Term Request form indicating 
"File emailed separately" in Additional Information.
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="url"><%=VOCABULARY_LABEL%></LABEL>:</td>
        <td>
          <select name="<%=VOCABULARY%>" id="url" class="newConceptCB2<%=css%>">
            <%
                selectedItem = vocabulary;
                ArrayList list = AppProperties.getInstance().getVocabularies(version);
                VocabInfo[] vocabs  = (VocabInfo[]) 
                  list.toArray(new VocabInfo[list.size()]);
                boolean isSelected = false;
                int n = vocabs.length;
                for (i=0; i<n; ++i) {
                  VocabInfo vocab = vocabs[i];
                  String displayName = vocab.getDisplayName();
                  String vocabName = vocab.getName();
                  String url = vocab.getUrl();
                  
                  String args = "";
                  if (! isSelected) {
                    if (! isWarnings && vocabName.equalsIgnoreCase(pVocabulary))
                      { args += "selected=\"true\""; isSelected = true; }
                    else if (url.length() > 0 && url.equals(selectedItem))
                      { args += "selected=\"true\""; isSelected = true; }
                    else if (i >= n-1 && pVocabulary.length() > 0) // Default it to the last one.
                      { args += "selected=\"true\""; isSelected = true; }
                  }
                  
            %>
                  <option value="<%=url%>" <%=args%>><%=displayName%></option>
            <%
                }
            %>
          </select>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=CDISC_REQUEST_TYPE%>"><%=CDISC_REQUEST_TYPE_LABEL%></LABEL>:</td>
        <td colspan="2">
          <select name="<%=CDISC_REQUEST_TYPE%>" class="newConceptCB2<%=css%>">
            <%
              selectedItem = cdisc_request_type;
              items = AppProperties.getInstance().getCDISCRequestTypeList();
              for (i=0; i<items.length; ++i) {
                String item = items[i];
                String args = "";
                if (item.equals(selectedItem))
                  args += "selected=\"true\"";
            %>
                  <option value="<%=item%>" <%=args%>><%=item%></option>
            <%
              }
            %>
          </select>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=CDISC_CODES%>"><%=CDISC_CODES_LABEL%></LABEL>:</td>
        <td colspan="2">
          <select name="<%=CDISC_CODES%>" class="newConceptCB2<%=css%>">
            <%
              selectedItem = cdisc_codes;
              items = AppProperties.getInstance().getCDISCCodeList();
              for (i=0; i<items.length; ++i) {
                String item = items[i];
                String args = "";
                if (item.equals(selectedItem))
                  args += "selected=\"true\"";
            %>
                  <option value="<%=item%>" <%=args%>><%=item%></option>
            <%
              }
            %>
          </select>
        </td>
      </tr>
      <tr>
        <td></td>
        <td colspan="2" class="newConceptNotes"><b class="warningMsgColor">Note to user: </b>
          CDASH and SDTM Terminology are the same and are contained within the SDTM codelists in the drop down list.
        </td>        
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=TERM%>"><%=TERM_LABEL%></LABEL>: <i class="warningMsgColor">*</i></td>
        <td colspan="2"><textarea id="<%=TERM%>" name="<%=TERM%>" class="newConceptTA2<%=css%>"><%=term%></textarea></td>
      </tr>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr><td class="newConceptSubheader" colspan="2">Additional Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><LABEL FOR="<%=REASON%>"><%=REASON_LABEL%></LABEL>: <i class="warningMsgColor">*</i></td>
        <td colspan="2"><textarea name="<%=REASON%>" class="newConceptTA6<%=css%>"><%=reason%></textarea></td>
      </tr>

      <!-- =================================================================== -->
 
 <%
 
 System.out.println(REASON_LABEL);
 
 
 String answer = "";
 String answer_label = "Enter the characters appearing in the above image";
 if (captcha_option.compareTo("default") != 0) {
     answer_label = "";
 }
 
 if (captcha_option.compareTo("default") == 0) {
 %>
      <tr><td class="newConceptSubheader" colspan="2">Security Code:</td></tr>
      <tr>  
      <td></td>
      <td <%=LABEL_ARGS%> class="newConceptTA6<%=css%>">
              <img src="<c:url value="/nci.simpleCaptcha.png"  />" alt="simpleCaptcha.png">
        &nbsp;<h:commandLink value="Unable to read this image?" action="#{userSessionBean.regenerateCaptchaImage}" />
      </td>
      </tr> 
      
       <tr>
       <td <%=LABEL_ARGS%> class="newConceptTA6<%=css%>"> 
           <%=answer_label%>: <i class="warningMsgColor">*</i>
       </td>
       <td <%=LABEL_ARGS%> class="newConceptTA6<%=css%>">
           <input type="text" id="answer" name="answer" value="<%=HTTPUtils.cleanXSS(answer)%>"/>&nbsp;
           &nbsp;<h:commandLink value="Prefer an alternative form of CAPTCHA?" action="#{userSessionBean.switchCaptchaMode}" />
       </td>
       </tr>      
      
 <%
 } else {
 %>
      <tr>
 <td <%=LABEL_ARGS%> class="newConceptTA6<%=css%>">
 Click <a href="<%=request.getContextPath()%>/<%=audio_captcha_str%> ">here</a> to listen to the audio, 
 then enter the numbers you hear from the audio
 
           <%=answer_label%>: <i class="warningMsgColor">*</i>
       </td>
       <td <%=LABEL_ARGS%> class="newConceptTA6<%=css%>">
           <input type="text" id="answer" name="answer" value="<%=HTTPUtils.cleanXSS(answer)%>"/>&nbsp;
           &nbsp;<h:commandLink value="Prefer an alternative form of CAPTCHA?" action="#{userSessionBean.switchCaptchaMode}" />
       </td>
       </tr>       
       
 <%
 } 
%>
      
      <tr>
        <td class="newConceptNotes"><i class="warningMsgColor">* Required</i></td>
        <td colspan="2" align="right">
<!--        
           <h:commandButton
             id="clear"
             value="clear"
             action="#{userSessionBean.clearCDISCSuggestion}"
             image="/images/clear.gif"
             alt="clear">
           </h:commandButton>      
-->

     <a href="<%= request.getContextPath() %>/redirect?version=<%=version%>" tabindex="15"
	onclick="return confirm('Are you sure you want clear this page?')">
	<img src="<%=imagesPath%>/clear.gif" border="0"></a>
	
           <img src="<%=imagesPath%>/spacer.gif" width="1" />
 
           <h:commandButton
             id="submit"
             value="submit"
             action="#{userSessionBean.requestSuggestionCDISC}"
             image="/images/submit.gif"
              alt="submit">
           </h:commandButton>        

        </td>
      </tr>
      
      <%
      }
      %>      
      
      </table>      

      <input type="hidden" id="cdisc" name="cdisc" value="true" />
      <input type="hidden" name="captcha_option" id="captcha_option" value="<%=alt_captcha_option%>">
      <input type="hidden" name="newtermform" id="newtermform" value="cdiscnewtermform">
      <input type="hidden" name="version" id="version" value="<%=versionSession%>">

  </h:form>
</f:view>

<script type="text/javascript">_satellite.pageBottom();</script>
</body>
</html>
