--------------------------------------------------------
--  DDL for Package Body PKG_TRACELOG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_TRACELOG" AS
  
    PROCEDURE "SP_TRACELOG" 
   (
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
     ) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_ora_error VARCHAR2 (1024);
    v_root_loglevel NUMBER := 4;
    /*
    Error = 1,
    Warn = 2,
    Info = 3,
    Debug = 4,
    Trace = 5,
    */
  	BEGIN
	    --Check log level
	    IF log_level > v_root_loglevel THEN
	        NULL;
	        RETURN;
	    END IF;
	    -- TODO: Implementation required for PROCEDURE PKG_TRACELOG."SP_TRACELOG"
	    IF DBMS_UTILITY.format_error_stack () is not null  THEN
	      v_ora_error :=
	                   'EXCEPTION: FORMAT_ERROR_BACKTRACE:'
	                || DBMS_UTILITY.format_error_backtrace ()
	                || CHR (13)
	                || 'FORMAT_ERROR_STACK:'
	                || DBMS_UTILITY.format_error_stack ();
	    END IF;
	    insert into TBL_TRACELOG(id, uuid,threadname,functionname,orig_starttime,step_starttime, step_finishtime,  final_finishtime,status,description,notes, ora_error, logtime, step_num)
	    values (SEQ_TBL_TRACELOG.nextval,uuid,threadname,functionname,orig_starttime,step_starttime, step_finishtime,  final_finishtime,status,description,notes, v_ora_error, sysdate, step_num);
	    commit;
	    EXCEPTION
	    WHEN others THEN
	        dbms_output.put_line('exception in trace');
	        ROLLBACK;
	    NULL;
  	END "SP_TRACELOG";
 	
 	PROCEDURE SP_INSERT_LOG_ERROR (
    	p_functionname IN varchar2,
    	p_description IN varchar2,
    	p_notes IN varchar2
    )
    IS	
	    PRAGMA AUTONOMOUS_TRANSACTION;
	    v_ora_error VARCHAR2 (1024);
	    v_uuid VARCHAR2 (50);
	BEGIN
		IF DBMS_UTILITY.format_error_stack () is not null  THEN
	      	v_ora_error :=
	                   'EXCEPTION: FORMAT_ERROR_BACKTRACE:'
	                || DBMS_UTILITY.format_error_backtrace ()
	                || CHR (13)
	                || 'FORMAT_ERROR_STACK:'
	                || DBMS_UTILITY.format_error_stack ();
	        
	        v_uuid := sys_guid();  
	    	insert into TBL_TRACELOG(id, uuid, functionname, orig_starttime, status, description, notes, ora_error, logtime)
	    	values (SEQ_TBL_TRACELOG.nextval, v_uuid, p_functionname, sysdate, -999, p_description, p_notes, v_ora_error, sysdate);
	    	commit;
	    END IF;
	   
	    EXCEPTION
	    WHEN others THEN
	        dbms_output.put_line('exception in trace');
	        ROLLBACK;
	    NULL;
 	END;
 
 	PROCEDURE SP_INSERT_LOG_INFO (
    	p_functionname IN varchar2,
    	p_description IN varchar2,
    	p_notes IN varchar2
    )
    IS	
	    PRAGMA AUTONOMOUS_TRANSACTION;
	    v_ora_error VARCHAR2 (1024);
	    v_uuid VARCHAR2 (50);
	BEGIN
		IF DBMS_UTILITY.format_error_stack () is not null  THEN
	      	v_ora_error :=
	                   'EXCEPTION: FORMAT_ERROR_BACKTRACE:'
	                || DBMS_UTILITY.format_error_backtrace ()
	                || CHR (13)
	                || 'FORMAT_ERROR_STACK:'
	                || DBMS_UTILITY.format_error_stack ();
	        
	        v_uuid := sys_guid();  
	    	insert into TBL_TRACELOG(id, uuid, functionname, orig_starttime, status, description, notes, ora_error, logtime)
	    	values (SEQ_TBL_TRACELOG.nextval, v_uuid, p_functionname, sysdate, -999, p_description, p_notes, v_ora_error, sysdate);
	    	commit;
	    ELSE
	    	v_uuid := sys_guid();  
	    	insert into TBL_TRACELOG(id, uuid, functionname, orig_starttime, status, description, notes, logtime)
	    	values (SEQ_TBL_TRACELOG.nextval, v_uuid, p_functionname, sysdate, 200, p_description, p_notes, sysdate);
	    	commit;
	    END IF;
	   
	    EXCEPTION
	    WHEN others THEN
	        dbms_output.put_line('exception in trace');
	        ROLLBACK;
	    NULL;
 	END;
 	
END PKG_TRACELOG;

/
