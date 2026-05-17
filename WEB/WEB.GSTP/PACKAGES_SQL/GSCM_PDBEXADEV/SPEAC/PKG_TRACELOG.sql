--------------------------------------------------------
--  DDL for Package PKG_TRACELOG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_TRACELOG" 

AS         
	PROCEDURE "SP_TRACELOG" (
	    log_level IN NUMBER,
	    uuid IN varchar2,
	    threadname IN varchar2,
	    functionname IN varchar2,
	    orig_starttime IN date,
	    step_starttime IN date,
	    step_finishtime IN date,
	    final_finishtime IN date,
	    status IN number,
	    description IN varchar2,
	    notes IN varchar2,
	    step_num IN NUMBER
    );
    
    PROCEDURE SP_INSERT_LOG_ERROR (
    	p_functionname IN varchar2,
    	p_description IN varchar2,
    	p_notes IN varchar2
    );
   
   	PROCEDURE SP_INSERT_LOG_INFO (
    	p_functionname IN varchar2,
    	p_description IN varchar2,
    	p_notes IN varchar2
    );

END PKG_TRACELOG;

/
