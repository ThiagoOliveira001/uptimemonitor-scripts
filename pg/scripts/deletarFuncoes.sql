/*

SELECT routines.routine_name, parameters.data_type, parameters.ordinal_position, routines.specific_name, parameters.specific_name AS pn
FROM information_schema.routines
    LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
WHERE routines.specific_schema='seguranca'
ORDER BY routines.routine_name, parameters.ordinal_position;

*/

CREATE OR REPLACE FUNCTION public.deletarFuncoes(
    pSchema VARCHAR, 
    pNome VARCHAR
) 

RETURNS VOID AS $$

    /*
        Documentacao:
        Arquivo fonte.....: deletarFuncoes.sql
        Objetivo..........: Deletar todas as funcoes de acordo com os parametros passados
        Autor.............: Thiago Oliveira
        Data..............: 30/06/2019
    */
    DECLARE 
        vFunctions JSON;
        rec RECORD;

    BEGIN
        SELECT json_agg(t)
            INTO vFunctions
            FROM (
                SELECT  r.specific_schema,
                        r.routine_name AS funcao,
                        pr.params
                    FROM information_schema.routines AS r
                        LEFT JOIN LATERAL (
                            SELECT string_agg(p.data_type::TEXT, ',') AS params
                                FROM information_schema.parameters AS p
                                WHERE p.specific_name = r.specific_name
                        ) AS pr ON TRUE
                    WHERE r.routine_name ILIKE pNome
                        AND r.specific_schema ILIKE pSchema 
            ) t;    

        for rec in (SELECT * FROM json_to_recordset(vFunctions) AS x("specific_schema" VARCHAR, "funcao" VARCHAR, "params" TEXT))
        LOOP
            EXECUTE 'DROP FUNCTION ' || rec.specific_schema || '.' || rec.funcao || '(' || COALESCE(rec.params, '') || ');';
        END LOOP;
    END;

$$
LANGUAGE plpgsql;