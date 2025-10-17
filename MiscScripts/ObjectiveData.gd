extends Resource
class_name ObjectiveData

var DATA = [
	{
		"title": "Lv.1 Movimentando o robô",
		"objectives":[
			{"ID": 0, "info":"Mover o robô para a origem (pos 0, 0)", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_to", "target": Vector2i.ZERO, "completed": false, "progress_step": false}
			]},
			{"ID": 1, "info":"Mover o robô para direita", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_dir", "target": "next", "completed": false, "progress_step": false}
			]},
			{"ID": 2, "info":"Mover o robô para esquerda", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_dir", "target": "previous", "completed": false, "progress_step": false}
			]},
			{"ID": 3, "info":"Mover o robô para a posição 0, 5", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_to", "target": Vector2i(0, 5), "completed": false, "progress_step": false}
			]}],
		"tip": "Utilize os blocos de movimento 'MoverPara', 'MoverProx' e 'MoverAnt'",
		"grid_state": {}
	},
	{
		"title": "Lv.2 Plantio simples",
		"objectives": [
		  {"info": "Mover até o canteiro (0, 1) e plantar 1 cenoura", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "move_to", "target": Vector2i(0, 1), "completed": false, "progress_step": false},
				{"type": "plant_at", "target": Vector2i(0, 1), "target_crop":"Cenoura", "completed": false, "progress_step": false},
			]},
		  {"info": "Regar o canteiro (0, 1) e aguardar", "has_progression": false, "progress_max": 0,
			"steps":[
				{"type": "water_at", "target": Vector2i(0, 1), "completed": false, "progress_step": false}
			]},
		  {"info": "Colher 1 cenoura madura", "has_progression": true, "progress_max": 1,
			"steps":[
				{"type": "harvest_at", "target": Vector2i(0, 1), "target_crop":"Cenoura", "completed": false, "progress_step": false}
			]}],
		"tip": "Mova-se até o canteiro indicado e use 'Plantar', 'Regar' e 'Colher'",
		"grid_state": {}
	},
	{
		"title": "Lv.3 Caminhar pela linha",
		"objectives": [
		  { "info": "Ir da origem até o final da primeira linha", "has_progression": true, "progress_max": 6,
			"steps":[
				{"type": "move_to", "target": Vector2i(0, 0), "completed": false, "progress_step": true},
				{"type": "move_to", "target": Vector2i(1, 0), "completed": false, "progress_step": true},
				{"type": "move_to", "target": Vector2i(2, 0), "completed": false, "progress_step": true},
				{"type": "move_to", "target": Vector2i(3, 0), "completed": false, "progress_step": true},
				{"type": "move_to", "target": Vector2i(4, 0), "completed": false, "progress_step": true},
				{"type": "move_to", "target": Vector2i(5, 0), "completed": false, "progress_step": true},
			]}],
		"tip": "Mova-se para todos os canteiros entre (0, 0) e (5, 0)",
		"grid_state": {}
	},
	{
		"title": "Lv.4 Plantar em 3 canteiros diferentes",
		"objectives": [
		  { "info": "Plantar cenouras em 3 canteiros diferentes", "has_progression": true, "progress_max": 3,
			"steps":[
				{"type": "plant_at", "target": "any", "target_crop":"Cenoura", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cenoura", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cenoura", "completed": false, "progress_step": true},
			]}],
		"tip": "Utilize os blocos 'MoverProx' e 'Plantar'",
		"grid_state": {}
	},
	{
		"title": "Lv.5 Repetição básico",
		"objectives": [
		  { "info": "Plantar cebolas em 5 canteiros diferentes", "has_progression": true, "progress_max": 5,
		"steps":[
				{"type": "plant_at", "target": "any", "target_crop":"Cebola", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cebola", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cebola", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cebola", "completed": false, "progress_step": true},
				{"type": "plant_at", "target": "any", "target_crop":"Cebola", "completed": false, "progress_step": true},
			]}],
		"tip": "Utilize os blocos 'MoverProx' e 'Plantar' em conjunto com o bloco 'PARA_FAÇA'",
		"grid_state": {}
	},
	{
		"title": "Lv.6 Quatro pontos",
		"objectives": [
		  { "info": "Plantar um vegetal em (0, 0)", "has_progression": false, "progress_max": 0,
		"steps":[
			{"type": "plant_at", "target": Vector2i(0, 0), "target_crop":"any", "completed": false, "progress_step": false},
		]},
		  { "info": "Plantar um vegetal em (0, 5)", "has_progression": false, "progress_max": 0,
		"steps":[
			{"type": "plant_at", "target": Vector2i(0, 5), "target_crop":"any", "completed": false, "progress_step": false},
		]},
		  { "info": "Plantar um vegetal em (5, 0)", "has_progression": false, "progress_max": 0,
		"steps":[
			{"type": "plant_at", "target": Vector2i(5, 0), "target_crop":"any", "completed": false, "progress_step": false},
		]},
		  { "info": "Plantar um vegetal em (5, 5)", "has_progression": false, "progress_max": 0,
		"steps":[
			{"type": "plant_at", "target": Vector2i(5, 5), "target_crop":"any", "completed": false, "progress_step": false},
		]}],
		"tip": "Utilize 'MoverPara' e 'Plantar'",
		"grid_state": {}
	},
	{
		"title": "Lv.7 Condicional - SE_SENÃO",
		"objectives": [
		  { "info": "Colher plantas maduras, senão regar", "has_progression": true, "progress_max": 4,
		"steps":[
			{"type": "harvest_at", "target": Vector2i(2, 0), "target_crop":"any", "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2, 1), "completed": false, "progress_step": true},
			{"type": "harvest_at", "target": Vector2i(2, 2), "target_crop":"any", "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2, 3), "completed": false, "progress_step": true},
		]}],
		"tip": "'SE_SENÃO' permite alterar o comportamento de acordo com a condição",
		"grid_state": {
			Vector2i(2, 0): {"crop":3, "growth":50.0, "water":0.0},
			Vector2i(2, 1): {"crop":1, "growth":0.0, "water":0.0},
			Vector2i(2, 2): {"crop":2, "growth":50.0, "water":0.0},
			Vector2i(2, 3): {"crop":1, "growth":0.0, "water":0.0},
		}
	},
	{
		"title": "Lv.8 Condicional - ENQUANTO",
		"objectives": [
		  { "info": "Da origem, percorrer o canteiro até pos (0, 2)", "has_progression": true, "progress_max": 13,
		"steps":[
			{"type": "move_to", "target": Vector2i(0, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(1, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(2, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(3, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(4, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(5, 0), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(0, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(1, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(2, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(3, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(4, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(5, 1), "completed": false, "progress_step": true},
			{"type": "move_to", "target": Vector2i(0, 2), "completed": false, "progress_step": true},
			]}],
		"tip": "Utilize 'ENQUANTO' com a condição 'pos_y'",
		"grid_state": {}
	},
	{
		"title": "Lv.9 Criar função",
		"objectives": [
		  { "info": "Definir função que planta e rega; chamar 3 vezes", "has_progression": true, "progress_max": 3,
		"steps":[
			{"type": "plant_at", "target": "any", "target_crop": "any", "completed": false, "progress_step": false},
			{"type": "water_at", "target": "any", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": "any", "target_crop": "any", "completed": false, "progress_step": false},
			{"type": "water_at", "target": "any", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": "any", "target_crop": "any", "completed": false, "progress_step": false},
			{"type": "water_at", "target": "any", "completed": false, "progress_step": true},
		]}],
		"tip": "Para criar uma função, arraste um bloco em cima da área f().",
		"grid_state": {}
	},
	{
		"title": "Lv.10 Desafio 1",
		"objectives": [
		  { "info": "Plantar e ragar cenouras nas linhas 0, 2, 4", "has_progression": true, "progress_max": 36,
		"steps":[
			{"type": "plant_at", "target": Vector2i(0,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,0), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(0,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,2), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(0,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,4), "target_crop": "Cenoura", "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,0), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,2), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,4), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,4), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,4), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,4), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,4), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,4), "completed": false, "progress_step": true},
		]},
		  { "info": "Plantar e ragar cebolas nas linhas 1, 3, 5", "has_progression": true, "progress_max": 36,
		"steps":[
			{"type": "plant_at", "target": Vector2i(0,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,1), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(0,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,3), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(0,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(1,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(2,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(3,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(4,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "plant_at", "target": Vector2i(5,5), "target_crop": "Cebola", "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,1), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,3), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(0,5), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(1,5), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(2,5), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(3,5), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(4,5), "completed": false, "progress_step": true},
			{"type": "water_at", "target": Vector2i(5,5), "completed": false, "progress_step": true},
		]}],
		"tip": "Tente combinar 'SE_SENÃO' e 'ENQUANTO' para completar em uma única execução",
		"grid_state": {}
	},
	{
		"title": "Modo Livre",
		"objectives": [
		  { "info": "Experimente blocos e funções para automatizar a colheita", "has_progression": false, "progress_max": 0,
		"steps":[
			
		]}],
		"tip": "Tente combinar diferentes blocos para automatizar plantio e colheita.",
		"grid_state": {}
	}
]
