<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.evs.browser.properties.*" %>
<%@ page import="gov.nih.nci.evs.browser.webapp.*" %>
<%@ page import="gov.nih.nci.evs.utils.*" %>
<%
  String imagesPath = FormUtils.getImagesPath(request);
  ArrayList list = AppProperties.getInstance().getCDISCQuickLinks();
%>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/dropdown.js"></script>
<div id="quicklinksholder_960">
  <ul id="quicklinks"
    onmouseover="document.quicklinksimg.src='<%=imagesPath%>/quicklinks-active.gif';"
    onmouseout="document.quicklinksimg.src='<%=imagesPath%>/quicklinks-inactive.gif';">
    <li>
      <a href="#"><img src="<%=imagesPath%>/quicklinks-inactive.gif" width="162"
        height="18" border="0" name="quicklinksimg" alt="Quick Links" />
      </a>
      <ul>
        <%
          Iterator iterator = list.iterator();
          while (iterator.hasNext()) {
            QuickLinkInfo info = (QuickLinkInfo) iterator.next();
            String display = info.getDisplay();
            String url = info.getUrl();
        %>
            <li><a href="<%=url%>" target="_blank" rel="noopener" ><%=display%></a></li>
        <%
          }
        %>
      </ul>
    </li>
  </ul>
</div>
