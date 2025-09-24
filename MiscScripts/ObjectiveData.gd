extends Resource
class_name ObjectiveData

var DATA = [
	{
		"title": "Lv.1 Movimentando o robô",
		"objectives":[
			{"ID": 0, "info":"Mover o robô para a origem (pos 0, 0)", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_to", "target": Vector2i.ZERO, "completed": false, "last_step": true, "progress_step": false}
			]},
			{"ID": 1, "info":"Mover o robô para direita", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_dir", "target": "next", "completed": false, "last_step": true, "progress_step": false}
			]},
			{"ID": 2, "info":"Mover o robô para esquerda", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_dir", "target": "previous", "completed": false, "last_step": true, "progress_step": false}
			]},
			{"ID": 3, "info":"Mover o robô para a posição 0, 5", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_to", "target": Vector2i(0, 5), "completed": false, "last_step": true, "progress_step": false}
			]},
		]
	},
	{
		"title": "Lv.2 Plantio simples",
		"objectives": [
		  {"info": "Mover até o canteiro (0, 1) e plantar 1 cenoura", "has_progression": false, "progress_max": 0 },
		  {"info": "Regar o canteiro (0, 1) e aguardar", "has_progression": false, "progress_max": 0 },
		  {"info": "Colher 1 cenoura madura", "has_progression": true, "progress_max": 1 }
		]
	},
	{
		"title": "Lv.3 Caminhar pela linha",
		"objectives": [
		  { "info": "Ir da origem até o final da linha usando mover_proximo", "has_progression": false, "progress_max": 0 }
		]
	},
	{
		"title": "Lv.4 Plantar em 3 canteiros da mesma linha",
		"objectives": [
		  { "info": "Plantar cenouras em 3 canteiros consecutivos", "has_progression": true, "progress_max": 3 }
		]
	},
	{
		"title": "Lv.5 Repetição básico",
		"objectives": [
		  { "info": "Plantar cenouras em 5 canteiros consecutivos - Use PARA_FAÇA(5)", "has_progression": true, "progress_max": 5 }
		]
	},
	{
		"title": "Lv.6 Quatro pontos",
		"objectives": [
		  { "info": "Plantar um vegetal em (0, 0)", "has_progression": false, "progress_max": 0 },
		  { "info": "Plantar um vegetal em (0, 5)", "has_progression": false, "progress_max": 0 },
		  { "info": "Plantar um vegetal em (5, 0)", "has_progression": false, "progress_max": 0 },
		  { "info": "Plantar um vegetal em (5, 5)", "has_progression": false, "progress_max": 0 }
		]
	},
	{
		"title": "Lv.7 Condicional - SE_SENÃO",
		"objectives": [
		  { "info": "Vá até os canteiros ocupados, se maduro colher, senão regar", "has_progression": true, "progress_max": 4 }
		]
	},
	{
		"title": "Lv.8 Condicional - ENQUANTO",
		"objectives": [
		  { "info": "Da origem, percorrer o canteiro até pos (0, 2)", "has_progression": true, "progress_max": 13 }
		]
	},
	{
		"title": "Lv.9 Criar função",
		"objectives": [
		  { "info": "Definir função que planta e rega; chamar 3 vezes", "has_progression": true, "progress_max": 3 }
		]
	},
	{
		"title": "Lv.10 Desafio 1",
		"objectives": [
		  { "info": "Plantar e ragar cenouras nas linhas 0, 2, 4", "has_progression": true, "progress_max": 3 },
		  { "info": "Plantar e ragar cebolas nas linhas 1, 3, 5", "has_progression": true, "progress_max": 3 },
		]
	},
	{
		"title": "Modo Livre",
		"objectives": [
		  { "info": "Experimente blocos e funções para automatizar a colheita", "has_progression": false, "progress_max": 0 }
		]
	}
]

#"move_to":
	#if curr_pos == objective.target:
		#complete_objective(objective)
		#break
#"move_dir":
	#if last_move_dir == objective.target:
		#complete_objective(objective)
		#break
#"plant_at":
	#if last_crop == objective.target_crop and curr_pos == objective.target:
		#complete_objective(objective)
		#break
#"water_at":
	#if curr_pos == objective.target:
		#complete_objective(objective)
		#break
#"harvest_at":
	#if curr_pos == objective.target and last_crop == objective.target_crop:
		#complete_objective(objective)
		#break
