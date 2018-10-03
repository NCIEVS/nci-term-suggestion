<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.browser.common.Constants" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>
<%@ page import="gov.nih.nci.evs.browser.bean.UserSessionBean" %>
<%@ page import="nl.captcha.Captcha" %>
<%@ page import="nl.captcha.audio.AudioCaptcha" %>

<%!
  private static final String TELEPHONE = Constants.TELEPHONE;
  private static final String MAIL_TO = Constants.MAIL_TO;
  private static final String NCICB_URL = Constants.NCICB_URL;
  
  // List of attribute name(s):
  private static final String SUBJECT = ContactUsRequest.SUBJECT;
  private static final String EMAIL_MSG = ContactUsRequest.EMAIL_MSG;
  private static final String EMAIL_ADDRESS = ContactUsRequest.EMAIL_ADDRESS;
  private static final String WARNINGS = ContactUsRequest.WARNINGS;
  private static final String WARNING_TYPE = ContactUsRequest.WARNING_TYPE;
%>
<%
  String imagesPath = FormUtils.getImagesPath(request);
  String ncicb_contact_url = AppProperties.getInstance().getContactUrl();
  
  //String subject = HTTPUtils.getJspAttributeString(request, SUBJECT);
  //String email_msg = HTTPUtils.getJspAttributeString(request, EMAIL_MSG);
  //String email_address = HTTPUtils.getJspSessionAttributeString(request, EMAIL_ADDRESS);
  
  String warnings = HTTPUtils.getJspAttributeString(request, WARNINGS);
  String warningType = HTTPUtils.getJspAttributeString(request, WARNING_TYPE);
  boolean isUserError = Prop.WarningType.valueOfOrDefault(warningType) == Prop.WarningType.User;
    
  
  String subject = HTTPUtils.getJspAttributeString(request, SUBJECT);
  String email_msg = HTTPUtils.getJspAttributeString(request, EMAIL_MSG);
  String email_address = HTTPUtils.getJspSessionAttributeString(request, EMAIL_ADDRESS);
  
  subject = (String) request.getSession().getAttribute(ContactUsRequest.SUBJECT);
  email_msg = (String) request.getSession().getAttribute(ContactUsRequest.EMAIL_MSG);
  email_address = (String) HTTPUtils.getJspSessionAttributeString(request, EMAIL_ADDRESS);

  if (UserSessionBean.isNull(subject)) subject = "";
  if (UserSessionBean.isNull(email_msg)) email_msg = "";
  if (UserSessionBean.isNull(email_address)) email_address = "";
  
  String answer  = "";

   
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

  <%
    String color = ""; 
    if (isUserError)
      color = "style=\"color:#FF0000;\"";
  %>



<f:view>
  <div class="texttitle-blue">Contact Us</div>
  <hr></hr>

<%
if (errorMsg != null) {
%>
<p class="textbodyred">&nbsp;<%=errorMsg%></p>
<%
}
%>

    <%
      if (warnings != null && warnings.length() > 0) {
          warnings = warnings.replaceAll("&lt;br/&gt;", "\n");
          String[] list = StringUtils.toStrings(warnings, "\n", false, false);
          for (int i=0; i<list.length; ++i) {
            String text = list[i];
            text = StringUtils.toHtml(text); // For leading spaces (indentation)
    %>
            <i style="color:#FF0000;"><%= text %></i>
            <br/>
    <%
          }
      }
    %>


  <div>
    <b>You can request help or make suggestions by filling out the
      online form below, or by using any one of these contact points:
    </b>
  </div>
  <br/>

  <table class="textbody" role='presentation'>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td>Telephone:</td>
      <td><%=TELEPHONE%></td>
    </tr>
    <tr>
      <td/>
      <td>Email:</td>
      <td><a href="mailto:<%=MAIL_TO%>"><%=MAIL_TO%></a></td>
    </tr>
    <tr>
      <td/>
      <td>Web Page:</td>
      <td><a href="<%=NCICB_URL%>" target="_blank"><%=NCICB_URL%></a></td>
    </tr>
  </table>
  <br/>

  <div>
    Telephone support is available Monday to Friday, 8 am - 8 pm 
    Eastern Time, excluding government holidays. You may leave a 
    message, send an email, or submit a support request via the Web
    at any time.  Please include: 
    <ul>
      <li>Your contact information;</li>
      <li>Reference to the Term Suggestions Application; and</li>
      <li>A detailed description of your problem or suggestion.</li>
    </ul>

    For questions related to NCI's Cancer.gov Web site,
    see the
    <a href="http://www.cancer.gov/help" target="_blank">
      Cancer.gov help page</a>. &nbsp;
    For help and other questions concerning NCI Enterprise Vocabulary
    Services (EVS),
    see the <a href="http://evs.nci.nih.gov/" target="_blank">
      EVS Web site</a>.
  </div>


  <p><b>Online Form</b></p>
  <p <%= color %>>
    To use this web form, please fill in every box below and then click on 'Submit'. 
  </p>
  
  <h:form styleClass="search-form" acceptcharset="UTF-8">
  
<p>
<table role='presentation'>
<%
String answer_label = "Enter the characters appearing in the above image";

if (captcha_option.compareTo("default") == 0) {
%>
      <tr>
      <td class="textbody">
             <img src="<c:url value="/nci.simpleCaptcha.png"  />" alt="simpleCaptcha.png">
             
       &nbsp;<h:commandLink value="Unable to read this image?" action="#{userSessionBean.regenerateCaptchaImage}" />
       <br/>             
      </td>
      </tr>

       

<%
} else {
      answer_label = "Enter the numbers you hear from the audio";
%>

<tr>
<td>
<p class="textbody">Click 


<a href="<%=request.getContextPath()%>/<%=audio_captcha_str%> ">here</a> to listen to the audio. 
</td>
</tr>


<%
} 
%>

      <tr>
      <td class="textbody"> 
          <label for="answer"><%=answer_label%><LAB/EL>: <i class="warningMsgColor">*</i> 
          <input type="text" id="answer" name="answer" value="<%=HTTPUtils.cleanXSS(answer)%>"/>&nbsp;
      </td>
      </tr> 
      
      
      <tr>
      <td class="textbody">
       <h:commandLink value="Prefer an alternative form of CAPTCHA?" action="#{userSessionBean.switchCaptchaMode}" />
       <br/>             
      </td>
      </tr>
     

      </table>  
      
</p>    
 
  
  
    <p>
      <% if (isUserError) %> <i style="color:#FF0000;">* Required)</i>
      <i><label for="subject">Subject of your email</label>:</i>
    </p>
    <input class="textbody" size="100" name="subject" alt="Subject" value="<%= subject %>" onFocus="active = true" onBlur="active = false" onKeyPress="return ifenter(event,this.form)">
    <p>
      <% if (isUserError) %> <i style="color:#FF0000;">* Required)</i>
      <i><label for="<%= EMAIL_MSG %>">Detailed description of your problem or suggestion (no attachments):</label></i>
    </p>
    <textarea class="textbody" Name="<%= EMAIL_MSG %>" id="<%= EMAIL_MSG %>" rows="4" cols="98"><%= email_msg %></textarea>
    <p>
      <% if (isUserError) %> <i style="color:#FF0000;">* Required)</i>
      <i><label for="<%= EMAIL_ADDRESS %>">Your e-mail address</label>:</i>
    </p>
    <input class="textbody" size="100" name="<%= EMAIL_ADDRESS %>" alt="<%= EMAIL_ADDRESS %>" value="<%= email_address %>" onFocus="active = true" onBlur="active = false" onKeyPress="return ifenter(event,this.form)">
    <br/><br/>
    
    <h:commandButton
      id="clear"
      value="clear"
      image="/images/clear.gif"
      action="#{userSessionBean.clearContactUs}"
      alt="clear">
    </h:commandButton>
           <img src="<%=imagesPath%>/spacer.gif" alt="spacer" width="1" />
    <h:commandButton
      id="mail"
      value="submit"
      image="/images/submit.gif"
      action="#{userSessionBean.contactUs}"
      alt="submit">
    </h:commandButton>
    
    
<label for="captcha_option">Captcha Option<LABEL>    
    <input type="hidden" id="captcha_option" name="captcha_option" id="captcha_option" value="<%=alt_captcha_option%>">


  </h:form>
  <br/>
  
  <a href="http://www.cancer.gov/policies/page3" target="_blank">
    <i>Privacy Policy on E-mail Messages Sent to the NCI Web Site</i>
  </a>
  
</f:view>
