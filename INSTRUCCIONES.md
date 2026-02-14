# Instrucciones para Conectar dos Dispositivos

## Sistema Arreglado

He arreglado el sistema de pairing (emparejamiento) para que funcione correctamente. Los cambios incluyen:

1. El PIN ahora se guarda correctamente en la base de datos cuando se genera
2. El sistema de invitaciones funciona sin necesitar autenticación
3. Los dos dispositivos pueden conectarse usando un código PIN de 8 dígitos
4. Las fotos pueden subirse usando enlaces de iCloud o cualquier URL pública

## Cómo Conectar Dos Dispositivos

### Dispositivo 1 (Persona que genera el PIN):

1. Abre la aplicación
2. Verás una pantalla con dos opciones: "Generate PIN" y "Enter PIN"
3. Haz clic en "Generate PIN"
4. Se generará un código PIN de 8 dígitos
5. Comparte este PIN con tu pareja (puedes copiarlo usando el botón "Copy PIN")
6. El PIN expira en 5 minutos, así que compártelo rápidamente

### Dispositivo 2 (Persona que ingresa el PIN):

1. Abre la aplicación en otro dispositivo o navegador
2. Verás la misma pantalla con dos opciones
3. Haz clic en "Enter PIN"
4. Ingresa el código PIN de 8 dígitos que recibiste
5. Haz clic en "Connect"
6. ¡Ahora están conectados como pareja!

## Cómo Subir Fotos

### Usando Enlaces de iCloud:

1. Abre la foto en iCloud Photos o en tu iPhone
2. Toca el botón de compartir
3. Selecciona "Copiar enlace de iCloud" o "Compartir enlace"
4. En la app, haz clic en el botón "+" (parte inferior derecha)
5. Pega el enlace en el campo "Enlace de Foto"
6. Completa los demás campos (título, fecha, categoría, descripción)
7. Haz clic en "Create Memory"

### Usando Otros Enlaces:

También puedes usar enlaces de:
- Google Photos (asegúrate que el enlace sea público)
- Dropbox
- Google Drive (con permisos públicos)
- Cualquier URL de imagen pública

## Características Disponibles

1. **Vista de Libro (Book)**: Ver todas tus memorias como tarjetas
   - Buscar por título o descripción
   - Filtrar por categoría
   - Ver solo favoritos
   - Editar o eliminar memorias

2. **Vista de Calendario (Calendar)**: Ver memorias organizadas por fecha
   - Navegar por meses
   - Ver qué días tienen memorias
   - Ver detalles de cada memoria

3. **Configuración (Settings)**:
   - Cambiar el nombre de la pareja
   - Establecer fecha de aniversario

## Notas Importantes

- Cada dispositivo tiene un ID único que se guarda en localStorage
- Si borras los datos del navegador, perderás la conexión y tendrás que volver a emparejar
- Los PINs expiran después de 5 minutos por seguridad
- Ambos usuarios pueden crear, editar y eliminar memorias
- Las memorias son compartidas entre los dos dispositivos

## Solución de Problemas

Si no puedes conectarte:
1. Verifica que el PIN no haya expirado (5 minutos máximo)
2. Asegúrate de no estar usando el mismo dispositivo/navegador
3. Verifica que tengas conexión a internet
4. Intenta generar un nuevo PIN

Si las fotos no se cargan:
1. Verifica que el enlace sea público y accesible
2. Para iCloud, asegúrate de tener activado "Compartir enlace de iCloud"
3. Prueba abriendo el enlace en una pestaña privada para verificar que sea público
4. Si el enlace funciona pero no se muestra la vista previa, la foto se guardará correctamente de todas formas
