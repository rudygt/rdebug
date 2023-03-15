package com.rdebug.views.graphviewer;

import com.rdebug.views.MainLayout;
import com.vaadin.flow.component.Key;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.html.Image;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextArea;
import com.vaadin.flow.dom.Element;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouteAlias;
import com.vaadin.flow.server.StreamResource;
import guru.nidi.graphviz.engine.Format;
import guru.nidi.graphviz.engine.Graphviz;
import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;
import org.w3c.dom.html.HTMLImageElement;

import java.io.ByteArrayInputStream;
import java.io.IOException;

@PageTitle("GraphViewer")
@Route(value = "graph", layout = MainLayout.class)
@RouteAlias(value = "", layout = MainLayout.class)
public class GraphViewerView extends HorizontalLayout {

    private Button drawButton;

    private TextArea inputGraph;

    private Image graph;

    private Parser p;

    public GraphViewerView() {

        inputGraph = new TextArea("Graph");
        inputGraph.setValue("digraph PCB {\n" +
                "    rankdir=LR;\n" +
                "    node [shape=box, style=filled, fillcolor=lightblue];\n" +
                "\n" +
                "    New [label=\"New\"];\n" +
                "    Ready [label=\"Ready\"];\n" +
                "    Running [label=\"Running\"];\n" +
                "    Blocked [label=\"Blocked\"];\n" +
                "    Exit [label=\"Exit\"];\n" +
                "\n" +
                "    New -> Ready [label=\"Admitted\"];\n" +
                "    Ready -> Running [label=\"Scheduled\"];\n" +
                "    Running -> Ready [label=\"Interrupt\"];\n" +
                "    Running -> Blocked [label=\"I/O or Event Wait\"];\n" +
                "    Running -> Exit [label=\"Exit\"];\n" +
                "    Blocked -> Ready [label=\"I/O or Event Completion\"];\n" +
                "}\n");
        inputGraph.setSizeFull();

        drawButton = new Button(">");

        p = new Parser();
        drawButton.addClickListener(e -> {
            try {

                MutableGraph g = p.read(inputGraph.getValue());

                String svgData = Graphviz.fromGraph(g).render(Format.SVG).toString();

                StreamResource resource = new StreamResource("data.svg", () -> new ByteArrayInputStream(svgData.getBytes()));

                graph.setSrc(resource);

            } catch (IOException ex) {
                Notification.show("failed to generate graph!");
            }
        });

        drawButton.addClickShortcut(Key.ENTER);

        VerticalLayout panel = new VerticalLayout();
        panel.setWidth("30%");
        panel.setHeightFull();
        panel.add(drawButton, inputGraph);

        graph = new Image();

        graph.setWidth("70%");
        graph.setHeightFull();

        add(panel, graph);

        setHeightFull();

    }

}
