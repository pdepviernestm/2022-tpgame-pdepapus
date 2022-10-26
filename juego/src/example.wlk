import wollok.game.*

object game {
	method iniciar() {
		//game.title("Space Invaders")
		game.width(10)
		game.height(15)
		game.boardGround("fondo.jpg")
		game.addVisualCharacter(nave)
		game.start()
	}
}

class Naves {
	var vida 
	var arma
	method perderVida(dano) {
		vida -= 0.max(vida-dano)
	}
}

class Invasores inherits Naves {
	const valor
	method darPuntos() {
		if(vida == 0) {
			nave.ganarPuntos(valor)
			game.say(nave,nave.varlor().toString)
		}
	}
	
}

object nave inherits Naves(vida=3,arma=basica) {
	var property position = game.at(7,0)
	var puntos = 0
	method image() = "navePrincipal.png"
	method izquierda() {
		position = position.left(1)
	}
	method derecha() {
		position = position.right(1)
	}
	method cambiarArma(nuevaArma){
		arma = nuevaArma
	}
	method disparar() {
		self.atacar(up)
	}
	method ganarPuntos(valor)
	{
		puntos += valor
	}
	method puntuacionTotal()
	{
		
	}
}

class Arma {
	const dano
	const efecto
	
	method efecto() {return efecto}  
	method impactar(objectivo) {
		objectivo.perderVida(dano)
	}
}

const basica = new Arma(dano=1,efecto="Ninguno")
const mejorada = new Arma(dano=2,efecto="Mas Daño")
const peligrosa = new Arma(dano=1,efecto="Doble Punto") 


object teclado {
  method configurar() {
    keyboard.left().onPressDo{nave.izquierda()}
    keyboard.right().onPressDo{nave.derecha()}
    keyboard.q().onPressDo{nave.cambiarArma(basica)}
    keyboard.w().onPressDo{nave.cambiarArma(mejorada)}
    keyboard.e().onPressDo{nave.cambiarArma(peligrosa)}	
   	keyboard.space().onPressDo{nave.disparar()}
   }
}