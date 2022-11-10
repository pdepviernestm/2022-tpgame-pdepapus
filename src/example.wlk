import wollok.game.*

object juego {
	const musica = game.sound("principal.mp3")
	method titulo() {
		game.width(15)
		game.height(15)
		game.boardGround("fondo.png")
		game.title("Space Invaders")
		game.addVisual(inicio)
		keyboard.enter().onPressDo{self.iniciar()}
		game.start()
	}
	method iniciar() {
		musica.shouldLoop(true)
		musica.play()
		game.removeVisual(inicio)
		keyboard.a().onPressDo{nave.izquierda()}
    	keyboard.d().onPressDo{nave.derecha()}
   		keyboard.space().onPressDo{nave.disparar()}
		game.addVisualCharacter(nave)
		vidas.aparecer()
		invasores.aparecer()
	}
	method reiniciar(objeto,puntos) {
		game.sound("win.mp3").stop()
		musica.resume()
		game.removeVisual(objeto)
		nave.reinicio(puntos)
		vidas.aparecer()
		invasores.aparecer()
	}
	method ganar() {
		musica.pause()
		game.sound("win.mp3").play()
		game.removeVisual(nave)
		game.removeVisual(vidas)
		game.removeVisual(explosion)
		invasores.fin()
		puntajeGanador.aparecer()
		keyboard.r().onPressDo({self.reiniciar(puntajeGanador,nave.puntaje())})
	}
	method perder() {
		invasores.fin()
		puntajePerdedor.aparecer()	
		musica.pause()
		game.sound("game-over.mp3").play()
		game.removeVisual(nave)
		game.removeVisual(explosion)				
	}
}


object inicio {
	var property position = game.at(4,5)
	method image() = "titulo.png"
}
object puntajeGanador{
	method position() = game.at(6,6)
	method image() = "navePrincipal.png"
	method aparecer () {
		game.addVisual(self)	
		game.schedule(2000,{game.say(self,"Precione R para reitentar.")})
		game.schedule(2000,{game.say(self,"Ganaste.Tu puntaje actual es de:")})
		game.schedule(2000,{game.say(self,nave.puntaje().toString())})					
		}
}	
object puntajePerdedor{
	method position() = game.at(6,6)
	method image() = "invaderBasic.png"
	method aparecer () {
		game.addVisual(self)
		game.schedule(2000,{game.say(self,"Perdiste.Tu puntaje fue de: ")})	
		game.schedule(2000,{game.say(self,nave.puntaje().toString())})			
	}	
}

object invasores {
	var listaInvasores = []
	method aparecer() {
		const inv1 = new Invasores(arma=armaEnemiga,position=game.at(4,8),valor=10,image="invaderBasic.png",constanciaDisparo = 5000)
		const inv2 = new Invasores(arma=armaEnemiga,position=game.at(6,8),valor=10,image="invaderBasic.png",constanciaDisparo = 1000)
		const inv3 = new Invasores(arma=armaEnemiga,position=game.at(8,8),valor=10,image="invaderBasic.png",constanciaDisparo = 3000)
		const inv4 = new Invasores(arma=armaEnemiga,position=game.at(10,8),valor=20,image="invaderBasic.png",constanciaDisparo = 500)
		
		const inv5 = new Invasores(arma=armaLenta,position=game.at(5,11),valor=20,image="invaderMid.png",constanciaDisparo = 1000)
		const inv6 = new Invasores(arma=armaLenta,position=game.at(7,11),valor=20,image="invaderMid.png",constanciaDisparo = 6000)
		const inv7 = new Invasores(arma=armaLenta,position=game.at(9,11),valor=20,image="invaderMid.png",constanciaDisparo = 2000)
		const inv8 = new Invasores(arma=armaLenta,position=game.at(11,11),valor=20,image="invaderMid.png",constanciaDisparo = 650)
		
		const inv9 = new Invasores(arma=armaRapida,position=game.at(4,14),valor=30,image="invaderAlfa.png",constanciaDisparo = 5000)
		const inv10 = new Invasores(arma=armaRapida,position=game.at(6,14),valor=30,image="invaderAlfa.png",constanciaDisparo = 700)
		const inv11 = new Invasores(arma=armaRapida,position=game.at(8,14),valor=30,image="invaderAlfa.png",constanciaDisparo = 2000)
		const inv12 = new Invasores(arma=armaRapida,position=game.at(10,14),valor=30,image="invaderAlfa.png",constanciaDisparo = 3000)		
		listaInvasores = [inv1,inv2,inv3,inv4,inv5,inv6,inv7,inv8,inv9,inv10,inv11,inv12]
		listaInvasores.forEach({invasor => invasor.iniciar()})
	}
	method fin() {
		listaInvasores.forEach({invasor => game.removeVisual(invasor)
		game.removeTickEvent("disparar")
		game.removeTickEvent("movimientoNormal")})
	}
	method invasorDestruido(invasor) {
		game.removeVisual(invasor)
		game.removeTickEvent("disparar")
		listaInvasores.remove(invasor)
		if(listaInvasores.size() == 0) {
			juego.ganar()
		}
	}
}

class Naves { 
	var arma	
	var property position 
	var image
	method image() = image
}

class Invasores inherits Naves {
	var valor
	var constanciaDisparo
	var lado = true
	method valor() {return valor}
	method chocoEnemigo(aliado) {}
	method chocoTiro(tiro) {}
	method iniciar() {
		game.addVisual(self)
		game.whenCollideDo(self,{elemento => elemento.chocoEnemigo(self)})
		game.onTick(1000,"movimientoNormal",{self.moverse()})
		game.onTick(constanciaDisparo,"disparar",{self.disparar()})
	}
	
	method perderVida() {
		invasores.invasorDestruido(self)
		nave.ganarPuntos(valor)
		game.say(nave,self.valor().toString())
	}
	method moverse() {
		if(lado) {
			if(position.x() + 1 > 14) {
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
	method disparar() {
		const tiro = new TiroEnemigo(position = game.at(position.x(),position.y() - 1),image= arma.image())
		game.addVisual(tiro)
		game.onTick(arma.velocidad(),"moverse",{tiro.bajar()})	
		game.whenCollideDo(tiro,{elemento => 
			elemento.chocoTiro(tiro)
		})	
	}
}

object nave inherits Naves(arma = basica,position = game.at(6,0),image="navePrincipal.png") {
	var puntos = 0
	var vida = 3
	method puntaje() {return puntos}
	method reinicio(puntaje) {
		position = game.at(7,0)
		vida = 3
		vidas.cambiarVida(vida)
		self.iniciar()
		puntos = puntaje
	}
	method iniciar() {	
		game.addVisual(self)	
		}
	method perderVida() {
		vida -=1
		vidas.cambiarVida(vida)
	}
	method izquierda() {
		if((position.x() - 1) < 0) {
			self.bloquear()
		}
		else {
			position = position.left(1)
		}
	}
	method derecha() {
		if((position.x() + 1) > 14) {
			self.bloquear()
		}
		else {
			position = position.right(1)	
		}
	}
	method bloquear() {
		position = game.at(position.x(),0)
	}
	method disparar() {
		const tiroAliado = new Tiro(position = game.at(position.x(),position.y() + 1),image= arma.image())
		game.onTick(arma.velocidad(),"subirDisparo",{tiroAliado.subir()})
		game.addVisual(tiroAliado)
	}
	method ganarPuntos(valor)
	{
		puntos += valor
	}
	method chocoEnemigo(invasor) {
		juego.perder()
	}
	method chocoTiro(tiro) {
		position = game.at(7,0)
		self.perderVida()
		tiro.colicion()
	}
}

class Tiro {
	var property position
	var image
	method image() = image
	method conquistar(){}
	method subir() {
		if(position.y() + 1 > 15) {
			game.removeVisual(self)
			game.removeTickEvent("subirDisparo")
		}
		else {
			position = position.up(1)
		}
	}
	method chocoTiro(tiro) {tiro.colicion()}
	method chocoEnemigo(invasor) {
		game.removeVisual(self)
		game.removeTickEvent("subirDisparo")
		game.schedule(100,{explosion.aparecer(position.x(),position.y())})
		invasor.perderVida()
	}
}

class TiroEnemigo inherits Tiro {
	method bajar() {
		if(position.y() - 1  < 0) {
			game.removeVisual(self)		}
		else {
			position = position.down(1)
		}
	}
	 	method colicion() {
		game.removeVisual(self)
		game.removeTickEvent("moverse")
	}
	override method chocoEnemigo(invasor) {}
}

class Arma {
	const velocidad
	const image
	method image() = image
	method velocidad() {return velocidad}  
}

const basica = new Arma(velocidad=100,image="armaBasica.png")
const armaEnemiga = new Arma(velocidad=200,image="armaEnemiga.png")
const armaLenta = new Arma(velocidad=500,image="armaEnemiga.png")
const armaRapida = new Arma(velocidad=100,image="armaEnemiga.png")

object explosion {
	var property position
	method image() = "explocion.png"
	method chocoEnemigo(nave) {}
	method chocoTiro() {}
	method aparecer(x,y) {
		position = game.at(x,y)
		game.addVisual(self)
	}
}

object vidas {
	const property position = game.at(0,13)
	var image = "fullVida.png"
	method image() = image
	method aparecer() {game.addVisual(self)}
	method chocoEnemigo(elemento) {}
	method chocoTiro(elemento) {}
	method cambiarVida(vida) {
		if(vida == 3) {image = "fullVida.png"}
		if(vida == 2) {image = "2vidas.png"}
		if(vida == 1) {image = "1vida.png"}
		if(vida == 0) {
			game.removeVisual(self)
			juego.perder()
		}	
	}
}