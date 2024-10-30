class Nave{
  var velocidad
  var direccion
  var combustible

  method acelerar(cuanto){
    velocidad = 100000.min(velocidad + cuanto)
  }
  method desacelerar(cuanto){
    velocidad = 0.max(velocidad-cuanto)
  }
  method irHaciaElSol(){
    direccion=10
  }
  method escaparDelSol(){
    direccion = -10
  }
  method ponerseParaleloAlSol(){direccion = 0}
  method acercarseUnPocoAlSol(){
    direccion = 10.min(direccion+1)
  }
  method alejarseUnPocoDelSol(){
    direccion = -10.max(direccion-1)
  }
  method cargarCombustible(cantidad){
    combustible += cantidad
  }
  method descargarCombustible(cantidad){
    combustible = 0.max(combustible - cantidad)
  }
  method prepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.condicionAdicional()
  }
  method estaTranquila() = 
    combustible >= 4000 and velocidad <= 12000 and self.condicionAdicionalTanquilidad()
  
  method condicionAdicionalTanquilidad()

  method condicionAdicional()

  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()
  method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
  method tienePocaActividad()
}
class NaveBaliza inherits Nave{
  const property coloresValidos = #{"verde","rojo","azul"}
  var cambioDeColor = false
  var colorDeBaliza
  method cambiarColorBaliza(colorNuevo){
    if(!coloresValidos.contains(colorNuevo))
      self.error("el color es invalido")
    cambioDeColor = true
    colorDeBaliza = colorNuevo
  }
  override method condicionAdicional(){
    self.ponerseParaleloAlSol()
    self.cambiarColorBaliza("verde")
  }
  override method condicionAdicionalTanquilidad() = colorDeBaliza != "rojo"
  override method escapar(){
    self.irHaciaElSol()
  }
  override method avisar(){
    self.cambiarColorBaliza("rojo")
  }
  override method tienePocaActividad() = not cambioDeColor
}
class NavePasajeros inherits Nave{
  const cantidadPasajeros
  var racionesComida
  var racionesServidas
  var racionesBebida
  method descargarComida(cantidad){
    racionesComida = 0.max(racionesComida - cantidad)
    racionesServidas += cantidad
  }
  method cargarComida(cantidad){
    racionesComida += cantidad
  }
  method descargarBebida(cantidad){
    racionesBebida = 0.max(racionesBebida - cantidad)
  }
  method cargarBebida(cantidad){
    racionesBebida += cantidad
  }
  override method condicionAdicional(){
    self.cargarComida(cantidadPasajeros*4)
    self.cargarBebida(cantidadPasajeros*6)
    self.acercarseUnPocoAlSol()
  }
  override method condicionAdicionalTanquilidad() = true
  override method escapar(){
    self.acelerar(velocidad)
  }
  override method avisar(){
    self.descargarComida(cantidadPasajeros)
    self.descargarBebida(cantidadPasajeros*2)
  }
  override method tienePocaActividad() = racionesServidas < 50
}
class NaveCombate inherits Nave{
  var estaInvisible = false
  var misilesDesplegados = false
  const property mensajesEmitidos = []
  method estaInvisible() = estaInvisible
  method ponerseVisible() {
    estaInvisible = false
  }
  method ponerseInvisible(){
    estaInvisible = true
  }

  method misilesDesplegados() = misilesDesplegados
  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}

  method emitirMensaje(mensaje){
    mensajesEmitidos.add(mensaje)
  }
  method primerMensajeEmitido(){
    if(mensajesEmitidos.isEmpty())
      self.error("no se emitio ningun mensaje")
    mensajesEmitidos.first()
  }
  method ultimoMensajeEmitido(){
    if(mensajesEmitidos.isEmpty())
      self.error("no se emitio ningun mensaje")
    mensajesEmitidos.last()
  }
  method esEscueta() = mensajesEmitidos.all({m=> m.length()<=30})
  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
  override method condicionAdicional(){
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en mision")
  }
  override method condicionAdicionalTanquilidad() = not misilesDesplegados
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NavePasajeros{
  var tienePreparadoElQuirofano
  method prepararQuirofano(){
    tienePreparadoElQuirofano = true
  }
  method desprepararQuirofano(){
    tienePreparadoElQuirofano = false
  }
  override method condicionAdicionalTanquilidad() = not tienePreparadoElQuirofano
  override method recibirAmenaza(){
    super()
    self.prepararQuirofano()
  }
}
class NaveCombateSigilosa inherits NaveCombate{
  override method condicionAdicionalTanquilidad() = not estaInvisible
  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}