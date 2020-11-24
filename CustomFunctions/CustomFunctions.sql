/********************************************************************************************************************************************

						******************************************
					                     CUSTOM FUNCTIONS
						******************************************

	Description: Bunch of useful functions, scalar and table valued to make our life easier.
		     Some of them are implemented as CLR.
				 
	HOW TO: Just RUN this file once in each SQL Server Database to save all functions.

	TODO: 
		- Add new functions like GetIntBeforeString, GetFloatBeforeString, GetTinyIntAfterString, GetSmallIntAfterString ... etc
		- Still improving the CLR functions

				
*********************************************************************************************************************************************/

USE [test]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Create custom schema if not exists

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'custom')
EXEC ('CREATE SCHEMA [custom]')
GO
-- Import the Assembly CustomFunctions.dll

sp_configure 'show advanced options', 1
RECONFIGURE
GO
sp_configure 'clr enabled', 1
RECONFIGURE
GO
sp_configure 'show advanced options', 0
RECONFIGURE
GO

IF EXISTS(SELECT 1 FROM sys.assemblies WHERE name = 'CustomFunctions')
BEGIN
DROP FUNCTION [custom].[GetNumbersString]
DROP FUNCTION [custom].[SplitString]
DROP FUNCTION [custom].[SplitStringNoReplaceLeft]
DROP FUNCTION [custom].[SplitStringNoReplaceRight]
DROP FUNCTION [custom].[GetIntAfterString]
DROP FUNCTION [custom].[GetBigIntAfterString]
DROP FUNCTION [custom].[GetRealAfterString]
DROP FUNCTION [custom].[GetFloatAfterString]
DROP ASSEMBLY CustomFunctions
END
GO
CREATE ASSEMBLY [CustomFunctions]
FROM 'C:\custom\CustomFunctions\CustomFunctions.dll'
WITH PERMISSION_SET = SAFE
GO

/* [custom].[GetStringBetween] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetStringBetween]') IS NOT NULL
DROP FUNCTION [custom].[GetStringBetween]
GO
CREATE FUNCTION [custom].[GetStringBetween]
(
  @string_in		NVARCHAR(MAX),
  @first_pattern	NVARCHAR(MAX),
  @second_pattern	NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @string_out NVARCHAR(MAX)
	DECLARE @first_index INT
	DECLARE @second_index INT
	DECLARE @first_pattern_len INT

	IF @string_in IS NULL
	RETURN NULL

	IF @first_pattern IS NULL
	RETURN NULL

	IF @second_pattern IS NULL
	RETURN NULL

	SET @first_index = CHARINDEX(@first_pattern, @string_in)

	IF @first_index = 0
	RETURN NULL

	SET @second_index = CHARINDEX(@second_pattern, @string_in)
	
	IF @second_index = 0
	RETURN NULL
	
	SET @string_out = SUBSTRING(@string_in, @first_index + LEN(@first_pattern), @second_index - @first_index)

	RETURN LTRIM(RTRIM(@string_out))
END
GO

/* [custom].[GetStringLeft] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetStringLeft]') IS NOT NULL
DROP FUNCTION [custom].[GetStringLeft]
GO
CREATE FUNCTION [custom].[GetStringLeft]
(
  @string_in	NVARCHAR(MAX),
  @pattern		NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @string_out NVARCHAR(MAX)
	DECLARE @index INT
	DECLARE @pattern_len INT

	IF @string_in IS NULL
	RETURN NULL

	IF @pattern IS NULL
	RETURN NULL

	SET @index = CHARINDEX(@pattern, @string_in)
	
	IF @index = 0
	RETURN NULL

	SET @string_out = LEFT(@string_in, @index - 1)

	RETURN LTRIM(RTRIM(@string_out))
END
GO

/* [custom].[GetStringRight] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetStringRight]') IS NOT NULL
DROP FUNCTION [custom].[GetStringRight]
GO
CREATE FUNCTION [custom].[GetStringRight]
(
  @string_in	NVARCHAR(MAX),
  @pattern		NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @string_out NVARCHAR(MAX)
	DECLARE @index INT
	DECLARE @pattern_len INT

	IF @string_in IS NULL
	RETURN NULL

	IF @pattern IS NULL
	RETURN NULL

	SET @index = CHARINDEX(@pattern, @string_in)

	IF @index = 0
	RETURN NULL

	SET @string_out = RIGHT(RTRIM(@string_in), LEN(@string_in) - @index - LEN(@pattern) + 1)

	RETURN LTRIM(RTRIM(@string_out))
END
GO

/* [custom].[GetNumberString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetNumbersString]') IS NOT NULL
DROP FUNCTION [custom].[GetNumberString]
GO
CREATE FUNCTION [custom].[GetNumbersString]
(
  @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(256)
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetNumbersString]
GO

IF OBJECT_ID('[custom].[SplitString]') IS NOT NULL
DROP FUNCTION [custom].[SplitString]
GO
CREATE FUNCTION [custom].[SplitString]
(
	@string_in NVARCHAR(MAX), 
	@delimiter NVARCHAR(255)
)
RETURNS  TABLE 
(
	nRow	INT,
	string	NVARCHAR(4000)
)
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[SplitString]
GO

IF OBJECT_ID('[custom].[SplitStringNoReplaceLeft]') IS NOT NULL
DROP FUNCTION [custom].[SplitStringNoReplaceLeft]
GO
CREATE FUNCTION [custom].[SplitStringNoReplaceLeft]
(
	@string_in NVARCHAR(MAX), 
	@delimiter NVARCHAR(255)
)
RETURNS  TABLE 
(
	nRow	INT,
	string	NVARCHAR(4000)
)
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[SplitStringNoReplaceLeft]
GO

IF OBJECT_ID('[custom].[SplitStringNoReplaceRight]') IS NOT NULL
DROP FUNCTION [custom].[SplitStringNoReplaceRight]
GO
CREATE FUNCTION [custom].[SplitStringNoReplaceRight]
(
	@string_in NVARCHAR(MAX), 
	@delimiter NVARCHAR(255)
)
RETURNS  TABLE 
(
	nRow	INT,
	string	NVARCHAR(4000)
)
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[SplitStringNoReplaceRight]
GO

/* [custom].[GetIntAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetIntAfterString]') IS NOT NULL
DROP FUNCTION [custom].[GetIntAfterString]
GO
CREATE FUNCTION [custom].[GetIntAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS INT
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetIntAfterString]
GO

/* [custom].[GetBigIntAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetBigIntAfterString]') IS NOT NULL
DROP FUNCTION [custom].[GetBigIntAfterString]
GO
CREATE FUNCTION [custom].[GetBigIntAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS BIGINT
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetBigIntAfterString]
GO

/* [custom].[GetFloatAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetFloatAfterString]') IS NOT NULL
DROP FUNCTION [custom].[GetFloatAfterString]
GO
CREATE FUNCTION [custom].[GetFloatAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS FLOAT
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetFloatAfterString]
GO

/* [custom].[GetRealAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[GetRealAfterString]') IS NOT NULL
DROP FUNCTION [custom].[GetRealAfterString]
GO
CREATE FUNCTION [custom].[GetRealAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS REAL
WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetRealAfterString]
GO

/* [custom].[ConvertToDatetime] UserScalarDefinedFunction */

-- DATETIME2 is the ISO standard for datetime formats, DATETIME isn't
-- Same Output of NovaExplorer DATETIME2(3), that means maximum precision in miliseconds, now Consulting Engineers will the same DateTime in NovaExplorer (I'm sure that Parser use DATETIME2)

IF OBJECT_ID('[custom].[ConvertToDatetime]') IS NOT NULL
DROP FUNCTION [custom].[ConvertToDatetime]
GO
CREATE FUNCTION [custom].[ConvertToDatetime]
(
  @UTC_TimeSeconds INT,
  @UTC_TimeNanoSeconds INT = 0,
  @TimeZoneCorrection SMALLINT = 0,
  @DaylightSavingTimeCorrection SMALLINT = 0
)
RETURNS DATETIME2(3)
AS
BEGIN
	DECLARE @StartDateTime DATETIME2(3)
	DECLARE @DateTime DATETIME2(3)

	SET @StartDateTime = '1970-1-1 00:00:00.000'
	SET @DateTime = DATEADD(MILLISECOND, @UTC_TimeNanoSeconds/1000000, DATEADD(SECOND, @UTC_TimeSeconds + @TimeZoneCorrection + @DaylightSavingTimeCorrection, @StartDateTime))

	RETURN @DateTime
END
GO

/* [custom].[CountLinesString] UserScalarDefinedFunction */

IF OBJECT_ID('[custom].[CountLinesString]') IS NOT NULL
DROP FUNCTION [custom].[CountLinesString]
GO
CREATE FUNCTION [custom].[CountLinesString] 
(
	@string NVARCHAR(MAX)
)
RETURNS BIGINT
AS 
BEGIN
	DECLARE @count BIGINT

	-- CHAR(10) = '\n'
	SET @count = LEN(@string) - LEN(REPLACE(@string, CHAR(10), '')) + 1

    RETURN @count
END
GO
