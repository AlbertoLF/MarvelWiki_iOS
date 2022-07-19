# Marvel Wiki iOS App

App para iphone donde se muestran los personajes de Marvel y el detalle de cada uno.

Se usarán datos extraídos de la API de Marvel https://developer.marvel.com/docs

## Possible Improvements

Manejo de errores más acertado en la capa de presentación (Más acorde a UX).

Manejo de la caché de sesión. Actualmente no se limpia hasta que el sistema cierra la app o se fuerza la salida.

Testeo de Repository. Aunque el repository mantiene lógica de negocio, ya que pertenece a la capa **domain**, este no se puede testear por estar acoplado al conector Alamofire

Soporte de DarkMode

Encriptar los secrets y tener un archivo seguro para claves sensibles.

---

## Technical

La App se ha desarrollado con una arquitectura que mezcla conceptos de VIPER con patrón Coordinator y Repository.

La capa de **presentación** está formada por ViewController, Presenter y Coordinator

La capa de **dominio** está formada por **Interactors**, que aglutina casos de usos de una misma "funcionalidad" y por **Repositories**, que se encargan de obtener los datos de distintas fuentes.

La capa de **Data** está formada por entidades y configuraciones para DataSources. Un cambio necesario sería hacer un conector de API para Alamofire que se pueda inyectar en los repositories, para así poder testear y no depender de implementaciones en la capa de dominio.

### Author: Alberto Luque Fernández