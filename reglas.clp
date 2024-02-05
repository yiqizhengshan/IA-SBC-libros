;; VARIABLES GLOBALES
(defglobal ?*libros* = (create$ ""))
(defglobal ?*copia_libros* = (create$ "")) ;; en caso de que llegue alguna regla 
(defglobal ?*rango_edad* = (create$))
(defglobal ?*subgeneros_estado_animico* = (create$))
(defglobal ?*habito_de_lectura* = (create$))
(defglobal ?*nivel_de_lectura* = (create$))
(defglobal ?*formato_lectura* = (create$))
(defglobal ?*datos_utilizados* = (create$))

;; MODULOS
(defmodule MAIN (export ?ALL))

;; Recoge los datos del lector (problema concreto)
(defmodule RECOGER_DATOS
   (import MAIN ?ALL)
   (export ?ALL)
)

;; Transforma el problema concreto en problema abstracto
(defmodule ABSTRAER_DATOS
   (import MAIN ?ALL)
   (import RECOGER_DATOS ?ALL)
   (export ?ALL)
)

;; Genera los libros a recomendar
(defmodule PROCESAR_DATOS
   (import MAIN ?ALL)
   (import RECOGER_DATOS ?ALL)
   (import ABSTRAER_DATOS ?ALL)
   (export ?ALL)
)

;; Muestra los libros recomendados
(defmodule MOSTRAR_LIBROS
   (import MAIN ?ALL)
   (import RECOGER_DATOS ?ALL)
   (import ABSTRAER_DATOS ?ALL)
   (import PROCESAR_DATOS ?ALL)
   (export ?ALL)
)

;; MODULO MAIN
(defrule MAIN::iniciar "Iniciar"
   (declare (salience 10))
   =>
   (make-instance Usuario of Lector)
   (printout t "-*-*-*-*-*-*-* Bienvenido al recomendador de libros! -*-*-*-*-*-*-*" crlf)
   (focus RECOGER_DATOS)
)

;; --------------------- MODULO RECOGER_DATOS ---------------------
(defrule RECOGER_DATOS::recoger_nombre "Recoger el nombre del usuario"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?respuesta (pregunta_general "¿Cómo te llamas?"))
    (assert (nombre ?respuesta))
)

(defrule RECOGER_DATOS::recoger_subgeneros_favoritos "Recoger los subgeneros preferidos del lector"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Hay algun genero literario que te interese?"))
    (if ?quiere_responder
        then
        (bind ?generos_posibles (create$ narrativa policiaca terror fantasia romantica historica ciencia_ficcion aventura))
        (bind ?respuesta (pregunta_multiple "¿Que genero/s literario/s te interesan?" ?generos_posibles))
        (send ?lector put-subgeneros_preferidos ?respuesta)
        (assert (filtra_subgenero))
        else (assert (pregunta_estado_animico)) 
    )
)

(defrule RECOGER_DATOS::recoger_epocas_favoritas "Recoger las epocas favoritas del lector"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Hay alguna epoca sobre la que te gustaria leer?"))
    (if ?quiere_responder
        then
        (bind ?epocas_posibles (create$ prehistoria edad_antigua edad_media edad_moderna edad_contemporanea))
        (bind ?respuesta (pregunta_multiple "¿Que epocas te interesan?" ?epocas_posibles))
        (send ?lector put-epocas_preferidas ?respuesta)
        (assert (filtra_epoca))
    )
)

(defrule RECOGER_DATOS::recoger_idiomas "Recoger los idiomas en los que quiere leer el lector"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Hay algun idioma en especifico que quieras?"))
    (if ?quiere_responder
        then
        (bind ?idiomas_posibles (create$ universal castellano ingles frances aleman chino))
        (bind ?respuesta (pregunta_multiple "¿Que idiomas te interesan?" ?idiomas_posibles))
        (send ?lector put-idiomas_preferidos ?respuesta)
        (assert (filtra_idioma))
    )
)

(defrule RECOGER_DATOS::recoger_autor_favorito "Recoger el autor favorito"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Tienes autor favorito?"))
    (if ?quiere_responder
        then
        (bind ?respuesta (pregunta_general "¿Cual es tu autor favorito? (Introduce el nombre entre comillas)"))
        (send ?lector put-autor_favorito ?respuesta)
        (assert (filtra_autor))
    )
)

(defrule RECOGER_DATOS::recoger_edad_usuario "Recoger la edad del usuario"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?respuesta (pregunta_numerica "¿Cual es tu edad? " 5 100))
    (send ?lector put-edad ?respuesta)
)

(defrule RECOGER_DATOS::recoger_estado_animico "Recoger el estado animico del usuario"
    ?hecho <- (pregunta_estado_animico)
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Quieres que el libro te haga sentir relajado, intrigado, emocionado o reflexivo?"))
    (if ?quiere_responder
        then
        (bind ?estados_animicos_posibles (create$ relajado intrigado emocionado reflexivo))
        (bind ?respuesta (pregunta_simple "Indique la opcion escogida por favor: " ?estados_animicos_posibles))
        (send ?lector put-estado_animico_deseado ?respuesta)
        (assert (recoger_estado_animo))
    )
    (retract ?hecho)
)

(defrule RECOGER_DATOS::recoger_horas_lectura_semanales "Recoger las horas de lectura semanales"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?respuesta (pregunta_numerica "¿Aproximadamente cuántas horas lees a la semana? " 0 168))
    (send ?lector put-horas_lectura_semanales ?respuesta)
)

(defrule RECOGER_DATOS::recoger_formatos_favoritos "Recoger los formatos de libro favoritos"
    ?lector <- (object (is-a Lector))
    =>
    (bind ?quiere_responder (pregunta_si_o_no "¿Tienes algun formato de libro favorito?"))
    (if ?quiere_responder
        then
        (bind ?formatos_posibles (create$ formato_digital texto audiolibro texto_imagenes))
        (bind ?respuesta (pregunta_multiple "¿Que formatos te interesan?" ?formatos_posibles))
        (send ?lector put-formatos_preferidos ?respuesta)
        (assert (filtra_formato))
        
        else (assert (pregunta_lugar_lectura))
    )
)

(defrule RECOGER_DATOS::recoger_lugar_lectura "Recoger los formatos de libro favoritos"
    ?hecho <- (pregunta_lugar_lectura)
    ?lector <- (object (is-a Lector))
    =>
    (bind ?lugares_posibles (create$ metro casa cafeteria naturaleza avion biblioteca autobus))
    (bind ?respuesta (pregunta_simple "¿En que lugares vas a leer?" ?lugares_posibles))
    (send ?lector put-lugar_lectura ?respuesta)
    (retract ?hecho)
    (assert (recoger_lugar))
)


(defrule RECOGER_DATOS::finalizar_recogida "Finaliza la recogida de informacion"
   (declare (salience -10))
   =>
   (printout t "Procesando los datos obtenidos..." crlf)
   (focus ABSTRAER_DATOS)
)

;; --------------------- MODULO ABSTRAER_DATOS ---------------------
(defrule ABSTRAER_DATOS::abstraccion_edad_lector "ira relacionado con publico_dirigido"
    ?lector <- (object(is-a Lector))
    =>
    (bind ?edad_lector (send ?lector get-edad))
    (if (<= ?edad_lector 12) then (bind ?*rango_edad* "infantil")
     else (if (<= ?edad_lector 18) then (bind ?*rango_edad* "adolescente")
           else (if (<= ?edad_lector 50) then (bind ?*rango_edad* "adulto")
                 else  (bind ?*rango_edad* "experimentado")
                )
           )
    )
    (assert (abstraccion_edad))
)

(defrule ABSTRAER_DATOS::abstraccion_lugar_lectura " "
    ?hecho <- (recoger_lugar)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?lugar_lector (str-cat (send ?lector get-lugar_lectura)))
    (if (eq ?lugar_lector "metro") then (bind ?*formato_lectura* "audiolibro" "formato_digital")
     else (if (eq ?lugar_lector "casa") then (bind ?*formato_lectura* "texto")
           else (if (eq ?lugar_lector "cafeteria") then (bind ?*formato_lectura* "texto" "texto_imagenes") ;;en una cafeteria hay ruido y las imagenes ayudan
                 else (if (eq ?lugar_lector "naturaleza") then (bind ?*formato_lectura* "texto" "formato_digital") ;;digital para que no se moje el papel del libro
                       else (if (eq ?lugar_lector "avion") then (bind ?*formato_lectura* "audiolibro") ;; vas apretado y es mejor escuchar ya que no peudes tener una postura de lectura comoda
                             else (if (eq ?lugar_lector "biblioteca") then (bind ?*formato_lectura* "texto")
                                   else (bind ?*formato_lectura* "audiolibro" "formato_digital") ;;autobus
                             )
                       )
                 )
           )
     )
    )
    (printout t ?*formato_lectura* crlf)
    (retract ?hecho)
    (assert (abstraccion_lugar_lectura))
)

(defrule ABSTRAER_DATOS::abstraccion_habito_lectura "Obtener habito lectura a partir de horas semanales de lectura"
    ?lector <- (object(is-a Lector))
    =>
    (bind ?horas_lectura_semanales (send ?lector get-horas_lectura_semanales))
    (if (<= ?horas_lectura_semanales 1)
        then (bind ?*habito_de_lectura* "principiante")
    else
        (if (<= ?horas_lectura_semanales 4)
            then (bind ?*habito_de_lectura* "intermedio")
        else
            (bind ?*habito_de_lectura* "avanzado")
        )
    )
    (assert (abstraccion_habito_de_lectura))
)

(defrule ABSTRAER_DATOS::abstraccion_nivel_lectura "Obtener nivel de lectura a partir habito de lectura y edad"
    ?lector <- (object(is-a Lector))
    (abstraccion_edad)
    (abstraccion_habito_de_lectura)
    =>
    (if (eq ?*habito_de_lectura* "avanzado")
        then (bind ?*nivel_de_lectura* "avanzado")
    else
        (if (or (eq ?*habito_de_lectura* "intermedio") (or (eq ?*rango_edad* "adulto") (eq ?*rango_edad* "experimentado")))
            then (bind ?*nivel_de_lectura* "intermedio")
        else
            (bind ?*nivel_de_lectura* "principiante")
        )
    )
    (assert (abstraccion_edad))
)

(defrule ABSTRAER_DATOS:abstraccion_estado_animico "ira relacionado con subgenero"
    ?hecho <- (recoger_estado_animo)
    ?lector <- (object(is-a Lector))
    =>

    (bind ?estado_animico_lector (str-cat (send ?lector get-estado_animico_deseado)))
    (switch ?estado_animico_lector
        (case "relajado" then
            (bind ?*subgeneros_estado_animico* "narrativa" "historica")
        )
        (case "intrigado" then
            (bind ?*subgeneros_estado_animico* "policiaca" "aventura" "ciencia_ficcion")
        )
        (case "emocionado" then
            (bind ?*subgeneros_estado_animico* "romantica" "fantasia" "aventura")
        )
        (case "reflexivo" then
            (bind ?*subgeneros_estado_animico* "historica" "terror" "policiaca")
        )
        (default (bind ?*subgeneros_estado_animico* "narrativa" "historica" "policiaca" "aventura" "ciencia_ficcion" "terror"))
    )
    (assert (abstraccion_estado_animo))
    (retract ?hecho)
)

(defrule ABSTRAER_DATOS::finalizar_abstraccion ""
    (declare (salience -10))
    ?lector <- (object(is-a Lector))
    =>
    (focus PROCESAR_DATOS)
)

;; --------------------- MODULO PROCESAR_DATOS ---------------------
(defrule PROCESAR_DATOS::inicializar ""
    (declare (salience 10))
    ?lector <- (object(is-a Lector))
    =>
    (bind ?*libros* (find-all-instances ((?inst Novela)) (eq ?inst:titulo ?inst:titulo)))
    (bind ?*copia_libros* ?*libros*)
)

(defrule PROCESAR_DATOS::filtrar_genero "Filtrar los libros por genero"
    ?hecho <- (filtra_subgenero)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    
    (bind ?generos_escogidos (send ?lector get-subgeneros_preferidos))
    
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_subgeneros (send ?libro_nth get-subgenero))
        (if (tienen_elemento_en_comun ?generos_escogidos ?var_subgeneros)
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )   
    (bind ?*libros* ?aux)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*) 
        (bind ?dato "subgeneros")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

(defrule PROCESAR_DATOS::filtrar_autor "Filtrar los libros por autor"
    ?hecho <- (filtra_autor)
    ?lector <- (object(is-a Lector))
    =>
     (bind ?autor_escogido (str-cat(send ?lector get-autor_favorito)))
     
     ;;Buscamos la instancia de Escritor cuyo nombre es ?autor_escogido
     (bind ?instancia_autor_escogido (find-instance ((?inst Escritor)) (eq ?autor_escogido ?inst:nombre)))

     (if (= (length$ ?instancia_autor_escogido) 0)
          then (printout t "No existe ese autor en la base de datos" crlf)
          else
            (bind ?i 1)
            (bind ?aux (create$))
            (while (<= ?i (length$ ?*libros*)) do
               (bind ?libro_nth (nth$ ?i ?*libros*))
               (bind ?autor_libro (send ?libro_nth get-escrito_por)) 
               (if (eq ?autor_escogido (send ?autor_libro get-nombre))
                   then (bind ?aux (create$ ?aux ?libro_nth)))
               (bind ?i (+ ?i 1))
            )   
            (bind ?*libros* ?aux)
     )

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*)
        (bind ?dato "autor")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

(defrule PROCESAR_DATOS::filtrar_publico_dirigido "Filtrar los libros por publico_dirigido"
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_publico_dirigido (send ?libro_nth get-publico_dirigido)) 
        (if (or (member$ ?*rango_edad* ?var_publico_dirigido) (member$ "para_todos" ?var_publico_dirigido))
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )   
    (bind ?*libros* ?aux)
    ;(printout t ?*libros* crlf)
    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*)
        (bind ?dato "edad -> publico dirigido")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
)

(defrule PROCESAR_DATOS::filtrar_estado_animico "Filtrar los libros por estado animico deseado"
    ?hecho <- (abstraccion_estado_animo)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_subgeneros (send ?libro_nth get-subgenero))
        (if (tienen_elemento_en_comun ?*subgeneros_estado_animico* ?var_subgeneros)
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )

    (bind ?*libros* ?aux)
    ;(printout t ?*libros* crlf)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*)
        (bind ?dato "estados animicos -> subgeneros")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

(defrule PROCESAR_DATOS::filtrar_extension "Filtrar los libros por extension relacionado con nivel de lectura"
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    (switch ?*nivel_de_lectura*
        (case "principiante" then
            (bind ?extension_deseada "corta")
        )
        (case "intermedio" then
            (bind ?extension_deseada "media")
        )
        (case "avanzado" then (bind ?extension_deseada "larga"))
        (default (bind ?extension_deseada "larga"))
    )

    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_extension (send ?libro_nth get-extension)) 
        (if (eq ?extension_deseada ?var_extension)
            then (bind ?aux (create$ ?aux ?libro_nth))
        )
        (bind ?i (+ ?i 1))
    ) 
    (bind ?*libros* ?aux)
    ;;(printout t ?*libros* crlf)
    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then
        (bind ?*copia_libros* ?*libros*)
        (bind ?dato "edad y horas de lectura semanales -> extension")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
)

(defrule PROCESAR_DATOS::filtrar_epoca "Filtrar los libros por epoca"
    ?hecho <- (filtra_epoca)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    (bind ?epocas_escogidas (send ?lector get-epocas_preferidas))
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))   
        (bind ?var_epoca (send ?libro_nth get-epoca))

        (bind ?j 1)
        (while (<= ?j (length$ ?epocas_escogidas)) do
            (bind ?epoca_nth (nth$ ?j ?epocas_escogidas))
            (if (eq (str-cat ?epoca_nth) (str-cat ?var_epoca))
                then (bind ?aux (create$ ?aux ?libro_nth))
            )
            (bind ?j (+ ?j 1))
        )
        (bind ?i (+ ?i 1))        
    )   
    (bind ?*libros* ?aux)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*)
        (bind ?dato "epocas")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

(defrule PROCESAR_DATOS::filtrar_idioma "Filtrar los libros por idioma"
    ?hecho <- (filtra_idioma)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    
    (bind ?idiomas_escogidos (send ?lector get-idiomas_preferidos))
    
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_idiomas (send ?libro_nth get-idiomas))
        (if (tienen_elemento_en_comun ?idiomas_escogidos ?var_idiomas)
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )   
    (bind ?*libros* ?aux)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*) 
        (bind ?dato "idiomas")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

;;1 => muchos
(defrule PROCESAR_DATOS::filtrar_formato "Filtrar los libros por formato"
    ?hecho <- (filtra_formato)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    
    (bind ?formatos_escogidos (send ?lector get-formatos_preferidos))
    
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_formatos (send ?libro_nth get-formato_libro))
        (if (tienen_elemento_en_comun ?formatos_escogidos ?var_formatos)
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )   
    (bind ?*libros* ?aux)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*) 
        (bind ?dato "formato")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

;;muchos formatos => muchosformato
(defrule PROCESAR_DATOS::filtrar_lugar_lectura "Filtrar los libros por lugar de lectura"
    ?hecho <- (abstraccion_lugar_lectura)
    ?lector <- (object(is-a Lector))
    =>
    (bind ?i 1)
    (bind ?aux (create$))
    
    (while (<= ?i (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_formatos (send ?libro_nth get-formato_libro))
        (if (member$ ?*formato_lectura* ?var_formatos)
            then (bind ?aux (create$ ?aux ?libro_nth)))
        (bind ?i (+ ?i 1))
    )

    (bind ?*libros* ?aux)
    ;(printout t ?*libros* crlf)

    ;; Si libros se queda en 0, no modificar copia_libros
    (if (not (= (length$ ?*libros*) 0)) 
        then (bind ?*copia_libros* ?*libros*) 
        (bind ?dato "lugar de lectura -> formato")
        (bind ?*datos_utilizados* (create$ ?*datos_utilizados* ?dato))
    )
    (retract ?hecho)
)

(defrule PROCESAR_DATOS::finalizar_procesamiento "Funcion que finaliza el procesado"
    (declare (salience -10))
    ?lector <- (object(is-a Lector))
    =>
    (if (= (length$ ?*libros*) 0) 
        then (bind ?*libros* ?*copia_libros*) 
    )
    (focus MOSTRAR_LIBROS)
)

(defrule MOSTRAR_LIBROS::mostrar_libros "Funcion que muestra los libros recomendados"
    ?lector <- (object(is-a Lector))
    ?fact <- (nombre ?value)
    =>
    (bind ?i 1)
    (bind ?aux (create$))

    ;; Obtenemos los libros con más valoración
    (while (and (<= ?i (length$ ?*libros*)) (< (length$ ?aux) 3)) do
        (bind ?libro_nth (nth$ ?i ?*libros*))
        (bind ?var_valoracion (send ?libro_nth get-valoracion))
        (if (eq ?var_valoracion "excelente")
            then (bind ?aux (create$ ?aux ?libro_nth))
        )

        (bind ?i (+ ?i 1))
    )
        
    (bind ?j 1)
    (while (and (<= ?j (length$ ?*libros*)) (< (length$ ?aux) 3)) do
        (bind ?libro_nth (nth$ ?j ?*libros*))
        (bind ?var_valoracion (send ?libro_nth get-valoracion))
        (if (eq ?var_valoracion "buena")
            then (bind ?aux (create$ ?aux ?libro_nth))
        )

        (bind ?j (+ ?j 1))
    )

    (bind ?k 1)
    (while (and (<= ?k (length$ ?*libros*)) (< (length$ ?aux) 3)) do
        (bind ?libro_nth (nth$ ?k ?*libros*))
        (bind ?var_valoracion (send ?libro_nth get-valoracion))
        (if (eq ?var_valoracion "regular")
            then (bind ?aux (create$ ?aux ?libro_nth))
        )

        (bind ?k (+ ?k 1))
    )

    (bind ?z 1)
    (while (and (<= ?z (length$ ?*libros*)) (< (length$ ?aux) 3)) do
        (bind ?libro_nth (nth$ ?z ?*libros*))
        (bind ?var_valoracion (send ?libro_nth get-valoracion))
        (if (eq ?var_valoracion "deficiente")
            then (bind ?aux (create$ ?aux ?libro_nth))
        )

        (bind ?z (+ ?z 1))
    )

    (bind ?*libros* ?aux)

    (printout t crlf ?value ", estos son los libros que te recomendamos:" crlf)
    (printout t (implode$ ?*libros*) crlf crlf)
    (bind ?k 1)

    ;; Imprimimos la informacion de cada libro recomendado
    (while (<= ?k (length$ ?*libros*)) do
        (bind ?libro_nth (nth$ ?k ?*libros*))
        (imprimir_libro ?libro_nth)
        (bind ?k (+ ?k 1))
    )

    ;; Imprimimos los datos utilizados para la recomendacion
    (printout t "Se han elegido estos libros ya que son los que más se adecúan a tu perfil." crlf)
    (printout t "Concretamente, hemos utilizado estos datos:" crlf)
    (progn$
        (?dato ?*datos_utilizados*)
        (printout t " - " ?dato crlf)
        (bind ?k (+ ?k 1))
    )
)