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
    <META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>NCI Term Form</title>

	<script type="text/javascript" src="<%=FormUtils.getJSPath(request)%>/utils.js"></script>
	<link href="<%= request.getContextPath() %>/css/sc.css" type="text/css" rel="stylesheet" />    

    <script>
	    function getContextPath() {
		return "<%=request.getContextPath()%>";
	    }

	    function loadAudio() {
		var path = getContextPath() + "/audio.wav?bogus=";
		document.getElementById("audioCaptcha").src = path + new Date().getTime();
		document.getElementById("audioSupport").innerHTML = document.createElement('audio').canPlayType("audio/wav");
	    }
    </script>
    
</head>

<%
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
  
  String retry = (String) request.getSession().getAttribute("retry");
  if (retry != null && retry.compareTo("true") == 0) {
        request.getSession().removeAttribute("retry");
  }

%>    
    
<body>


<%!
  // List of parameter name(s):
  
  private static final String DICTIONARY = "dictionary";
  private static final String CODE = "code";

  // List of attribute name(s):
  private static final String EMAIL = SuggestionRequest.EMAIL;
  private static final String OTHER = SuggestionRequest.OTHER;
  private static final String VOCABULARY = SuggestionRequest.VOCABULARY;
  private static final String TERM = SuggestionRequest.TERM;
  private static final String SYNONYMS = SuggestionRequest.SYNONYMS;
  private static final String NEAREST_CODE = SuggestionRequest.NEAREST_CODE;
  private static final String DEFINITION = SuggestionRequest.DEFINITION;
  private static final String CADSR_SOURCE = SuggestionRequest.CADSR_SOURCE;
  private static final String CADSR_TYPE = SuggestionRequest.CADSR_TYPE;
  private static final String PROJECT = SuggestionRequest.PROJECT;
  private static final String REASON = SuggestionRequest.REASON;
  private static final String WARNINGS = SuggestionRequest.WARNINGS;

  // List of label(s):
  private static final String EMAIL_LABEL = SuggestionRequest.EMAIL_LABEL;
  private static final String OTHER_LABEL = SuggestionRequest.OTHER_LABEL;
  private static final String VOCABULARY_LABEL = SuggestionRequest.VOCABULARY_LABEL;
  private static final String TERM_LABEL = SuggestionRequest.TERM_LABEL;
  private static final String SYNONYMS_LABEL = SuggestionRequest.SYNONYMS_LABEL;
  private static final String NEAREST_CODE_LABEL = SuggestionRequest.NEAREST_CODE_LABEL;
  private static final String DEFINITION_LABEL = SuggestionRequest.DEFINITION_LABEL;
  private static final String CADSR_SOURCE_LABEL = SuggestionRequest.CADSR_SOURCE_LABEL;
  private static final String CADSR_TYPE_LABEL = SuggestionRequest.CADSR_TYPE_LABEL;
  private static final String PROJECT_LABEL = SuggestionRequest.PROJECT_LABEL;
  private static final String REASON_LABEL = SuggestionRequest.REASON_LABEL;

  private static final String INPUT_ARGS =
    "class=\"textbody\" onFocus=\"active=true\" onBlur=\"active=false\"";
    // " onKeyPress=\"return ifenter(event,this.form)\"";
  private static final String LABEL_ARGS = "valign=\"top\"";
%>
<%
    // Member variable(s):
  String imagesPath = FormUtils.getImagesPath(request);
  String version = BaseRequest.getVersion(request);
    
  //Prop.Version version = BaseRequest.getVersion(request);
  
  //SuggestionRequest.setupTestData();
  

  // Attribute(s):
  /*
  String email = HTTPUtils.getJspSessionAttributeString(request, EMAIL);
  String other = HTTPUtils.getJspSessionAttributeString(request, OTHER);
  String vocabulary = HTTPUtils.getJspSessionAttributeString(request, VOCABULARY);
  String term = HTTPUtils.getJspSessionAttributeString(request, TERM);
  String synonyms = HTTPUtils.getJspSessionAttributeString(request, SYNONYMS);
  String nearest_code = HTTPUtils.getJspSessionAttributeString(request, NEAREST_CODE);
  String definition = HTTPUtils.getJspSessionAttributeString(request, DEFINITION);
  String cadsr_source = HTTPUtils.getJspSessionAttributeString(request, CADSR_SOURCE);
  String cadsr_type = HTTPUtils.getJspSessionAttributeString(request, CADSR_TYPE);
  String reason = HTTPUtils.getJspSessionAttributeString(request, REASON);
  String project = HTTPUtils.getJspSessionAttributeString(request, PROJECT);
  String warnings = HTTPUtils.getJspAttributeString(request, WARNINGS);
  */
  
  String email = (String) request.getSession().getAttribute(EMAIL);
  String other = (String) request.getSession().getAttribute(OTHER);
  String vocabulary = (String) request.getSession().getAttribute(VOCABULARY);
  String term = (String) request.getSession().getAttribute(TERM);
  String synonyms = (String) request.getSession().getAttribute(SYNONYMS);
  String nearest_code = (String) request.getSession().getAttribute(NEAREST_CODE);
  String definition = (String) request.getSession().getAttribute(DEFINITION);
  String cadsr_source = (String) request.getSession().getAttribute(CADSR_SOURCE);
  String cadsr_type = (String) request.getSession().getAttribute(CADSR_TYPE);
  String reason = (String) request.getSession().getAttribute(REASON);
  String project = (String) request.getSession().getAttribute(PROJECT);
  String warnings = (String) request.getSession().getAttribute(WARNINGS);
  
  if (email == null || email.compareTo("null") == 0) email = "";
  if (other == null || other.compareTo("null") == 0) other = "";
  if (vocabulary == null || vocabulary.compareTo("null") == 0) {
      vocabulary = "NCI Thesaurus";
  }
  if (term == null || term.compareTo("null") == 0) term = "";
  if (synonyms == null || synonyms.compareTo("null") == 0) synonyms = "";
  if (nearest_code == null || nearest_code.compareTo("null") == 0) {
  	nearest_code = "";
  }
  
  if (definition == null || definition.compareTo("null") == 0) definition = "";
  if (cadsr_source == null || cadsr_source.compareTo("null") == 0) cadsr_source = "";
  if (cadsr_type == null || cadsr_type.compareTo("null") == 0) cadsr_type = "";
  if (reason == null || reason.compareTo("null") == 0) reason = "";
  if (project == null || project.compareTo("null") == 0) project = "";
  if (warnings == null || warnings.compareTo("null") == 0) warnings = "";
      
  boolean isWarnings = false;
  if (warnings != null && warnings.length() > 0) isWarnings = true;  
  String message = (String) request.getSession().getAttribute("message");
  String answer  = "";

  String pVocabulary = null;
  String pCode = null;
 
  String newtermform = (String) request.getParameter("newtermform");
  if (newtermform == null || newtermform.compareTo("null") == 0) {
	  pVocabulary = (String) request.getParameter(DICTIONARY);// HTTPUtils.getJspParameter(request, DICTIONARY);
	  /*
	  if (pVocabulary == null || pVocabulary.length() <= 0) {
	      // Note: This is how NCIt/TB and NCIm is passing in this value.  
	      pVocabulary = HTTPUtils.getJspParameter(request, DICTIONARY);
	  } 
	  */
 	  pCode = (String) request.getParameter(CODE);//getJspParameter(request, CODE, false);
  	  if (! isWarnings && pCode != null && pCode.compareTo("null") != 0) {
		nearest_code = pCode;
          }
  } else {
      pVocabulary = vocabulary;
      pCode = nearest_code;
  }


  if (pVocabulary == null || pVocabulary.compareTo("null") == 0) {
      pVocabulary = "NCI Thesaurus";
  }
  
  
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


  <h:form id="suggestion" onkeypress="return handleSubmit(event, 'suggestion:submit')">
   
  
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
        request.getSession().setAttribute("retry", "true");
              
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

              request.getSession().setAttribute("retry", "true");
              request.getSession().setAttribute(OTHER, other);
              request.getSession().setAttribute(VOCABULARY, vocabulary);
              request.getSession().setAttribute(TERM, term);
              request.getSession().setAttribute(SYNONYMS, synonyms);
              request.getSession().setAttribute(DEFINITION, definition);
              request.getSession().setAttribute(NEAREST_CODE, nearest_code);
              request.getSession().setAttribute(CADSR_SOURCE, cadsr_source);
              request.getSession().setAttribute(CADSR_TYPE, cadsr_type);
              request.getSession().setAttribute(REASON, reason);
              request.getSession().setAttribute(PROJECT, project);
              request.getSession().setAttribute(WARNINGS, warnings);
              
              request.getSession().setAttribute("cdisc", "false");
              
              //if (versionSession == Prop.Version.CADSR) {
              if (version.compareToIgnoreCase("CADSR") == 0) {
                if (refresh_bool) { %>
                  <h:outputLink
                    value="/ncitermform/?version=cadsr">
                    <h:graphicImage value="/images/refresh.gif" alt="Refresh image"
                    style="border-width:0;" />
                  </h:outputLink>            
                <% } else { %>    
                  <h:outputLink
                    value="/ncitermform/?version=cadsr">
                    <h:graphicImage value="/images/tryagain.gif" alt="Try again"
                    style="border-width:0;" />
                  </h:outputLink>                 
                <% }
              } else {
                  if (refresh_bool) { %>
                  <h:outputLink
                    value="/ncitermform/">
                    <h:graphicImage value="/images/refresh.gif" alt="Refresh image"
                    style="border-width:0;" />
                  </h:outputLink>            
                <% } else { %>    
                  <h:outputLink
                    value="/ncitermform/">
                    <h:graphicImage value="/images/tryagain.gif" alt="Try again"
                    style="border-width:0;" />
                  </h:outputLink>                 
                <% }
              }

          %>
          
              </td>
              </tr> 
              
     <%     
          } else {
          
 request.getSession().removeAttribute("retry");
         

      %>

      <!-- =================================================================== -->
      <tr><td class="newConceptSubheader" colspan="2">Contact Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=EMAIL_LABEL%>: <i class="warningMsgColor">*</i></td>
        <td colspan="2">
          <input type="text" id="<%=EMAIL%>" name="<%=EMAIL%>" value="<%=email%>" alt="<%=EMAIL%>"
          class="newConceptTF<%=css%>" <%=INPUT_ARGS%>>
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=OTHER_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=OTHER%>" class="newConceptTA4<%=css%>"><%=other%></textarea></td>
      </tr>
      <tr>
        <td></td>
        <td colspan="2" class="newConceptNotes"><b class="warningMsgColor">Privacy Notice: </b>
          For term submission purposes we request business contact information only, not personal information.
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;Your business email, and any other business contact information that you enter, will only be used to contact you
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;about this topic if any clarifications are needed.  This information will not be disseminated to others outside the 
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;EVS group of the NCI, or stored except as part of the email communications on this topic.
        </td>
      </tr>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr>
        <td class="newConceptSubheader">Term Information:</td>
        <td>Fill in the following fields as appropriate:</td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=VOCABULARY_LABEL%>:</td>
        <td>
          <select name="<%=VOCABULARY%>" id="url" class="newConceptCB<%=css%>">
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
        <td align="right">
          <img src="<%=imagesPath%>/browse.gif" onclick="javascript:displayVocabLinkInNewWindow('url')" alt="browse" />
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=TERM_LABEL%>: <i class="warningMsgColor">*</i></td>
        <td colspan="2"><textarea id="<%=TERM%>" name="<%=TERM%>" class="newConceptTA2<%=css%>"><%=term%></textarea></td>
        
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=SYNONYMS_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=SYNONYMS%>" class="newConceptTA2<%=css%>"><%=synonyms%></textarea></td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=NEAREST_CODE_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=NEAREST_CODE%>" class="newConceptTA2<%=css%>"><%=nearest_code%></textarea></td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=DEFINITION_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=DEFINITION%>" class="newConceptTA6<%=css%>"><%=definition%></textarea></td>
      </tr>

      <!-- =================================================================== -->
      <%
          if (version != null && version.compareToIgnoreCase("CADSR") == 0) {
      %>
          <tr>
            <td <%=LABEL_ARGS%>><%=CADSR_SOURCE_LABEL%>:</td>
            <td colspan="2">
              <select name="<%=CADSR_SOURCE%>" class="newConceptCB2<%=css%>">
                <%
                  selectedItem = cadsr_source;
                  items = AppProperties.getInstance().getCADSRSourceList();
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
            <td <%=LABEL_ARGS%>><%=CADSR_TYPE_LABEL%>:</td>
            <td colspan="2">
              <select name="<%=CADSR_TYPE%>" class="newConceptCB2<%=css%>">
                <%
                  selectedItem = cadsr_type;
                  items = AppProperties.getInstance().getCADSRTypeList();
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
      <%
        }
      %>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr><td class="newConceptSubheader" colspan="2">Additional Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=PROJECT_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=PROJECT%>" class="newConceptTA2<%=css%>"><%=project%></textarea></td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=REASON_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=REASON%>" class="newConceptTA6<%=css%>"><%=reason%></textarea></td>
      </tr>

      <!-- =================================================================== -->
      
<%
String answer_label = "Enter the characters appearing in the above image";
if (captcha_option.compareTo("default") != 0) {
    answer_label = "";
}

if (captcha_option.compareTo("default") == 0) {
%>
      <tr>  
      <td></td>
      <td class="newConceptTA6<%=css%>">
             <img src="<c:url value="/nci.simpleCaptcha.png"  />" alt="simpleCaptcha.png">
       &nbsp;<h:commandLink value="Unable to read this image?" action="#{userSessionBean.regenerateCaptchaImage}" />
     </td>
     </tr> 
     
      <tr>
      <td class="newConceptTA6<%=css%>"> 
          <%=answer_label%>: <i class="warningMsgColor">*</i>
      </td>
      <td class="newConceptTA6<%=css%>">
          <input type="text" id="answer" name="answer" value="<%=HTTPUtils.cleanXSS(answer)%>"/>&nbsp;
          &nbsp;<h:commandLink value="Prefer an alternative form of CAPTCHA?" action="#{userSessionBean.switchCaptchaMode}" />
      </td>
      </tr>      
     
<%
} else {
%>
     <tr>
<td class="newConceptTA6<%=css%>">
Click <a href="<%=request.getContextPath()%>/<%=audio_captcha_str%> ">here</a> to listen to the audio, 
then enter the numbers you hear from the audio

          <%=answer_label%>: <i class="warningMsgColor">*</i>
      </td>
      <td class="newConceptTA6<%=css%>">
          <input type="text" id="answer" name="answer" value="<%=HTTPUtils.cleanXSS(answer)%>"/>&nbsp;
          &nbsp;<h:commandLink value="Prefer an alternative form of CAPTCHA?" action="#{userSessionBean.switchCaptchaMode}" />
      </td>
      </tr>       
      
<%
} 
%>
      
      <tr>
      <td class="newConceptNotes"><i class="warningMsgColor">* Required</i></td>
      <td align="right">
           <h:commandButton
             id="clear"
             value="clear"
             action="#{userSessionBean.clearSuggestion}"
             image="/images/clear.gif"
             alt="clear">
           </h:commandButton>      
      
           <img src="<%=imagesPath%>/spacer.gif" width="1" />
 
           <h:commandButton
             id="submit"
             value="submit"
             action="#{userSessionBean.requestSuggestion}"
             image="/images/submit.gif"
              alt="submit">
           </h:commandButton>
      </td>
      </tr>
      
      <%
      }
      %>
      
      
      </table>
      
<%  

if (form_completed) {
%>
      <p class="newConceptNotes">
     
For multiple terms, please consider emailing an Excel, delimited text, or similar file to <a href="mailto:ncithesaurus@mail.nih.gov">ncithesaurus@mail.nih.gov</a>,
which can also respond to any questions.
     
      </p>
<%
}
%>
   <input type="hidden" id="cdisc" name="cdisc" value="false" /> 
   <input type="hidden" name="captcha_option" id="captcha_option" value="<%=alt_captcha_option%>">
   <input type="hidden" name="newtermform" id="newtermform" value="newtermform">
   <input type="hidden" name="version" id="newtermform" value="<%=version%>">
   
  </h:form>

</f:view>

</body>
</html>