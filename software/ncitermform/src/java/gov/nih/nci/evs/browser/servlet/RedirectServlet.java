package gov.nih.nci.evs.browser.servlet;

import gov.nih.nci.evs.browser.webapp.*;
import gov.nih.nci.evs.browser.properties.*;
import javax.faces.context.FacesContext;
import javax.faces.context.FacesContextFactory;

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
 * @version 1.0
 *
 * Modification history
 *     Initial implementation kim.ong@ngc.com
 *
 */


import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import gov.nih.nci.evs.utils.*;
//import org.apache.log4j.*;



public final class RedirectServlet extends HttpServlet {

    public static final String PLEASE_COMPLETE_DATA_ENTRIES = "Please complete data entries.";
    public static final String INVALID_EMAIL_ADDRESS = "WARNING: Invalid email address.";


    //private static Logger _logger = Logger.getLogger(RedirectServlet.class);

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
        if (action != null && action.compareToIgnoreCase("contactUs") == 0) {
			try {

				System.out.println("execute contact us...");

				contactUs(request, response);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
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

	public static boolean isNull(String s) {
		if (s == null) return true;
		s = s.trim();
		if (s.compareTo("") == 0) return true;
		return false;
	}


    public String contactUs(HttpServletRequest request, HttpServletResponse response) throws Exception {

		System.out.println("RedirectServlet contactUs ");

        String msg = "Your message was successfully sent.";
        /*
        HttpServletRequest request =
            (HttpServletRequest) FacesContext.getCurrentInstance()
                .getExternalContext().getRequest();
        */
        request.getSession().removeAttribute("errorMsg");
        request.getSession().removeAttribute("errorType");
        request.getSession().removeAttribute("retry");

		String answer = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.ANSWER));
		String subject = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.SUBJECT));
		String message = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_MSG));
		String from    = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_ADDRESS));

		request.getSession().setAttribute(ContactUsRequest.ANSWER, answer);
		request.getSession().setAttribute(ContactUsRequest.SUBJECT, subject);
		request.getSession().setAttribute(ContactUsRequest.EMAIL_MSG, message);
		request.getSession().setAttribute(ContactUsRequest.EMAIL_ADDRESS, from);


		if (isNull(answer) || isNull(subject) || isNull(message) || isNull(from)) {
			msg = PLEASE_COMPLETE_DATA_ENTRIES;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

		boolean emailAddressValid = MailUtils.isValidEmailAddress(from);
		if (!emailAddressValid) {
			msg = INVALID_EMAIL_ADDRESS;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

/*
        String captcha_option = HTTPUtils.cleanXSS((String) request.getParameter("captcha_option"));
        if (isNull(captcha_option)) {
			captcha_option = "default";
		}
		if (captcha_option.compareTo("audio") == 0) {
			captcha_option = "default";
		} else {
			captcha_option = "audio";
		}


        try {
    		String retstr = null;
    		if (captcha_option.compareTo("audio") == 0) {
				retstr = validateAudioCaptcha(request, "incomplete");
			} else {
				retstr = validateCaptcha(request, "incomplete");
			}
			request.getSession().setAttribute("message", msg);
			return new ContactUsRequest().submitForm();

        } catch (NoReloadException e) {
            msg = e.getMessage();
            request.getSession().setAttribute("errorMsg", toHtml(msg));
            request.getSession().setAttribute("errorType", "user");
            return "retry";

        } catch (InvalidCaptChaInputException e) {
            msg = e.getMessage();
            request.getSession().setAttribute("errorMsg", toHtml(msg));
            request.getSession().setAttribute("answer", "");
            request.getSession().setAttribute("errorType", "user");
            return "retry";

        } catch (Exception e) {
            msg = "Your message was not sent.\n";
            msg += "    (If possible, please contact NCI systems team.)\n";
            msg += "\n";
            msg += e.getMessage();
            request.getSession().setAttribute("errorMsg", toHtml(msg));
            request.getSession().setAttribute("errorType", "system");
            e.printStackTrace();
            return "error";
        }
*/
        return "message";
    }

    public static String toHtml(String text) {
        text = text.replaceAll("\n", "<br/>");
        text = text.replaceAll("  ", "&nbsp;&nbsp;");
        return text;
    }

}