SELECT public.deletarFuncoes('seguranca', 'login');
CREATE OR REPLACE FUNCTION seguranca.login(
    pLogin seguranca.usuario.login%TYPE,
    pSenha seguranca.usuario.senha%TYPE
)

RETURNS TABLE (
    "nome"            seguranca.usuario.nome%TYPE,
    "id"              seguranca.usuario.id%TYPE,
    "email"           seguranca.email.email%TYPE,
    "ativo"           seguranca.usuario.ativo%TYPE
) AS $$

    /*
        Documentação
        Arquivo fonte.....: autenticacao.sql
        Objetivo..........: Retornar dados de login do usuario
        Autor.............: Thiago Oliveira
        Data..............: 06/07/2019
    */

    BEGIN

        RETURN QUERY

        SELECT  u.nome,
                u.id,
                le.email,
                u.ativo
            FROM seguranca.usuario u 
                LEFT JOIN LATERAL(
                    SELECT e.email
                        FROM seguranca.email e
                            INNER JOIN seguranca.usuarioemail ue
                                ON ue.idusuario = u.id 
                        WHERE e.principal IS TRUE
                        LIMIT 1
                ) le ON TRUE
            WHERE unaccent(u.login) ILIKE unaccent(pLogin)
                AND u.senha = pSenha
            LIMIT 1; 
    END;

$$
LANGUAGE plpgsql;
-------------------------------------------------------------------------------
