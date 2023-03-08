package com.rdebug.views.regexeditor;

import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.data.value.ValueChangeMode;
import com.vaadin.flow.function.SerializablePredicate;

public class RegexTextField extends TextField {

    private SerializablePredicate<String> patternValidator;

    public RegexTextField(String label, String placeholder) {
        super(label, placeholder);
        setValueChangeMode(ValueChangeMode.LAZY);
        addValueChangeListener(event -> {
            if (!patternValidator.test(event.getValue())) {
                setInvalid(true);
            } else {
                setInvalid(false);
            }
        });
    }

    public void setPatternValidator(SerializablePredicate<String> patternValidator) {
        this.patternValidator = patternValidator;
    }
}
