package com.rdebug.views.regexeditor;

import com.rdebug.views.MainLayout;
import com.vaadin.flow.component.Key;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextArea;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouteAlias;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

@PageTitle("RegexEditor")
@Route(value = "editor", layout = MainLayout.class)
@RouteAlias(value = "", layout = MainLayout.class)
public class RegexEditorView extends VerticalLayout {

    private Button testRegexButton;

    RegexTextField regexTextField;

    TextArea textArea;

    public static Pattern match(String pattern) {
        if (pattern.startsWith("^"))
            return Pattern.compile(pattern, Pattern.CASE_INSENSITIVE | Pattern.MULTILINE);
        else
            return Pattern.compile(pattern, Pattern.CASE_INSENSITIVE);
    }

    public RegexEditorView() {

        HorizontalLayout panel = new HorizontalLayout();

        testRegexButton = new Button("Test Regex");
        testRegexButton.addClickListener(e -> {
            if (!regexTextField.isInvalid()) {
                String regex = regexTextField.getValue();

                Pattern p = match(regex);

                Matcher matcher = p.matcher(textArea.getValue());
                if (matcher.find()) {
                    Notification.show("match!");
                    if (matcher.groupCount() > 0) {
                        String captured = matcher.group(1);
                        Notification.show(captured);
                    }
                } else {
                    Notification.show("no match :(");
                }
            }

        });

        testRegexButton.addClickShortcut(Key.ENTER);
        testRegexButton.setWidth("20%");

        //setMargin(true);

        regexTextField = new RegexTextField("Regex pattern", "Enter regular expression");

        regexTextField.setPatternValidator((value) -> {
            try {
                Pattern.compile(value);
                Notification.show("regex is valid");
                return true;
            } catch (PatternSyntaxException e) {
                return false;
            }
        });

        regexTextField.setWidth("80%");
        regexTextField.setValue("date:\\s(\\d{4}-\\d{2}-\\d{2})");

        panel.add(regexTextField, testRegexButton);
        panel.setVerticalComponentAlignment(Alignment.END, regexTextField, testRegexButton);
        panel.setWidthFull();
        add(panel);

        textArea = new TextArea("Enter your text");
        textArea.setValue("this is a sample text to match: important date: 2023-03-05 and some other information");
        textArea.setSizeFull();
        add(textArea);

        setHeightFull();

    }

}

