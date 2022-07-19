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

### Author: Alberto Luque Fernández