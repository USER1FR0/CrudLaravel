--Funcion para crear una nueva tarea, estado por defecto false
-- Function: public.spi_tarea_create(text, text, date)

CREATE OR REPLACE FUNCTION public.spi_tarea_create(
    T_Titulo TEXT,
    T_Descripcion TEXT,
    T_FechaEntrega DATE
)
RETURNS text[]
LANGUAGE 'plpgsql'
COST 100
VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_retorno text[];
BEGIN

    v_retorno[1] := '0';
    v_retorno[2] := 'Se creo correctamente la tarea.';
    v_retorno[3] := '0';

    INSERT INTO tarea("Titulo", "Descripcion", "FechaEntrega", "Estado")
	VALUES (T_Titulo, T_Descripcion, T_FechaEntrega, false);

    RETURN v_retorno;

EXCEPTION
    WHEN OTHERS THEN
        v_retorno[1] := '1';
        v_retorno[2] := 'Error al insertar tarea: ' || SQLERRM;
        v_retorno[3] := '-1';
        RETURN v_retorno;
END;
$BODY$;

ALTER FUNCTION public.spi_tarea_create(TEXT, TEXT, DATE)
OWNER TO postgres;

SELECT * FROM spi_tarea_create(
    'Tarea de ejemplo',
    'Esta es una descripción de prueba',
    '2025-06-10'
);

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'tarea';

SELECT * FROM public.tarea;


-- Funcion que marca una tarea como completada.
-- Function: public.spu_tarea_completed(id)
CREATE OR REPLACE FUNCTION public.spu_tarea_completed(
	t_tarea_id integer
	)
    RETURNS text[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	v_retorno TEXT[];
BEGIN
	UPDATE public.tarea
	SET "Estado" = true
	WHERE id=t_tarea_id;

	IF FOUND THEN
		v_retorno[1] := '0';
		v_retorno[2] := 'Tarea marcada como completada';
		v_retorno[3] := '0';
	ELSE
		v_retorno[1] := '1';
		v_retorno[2] := 'No se encontró la tarea.';
		v_retorno[3] := '-1';
	END IF;

	RETURN v_retorno;

EXCEPTION
	WHEN OTHERS THEN
		v_retorno[1] := '1';
		v_retorno[2] := 'Error al actualizar tarea: ' || SQLERRM;
		v_retorno[3] := '-1';
		RETURN v_retorno;
	
END;
$BODY$;

ALTER FUNCTION public.spu_tarea_completed(integer)
	OWNER TO postgres;

-- Prueba Marcar Como Completada.
SELECT * FROM spu_tarea_completed(2);

-- Funcion para actualizar una tarea.(Excepto el estado).
-- Function: public.spu_tarea(Integer,Text, Text, Date).

CREATE OR REPLACE FUNCTION public.spu_tarea_updated(
	t_tarea_id INTEGER,
	t_Titulo TEXT,
	t_Descripcion TEXT,
	t_FechaEntrega DATE)
	RETURNS void
	LANGUAGE plpgsql
	COST 100
	VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	UPDATE public.tarea
	SET "Titulo"=t_Titulo, "Descripcion"=t_Descripcion,"FechaEntrega"=t_FechaEntrega
	WHERE id=t_tarea_id;

	RETURN;
END;
$BODY$;

ALTER FUNCTION public.spu_tarea_updated(INTEGER,TEXT,TEXT,DATE)
	OWNER TO postgres;
	
-- Test de actualizar tarea 
SELECT public.spu_tarea_updated(2, 'Tarea actualizada', 'Nueva descripción', '2025-06-30');

-- Funcion para eliminar cualquier tarea mediante el id
-- Function: public.spd_eliminar_tarea(integer);

CREATE OR REPLACE FUNCTION public.spd_eliminar_tarea(
		t_id integer
	)
	RETURNS void
	LANGUAGE plpgsql
	COST 100
	VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	DELETE FROM tarea
	WHERE id = t_id;

	RETURN;

END;
$BODY$;

ALTER FUNCTION public.spd_eliminar_tarea(integer)
OWNER TO postgres;

SELECT * FROM public.tarea;

SELECT * FROM spd_eliminar_tarea(3);

-- FUNCTION: public.sps_tarea_all()
CREATE OR REPLACE FUNCTION public.sps_tarea_all()
RETURNS TABLE(tarea_id bigint,tarea_titulo text, tarea_descripcion text, tarea_fechaEntrega date, tarea_estado boolean)
LANGUAGE plpgsql
COST 100
VOLATILE PARALLEL UNSAFE
ROWS 1000

AS $BODY$
BEGIN

	RETURN QUERY SELECT t.id,t."Titulo",t."Descripcion",t."FechaEntrega",t."Estado"
	FROM public.tarea t
	ORDER BY "FechaEntrega";
END;
$BODY$;

ALTER FUNCTION public.sps_tarea_all()
	OWNER TO postgres;

--DROP FUNCTION sps_tarea_all();

SELECT * FROM sps_tarea_all();

-- FUNCTION: public.sps_tarea_by_titulo(t_titulo)

CREATE OR REPLACE FUNCTION public.sps_tarea_by_titulo(
	t_titulo TEXT
)
RETURNS TABLE(tarea_id bigint,tarea_titulo text, tarea_descripcion text, tarea_fechaEntrega date, tarea_estado boolean)
LANGUAGE plpgsql
COST 100
VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	RETURN QUERY SELECT t.id,t."Titulo",t."Descripcion",t."FechaEntrega",t."Estado"
	FROM public.tarea t
	WHERE t."Titulo" ILIKE '%' || t_titulo || '%'
	ORDER BY "FechaEntrega";
END;
$BODY$;

ALTER FUNCTION public.sps_tarea_by_titulo(TEXT)
	OWNER TO postgres;

SELECT * FROM sps_tarea_by_titulo('Tareaa');
	