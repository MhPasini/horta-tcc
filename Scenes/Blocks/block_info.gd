extends Resource
class_name BlockInfo

enum {
	MOVER_PARA,
	MOVER_PROX,
	MOVER_ANT,
	MOVER_ORIG,
	PLANTAR,
	REGAR,
	COLHER,
	SE_SENAO,
	PARA_FACA,
	ENQUANTO,
	FUNCAO
}

const CODE_DATA = {
	MOVER_PARA: {
	"Name": "move_to",
	"Info": "Função para se movimentar até uma posição definida por x e y",
	"BlockText": "MoverPara"
	},
	MOVER_PROX: {
	"Name": "move_to_next",
	"Info": "Função para se movimentar até a próxima posição",
	"BlockText": "MoverProximo"
	},
	MOVER_ANT: {
	"Name": "move_to_previous",
	"Info": "Função para se movimentar até a posição anterior",
	"BlockText": "MoverAnterior"
	},
	MOVER_ORIG: {
	"Name": "move_to_origin",
	"Info": "Função para se movimentar até a posição (0, 0)",
	"BlockText": "MoverOrigem"
	},
	PLANTAR: {
	"Name": "plant_crop",
	"Info": "Função para plantar uma semente no canteiro atual",
	"BlockText": "Plantar"
	},
	REGAR: {
	"Name": "water_crop",
	"Info": "Função para regar o canteiro atual",
	"BlockText": "Regar"
	},
	COLHER: {
	"Name": "harvest_crop",
	"Info": "Função para colher a planta do canteiro atual",
	"BlockText": "Colher"
	},
	SE_SENAO:{
		"Name": "if_else",
		"Info": "Bloco 'SE', executa os blocos internos se 'CONDIÇÃO' for verdadeira"
	},
	PARA_FACA:{
		"Name": "for_loop",
		"Info": "Bloco de repetição, executa os blocos internos 'x' vezes"
	},
	ENQUANTO:{
		"Name": "while_loop",
		"Info": "Bloco 'ENQUANTO', executa os blocos internos enquanto 'CONDIÇÃO' for verdadeira"
	},
	FUNCAO:{
		"Name": "custom_function",
		"Info": "Bloco 'FUNÇÃO', executa os blocos internos quando chamado"
	}
}
