package gov.nih.nci.evs.browser.bean;

import gov.nih.nci.evs.browser.properties.*;
import gov.nih.nci.evs.browser.common.*;
import javax.servlet.http.*;
import gov.nih.nci.evs.browser.webapp.*;
import gov.nih.nci.evs.browser.utils.*;
import gov.nih.nci.evs.utils.*;

import nl.captcha.Captcha;

import java.io.*;
import java.util.*;

import javax.faces.context.*;
import javax.faces.event.*;
import javax.faces.model.*;
import javax.servlet.http.*;


import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;


/*
import nl.captcha.servlet.CaptchaServletUtil;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
*/
import nl.captcha.audio.AudioCaptcha;

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
 * @author EVS Team (David Yee, Kim Ong)
 * @version 1.0
 */

public class UserSessionBean {

    public static final String PLEASE_COMPLETE_DATA_ENTRIES = "Please complete data entries.";
    public static final String INVALID_EMAIL_ADDRESS = "WARNING: Invalid email address.";
    public static final String INCOMPLETE_CAPTCHA_RESPONSE = "WARNING: Incomplete Captcha Response";

    public String changeRequest() {
        HTTPUtils.getRequest().setAttribute(
            FormRequest.MESSAGE, "UserSessionBean.changeRequest");
        return FormRequest.MESSAGE_STATE;
    }

    private String getVersion() {
        HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
        String version = (String) request.getSession().getAttribute(FormRequest.VERSION);
        return version;
    }

/*
    private IFormRequest getFormRequest() {
        Prop.Version version = getVersion();
        if (version == Prop.Version.CDISC)
            return new SuggestionCDISCRequest();
        return new SuggestionRequest();
    }
*/
    private IFormRequest getFormRequest() {
        String version = getVersion();
        if (version != null && version.compareToIgnoreCase("CDISC") == 0) {
            return new SuggestionCDISCRequest();
		}
        return new SuggestionRequest();
    }

    private static class NoReloadException extends Exception {
        private static final long serialVersionUID = 1L;
        public NoReloadException(String text) {
            super(text);
        }
    }

/*
    private String validateCaptcha(HttpServletRequest request,
        String returnIncompleteState) throws Exception {
        Captcha captcha = (Captcha) request.getSession().getAttribute(Captcha.NAME);
        if (captcha == null) {
            captcha = new Captcha.Builder(200, 50).addText().addBackground()
                // .addNoise()
                .gimp()
                // .addBorder()
                .build();
            request.getSession().setAttribute(Captcha.NAME, captcha);
        }

        // Do this so we can capture non-Latin chars
        request.setCharacterEncoding("UTF-8");
        String answer = HTTPUtils.cleanXSS((String) request.getParameter("answer"));
        if (answer == null || answer.length() == 0) {
            throw new NoReloadException(
                "Please enter the security code appearing in the image. ");
        }

        request.getSession().removeAttribute("reload");
        if (!captcha.isCorrect(answer))
            throw new InvalidCaptChaInputException(
                "WARNING: The string you entered does not match"
                    + " with what is shown in the image. Please try again.");

        request.getSession().removeAttribute(Captcha.NAME);
        return null;
    }
*/



    public void saveSessionVariables(HttpServletRequest request) {
        String email = null;
        String term = null;
        String other = null;
        String vocabulary = null;
        String synonyms = null;
        String nearest_code = null;
        String definition = null;
        String cadsr_source = null;
        String cadsr_type = null;
        String reason = null;
        String project = null;
        String version = null;

		email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.EMAIL));
		term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.TERM));
		other = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.OTHER));
		vocabulary = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.VOCABULARY));
		synonyms = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.SYNONYMS));
		nearest_code = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.NEAREST_CODE));
		definition = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.DEFINITION));
		cadsr_source = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.CADSR_SOURCE));
		cadsr_type = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.CADSR_TYPE));
		reason = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.REASON));
		project = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.PROJECT));
		version = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.VERSION));

		request.getSession().setAttribute(SuggestionRequest.EMAIL, email);
		request.getSession().setAttribute(SuggestionRequest.TERM, term);
		request.getSession().setAttribute(SuggestionRequest.OTHER, other);
		request.getSession().setAttribute(SuggestionRequest.VOCABULARY, vocabulary);
		request.getSession().setAttribute(SuggestionRequest.SYNONYMS, synonyms);
		request.getSession().setAttribute(SuggestionRequest.NEAREST_CODE, nearest_code);
		request.getSession().setAttribute(SuggestionRequest.DEFINITION, definition);
		request.getSession().setAttribute(SuggestionRequest.CADSR_SOURCE, cadsr_source);
		request.getSession().setAttribute(SuggestionRequest.CADSR_TYPE, cadsr_type);
		request.getSession().setAttribute(SuggestionRequest.REASON, reason);
		request.getSession().setAttribute(SuggestionRequest.PROJECT, project);
		request.getSession().setAttribute(SuggestionRequest.VERSION, version);
	}


    public String requestSuggestion() {
		HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else {
			System.out.println("CSRF_TOKEN verified.");
		}
		saveSessionVariables(request);
		String msg = "Your message was successfully sent.";

        String str = HTTPUtils.cleanXSS((String) request.getParameter("g-recaptcha-response"));
        String recaptcha_security_key = AppProperties.getInstance().getRecaptchaSecurityKey();
        JSONObject json = new CaptchaUtils().getCaptchaJsonResponse(recaptcha_security_key, request.getParameter("g-recaptcha-response"));

        if (json == null) {
			msg = INCOMPLETE_CAPTCHA_RESPONSE;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
//TO BE MODIFIED:
        } else {
			String json_str = json.toString();
			if (str.length() == 0 || json_str.indexOf("error-code") != -1) {
				msg = INCOMPLETE_CAPTCHA_RESPONSE;
				request.getSession().setAttribute("errorMsg", msg);
				request.getSession().setAttribute("retry", "true");
				return "retry";
			}
		}

        //String answer = HTTPUtils.cleanXSS((String) request.getParameter("answer"));

		String email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.EMAIL));
		if (isNull(email))
		{
			msg = "Please provide an email address.";
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

		String term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.TERM));
		if (isNull(term))
		{
			msg = "Please enter term information below.";
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

		if (isNull(answer))
		{
			if (captcha_option.compareTo("audio") == 0) {
				msg = "Please enter the digits you heard from the audio.";
			} else {
				msg = "Please enter the security code appearing in the image.";
			}
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
*/
		String[] required_fields = SuggestionRequest.get_REQUIRED_FIELDS();
		for (int i=0; i<required_fields.length; i++) {
			String parameter = required_fields[i];
			String s =  HTTPUtils.cleanXSS((String) request.getParameter(parameter));

			if (isNull(s)) {
				msg = "Please complete data entries.";
				request.getSession().setAttribute("errorMsg", msg);
				request.getSession().setAttribute("retry", "true");
				return "retry";
			}
		}
		boolean emailAddressValid = MailUtils.isValidEmailAddress(email);
		if (!emailAddressValid) {
			msg = INVALID_EMAIL_ADDRESS;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
/*
        try {
    		String retstr = null;
    		if (captcha_option.compareTo("audio") == 0) {
				retstr = validateAudioCaptcha(request, "incomplete");
			} else {
				retstr = validateCaptcha(request, "incomplete");
			}
			request.getSession().setAttribute("message", msg);
			return new SuggestionRequest().submitForm();


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
            msg = e.getMessage();
            request.getSession().setAttribute("message", msg);
            if (! (e instanceof NoReloadException))
                request.getSession().setAttribute("reload", "true");

            return "incomplete";
        }
*/
        try {
			request.getSession().setAttribute("message", msg);
			return new SuggestionRequest().submitForm();
	    } catch (Exception e) {
            msg = e.getMessage();
            request.getSession().setAttribute("message", msg);
            if (! (e instanceof NoReloadException))
                request.getSession().setAttribute("reload", "true");

            return "incomplete";
		}

    }

    public void saveCDISCSessionVariables(HttpServletRequest request) {
        String email = null;
        String name = null;
        String phone_number = null;
        String organization = null;
        String vocabulary = null;
        String cdisc_request_type = null;
        String cdisc_codes = null;
        String term = null;
        String reason = null;

	    email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.EMAIL));
	    name = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.NAME));
	    phone_number = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.PHONE_NUMBER));
	    organization = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.ORGANIZATION));
	    vocabulary = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.VOCABULARY));
	    cdisc_request_type = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_REQUEST_TYPE));
	    cdisc_codes = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_CODES));
	    term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.TERM));
	    reason = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.REASON));

		request.getSession().setAttribute(SuggestionCDISCRequest.EMAIL, email);
		request.getSession().setAttribute(SuggestionCDISCRequest.NAME, name);
		request.getSession().setAttribute(SuggestionCDISCRequest.PHONE_NUMBER, phone_number);
		request.getSession().setAttribute(SuggestionCDISCRequest.ORGANIZATION, organization);
		request.getSession().setAttribute(SuggestionCDISCRequest.VOCABULARY, vocabulary);
		request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_REQUEST_TYPE, cdisc_request_type);
		request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_CODES, cdisc_codes);
		request.getSession().setAttribute(SuggestionCDISCRequest.TERM, term);
		request.getSession().setAttribute(SuggestionCDISCRequest.REASON, reason);
	}

	/*
    public void saveCDISCSessionVariables(HttpServletRequest request) {
	    //HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
	    String retry_cdisc = (String) request.getSession().getAttribute("retry_cdisc");

	    String email = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.EMAIL);
	    String name = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.NAME);
	    String phone_number = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.PHONE_NUMBER);
	    String organization = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.ORGANIZATION);
	    String vocabulary = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.VOCABULARY);
	    String cdisc_request_type = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.CDISC_REQUEST_TYPE);
	    String cdisc_codes = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.CDISC_CODES);
	    String term = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.TERM);
	    String reason = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.REASON);
	    //String warnings = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.WARNINGS);

	    if (retry_cdisc == null || retry_cdisc.compareTo("true") != 0) {
			email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.EMAIL));
			name = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.NAME));
			phone_number = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.PHONE_NUMBER));
			organization = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.ORGANIZATION));
			vocabulary = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.VOCABULARY));
			cdisc_request_type = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_REQUEST_TYPE));
			cdisc_codes = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_CODES));
			term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.TERM));
			reason = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.REASON));

			request.getSession().setAttribute(SuggestionCDISCRequest.EMAIL, email);
			request.getSession().setAttribute(SuggestionCDISCRequest.NAME, name);
			request.getSession().setAttribute(SuggestionCDISCRequest.PHONE_NUMBER, phone_number);
			request.getSession().setAttribute(SuggestionCDISCRequest.ORGANIZATION, organization);
			request.getSession().setAttribute(SuggestionCDISCRequest.VOCABULARY, vocabulary);
			request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_REQUEST_TYPE, cdisc_request_type);
			request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_CODES, cdisc_codes);
			request.getSession().setAttribute(SuggestionCDISCRequest.TERM, term);
			request.getSession().setAttribute(SuggestionCDISCRequest.REASON, reason);
		}

	}
    */


    public String requestSuggestionCDISC() {
		HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else {
			System.out.println("CSRF_TOKEN verified.");
		}

		saveCDISCSessionVariables(request);
		request.getSession().setAttribute("version", "CDISC");
		String msg = "Your message was successfully sent.";

        String str = HTTPUtils.cleanXSS((String) request.getParameter("g-recaptcha-response"));
        String recaptcha_security_key = AppProperties.getInstance().getRecaptchaSecurityKey();
        JSONObject json = new CaptchaUtils().getCaptchaJsonResponse(recaptcha_security_key, request.getParameter("g-recaptcha-response"));

        if (json == null) {
			msg = INCOMPLETE_CAPTCHA_RESPONSE;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
//TO BE MODIFIED:
        } else {
			String json_str = json.toString();
			if (str.length() == 0 || json_str.indexOf("error-code") != -1) {
				msg = INCOMPLETE_CAPTCHA_RESPONSE;
				request.getSession().setAttribute("errorMsg", msg);
				request.getSession().setAttribute("retry", "true");
				return "retry";
			}
		}

		String email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.EMAIL));
		if (isNull(email))
		{
			msg = "Please provide an email address.";
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

		String term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.TERM));
		if (isNull(term))
		{
			msg = "Please enter term information below.";
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
/*
        String answer = HTTPUtils.cleanXSS((String) request.getParameter("answer"));

        String captcha_option = HTTPUtils.cleanXSS((String) request.getParameter("captcha_option"));
        if (isNull(captcha_option)) {
			captcha_option = "default";
		}
		if (captcha_option.compareTo("audio") == 0) {
			captcha_option = "default";
		} else {
			captcha_option = "audio";
		}

		if (isNull(answer))
		{
			if (captcha_option.compareTo("audio") == 0) {
				msg = "Please enter the digits you heard from the audio.";
			} else {
				msg = "Please enter the security code appearing in the image.";
			}
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
*/
		String[] required_fields = SuggestionCDISCRequest.get_REQUIRED_FIELDS();
		for (int i=0; i<required_fields.length; i++) {
			String parameter = required_fields[i];
			String s = HTTPUtils.cleanXSS((String) request.getParameter(parameter));
			if (isNull(s)) {
				msg = "WARNING: Incomplete data entry.";
				request.getSession().setAttribute("errorMsg", msg);
				request.getSession().setAttribute("retry", "true");
				return "retry";
			}
		}


		//String email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.EMAIL));
		boolean emailAddressValid = MailUtils.isValidEmailAddress(email);
		if (!emailAddressValid) {
		    msg = INVALID_EMAIL_ADDRESS;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

/*
        try {
    		String retstr = null;
    		if (captcha_option.compareTo("audio") == 0) {
				retstr = validateAudioCaptcha(request, "incomplete");
			} else {
				retstr = validateCaptcha(request, "incomplete");
			}
			request.getSession().setAttribute("message", msg);
			return new SuggestionCDISCRequest().submitForm();


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
            msg = e.getMessage();
            request.getSession().setAttribute("message", msg);
            if (! (e instanceof NoReloadException))
                request.getSession().setAttribute("reload", "true");

            return "incomplete_cdisc";
        }
*/

        try {
			request.getSession().setAttribute("message", msg);
			return new SuggestionCDISCRequest().submitForm();
	    } catch (Exception e) {
            msg = e.getMessage();
            request.getSession().setAttribute("message", msg);
            if (! (e instanceof NoReloadException))
                request.getSession().setAttribute("reload", "true");

            return "incomplete";
		}

    }


    /*
    public String requestSuggestionCDISC() {
		String msg = "Your message was successfully sent.";
		HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
		saveCDISCSessionVariables(request);
		request.getSession().setAttribute("version", Prop.Version.CDISC);

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
			return new SuggestionCDISCRequest().submitForm();
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
            msg = e.getMessage();
            request.getSession().setAttribute("message", msg);
            if (! (e instanceof NoReloadException))
                request.getSession().setAttribute("reload", "true");
            return "incomplete_cdisc";
        }

    }
    */

    public String clearSuggestion() {
        IFormRequest request = getFormRequest();
        return request.clearForm();
    }

    public String clearCDISCSuggestion() {
        IFormRequest request = getFormRequest();
        return request.clearForm();
    }

    public static String toHtml(String text) {
        text = text.replaceAll("\n", "<br/>");
        text = text.replaceAll("  ", "&nbsp;&nbsp;");
        return text;
    }


    public String contactUs() throws Exception {
        String msg = "Your message was successfully sent.";
        HttpServletRequest request =
            (HttpServletRequest) FacesContext.getCurrentInstance()
                .getExternalContext().getRequest();


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

        String str = HTTPUtils.cleanXSS((String) request.getParameter("g-recaptcha-response"));
        String recaptcha_security_key = AppProperties.getInstance().getRecaptchaSecurityKey();
        JSONObject json = new CaptchaUtils().getCaptchaJsonResponse(recaptcha_security_key, request.getParameter("g-recaptcha-response"));
        String json_str = json.toString();

        if (str.length() == 0 || json_str.indexOf("error-code") != -1) {
			msg = INCOMPLETE_CAPTCHA_RESPONSE;
			request.getSession().setAttribute("errorMsg", msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}

		//if (isNull(answer) || isNull(subject) || isNull(message) || isNull(from)) {
		if (isNull(subject) || isNull(message) || isNull(from)) {
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
		request.getSession().setAttribute("message", msg);
		return new ContactUsRequest().submitForm();

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

    }

    public String clearContactUs() {
        ContactUsRequest request = new ContactUsRequest();
        return request.clearForm();
    }


    private void refreshCaptcha(HttpServletRequest request) {
        Captcha captcha = (Captcha) request.getSession().getAttribute(Captcha.NAME);
        if (captcha == null) {
            captcha = new Captcha.Builder(200, 50)
                .addText()
                .addBackground()
                //.addNoise()
                .gimp()
                //.addBorder()
                .build();
            request.getSession().setAttribute(Captcha.NAME, captcha);
        }

        try {
            request.setCharacterEncoding("UTF-8"); // Do this so we can capture non-Latin chars
        } catch (Exception ex) {
			ex.printStackTrace();
        }

        request.getSession().removeAttribute("reload");
        String msg = "Please press Refresh to generate a new image.";
        request.getSession().setAttribute("message", msg);
        request.getSession().setAttribute("reload", "true");
        request.getSession().setAttribute("refresh", "true");
    }

    public String refreshForm() {
	    HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
	    String retry = (String) request.getSession().getAttribute("retry");

        String email = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.EMAIL);
        String term = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.TERM);
        String other = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.OTHER);
        String vocabulary = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.VOCABULARY);
        String synonyms = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.SYNONYMS);
        String nearest_code = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.NEAREST_CODE);
        String definition = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.DEFINITION);
        String cadsr_source = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.CADSR_SOURCE);
        String cadsr_type = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.CADSR_TYPE);
        String reason = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.REASON);
        String project = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.PROJECT);
      //String warnings = HTTPUtils.getJspSessionAttributeString(request, SuggestionRequest.WARNINGS);

	    if (retry == null || retry.compareTo("true") != 0) {
			email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.EMAIL));
			term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.TERM));
			other = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.OTHER));
			vocabulary = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.VOCABULARY));
			synonyms = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.SYNONYMS));
			nearest_code = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.NEAREST_CODE));
			definition = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.DEFINITION));
			cadsr_source = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.CADSR_SOURCE));
			cadsr_type = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.CADSR_TYPE));
			reason = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.REASON));
			project = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionRequest.PROJECT));

			request.getSession().setAttribute(SuggestionRequest.EMAIL, email);
			request.getSession().setAttribute(SuggestionRequest.TERM, term);
			request.getSession().setAttribute(SuggestionRequest.OTHER, other);
			request.getSession().setAttribute(SuggestionRequest.VOCABULARY, vocabulary);
			request.getSession().setAttribute(SuggestionRequest.SYNONYMS, synonyms);
			request.getSession().setAttribute(SuggestionRequest.NEAREST_CODE, nearest_code);
			request.getSession().setAttribute(SuggestionRequest.DEFINITION, definition);
			request.getSession().setAttribute(SuggestionRequest.CADSR_SOURCE, cadsr_source);
			request.getSession().setAttribute(SuggestionRequest.CADSR_TYPE, cadsr_type);
			request.getSession().setAttribute(SuggestionRequest.REASON, reason);
			request.getSession().setAttribute(SuggestionRequest.PROJECT, project);
		}

	    refreshCaptcha(request);
		return "refresh";
    }

    public String refreshCDISCForm() {
	    HttpServletRequest request = HTTPUtils.getRequest();
		String token_session = (String) request.getSession().getAttribute(TokenUtils.CSRF_TOKEN);
		String token_form = HTTPUtils.cleanXSS((String) request.getParameter(TokenUtils.CSRF_TOKEN));
		if (token_session == null || token_form == null) {
			String err_msg = "Validation token is missing.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		} else if (token_session.compareTo(token_form) != 0) {
			String err_msg = "Invalid token is detected.";
			request.getSession().setAttribute("errorMsg", err_msg);
			request.getSession().setAttribute("retry", "true");
			return "retry";
		}
	    String retry_cdisc = (String) request.getSession().getAttribute("retry_cdisc");

	    String email = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.EMAIL);
	    String name = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.NAME);
	    String phone_number = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.PHONE_NUMBER);
	    String organization = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.ORGANIZATION);
	    String vocabulary = HTTPUtils.getJspSessionAttributeString(request, SuggestionCDISCRequest.VOCABULARY);
	    String cdisc_request_type = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.CDISC_REQUEST_TYPE);
	    String cdisc_codes = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.CDISC_CODES);
	    String term = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.TERM);
	    String reason = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.REASON);
	    //String warnings = HTTPUtils.getJspAttributeString(request, SuggestionCDISCRequest.WARNINGS);

	    if (retry_cdisc == null || retry_cdisc.compareTo("true") != 0) {

			email = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.EMAIL));
			name = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.NAME));
			phone_number = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.PHONE_NUMBER));
			organization = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.ORGANIZATION));
			vocabulary = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.VOCABULARY));
			cdisc_request_type = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_REQUEST_TYPE));
			cdisc_codes = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.CDISC_CODES));
			term = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.TERM));
			reason = HTTPUtils.cleanXSS((String) request.getParameter(SuggestionCDISCRequest.REASON));

			request.getSession().setAttribute(SuggestionCDISCRequest.EMAIL, email);
			request.getSession().setAttribute(SuggestionCDISCRequest.NAME, name);
			request.getSession().setAttribute(SuggestionCDISCRequest.PHONE_NUMBER, phone_number);
			request.getSession().setAttribute(SuggestionCDISCRequest.ORGANIZATION, organization);
			request.getSession().setAttribute(SuggestionCDISCRequest.VOCABULARY, vocabulary);
			request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_REQUEST_TYPE, cdisc_request_type);
			request.getSession().setAttribute(SuggestionCDISCRequest.CDISC_CODES, cdisc_codes);
			request.getSession().setAttribute(SuggestionCDISCRequest.TERM, term);
			request.getSession().setAttribute(SuggestionCDISCRequest.REASON, reason);
		}

        refreshCaptcha(request);
		return "refresh_cdisc";
    }


	public static boolean isNull(String s) {
		if (s == null) return true;
		s = s.trim();
		if (s.compareTo("") == 0) return true;
		return false;
	}

	public String switchCaptchaMode() {
        HttpServletRequest request =
            (HttpServletRequest) FacesContext.getCurrentInstance()
                .getExternalContext().getRequest();

        String newtermform = HTTPUtils.cleanXSS((String) request.getParameter("newtermform"));
        if (!isNull(newtermform)) {
			if (newtermform.indexOf("cdisc") == -1) {
				saveSessionVariables(request);
			} else {
				saveCDISCSessionVariables(request);
			}
		} else {

			String answer = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.ANSWER));
			String subject = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.SUBJECT));
			String message = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_MSG));
			String from    = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_ADDRESS));

			request.getSession().setAttribute(ContactUsRequest.ANSWER, answer);
			request.getSession().setAttribute(ContactUsRequest.SUBJECT, subject);
			request.getSession().setAttribute(ContactUsRequest.EMAIL_MSG, message);
			request.getSession().setAttribute(ContactUsRequest.EMAIL_ADDRESS, from);
		}
        String captcha_option = HTTPUtils.cleanXSS((String) request.getParameter("captcha_option"));
        if (isNull(captcha_option)) {
			captcha_option = "default";
		}
        request.getSession().setAttribute("captcha_option", captcha_option);
        return "resetCaptcha";
	}

    public String regenerateCaptchaImage() throws Exception {
        HttpServletRequest request =
            (HttpServletRequest) FacesContext.getCurrentInstance()
                .getExternalContext().getRequest();

		request.getSession().setAttribute("retry", "true");
        String newtermform = HTTPUtils.cleanXSS((String) request.getParameter("newtermform"));
        if (!isNull(newtermform)) {
			if (newtermform.indexOf("cdisc") == -1) {
				saveSessionVariables(request);
			} else {
				saveCDISCSessionVariables(request);
			}

		} else { // contact page

			String answer = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.ANSWER));
			String subject = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.SUBJECT));
			String message = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_MSG));
			String from    = HTTPUtils.cleanXSS((String) request.getParameter(ContactUsRequest.EMAIL_ADDRESS));

			request.getSession().setAttribute(ContactUsRequest.ANSWER, answer);
			request.getSession().setAttribute(ContactUsRequest.SUBJECT, subject);
			request.getSession().setAttribute(ContactUsRequest.EMAIL_MSG, message);
			request.getSession().setAttribute(ContactUsRequest.EMAIL_ADDRESS, from);

		}


        return "retry";
	}

/*
    private String validateAudioCaptcha(HttpServletRequest request,
        String returnIncompleteState) throws Exception {

        AudioCaptcha captcha = (AudioCaptcha) request.getSession().getAttribute(AudioCaptcha.NAME);
        if (captcha == null) {
			AudioCaptcha ac = new AudioCaptcha.Builder()
				.addAnswer()
				.addNoise()
				.build();

			request.getSession().setAttribute(AudioCaptcha.NAME, ac);
		}

        // Do this so we can capture non-Latin chars
        request.setCharacterEncoding("UTF-8");
        String answer = HTTPUtils.cleanXSS((String) request.getParameter("answer"));

        if (isNull(answer)) {
            throw new NoReloadException(
                "Please enter the numbers you heard in the audio.");
        }

        request.getSession().removeAttribute("reload");
        if (!captcha.isCorrect(answer)) {
            throw new InvalidCaptChaInputException(
                "WARNING: The numbers you entered does not match"
                    + " with what is set in the audio. Please try again.");
		}

        request.getSession().removeAttribute(AudioCaptcha.NAME);
        return null;
    }
*/
    private static class InvalidCaptChaInputException extends Exception {
        private static final long serialVersionUID = 2L;
        public InvalidCaptChaInputException(String text) {
            super(text);
        }
    }


	public synchronized JSONObject getCaptchaJsonResponse(String secretKey, String response) {
		JSONObject json = null;
		BufferedReader rd = null;
		try {
			String url = "https://www.google.com/recaptcha/api/siteverify",
					params = "secret=" + secretKey + "&response=" + response;

			HttpURLConnection http = (HttpURLConnection) new URL(url).openConnection();
			http.setDoOutput(true);
			http.setRequestMethod("POST");
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded; charset=UTF-8");
			OutputStream out = http.getOutputStream();
			out.write(params.getBytes("UTF-8"));
			out.flush();
			out.close();

			InputStream res = http.getInputStream();
			rd = new BufferedReader(new InputStreamReader(res, "UTF-8"));

			StringBuilder sb = new StringBuilder();
			int cp;
			while ((cp = rd.read()) != -1) {
				sb.append((char) cp);
			}
			json = new JSONObject(sb.toString());
			res.close();

			if (rd != null) {
				try {
					rd.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rd != null) {
				try {
					rd.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		return json;
	}


}
