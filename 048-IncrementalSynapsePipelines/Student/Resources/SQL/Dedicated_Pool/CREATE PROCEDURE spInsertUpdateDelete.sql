IF OBJECT_ID ( 'SalesLT.spInsertUpdateDelete', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spInsertUpdateDelete;
GO

CREATE PROCEDURE [SalesLT].[spInsertUpdateDelete]
(
    @TableSchema VARCHAR(50),
    @TableName VARCHAR(50)
)

AS
DECLARE @sqlInsert AS NVARCHAR(4000)
DECLARE @sqlUpdate AS NVARCHAR(4000)
DECLARE @sqlDelete AS NVARCHAR(4000)
DECLARE @sqlTruncate AS NVARCHAR(4000)

SELECT @sqlInsert = 'EXEC ' + @TableSchema + '.spInsert' + @TableName + ''
EXEC(@sqlInsert)

SELECT @sqlUpdate = 'EXEC ' + @TableSchema + '.spUpdate' + @TableName + ''
EXEC(@sqlUpdate)

SELECT @sqlDelete = 'EXEC ' + @TableSchema + '.spDelete' + @TableName + ''
EXEC(@sqlDelete)

SELECT @sqlTruncate = 'TRUNCATE TABLE Staging.' + @TableName + ''
EXEC(@sqlTruncate)

GO