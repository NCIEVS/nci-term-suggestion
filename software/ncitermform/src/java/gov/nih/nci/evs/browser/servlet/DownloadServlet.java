package gov.nih.nci.evs.browser.servlet;

import gov.nih.nci.evs.browser.webapp.*;
import gov.nih.nci.evs.browser.properties.*;
import javax.faces.context.FacesContext;
import javax.faces.context.FacesContextFactory;
import gov.nih.nci.evs.browser.common.*;

/**
 * <!-- LICENSE_TEXT_START -->
 * Copyright 2008,2009 NGIT. This software was developed in conjunction
 * with the National Cancer Institute, and so to the extent government
 * employees are co-authors, any rights in such works shall be subject
 * to Title 17 of the United States Code, section 105.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the disclaimer of Article 3,
 *      below. Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *   2. The end-user documentation included with the redistribution,
 *      if any, must include the following acknowledgment:
 *      "This product includes software developed by NGIT and the National
 *      Cancer Institute."   If no such end-user documentation is to be
 *      included, this acknowledgment shall appear in the software itself,
 *      wherever such third-party acknowledgments normally appear.
 *   3. The names "The National Cancer Institute", "NCI" and "NGIT" must
 *      not be used to endorse or promote products derived from this software.
 *   4. This license does not authorize the incorporation of this software
 *      into any third party proprietary programs. This license does not
 *      authorize the recipient to use any trademarks owned by either NCI
 *      or NGIT
 *   5. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED
 *      WARRANTIES, (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *      OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE) ARE
 *      DISCLAIMED. IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE,
 *      NGIT, OR THEIR AFFILIATES BE LIABLE FOR ANY DIRECT, INDIRECT,
 *      INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 *      BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *      LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *      CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *      LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 *      ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *      POSSIBILITY OF SUCH DAMAGE.
 * <!-- LICENSE_TEXT_END -->
 */

/**
 * @author EVS Team
 * @version 1.1
 *
 * Modification history
 *     Initial implementation kim.ong@ngc.com
 *
 */


import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import gov.nih.nci.evs.utils.*;
import org.apache.logging.log4j.*;



public final class DownloadServlet extends HttpServlet {
	private static Logger _logger = LogManager.getLogger(DownloadServlet.class);

    /**
     * Validates the Init and Context parameters, configures authentication URL
     *
     * @throws ServletException if the init parameters are invalid or any other
     *         problems occur during initialisation
     */
    public void init() throws ServletException {

    }

    /**
     * Route the user to the execute method
     *
     * @param request The HTTP request we are processing
     * @param response The HTTP response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet exception occurs
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        execute(request, response);
    }

    /**
     * Route the user to the execute method
     *
     * @param request The HTTP request we are processing
     * @param response The HTTP response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet exception occurs
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        execute(request, response);
    }

    /**
     * Process the specified HTTP request, and create the corresponding HTTP
     * response (or forward to another web component that will create it).
     *
     * @param request The HTTP request we are processing
     * @param response The HTTP response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet exception occurs
     */


    public void resetSessionVariables(HttpServletRequest request) {
		request.getSession().removeAttribute(SuggestionRequest.EMAIL);
		request.getSession().removeAttribute(SuggestionRequest.TERM);
		request.getSession().removeAttribute(SuggestionRequest.OTHER);
		request.getSession().removeAttribute(SuggestionRequest.VOCABULARY);
		request.getSession().removeAttribute(SuggestionRequest.SYNONYMS);
		request.getSession().removeAttribute(SuggestionRequest.NEAREST_CODE);
		request.getSession().removeAttribute(SuggestionRequest.DEFINITION);
		request.getSession().removeAttribute(SuggestionRequest.CADSR_SOURCE);
		request.getSession().removeAttribute(SuggestionRequest.CADSR_TYPE);
		request.getSession().removeAttribute(SuggestionRequest.REASON);
		request.getSession().removeAttribute(SuggestionRequest.PROJECT);
		request.getSession().removeAttribute(SuggestionRequest.VERSION);
	}


    public void resetCDISCSessionVariables(HttpServletRequest request) {
		request.getSession().removeAttribute(SuggestionCDISCRequest.EMAIL);
		request.getSession().removeAttribute(SuggestionCDISCRequest.NAME);
		request.getSession().removeAttribute(SuggestionCDISCRequest.PHONE_NUMBER);
		request.getSession().removeAttribute(SuggestionCDISCRequest.ORGANIZATION);
		request.getSession().removeAttribute(SuggestionCDISCRequest.VOCABULARY);
		request.getSession().removeAttribute(SuggestionCDISCRequest.CDISC_REQUEST_TYPE);
		request.getSession().removeAttribute(SuggestionCDISCRequest.CDISC_CODES);
		request.getSession().removeAttribute(SuggestionCDISCRequest.TERM);
		request.getSession().removeAttribute(SuggestionCDISCRequest.REASON);
	}


    public void execute(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

		String action = HTTPUtils.cleanXSS((String) request.getParameter("action"));
		if (action != null && action.compareTo("download") == 0) {
			downloadTemplate(request, response);
			return;
		}

        String version = HTTPUtils.cleanXSS((String) request.getParameter("version"));
        if (version != null && version.compareToIgnoreCase("CDISC") == 0) {
            resetCDISCSessionVariables(request);
			String url = request.getContextPath() + "/pages/main/suggestion_cdisc.jsf?version=" + version;
			response.sendRedirect(response.encodeRedirectURL(url));
		} else {
			resetSessionVariables(request);
			String url = request.getContextPath() + "/pages/main/suggestion.jsf?version=" + version;
			response.sendRedirect(response.encodeRedirectURL(url));
		}
	}


	private String readFile( String file ) throws IOException {
		//BufferedReader reader = new BufferedReader( new FileReader (file));

		BufferedReader reader = new BufferedReader(new InputStreamReader(
			new FileInputStream(file), "UTF-8"));

		String         line = null;
		StringBuilder  stringBuilder = new StringBuilder();
		//String         ls = System.getProperty("line.separator");

		while( ( line = reader.readLine() ) != null ) {
			stringBuilder.append( line );
		}
		reader.close();
		return stringBuilder.toString();
	}


	protected void downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//String filename = URLDecoder.decode(request.getPathInfo(), "UTF-8");
		//File file = new File("/path/to/files", filename);

		String filename = Constants.CDISC_MULTIPLE_TERM_REQUEST_TEMPLATE;//"CDISC_Controlled_Terminology_Multiple_Term_Request_Spreadsheet.xlsx";
		String pathname = AppProperties.getConfigurationDir() + filename;
		//Systen.out.println(pathname);

		File file = new File(pathname);

		response.setHeader("Content-Type", getServletContext().getMimeType(file.getName()));
		//response.setHeader("Content-Length", file.length());
		response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

		BufferedInputStream input = null;
		BufferedOutputStream output = null;

		try {
			input = new BufferedInputStream(new FileInputStream(file));
			output = new BufferedOutputStream(response.getOutputStream());

			byte[] buffer = new byte[8192];
			for (int length = 0; (length = input.read(buffer)) > 0;) {
				output.write(buffer, 0, length);
			}
		} finally {
			if (output != null) try { output.close(); } catch (IOException ignore) {}
			if (input != null) try { input.close(); } catch (IOException ignore) {}
		}
	}



}
