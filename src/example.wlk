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
	method nada() {}
}

class Invasores inherits Naves {
	var valor
	var lado = true
	method perderVida(dano) {
		vida -= 0.max(vida-dano)
		if(vida == 0) {
			self.darPuntos()
			game.removeVisual(self)
		}
	}
	method moverse() {
		if(lado) {
			if(position.x() + 1 > 11) {
			position = game.at(position.x(),position.y() - 1)
			lado = false
			}
			else {position = position.right(1)}	
		}
		else {
			if((self.position().x()) - 1 < 0) {
			position = game.at(position.x(),position.y() - 1)
			lado = true
			}
			else {position = position.left(1)}
		}
	}
	method valor() {return valor}
	method darPuntos() {
			nave.ganarPuntos(valor)
			game.say(nave,self.valor().toString())
	}
	method disparar() {
		const tiro = new TiroEnemigo(position = game.at(position.x(),position.y() - 1),image= arma.image(),dano = arma.dano() + poder)
		game.onTick(arma.velocidad(),"moverse",{tiro.bajar()})
		game.whenCollideDo(tiro,{elemento => tiro.colisiono(elemento)})
	}
	method chocoEnemigo() {}
	method choco(tiro) {
		self.perderVida(tiro)
	}
}

const inv1 = new Invasores(vida=1,arma=basica,poder=1,position=game.at(0,10),valor=10,image="inv1.png")


object nave inherits Naves(vida=3,arma=basica,poder=1,position = game.at(7,0),image="navePrincipal.png") {
	var puntos = 0
	method perderVida(dano) {
		vida -= 0.max(vida-dano)
		vidas.perderVida(vida)
	}
	method puntaje() {return puntos}
	method izquierda() {
		if((self.position().x()) - 1 < 0) {
			self.bloquear()
			game.say(self,"Pared")
		}
		else {
			position = position.left(1)
		}
	}
	//revisar,anda raro
	method derecha() {
		if((self.position().x()) + 1 > 11) {
			self.bloquear()
			game.schedule(500,{game.say(self,"Pared")}
			)
		}
		else {
			position = position.right(1)	
		}
	}
	method bloquear() {
		position = game.at(position.x(),0)
	}
	method cambiarArma(nuevaArma){
		arma = nuevaArma
		armaActual.cambiar(nuevaArma)
	}
	method disparar() {
		const tiroAliado = new Tiro(position = game.at(position.x(),position.y() + 1),image= arma.image(),dano = arma.dano() + poder)
		game.onTick(arma.velocidad(),"subirDisparo",{tiroAliado.subir()})
		game.whenCollideDo(tiroAliado,{elemento => tiroAliado.colisiono(elemento)})
	}
	method ganarPuntos(valor)
	{
		puntos += valor
	}
	method puntuacionTotal()
	{
		game.say(self,self.puntaje().toString())
	}
	method choco() {}
	method chocoEnemigo(tiro) {
		self.perderVida(tiro)
		vidas.perderVida(tiro)
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
	method image() = image
	method subir() {
		if(position.y() + 1 > 7) {
			game.removeVisual(self)
		}
		else {
			position = position.up(1)
		}
	}
	method potencia() {return dano}
	method colisiono(elemento) {
		self.choco()
		elemento.choco(self.potencia())
	}
	method choco() {
		game.removeTickEvent("subirDisparo")
		game.removeVisual(self)
		game.schedule(1000,{explocion.aparecer(position.x(),position.y())})
			}
}

class TiroEnemigo inherits Tiro {
	method bajar() {
		if(position.y() -1  < 0) {
			game.removeVisual(self)
		}
		else {
			position = position.down(1)
		}
	}
	override method choco() {
		game.removeTickEvent("bajarDisparo")
		game.removeVisual(self)
		game.schedule(1000,{explocion.aparecer(position.x(),position.y())})
			} 
	override method colisiono(elemento) {
		elemento.chocoEnemigo()
		self.choco()
	} 
}

object explocion {
	var property position
	method image() = "explocion.png"
	method aparecer(x,y) {
		position = game.at(x,y)
		game.schedule(500,{game.addVisual(self)})
	}
}

object vidas {
	const property position = game.at(11,7)
	var image = "vidaLlena.png"
	method image() = image
	method perderVida(cantidad) {
		if(cantidad == 2)
		{
			image = "DosVidas.png"
		}
		else{
			if(cantidad == 1)
			{
				image = "UnaVida.png"
			}
			else {image= "Muerte.png"}
		}
	}
}

object armaActual {
	const property position = game.at(11,0)
	var image = "armaBasica.png"
	method image() = image
	method cambiar(arma) {
		if(arma == basica) {image = "armaBasica.png"}
		if(arma == rapida) {image = "armaRapida.png"}
		if(arma == peligrosa) {{image = "armaPeligrosa.png"}}
	}
}

const basica = new Arma(dano=0,velocidad=1000,image="basica.png")
const rapida = new Arma(dano=0,velocidad=500,image="basica.png")
const peligrosa = new Arma(dano=1,velocidad=1000,image="granBola.png") 


