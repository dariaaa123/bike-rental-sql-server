USE bicicleta;
GO

CREATE OR ALTER TRIGGER tr_DDL_Audit_Bicicleta
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
    CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
    CREATE_VIEW, ALTER_VIEW, DROP_VIEW
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @x XML = EVENTDATA();
    DECLARE @msg NVARCHAR(4000) =
        CONCAT(
            'DDL change in DB=', DB_NAME(),
            ' | Event=', @x.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
            ' | Object=', @x.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(256)'),
            ' | User=',  @x.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(256)')
        );

    RAISERROR(@msg, 10, 1) WITH LOG; -- severitate 10: informativ, se loghează
END;
GO
