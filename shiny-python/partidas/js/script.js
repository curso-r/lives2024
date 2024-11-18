elemento = document.getElementById("vb_num_gols_pro");
elemento.addEventListener("click", function(e) {
   console.log("oi");
   Shiny.setInputValue("click_vb_num_gols_pro", Math.random());
})