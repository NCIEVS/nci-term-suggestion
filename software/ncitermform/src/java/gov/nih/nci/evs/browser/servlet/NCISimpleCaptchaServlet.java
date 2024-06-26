package gov.nih.nci.evs.browser.servlet;

import nl.captcha.servlet.*;
import nl.captcha.backgrounds.*;

import static nl.captcha.Captcha.NAME;

import java.awt.Color;
import java.awt.Font;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nl.captcha.Captcha;
import nl.captcha.backgrounds.GradiatedBackgroundProducer;
import nl.captcha.backgrounds.FlatColorBackgroundProducer;
import nl.captcha.backgrounds.GradiatedBackgroundProducer;


import nl.captcha.text.renderer.ColoredEdgesWordRenderer;

import java.awt.Color;


/**
 * Generates, displays, and stores in session a 200x50 CAPTCHA image with sheared
 * black text, a solid dark grey background, and a slightly curved line over the
 * text.
 *
 * @author <a href="mailto:james.childers@gmail.com">James Childers</a>
 */
public class NCISimpleCaptchaServlet extends SimpleCaptchaServlet {

    private static final long serialVersionUID = 1L;

    //private static int _width = 200;
    //private static int _height = 50;

    private int _width = 200;
    private int _height = 50;

    //private static final List<Color> COLORS = new ArrayList<Color>(2);
    private static final List<Color> COLORS = new ArrayList<Color>(1);
    private static final List<Font> FONTS = new ArrayList<Font>(3);

    static {
        COLORS.add(Color.BLACK);
        //COLORS.add(Color.BLUE);

        FONTS.add(new Font("Geneva", Font.ITALIC, 48));
        FONTS.add(new Font("Courier", Font.BOLD, 48));
        FONTS.add(new Font("Arial", Font.BOLD, 48));
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    	if (getInitParameter("captcha-height") != null) {
    		//_height = Integer.valueOf(getInitParameter("captcha-height"));
    		_height = Integer.parseInt(getInitParameter("captcha-height"));

    	}

    	if (getInitParameter("captcha-width") != null) {
    		//_width = Integer.valueOf(getInitParameter("captcha-width"));
    		_width = Integer.parseInt(getInitParameter("captcha-width"));
    	}
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        //ColoredEdgesWordRenderer wordRenderer = new ColoredEdgesWordRenderer(COLORS, FONTS);
        ColoredEdgesWordRenderer wordRenderer = new ColoredEdgesWordRenderer(COLORS, FONTS, 1f);
        Captcha captcha = new Captcha.Builder(_width, _height).addText(wordRenderer)
                //.gimp()
                .addNoise()
                //.addBackground(new GradiatedBackgroundProducer())
                //.addBackground(new TransparentBackgroundProducer())
                //.addBackground(new FlatColorBackgroundProducer(Color.lightGray))
                .addBackground(new GradiatedBackgroundProducer(Color.lightGray, Color.white))
                .build();

        CaptchaServletUtil.writeImage(resp, captcha.getImage());
        req.getSession().setAttribute(NAME, captcha);
    }
}
