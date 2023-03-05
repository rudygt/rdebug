package com.rdebug.views.tablero;

import com.rdebug.views.MainLayout;
import com.vaadin.flow.component.ClickEvent;
import com.vaadin.flow.component.ComponentEventListener;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.html.Image;
import com.vaadin.flow.component.html.Paragraph;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouteAlias;
import com.vaadin.flow.theme.lumo.LumoUtility.Margin;
import org.vaadin.stefan.table.Table;
import org.vaadin.stefan.table.TableRow;

import java.util.Random;

@PageTitle("Tablero")
@Route(value = "tablero", layout = MainLayout.class)
@RouteAlias(value = "", layout = MainLayout.class)
public class TableroView extends VerticalLayout implements ComponentEventListener<ClickEvent<Button>> {

    private Casilla[][] casillas;

    private int numeroDeFilas = 4;
    private int numeroDeColumnas = 4;

    public TableroView() {
        setSpacing(false);

        Table table = new Table();

        casillas = new Casilla[numeroDeFilas][numeroDeColumnas];
        for (int i = 0; i < numeroDeFilas; i++) {
            TableRow currentRow = table.addRow();
            for (int j = 0; j < numeroDeColumnas; j++) {
                Casilla casilla = new Casilla(String.format("(%s,%s)", i, j));
                casilla.setSizeFull();
                casilla.addClickListener(this);
                casillas[i][j] = casilla;
                currentRow.addCells(casilla);
            }
        }

        table.setSizeFull();

        add(table);

        setSizeFull();
        setHeight("100%");
        setJustifyContentMode(JustifyContentMode.CENTER);
        setDefaultHorizontalComponentAlignment(Alignment.CENTER);
        getStyle().set("text-align", "center");

    }

    Random random = new Random();

    private String getRandomColor() {
        return String.format("#%06x", random.nextInt(256 * 256 * 256));
    }

    @Override
    public void onComponentEvent(ClickEvent<Button> event) {

        Button source = event.getSource();

        String message = "button clicked " + source.getText();

        System.out.println(message);

        //client side
        Notification.show(message);

        source.getStyle().set("background-color", getRandomColor());

    }


}

