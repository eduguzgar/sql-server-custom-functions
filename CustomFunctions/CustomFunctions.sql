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

USE [AdventurerWorks]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
DROP FUNCTION [GetNumbersString]
DROP FUNCTION [SplitString]
DROP FUNCTION [SplitStringNoReplaceLeft]
DROP FUNCTION [SplitStringNoReplaceRight]
DROP FUNCTION [GetIntAfterString]
DROP FUNCTION [GetBigIntAfterString]
DROP FUNCTION [GetRealAfterString]
DROP FUNCTION [GetFloatAfterString]
DROP FUNCTION [GetNumberAfterString]
DROP ASSEMBLY CustomFunctions
END
GO
CREATE ASSEMBLY [CustomFunctions]
FROM 'C:\custom\CustomFunctions\CustomFunctions.dll'
WITH PERMISSION_SET = SAFE
GO

/* [GetStringBetween] UserScalarDefinedFunction */

IF OBJECT_ID('[GetStringBetween]') IS NOT NULL
DROP FUNCTION [GetStringBetween]
GO
CREATE FUNCTION [GetStringBetween]
(
  @string_in		NVARCHAR(MAX),
  @first_pattern	NVARCHAR(255),
  @second_pattern	NVARCHAR(255)
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

/* [GetStringLeft] UserScalarDefinedFunction */

IF OBJECT_ID('[GetStringLeft]') IS NOT NULL
DROP FUNCTION [GetStringLeft]
GO
CREATE FUNCTION [GetStringLeft]
(
  @string_in	NVARCHAR(MAX),
  @pattern		NVARCHAR(255)
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

/* [GetStringRight] UserScalarDefinedFunction */

IF OBJECT_ID('[GetStringRight]') IS NOT NULL
DROP FUNCTION [GetStringRight]
GO
CREATE FUNCTION [GetStringRight]
(
  @string_in	NVARCHAR(MAX),
  @pattern		NVARCHAR(255)
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

/* [GetNumberString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetNumbersString]') IS NOT NULL
DROP FUNCTION [GetNumberString]
GO
CREATE FUNCTION [GetNumbersString]
(
  @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetNumbersString]
GO

IF OBJECT_ID('[SplitString]') IS NOT NULL
DROP FUNCTION [SplitString]
GO
CREATE FUNCTION [SplitString]
(
    @string_in NVARCHAR(MAX),
    @delimiter NVARCHAR(255) = N','
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

IF OBJECT_ID('[SplitStringNoReplaceLeft]') IS NOT NULL
DROP FUNCTION [SplitStringNoReplaceLeft]
GO
CREATE FUNCTION [SplitStringNoReplaceLeft]
(
    @string_in NVARCHAR(MAX),
    @delimiter NVARCHAR(255) = N','
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

IF OBJECT_ID('[SplitStringNoReplaceRight]') IS NOT NULL
DROP FUNCTION [SplitStringNoReplaceRight]
GO
CREATE FUNCTION [SplitStringNoReplaceRight]
(
    @string_in NVARCHAR(MAX),
    @delimiter NVARCHAR(255) = N','
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

/* [GetIntAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetIntAfterString]') IS NOT NULL
DROP FUNCTION [GetIntAfterString]
GO
CREATE FUNCTION [GetIntAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetIntAfterString]
GO

/* [GetBigIntAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetBigIntAfterString]') IS NOT NULL
DROP FUNCTION [GetBigIntAfterString]
GO
CREATE FUNCTION [GetBigIntAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS BIGINT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetBigIntAfterString]
GO

/* [GetFloatAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetFloatAfterString]') IS NOT NULL
DROP FUNCTION [GetFloatAfterString]
GO
CREATE FUNCTION [GetFloatAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS FLOAT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetFloatAfterString]
GO

/* [GetRealAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetRealAfterString]') IS NOT NULL
DROP FUNCTION [GetRealAfterString]
GO
CREATE FUNCTION [GetRealAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS REAL
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetRealAfterString]
GO

/* [GetRealAfterString] UserScalarDefinedFunction */

IF OBJECT_ID('[GetNumberAfterString]') IS NOT NULL
DROP FUNCTION [GetNumberAfterString]
GO
CREATE FUNCTION [GetNumberAfterString]
(
  @string_in NVARCHAR(MAX),
  @pattern NVARCHAR(255)
)
RETURNS NVARCHAR(255)
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [CustomFunctions].[CustomFunctions].[GetNumberAfterString]
GO

/* [ConvertToDatetime] UserScalarDefinedFunction */

-- DATETIME2 is the ISO standard for datetime formats, DATETIME isn't
-- This means maximum precision in miliseconds

IF OBJECT_ID('[ConvertToDatetime]') IS NOT NULL
DROP FUNCTION [ConvertToDatetime]
GO
CREATE FUNCTION [ConvertToDatetime]
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

/* [CountLinesString] UserScalarDefinedFunction */

IF OBJECT_ID('[CountLinesString]') IS NOT NULL
DROP FUNCTION [CountLinesString]
GO
CREATE FUNCTION [CountLinesString]
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
