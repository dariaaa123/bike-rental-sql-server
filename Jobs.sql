USE msdb;
GO

EXEC sp_add_job
    @job_name = N'JOB_Biciclete_ReconcilereStatus',
    @enabled = 1,
    @description = N'Repara status biciclete: inchiriata fara imprumut activ -> disponibila';
GO

EXEC sp_add_jobstep
    @job_name = N'JOB_Biciclete_ReconcilereStatus',
    @step_name = N'FixStatus',
    @subsystem = N'TSQL',
    @database_name = N'bicicleta',
    @command = N'
        UPDATE b
        SET b.Status = ''disponibila''
        FROM dbo.Biciclete b
        WHERE b.Status = ''inchiriata''
          AND NOT EXISTS (
              SELECT 1
              FROM dbo.Imprumuturi i
              WHERE i.BicicletaID = b.BicicletaID
                AND i.DataSfarsit IS NULL
          );
    ';
GO

-- Rulează zilnic la 02:00
EXEC sp_add_schedule
    @schedule_name = N'SCH_Daily_0200',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 020000;
GO

EXEC sp_attach_schedule
    @job_name = N'JOB_Biciclete_ReconcilereStatus',
    @schedule_name = N'SCH_Daily_0200';
GO

EXEC sp_add_jobserver
    @job_name = N'JOB_Biciclete_ReconcilereStatus';
GO
