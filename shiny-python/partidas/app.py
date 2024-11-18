from shiny import App, render, ui, reactive
from pathlib import Path
import pandas as pd

def calcular_gols(placar, mando):
    if mando == "mandante":
        pos = 0
    else:
        pos = 1
    gols = placar.split(sep="x")[pos]
    if gols == '':
        return 0
    else:
        return int(gols)

matches = pd.read_csv("shiny-python/partidas/matches.csv")

matches = matches \
    .query("score != 'x'") \
    .assign(
        num_gols_mandante = matches["score"].apply(lambda y: calcular_gols(y, "mandante")),
        num_gols_visitante = matches["score"].apply(lambda y: calcular_gols(y, "visitante"))
    )


temporada = matches.season.unique().tolist()
temporada.sort()


css_file = Path(__file__).parent / "css" / "custom.css"
js_file = Path(__file__).parent / "js" / "script.js"

app_ui = ui.page_navbar(
    ui.nav_panel(
        "Últimas 10 partidas",
        ui.head_content(
            ui.include_css(css_file)
        ),
        ui.layout_sidebar(
            ui.sidebar(
                ui.input_select(
                    id = "temporada",
                    label = "Selecione uma temporada",
                    choices = temporada
                ),
                ui.input_select(
                    id = "time", 
                    label = "Selecione um time",
                    choices = [""]
                )
            ),
            ui.panel_title("Últimas 10 partidas de um time"),
            ui.layout_columns(
                ui.output_ui(id = "vb_num_gols_pro"),
                col_widths = 3
            ),
            ui.output_table(id = "tabela"),
            ui.include_js(path = js_file)
        ),
    ),
    ui.nav_panel(
        "Número de pontos"
    ),
    title="App Partidas"
)


def server(input, output, session):

    @reactive.effect
    def _():
        temporada = int(input.temporada())
        partidas_temporada = matches.query("season == @temporada")
        times = partidas_temporada.home.unique().tolist()
        times.sort()
        ui.update_select(
            id = "time",
            choices = times
        )

    @reactive.calc
    def partidas_filtradas():
        time = input.time()
        temporada = int(input.temporada())
        tab = matches \
            .query("season == @temporada") \
            .query("home == @time | away == @time")
        return tab

    @render.table
    def tabela():
        tab = partidas_filtradas() \
            .sort_values(by = "date", ascending = False) \
            .head(10)
        return tab

    @render.ui
    def vb_num_gols_pro():
        with reactive.isolate():
            time = input.time()

        num_gols_como_mandante = partidas_filtradas() \
            .query("home == @time") \
            .agg({"num_gols_mandante": "sum"}) \
            .num_gols_mandante

        num_gols_como_visitante = partidas_filtradas() \
            .query("away == @time") \
            .agg({"num_gols_visitante": "sum"}) \
            .num_gols_visitante

        gols = num_gols_como_mandante + num_gols_como_visitante
            
        vb = ui.value_box(
            title = "Número de gols pro",
            value = str(gols)
        )
        return vb

    @reactive.effect
    @reactive.event(input.click_vb_num_gols_pro)
    def _():
        modal = ui.modal(
            ui.TagList("informações extras do modal"),
            title = "Gols pro",
            easy_close = True,
            size = "xl"
        )
        ui.modal_show(modal)



app = App(app_ui, server)

