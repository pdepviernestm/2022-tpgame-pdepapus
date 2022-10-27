import wollok.game.*

object juego {
	method iniciar() {
		game.title("Space Invaders")
		game.width(11)
		game.height(7)
		game.boardGround("fondo.jpg")
		game.addVisualCharacter(nave)
		game.start()
	}
}

class Naves {
	var vida 
	var arma
	var poder	
	var property position 
	var image
	method image() = image
	method posicion() {return position}
}

class Invasores inherits Naves {
	var valor
	var lado = true
		method perderVida(dano) {
		vida -= 0.max(vida-dano)
		if(vida == 0) {
			self.darPuntos()
		}
	}
	method moverse() {
		if(lado)
		{
			position = position.right(1)
			if((self.position().x()) + 1 > 10) {
			position = game.at(self.position().x(),self.position().y() - 1)
			lado = false
			}	
		}
		else
		{
			position = position.left(1)
			if((self.position().x()) - 1 < 0) {
			position = game.at(self.position().x(),self.position().y() - 1)
			lado = true
			}
		}
	}
	method valor() {return valor}
	method darPuntos() {
			nave.ganarPuntos(valor)
			game.say(nave,self.valor().toString())
	}
	method disparar() {
		const ejeY = self.posicion().y()
		const ejeX = self.posicion().x()
		const tiroEnemigo = new Tiro(position = game.at(ejeX,ejeY - 1),image= arma.image(),dano = arma.dano() + poder)
		game.onTick(arma.velocidad(),"moverse",{tiroEnemigo.bajar()})
	}
}

const inv1 = new Invasores(vida=1,arma=basica,poder=1,position=game.at(0,10),valor=10,image="inv1.png")


object nave inherits Naves(vida=3,arma=basica,poder=1,position = game.at(7,0),image="navePrincipal.png") {
	var puntos = 0
	method perderVida(dano) {
		vida -= 0.max(vida-dano)
	}
	method puntaje() {return puntos}
	method izquierda() {
		if((self.position().x()) - 1 < 0) {
			game.say(self,"Pared")
		}
		else {
			position = position.left(1)
		}
	}
	//rebisar,anda raro
	method derecha() {
		if((self.position().x()) + 1 > 11) {
			game.say(self,"Pared")
		}
		else {
			position = position.right(1)	
		}
	}
	method bloquear() {
		var eje 
		eje = self.posicion().x()
		position = game.at(eje,0)
	}
	method cambiarArma(nuevaArma){
		arma = nuevaArma
	}
	method disparar() {
		//var ejeY = self.posicion().y()
		//var ejeX = self.posicion().x()
		//const tiro = new Tiro(position = game.at(ejeX,ejeY + 1),image= arma.image(),dano = arma.dano() + poder)
		//game.onTick(arma.velocidad(),"moverse",{tiro.subir()})
	}
	method ganarPuntos(valor)
	{
		puntos += valor
	}
	method puntuacionTotal()
	{
		game.say(self,self.puntaje().toString())
	}
}

class Arma {
	const dano
	const velocidad
	const image
	method image() = image
	method dano() {return dano}
	method velocidad() {return velocidad}  
}

class Tiro {
	var property position
	var image
	var dano
	method imgae() = image
	method subir() {
		position = position.up(1)
	}
	method bajar() {
		position = position.down(1)
	}
	method potencia() {return dano}
}

const armaEnemiga = new Arma(dano=0,velocidad=1000,image="basicaEnemiga.png")
const basica = new Arma(dano=0,velocidad=1000,image="basica.png")
const mejorada = new Arma(dano=0,velocidad=500,image="basica.png")
const peligrosa = new Arma(dano=1,velocidad=1000,image="granBola.png") 


