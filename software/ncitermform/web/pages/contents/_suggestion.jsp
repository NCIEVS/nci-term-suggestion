<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.browser.utils.*" %>
<script type="text/javascript" src="<%=FormUtils.getJSPath(request)%>/utils.js"></script>
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
  private static final String CDISC_REQUEST_TYPE = SuggestionRequest.CDISC_REQUEST_TYPE;
  private static final String CDISC_CODES = SuggestionRequest.CDISC_CODES;
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
  private static final String CDISC_REQUEST_TYPE_LABEL = SuggestionRequest.CDISC_REQUEST_TYPE_LABEL;
  private static final String CDISC_CODES_LABEL = SuggestionRequest.CDISC_CODES_LABEL;
  private static final String REASON_LABEL = SuggestionRequest.REASON_LABEL;

  private static final String INPUT_ARGS =
    "class=\"textbody\" onFocus=\"active=true\" onBlur=\"active=false\"";
    // " onKeyPress=\"return ifenter(event,this.form)\"";
  private static final String LABEL_ARGS = "valign=\"top\"";
%>
<%
    // Member variable(s):
  String imagesPath = FormUtils.getImagesPath(request);
  Prop.Version version = FormUtils.getVersion(request);
  SuggestionRequest.setupTestData();

  // Attribute(s):
  String email = HTTPUtils.getSessionAttributeString(request, EMAIL);
  String other = HTTPUtils.getSessionAttributeString(request, OTHER);
  String vocabulary = HTTPUtils.getSessionAttributeString(request, VOCABULARY);
  String term = HTTPUtils.getAttributeString(request, TERM);
  String synonyms = HTTPUtils.getAttributeString(request, SYNONYMS);
  String nearest_code = HTTPUtils.getAttributeString(request, NEAREST_CODE);
  String definition = HTTPUtils.getAttributeString(request, DEFINITION);
  String cadsr_source = HTTPUtils.getAttributeString(request, CADSR_SOURCE);
  String cadsr_type = HTTPUtils.getAttributeString(request, CADSR_TYPE);
  String cdisc_request_type = HTTPUtils.getAttributeString(request, CDISC_REQUEST_TYPE);
  String cdisc_codes = HTTPUtils.getAttributeString(request, CDISC_CODES);
  String reason = HTTPUtils.getAttributeString(request, REASON);
  String warnings = HTTPUtils.getAttributeString(request, WARNINGS);
  boolean isWarnings = warnings.length() > 0;

  String pVocabulary = HTTPUtils.getParameter(request, VOCABULARY);
  if (pVocabulary == null || pVocabulary.length() <= 0) {
    // Note: This is how NCIt/TB and NCIm is passing in this value.  
    pVocabulary = HTTPUtils.getParameter(request, DICTIONARY);
  }
  String pCode = HTTPUtils.getParameter(request, CODE, false);
  if (! isWarnings && pCode != null)
    nearest_code = pCode;

  // Member variable(s):
  int i=0;
  String[] items = null;
  String selectedItem = null;
  String css = WebUtils.isUsingIE(request) ? "_IE" : "";
%>
<f:view>
  <form method="post">
    <table class="newConceptDT">
      <!-- =================================================================== -->
      <%
          if (isWarnings) {
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
      %>

      <!-- =================================================================== -->
      <tr><td class="newConceptSubheader" colspan="2">Contact Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=EMAIL_LABEL%>: <i class="warningMsgColor">*</i></td>
        <td colspan="2">
          <input name="<%=EMAIL%>" value="<%=email%>" alt="<%=EMAIL%>"
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
          Your email, name, phone, or other contact information will only be used
          <br/>&nbsp;&nbsp;&nbsp;&nbsp;
          to contact you about this topic and not for any other purpose.
        </td>
      </tr>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr>
        <td class="newConceptSubheader">Term Information:</td>
        <td>Fill in the following fields as appropriate:</td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=VOCABULARY_LABEL%>: <i class="warningMsgColor">*</i></td>
        <td>
          <select name="<%=VOCABULARY%>" id="url" class="newConceptCB<%=css%>">
            <%
                selectedItem = vocabulary;
                ArrayList list = AppProperties.getInstance().getVocabularies();
                VocabInfo[] vocabs  = (VocabInfo[]) 
                  list.toArray(new VocabInfo[list.size()]);
                boolean isSelected = false;
                int n = vocabs.length;
                for (i=0; i<n; ++i) {
                  VocabInfo vocab = vocabs[i];
                  String displayName = vocab.getDisplayName();
                  String name = vocab.getName();
                  String url = vocab.getUrl();
                  String args = "";
                  if (! isSelected) {
                    if (! isWarnings && name.equalsIgnoreCase(pVocabulary))
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
          <img src="<%=imagesPath%>/browse.gif" onclick="javascript:displayVocabLinkInNewWindow('url')" />
        </td>
      </tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=TERM_LABEL%>: <i class="warningMsgColor">*</i></td>
        <td colspan="2"><textarea name="<%=TERM%>" class="newConceptTA2<%=css%>"><%=term%></textarea></td>
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
          if (version == Prop.Version.CADSR) {
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
      <%
         if (version == Prop.Version.CDISC) {
      %>
          <tr>
            <td <%=LABEL_ARGS%>><%=CDISC_REQUEST_TYPE_LABEL%>:</td>
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
            <td <%=LABEL_ARGS%>><%=CDISC_CODES_LABEL%>:</td>
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
      <%
        }
      %>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr><td class="newConceptSubheader" colspan="2">Additional Information:</td></tr>
      <tr>
        <td <%=LABEL_ARGS%>><%=REASON_LABEL%>:</td>
        <td colspan="2"><textarea name="<%=REASON%>" class="newConceptTA6<%=css%>"><%=reason%></textarea></td>
      </tr>

      <!-- =================================================================== -->
      <tr><td><br/></td></tr>
      <tr>
        <td class="newConceptNotes"><i class="warningMsgColor">* Required</i></td>
        <td colspan="2" align="right">
          <h:commandButton
            id="clear"
            value="clear"
            action="#{userSessionBean.clearSuggestion}"
            image="#{facesContext.externalContext.requestContextPath}/images/clear.gif"
            alt="clear">
          </h:commandButton>
          <h:commandButton
            id="submit"
            value="submit"
            action="#{userSessionBean.requestSuggestion}"
            image="#{facesContext.externalContext.requestContextPath}/images/submit.gif"
            alt="submit">
          </h:commandButton>
        </td>
      </tr>
    </table>
  </form>
</f:view>