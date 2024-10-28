from shiny import App, render, ui
import pandas as pd

matches = pd.read_csv("shiny-python/partidas/matches.csv")

times = matches.home.unique().tolist()
times.sort()

app_ui = ui.page_navbar(
    ui.nav_panel(
        "Últimas 10 partidas",
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_select(
                    id = "time", 
                    label = "Selecione um time",
                    choices = times
                )
            ),
            ui.panel_title("Últimas 10 partidas de um time"),
            ui.output_table("tabela")
        ),
    ),
    ui.nav_panel(
        "Número de pontos"
    ),
    title="App Partidas"
)


def server(input, output, session):
    @render.table
    def tabela():
        time = input.time()
        tab = matches \
            .query("home == @time | away == @time") \
            .query("score != 'x'") \
            .sort_values(by = "date", ascending = False) \
            .head(10)
        return tab


app = App(app_ui, server)
